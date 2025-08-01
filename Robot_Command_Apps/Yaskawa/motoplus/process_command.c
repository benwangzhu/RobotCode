#include "motoPlus.h"
#include "process_command.h"
#include "global_variable.h"
#include "lib/lib_mptp_if.h"
#include "sbt_comm004.h"
#include "sbt_comm011.h"
#include "sbt_unstack.h"

VOID Command_Receive_Task_(VOID);

VOID Command_Process_Task_(VOID);

STATUS Create_Command_Receive_Task_(VOID);

/************************************************************************************
* ��  �ܣ�����JOB���͵�SKILLSND���������											  *
* ��  ������																		*
* ����ֵ����																		*
************************************************************************************/
VOID Command_Receive_Task_(VOID)
{
	SYS2MP_SENS_MSG Msg;
    STATUS Status = OK;
    
	memset(&Msg, CLEAR, sizeof(SYS2MP_SENS_MSG));
	
	// FOREVER begin
	FOREVER
	{
		mpEndSkillCommandProcess(MP_SL_ID1, &Msg);
		Status = mpReceiveSkillCommand(MP_SL_ID1, &Msg);		// ����SKILLSND���͵�����
		
		if (Status == OK)
		{
			DEBUG_INFO("mpReceiveSkillCommand OK.[main_comm:%d, sub_comm:%d, exe_tsk:%d, exe_apl:%d, cmd:%s]", Msg.main_comm, Msg.sub_comm, Msg.exe_tsk, Msg.exe_apl, Msg.cmd);
		}
		else
		{
			DEBUG_INFO("mpReceiveSkillCommand Error![ErrorCode:%d]", Status);
			
			continue;
		}
		
		// switch begin
		switch (Msg.main_comm)
		{
			case MP_SKILL_COMM:
			{
				switch (Msg.sub_comm)
				{
					case MP_SKILL_SEND:
					{
						if (strcmp(Msg.cmd, NULL) == 0)															// NULL
						{
							DEBUG_INFO("Command Receive %s", NULL);
														
							GlobalCommandNo = COMMAND_UNKNOWN;
							
						}

						/* COMM004 SKILLSND*/
						else if (strcmp(Msg.cmd, COMMAND_SKILLSND_STR_COMM004_PARAM) == 0)						// Comm004 ���� VIN �� PID ����ָ��
						{
							DEBUG_INFO("Command Receive %s", COMMAND_SKILLSND_STR_COMM004_PARAM);
							
							// ��ʼ�� Comm004 ����
							Status = processCommand_sbt_comm004_initialize_();
							Status = Create_Command_Receive_Task_();
							if (Status != OK)
							{
								/* code */
							}
							else
							{
								GlobalCommandNo = COMMAND_COMM004_PARAM;
							}														
						}
						else if (strcmp(Msg.cmd, COMMAND_SKILLSND_STR_COMM004_GUIDE) == 0)						// Comm004 ����ָ��
						{
							DEBUG_INFO("Command Receive %s", COMMAND_SKILLSND_STR_COMM004_GUIDE);

							GlobalCommandNo = COMMAND_COMM004_GUIDE;
														
						}
						else if (strcmp(Msg.cmd, COMMAND_SKILLSND_STR_COMM004_SEND_POS) == 0)					// Comm004 �����ƶ�����ϵλ��ָ��
						{
							DEBUG_INFO("Command Receive %s", COMMAND_SKILLSND_STR_COMM004_SEND_POS);

							GlobalCommandNo = COMMAND_COMM004_SEND_POS;
														
						}
						else if (strcmp(Msg.cmd, COMMAND_SKILLSND_STR_COMM004_CAMERA) == 0)						// Comm004 ѡ�����ָ��
						{
							DEBUG_INFO("Command Receive %s", COMMAND_SKILLSND_STR_COMM004_CAMERA);

							GlobalCommandNo = COMMAND_COMM004_CAMERA;
														
						}
						else if (strcmp(Msg.cmd, COMMAND_SKILLSND_STR_COMM004_VASMB) == 0)						// Comm004 װ��ָ��
						{
							DEBUG_INFO("Command Receive %s", COMMAND_SKILLSND_STR_COMM004_VASMB);

							Status = processCommand_sbt_comm004_initialize_();

							GlobalCommandNo = COMMAND_COMM004_VASMB;
														
						}
						else if (strcmp(Msg.cmd, COMMAND_SKILLSND_STR_COMM004_DQMONI) == 0)						// Comm004 ָ����ָ��
						{
							DEBUG_INFO("Command Receive %s", COMMAND_COMM004_DQMONI);

							Status = processCommand_sbt_comm004_initialize_();

							GlobalCommandNo = COMMAND_COMM004_DQMONI;
														
						}

						/* COMM011 SKILLSND*/
						else if (strcmp(Msg.cmd, COMMAND_SKILLSND_STR_COMM011_OPEN) == 0)						// Comm011 ָ������ͨѶ
						{
							DEBUG_INFO("Command Receive %s", COMMAND_SKILLSND_STR_COMM011_OPEN);

							Status = processCommand_sbt_comm011_open_();
							if (Status != OK)
							{
								DEBUG_ERROR("Connect Server Error![Server IP:%s, Port:%d]", GlobalSocketIp, GlobalSocketPort);
								mpSetAlarm(8201, "Connect Server Error!", 1);
								break;
							}
							Status = Create_Command_Receive_Task_();
							if (Status != OK)
							{
								/* code */
							}
							else
							{
								
								GlobalCommandNo = COMMAND_COMM011_REALTIME;
							}																												
						}
						else if (strcmp(Msg.cmd, COMMAND_SKILLSND_STR_COMM011_CLOSE) == 0)						// Comm011 ָ��Ͽ�ͨѶ
						{
							DEBUG_INFO("Command Receive %s", COMMAND_SKILLSND_STR_COMM011_CLOSE);

							Status = processCommand_sbt_comm011_close_();

							GlobalCommandNo = COMMAND_UNKNOWN;
						}	
						
						/* UNSTACK SKILLSND*/
						else if (strcmp(Msg.cmd, COMMAND_SKILLSND_STR_UNSTACK_INIT) == 0)							// UnStack ָ���ʼ��
						{
							DEBUG_INFO("Command Receive %s", COMMAND_SKILLSND_STR_UNSTACK_INIT);

							Status = processCommand_sbt_unstack_open_();

							if (Status != OK)
							{
								DEBUG_ERROR("Connect Server Error![Server IP:%s, Port:%d]", GlobalSocketIp, GlobalSocketPort);
								mpSetAlarm(8201, "Connect Server Error!", 1);
								break;
							}
							Status = Create_Command_Receive_Task_();
							if (Status != OK)
							{
								/* code */
							}
							else
							{
								
								GlobalCommandNo = COMMAND_UNSTACK_INIT;
							}																												
						}
						// else if (strcmp(Msg.cmd, COMMAND_SKILLSND_STR_UNSTACK_GETDATA) == 0)						// UnStack ָ���ȡ����
						// {
						// 	DEBUG_INFO("Command Receive %s", COMMAND_SKILLSND_STR_UNSTACK_GETDATA);

						// 	GlobalCommandNo = COMMAND_UNSTACK_GETDATA;
						// }
						else if (strcmp(Msg.cmd, COMMAND_SKILLSND_STR_UNSTACK_SUCCESS) == 0)						// UnStack ָ�������ɹ�
						{
							DEBUG_INFO("Command Receive %s", COMMAND_SKILLSND_STR_UNSTACK_SUCCESS);

							GlobalCommandNo = COMMAND_UNSTACK_SUCCESS;
						}
						else if (strcmp(Msg.cmd, COMMAND_SKILLSND_STR_UNSTACK_MISS) == 0)							// Comm011 ָ�������
						{
							DEBUG_INFO("Command Receive %s", COMMAND_SKILLSND_STR_UNSTACK_MISS);

							GlobalCommandNo = COMMAND_UNSTACK_MISS;
						}
						else if (strcmp(Msg.cmd, COMMAND_SKILLSND_STR_UNSTACK_AREA) == 0)							// Comm011 ָ�������
						{
							DEBUG_INFO("Command Receive %s", COMMAND_SKILLSND_STR_UNSTACK_AREA);

							GlobalCommandNo = COMMAND_UNSTACK_AREA;
						}
						else																					// δָ֪��
						{
							DEBUG_INFO("Unknown Command %s", Msg.cmd);
														
							GlobalCommandNo = COMMAND_UNKNOWN;
						}
						break;
					}
					case MP_SKILL_END:
					{
						DEBUG_INFO("MP_SKILL_END");
						
						GlobalCommandNo = COMMAND_UNKNOWN;												// �ָ���δ֪״̬
						
						break;
					}
					default:
					{
						DEBUG_INFO("Unknown Sub Command[main_comm:%d, Msg.sub_comm:%d]", Msg.main_comm, Msg.sub_comm);
						
						GlobalCommandNo = COMMAND_UNKNOWN;												// �ָ���δ֪״̬
					
						break;
					}
				}
				
				break;
			}
			default:
			{
				DEBUG_INFO("Unknown Main Command Or Command Reserved by the system[main_comm:%d]", Msg.main_comm);
				
				GlobalCommandNo = COMMAND_UNKNOWN;														// �ָ���δ֪״̬
				
				break;
			}
		} // switch end
		
	} // FOREVER end
	
	// ����������е�����̼߳����˳����û���Ҫ�������ƹ�
	mpSetAlarm(8201, "Command Process Task quit", 1);
}

