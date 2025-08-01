
#ifndef __GLOBAL_VARIABLE_H__
#define __GLOBAL_VARIABLE_H__

#define SERVER_IP_CHAR_REG_ADDR                     0
#define SERVER_PORT		                            11001

// try connect time intervals(ms)
#define TRY_CONNECT_SERVER_TIME_INTERVAL		    50
// try connect count
#define TRY_CONNECT_COUNT						    60
// wait send data time interval(ms)
#define WAIT_SEND_DATA_TIME_INTERVAL			    4


// robot receive buffer size
#define RECEIVE_BUFFER_SIZE						    1024

// robot send buffer size
#define SEND_BUFFER_SIZE					        1024

#define COMM_BUS_ST_ADDR_DIN                        510               
#define COMM_BUS_ST_ADDR_DOUT                       10510      

#define MAX_VIN_LENGTH                              17

// Define Motoplus & inform Comm Variable
#define MOTOPLUS_STATUS_BYTE_NUMBER                 69              // B[069]

#define PARAM1_INT_NUMBER							70 
#define PARAM2_INT_NUMBER							71
#define PARAM3_INT_NUMBER							72
#define PARAM4_INT_NUMBER							73
#define PARAM5_INT_NUMBER							74
#define PARAM6_INT_NUMBER							75
#define PARAM7_INT_NUMBER							76
#define PARAM8_INT_NUMBER							77

#define PARAM1_FLOAT_NUMBER							70
#define PARAM2_FLOAT_NUMBER							71
#define PARAM3_FLOAT_NUMBER							72
#define PARAM4_FLOAT_NUMBER							73
#define PARAM5_FLOAT_NUMBER							74
#define PARAM6_FLOAT_NUMBER							75
#define PARAM7_FLOAT_NUMBER							76
#define PARAM8_FLOAT_NUMBER							77

#define PARAM1_STRING_NUMBER						70
#define PARAM2_STRING_NUMBER						71
#define PARAM3_STRING_NUMBER						72
#define PARAM4_STRING_NUMBER						73
#define PARAM5_STRING_NUMBER						74
#define PARAM6_STRING_NUMBER						75
#define PARAM7_STRING_NUMBER						76
#define PARAM8_STRING_NUMBER						77

#define PARAM1_BYTE_NUMBER                          70
#define PARAM2_BYTE_NUMBER                          71
#define PARAM3_BYTE_NUMBER                          72
#define PARAM4_BYTE_NUMBER                          73
#define PARAM5_BYTE_NUMBER                          74
#define PARAM6_BYTE_NUMBER                          75
#define PARAM7_BYTE_NUMBER                          76
#define PARAM8_BYTE_NUMBER                          77

#define COMMAND_SKILLSND_STR_COMM004_PARAM              "Comm004Param"               // COMM004 ������ʼ������
#define COMMAND_SKILLSND_STR_COMM004_GUIDE              "Comm004Guide"               // COMM004 ��������
#define COMMAND_SKILLSND_STR_COMM004_SEND_POS           "Comm004SendPos"             // COMM004 ����λ������
#define COMMAND_SKILLSND_STR_COMM004_CAMERA             "Comm004Camera"              // COMM004 ��������������
#define COMMAND_SKILLSND_STR_COMM004_VASMB              "Comm004VaSmb"               // COMM004 װ������
#define COMMAND_SKILLSND_STR_COMM004_DQMONI             "Comm004DqMoni"              // COMM004 ָ��������


#define COMMAND_SKILLSND_STR_COMM011_OPEN               "Comm011Open"               // COMM011 ��������
#define COMMAND_SKILLSND_STR_COMM011_CLOSE              "Comm011Close"              // COMM011 �Ͽ�����
#define COMMAND_SKILLSND_STR_COMM011_2DSCAN_START       "Comm011Scan2DStart"        // COMM011 2D ɨ�迪ʼ
#define COMMAND_SKILLSND_STR_COMM011_2DSCAN_STOP        "Comm011Scan2DStop"         // COMM011 2D ɨ��ֹͣ
#define COMMAND_SKILLSND_STR_COMM011_GET_PATH           "Comm011GetPath"            // COMM011 ��ȡ�켣

