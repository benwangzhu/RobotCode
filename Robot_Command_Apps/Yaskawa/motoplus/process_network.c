#include "motoPlus.h"
#include "process_network.h"
#include "global_variable.h"
#include "lib/lib_mptp_if.h"
#include "lib/lib_mpsocket.h"
#include "sbt_comm011.h"
#include "sbt_unstack.h"

VOID Network_Process_Task_(VOID);

VOID close_network_(VOID);

STATUS get_server_ip_addr(VOID);

VOID Network_Process_Task_(VOID)
{
	memset(&GlobalSockAddr, 0, sizeof(GlobalSockAddr));
	GlobalSockAddr.sin_len = sizeof(struct sockaddr_in);
	GlobalSockAddr.sin_family = AF_INET;
	
	FOREVER
	{
		STATUS Status;

		Status = ERROR;
		
		
		if (GlobalConnect != 1)
		{ 
			// �ȴ�һ��ʱ����
			mpTaskDelay(TRY_CONNECT_SERVER_TIME_INTERVAL);
			continue;
		}

		Status = get_server_ip_addr();
		if (Status != OK)
		{
			GlobalConnect = 0;
			continue;
		}

		GlobalSockAddr.sin_addr.s_addr = mpInetAddr(GlobalSocketIp);
		GlobalSockAddr.sin_port = mpHtons(GlobalSocketPort);

		INT32 TryConnectCount = 0;		// �������Ӵ���
		
		// ����������λ����ֱ���ɹ�
		while (Status != OK)
		{
			if (GlobalSocketHandle < 0)
			{
				GlobalSocketHandle = mpSocket(AF_INET, SOCK_STREAM, 0);
				
				DEBUG_ERROR("socket(%d) is created!", GlobalSocketHandle);
			}
			
			if (GlobalSocketHandle < 0)
			{
				DEBUG_ERROR("Call mpSocket failed![ErrorCode:%d]", GlobalSocketHandle);
		
				mpClose(GlobalSocketHandle);
				GlobalSocketHandle = -1;
				GlobalConnectStatus = 0;
				
				TryConnectCount++;
				
				// �ȴ�һ��ʱ�������ٴγ�������
				mpTaskDelay(TRY_CONNECT_SERVER_TIME_INTERVAL);
				
				if (TryConnectCount >= TRY_CONNECT_COUNT)
				{
					GlobalConnect = 0;
					break;
				}
				else
				{
					continue;
				}
			}
		
			// ���ӷ�����
			Status = mpConnect(GlobalSocketHandle, (struct sockaddr*)&GlobalSockAddr, sizeof(GlobalSockAddr));
		
			if (Status != OK)
			{
				DEBUG_INFO("Connect server failed![ErrorCode:%d]", Status);
				
				mpClose(GlobalSocketHandle);
				GlobalSocketHandle = -1;
				GlobalConnectStatus = 0;
		
				TryConnectCount++;
				
				// �ȴ�һ��ʱ�������ٴγ�������
				mpTaskDelay(TRY_CONNECT_SERVER_TIME_INTERVAL);
					
				if (TryConnectCount >= TRY_CONNECT_COUNT)
				{

					GlobalConnect = 0;
					break;
				}
				
			}
			
		}

		// ֪ͨʾ�����������ӳɹ�
		Status = set_variable_byte_(MOTOPLUS_STATUS_BYTE_NUMBER, 1);
		if (Status != OK)
		{
			DEBUG_ERROR("Call set_variable_byte_ failed![ErrorCode:%d]", Status);
		}
		
		// ����������Դ����������µȴ�����
		if ((TryConnectCount >= TRY_CONNECT_COUNT) && (GlobalSocketHandle == -1))
		{
			TryConnectCount = 0;
			continue;	
		}
	
		GlobalConnectStatus = 1;

		GlobalConnect = 0;
		
		TryConnectCount = 0;
		
		DEBUG_INFO("Connect server success!");
		
		while (GlobalConnectStatus)
		{
			//////////////////////////////////////////////////////////////////////////////////
			// ��������
			// ռ���ź���
			int Timeout = WAIT_SEND_DATA_TIME_INTERVAL / mpGetRtc();
			Status = mpSemTake(GlobalSemSendBuffer1, Timeout);
			if (Status != OK)
			{
				if (GlobalConnectStatus != 1)
				{
					mpSemGive(GlobalSemSendBuffer2);
					
					break;
				}
				else
				{				
					continue;
				}
			}

			// �Ѿ��������Ϣʱ������������
			if (GlobalSendDataLenght > 0)
			{
				int BytesSended = 0;
				BytesSended = mpSend(GlobalSocketHandle, (char*)GlobalSendBuffer, GlobalSendDataLenght, 0);

				if (BytesSended <= 0)
				{ // ����ʧ��
					char ServerIp[32] = {0};
					mpInetNtoaB(GlobalSockAddr.sin_addr, ServerIp);
					
					DEBUG_ERROR("Send Data to Peer Error![Server IP:%s, Port:%d, ErrorCode:%d]", ServerIp, mpNtohs(GlobalSockAddr.sin_port), BytesSended);
					
					// �ͷ��ź�����������CommandProcessTask�̼߳����������ݣ������뷢�ͻ�����
					mpSemGive(GlobalSemSendBuffer2);
					
					break;
				}
			}

			// ���ݲ�ͨ�Ĺ�����ѡ���ȡ��������
			switch (GlobalSocketPort)
			{
			case COMM011_SERVER_PORT:
				Status = processReceived_sbt_comm011_data_();
				if (Status != OK)
				{
					// ����ͨѶ�����˳�ͨѶ״̬���ȴ��µ�����
					GlobalConnectStatus = 0;
				}
				break;
			case UNSTACK_SERVER_PORT:
				Status = processReceived_sbt_unstack_data_();
				if (Status != OK)
				{
					// ����ͨѶ�����˳�ͨѶ״̬���ȴ��µ�����
					GlobalConnectStatus = 0;
				}
				break;
			
			default:
				break;
			}

			// ���� GlobalSemSendBuffer2 �ź������� Command_Process_Task_ �����������
        	mpSemGive(GlobalSemSendBuffer2);

		}
		
		DEBUG_INFO("DisConnect !");
		close_network_();
	} // END FOREVER
	
	// ����������е�����̼߳����˳����û���Ҫ�������ƹ�
	mpSetAlarm(8201, "NetworkProcessTask quit", 1);
}

VOID close_network_(VOID)
{
	mpClose(GlobalSocketHandle);
	GlobalSocketHandle = -1;
	GlobalConnectStatus = 0;
	
	DEBUG_INFO("Socket is closed!");
}

STATUS get_server_ip_addr(VOID)
{
	INT32 Status = ERROR;

    Status = get_variable_string_(SERVER_IP_CHAR_REG_ADDR, GlobalSocketIp);   // �� S �Ĵ�����ȡ IP ��ַ
    if ((Status != OK) || (GlobalSocketIp == NULL))
    {
		DEBUG_ERROR("Failed Get Server Ip[S[]:%d]", SERVER_IP_CHAR_REG_ADDR); 
		
        // ��������
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Failed Get Server Ip[S:%d]", SERVER_IP_CHAR_REG_ADDR);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
		
		return ERROR;
    }

	DEBUG_INFO("Get Server Ip Successful![Addr:%s, Port:%d]", GlobalSocketIp, GlobalSocketPort);
	
	return OK;
}