/************************************************************************************
* ��  �ܣ����� GlobalCommandNo �������												 *
*  		  GlobalCommandNo ������ command_receive_task_ ��ֵ 						*
* ��  ������																		*
* ����ֵ����																		*
************************************************************************************/
VOID Command_Process_Task_(VOID)
{
	STATUS Status = OK;
	
	// FOREVER begin
	FOREVER
	{
		// ����һ�� IO ����ʱ��
		mpClkAnnounce(MP_IO_CLK);
		if (GlobalCommandNo == COMMAND_UNKNOWN)
		{
			// do nothing
			continue;
		}
		
		mpSemTake(GlobalSemSendBuffer2, WAIT_FOREVER);
				
		// switch begin
		switch (GlobalCommandNo)
		{
			/* UNKNOWN COMMAND*/
			case COMMAND_UNKNOWN:					// Unknown
			{
				mpSemGive(GlobalSemSendBuffer2);	
				break;								// do nothing
			}
			
			/* COMM004 COMMAND*/
			case COMMAND_COMM004_PARAM:				
			{
				Status = ProcessCommand_sbt_comm004_param_();															// ���� Comm004 ���� VIN �� PID ����ָ��
				if (Status != OK)
				{
					DEBUG_ERROR("Execute ProcessCommand_sbt_comm004_param_ Error![ErrorCode:%d]", Status);
					mpSemGive(GlobalSemSendBuffer2);
				}
				else
				{
					set_variable_byte_(MOTOPLUS_STATUS_BYTE_NUMBER, SUCCESS);
					mpSemGive(GlobalSemSendBuffer2);
				}
				
				GlobalCommandNo = COMMAND_UNKNOWN;
				break;
			}
			case COMMAND_COMM004_GUIDE:																					// ���� Comm004 ����ָ��
			{
				Status = ProcessCommand_sbt_comm004_guide_();
				if (Status != OK)
				{
					DEBUG_ERROR("Execute ProcessCommand_sbt_comm004_guide_ Error![ErrorCode:%d]", Status);
					mpSemGive(GlobalSemSendBuffer2);
				}
				else
				{
					set_variable_byte_(MOTOPLUS_STATUS_BYTE_NUMBER, SUCCESS);
					mpSemGive(GlobalSemSendBuffer2);
				}
				
				GlobalCommandNo = COMMAND_UNKNOWN;
				break;
			}
			case COMMAND_COMM004_SEND_POS:																				// ���� Comm004 ѡ�����ָ��
			{
				Status = ProcessCommand_sbt_comm004_send_pos_();
				if (Status != OK)
				{
					DEBUG_ERROR("Execute ProcessCommand_sbt_comm004_send_pos_ Error![ErrorCode:%d]", Status);
					mpSemGive(GlobalSemSendBuffer2);
				}
				else
				{
					set_variable_byte_(MOTOPLUS_STATUS_BYTE_NUMBER, SUCCESS);
					mpSemGive(GlobalSemSendBuffer2);
				}
				
				GlobalCommandNo = COMMAND_UNKNOWN;
				break;
			}
			case COMMAND_COMM004_CAMERA:																				// ���� Comm004 ѡ�����ָ��
			{
				Status = ProcessCommand_sbt_comm004_camera_();
				if (Status != OK)
				{
					DEBUG_ERROR("Execute ProcessCommand_sbt_comm004_camera_ Error![ErrorCode:%d]", Status);
					mpSemGive(GlobalSemSendBuffer2);
				}
				else
				{
					set_variable_byte_(MOTOPLUS_STATUS_BYTE_NUMBER, SUCCESS);
					mpSemGive(GlobalSemSendBuffer2);
				}
				
				GlobalCommandNo = COMMAND_UNKNOWN;
				break;
			}
			case COMMAND_COMM004_VASMB:																					// ���� Comm004 װ��ָ��		
			{
				Status = ProcessCommand_sbt_comm004_vasmb_();
				if (Status != OK)
				{
					DEBUG_ERROR("Execute ProcessCommand_sbt_comm004_vasmb_ Error![ErrorCode:%d]", Status);
					mpSemGive(GlobalSemSendBuffer2);
					GlobalCommandNo = COMMAND_UNKNOWN;
					
				}
				else
				{
					mpSemGive(GlobalSemSendBuffer2);
				}
				
				break;
			}
			case COMMAND_COMM004_DQMONI:																				// ���� Comm004 ָ����ָ��
			{
				Status = ProcessCommand_sbt_comm004_dqmoni_();
				if (Status != OK)
				{
					DEBUG_ERROR("Execute ProcessCommand_sbt_comm004_dqmoni_ Error![ErrorCode:%d]", Status);
					mpSemGive(GlobalSemSendBuffer2);
					GlobalCommandNo = COMMAND_UNKNOWN;
				}
				else
				{
					mpSemGive(GlobalSemSendBuffer2);
				}
				
				// 
				break;
			}
			
			/* COMM011 COMMAND*/
			case COMMAND_COMM011_REALTIME:
			{

				Status = processCommand_sbt_comm011_realtime_();
				if (Status != OK)
				{
					DEBUG_ERROR("Execute processCommand_sbt_comm011_realtime_ Error![ErrorCode:%d]", Status);
					mpSemGive(GlobalSemSendBuffer2);
				}
				else
				{
					mpSemGive(GlobalSemSendBuffer1);
				}
				
				break;
			}
			case COMMAND_COMM011_2DSCAN_START:
			{
				Status = processCommand_sbt_comm011_2dscan_start_();
				if (Status != OK)
				{
					DEBUG_ERROR("Execute processCommand_sbt_comm011_2dscan_start_ Error![ErrorCode:%d]", Status);
					mpSemGive(GlobalSemSendBuffer2);
				}
				else
				{
					// ���� GlobalSemSendBuffer1 һ���ź�����֪ͨ network_process_task_ �����������
					mpSemGive(GlobalSemSendBuffer1);
				}
				
				break;
			}
			case COMMAND_COMM011_2DSCAN_STOP:
			{
				Status = processCommand_sbt_comm011_2dscan_stop_();
				if (Status != OK)
				{
					DEBUG_ERROR("Execute processCommand_sbt_comm011_2dscan_stop_ Error![ErrorCode:%d]", Status);
					mpSemGive(GlobalSemSendBuffer2);
				}
				else
				{
					// ���� GlobalSemSendBuffer1 һ���ź�����֪ͨ network_process_task_ �����������
					mpSemGive(GlobalSemSendBuffer1);
				}
				
				break;
			}
			case COMMAND_COMM011_GET_PATH:
			{
				Status = processCommand_sbt_comm011_get_path_();
				if (Status != OK)
				{
					DEBUG_ERROR("Execute processCommand_sbt_comm011_get_path_ Error![ErrorCode:%d]", Status);
					mpSemGive(GlobalSemSendBuffer2);
				}
				else
				{
					// ���� GlobalSemSendBuffer1 һ���ź�����֪ͨ network_process_task_ �����������
					mpSemGive(GlobalSemSendBuffer1);
				}
				
				break;
			}
			
			/* UNSTACK COMMAND*/
			case COMMAND_UNSTACK_INIT:
			{
				Status = processCommand_sbt_unstack_initialize_();
				if (Status != OK)
				{
					DEBUG_ERROR("Execute processCommand_sbt_unstack_initialize_ Error![ErrorCode:%d]", Status);
					mpSemGive(GlobalSemSendBuffer2);
				}
				else
				{
					// ���� GlobalSemSendBuffer1 һ���ź�����֪ͨ network_process_task_ �����������
					mpSemGive(GlobalSemSendBuffer1);
				}

				// GlobalCommandNo = COMMAND_UNKNOWN;
				
				break;
			}
			case COMMAND_UNSTACK_GETDATA:
			{
				Status = processCommand_sbt_unstack_getData_();
				if (Status != OK)
				{
					DEBUG_ERROR("Execute processCommand_sbt_unstack_getData_ Error![ErrorCode:%d]", Status);
					mpSemGive(GlobalSemSendBuffer2);
				}
				else
				{
					// ���� GlobalSemSendBuffer1 һ���ź�����֪ͨ network_process_task_ �����������
					mpSemGive(GlobalSemSendBuffer1);
				}
				
				break;
			}
			case COMMAND_UNSTACK_SUCCESS:
			{
				Status = processCommand_sbt_unstack_success_();
				if (Status != OK)
				{
					DEBUG_ERROR("Execute processCommand_sbt_unstack_success_ Error![ErrorCode:%d]", Status);
					mpSemGive(GlobalSemSendBuffer2);
				}
				else
				{
					// ���� GlobalSemSendBuffer1 һ���ź�����֪ͨ network_process_task_ �����������
					mpSemGive(GlobalSemSendBuffer1);
				}

				GlobalCommandNo = COMMAND_UNKNOWN;
				
				break;
			}
			case COMMAND_UNSTACK_MISS:
			{
				Status = processCommand_sbt_unstack_miss_();
				if (Status != OK)
				{
					DEBUG_ERROR("Execute processCommand_sbt_unstack_miss_ Error![ErrorCode:%d]", Status);
					mpSemGive(GlobalSemSendBuffer2);
				}
				else
				{
					// ���� GlobalSemSendBuffer1 һ���ź�����֪ͨ network_process_task_ �����������
					mpSemGive(GlobalSemSendBuffer1);
				}
				
				GlobalCommandNo = COMMAND_UNKNOWN;
				break;
			}
			case COMMAND_UNSTACK_AREA:
			{
				Status = processCommand_sbt_unstack_area_();
				if (Status != OK)
				{
					DEBUG_ERROR("Execute processCommand_sbt_unstack_area_ Error![ErrorCode:%d]", Status);
					mpSemGive(GlobalSemSendBuffer2);
				}
				else
				{
					// ���� GlobalSemSendBuffer1 һ���ź�����֪ͨ network_process_task_ �����������
					mpSemGive(GlobalSemSendBuffer1);
				}

				// ��������ɹ����������һ������
				GlobalCommandNo = COMMAND_UNSTACK_GETDATA;
				
				break;
			}
			case COMMAND_UNSTACK_UNREACH:
			{
				Status = processCommand_sbt_unstack_unreach_();
				if (Status != OK)
				{
					DEBUG_ERROR("Execute processCommand_sbt_unstack_unreach_ Error![ErrorCode:%d]", Status);
					mpSemGive(GlobalSemSendBuffer2);
				}
				else
				{
					// ���� GlobalSemSendBuffer1 һ���ź�����֪ͨ network_process_task_ �����������
					mpSemGive(GlobalSemSendBuffer1);
				}
				
				// ��һ�����񲻿ɴ�ʱ��������һ������
				GlobalCommandNo = COMMAND_UNSTACK_GETDATA;
				
				break;
			}
			case COMMAND_UNSTACK_REACH:
			{
				Status = processCommand_sbt_unstack_reach_();
				if (Status != OK)
				{
					DEBUG_ERROR("Execute processCommand_sbt_unstack_reach_ Error![ErrorCode:%d]", Status);
					mpSemGive(GlobalSemSendBuffer2);
				}
				else
				{
					// ���� GlobalSemSendBuffer1 һ���ź�����֪ͨ network_process_task_ �����������
					mpSemGive(GlobalSemSendBuffer1);
				}

				GlobalCommandNo = COMMAND_UNKNOWN;
				
				break;
			}


			default:
			{
				DEBUG_INFO("Unknown command code %d!", GlobalCommandNo);
				
				mpSemGive(GlobalSemSendBuffer2);
			}
		} // switch end
			
	} // FOREVER end
	
	// ����������е�����̼߳����˳����û���Ҫ�������ƹ�
	mpSetAlarm(8201, "Command Process Task quit", 1);
}