/* UnStack */
#define COMMAND_SKILLSND_STR_UNSTACK_INIT               "UnStackInit"       // UNSTACK ��ʼ��
// #define COMMAND_SKILLSND_STR_UNSTACK_GETDATA            "UnStackGetData"    // UNSTACK ��ȡ����
#define COMMAND_SKILLSND_STR_UNSTACK_SUCCESS            "UnStackSuccess"    // UNSTACK ������ɹ�����
#define COMMAND_SKILLSND_STR_UNSTACK_MISS               "UnStackMiss"       // UNSTACK ���䷴��
#define COMMAND_SKILLSND_STR_UNSTACK_AREA               "UnStackArea"       // UNSTACK ������



// The sensor command sent by executing SKILLSND instruct
#define COMMAND_UNKNOWN								0	// unknown

/* Comm004 */
#define COMMAND_COMM004_PARAM                       400     // COMM004 ������ʼ��
#define COMMAND_COMM004_GUIDE                       401     // COMM004 ����
#define COMMAND_COMM004_SEND_POS                    402     // COMM004 ����λ��
#define COMMAND_COMM004_CAMERA                      403     // COMM004 ����������
#define COMMAND_COMM004_VASMB                       404     // COMM004 װ��
#define COMMAND_COMM004_DQMONI                      405     // COMM004 ָ����

/* Comm011 */
#define COMMAND_COMM011_REALTIME                    1100    // COMM011 ʵʱͨѶ
#define COMMAND_COMM011_2DSCAN_START                1101    // COMM011 2D ɨ�迪ʼ
#define COMMAND_COMM011_2DSCAN_STOP                 1102    // COMM011 2D ɨ��ֹͣ
#define COMMAND_COMM011_GET_PATH                    1103    // COMM011 ��ȡ�켣

/* UnStack */
#define COMMAND_UNSTACK_INIT                        87000    // UNSTACK ��ʼ��
#define COMMAND_UNSTACK_GETDATA                     87001    // UNSTACK ��ȡ����
#define COMMAND_UNSTACK_SUCCESS                     87002    // UNSTACK ������ɹ�����
#define COMMAND_UNSTACK_MISS                        87003    // UNSTACK ���䷴��
#define COMMAND_UNSTACK_AREA                        87004    // UNSTACK ������
#define COMMAND_UNSTACK_UNREACH                     87005    // UNSTACK �������ɴ�
#define COMMAND_UNSTACK_REACH                       87006    // UNSTACK �����ɴ�


/* Bus Comm Init */
#define COMMAND_BUSIO_INIT							99999	// Bus Io Init

typedef UINT8 vin_t[MAX_VIN_LENGTH];

//====================================================================================
// һЩȫ�ֱ���������

IMPORT INT32 GlobalCommandNo;										// ��ǰ�����˽��յ���JOB��SKILLSND����������
IMPORT INT32 GlobalProcessTaskId;                                   // Command_Process_Task_ ���� ID

IMPORT INT32 GlobalSocketHandle;							        // socket handle
IMPORT INT32 GlobalSocketPort;                                      // Connect Server Port
IMPORT CHAR GlobalSocketIp[STR_VAR_SIZE + 1];                       // Connect Server Ip
IMPORT struct sockaddr_in GlobalSockAddr;					        // socket address
IMPORT INT32 GlobalConnectStatus;								    // connect status
IMPORT INT32 GlobalConnect;									        // connect Flag

// robot receive buffer
IMPORT UINT8 GlobalReceiveBuffer[RECEIVE_BUFFER_SIZE];
// the length of robot received buffer
IMPORT INT32 GlobalReceivedDataLenght;

// robot send buffer
IMPORT UINT8 GlobalSendBuffer[SEND_BUFFER_SIZE];
// the length of send data
IMPORT INT32 GlobalSendDataLenght;

IMPORT SEM_ID GlobalSemSendBuffer1;								// �Է��ͻ��������ʵĻ���
IMPORT SEM_ID GlobalSemSendBuffer2;								// �Է��ͻ��������ʵĻ���

IMPORT struct businput_t GlobalBusInput;
IMPORT struct busoutput_t GlobalBusOutput;

IMPORT INT32 GlobalBusTimeout;

IMPORT VOID* GlobalStopWatch;										// ��ʱ��ָ��

IMPORT vin_t GlobalVinCode;
IMPORT UINT8 GlobalPartId; 

#endif /* __GLOBAL_VARIABLE_H__ */