/************************************************************************************
* ��  �ܣ� ���� Command_Process_Task_ �����߳�										 *
*  		  						
* ��  ������																		*
* ����ֵ�������ɹ����																 *
************************************************************************************/
STATUS Create_Command_Receive_Task_(VOID)
{
	// ���� Command_Process_Task_ ��������������
	DEBUG_INFO("Delete Command_Process_Task_ Task ! Task Id = %d ", GlobalProcessTaskId);
	// ����ɱ������
	if (GlobalProcessTaskId > 0)
		mpDeleteTask(GlobalProcessTaskId);

	delay_(100);

	// �������̴�������
	GlobalProcessTaskId = mpCreateTask(MP_PRI_IO_CLK_TAKE, MP_STACK_SIZE, (FUNCPTR)Command_Process_Task_,
							0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	if (GlobalProcessTaskId == ERROR)	
	{
		DEBUG_ERROR("Fail mpCreateTask --> Command_Process_Task_ ");

        // ��������
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Fail mpCreateTask --> Command_Process_Task_ ");        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);

		return ERROR;
	}	

	mpSemDelete(GlobalSemSendBuffer2);
	mpSemGive(GlobalSemSendBuffer2);

	DEBUG_INFO("Create Command_Process_Task_ Successful ! TaksId = %d ", GlobalProcessTaskId);

	return OK;
}