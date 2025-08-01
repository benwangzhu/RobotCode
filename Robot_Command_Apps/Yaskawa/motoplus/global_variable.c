

#include "motoPlus.h"
#include "lib/lib_mpbusio.h"
#include "global_variable.h"

INT32 GlobalCommandNo = COMMAND_UNKNOWN;						// 当前机器人接收到的JOB的SKILLSND发出的命令
INT32 GlobalProcessTaskId = 0;                                  // Command_Process_Task_ 任务 ID

INT32 GlobalSocketHandle = -1;								// socket handle
INT32 GlobalSocketPort = SERVER_PORT;                       // Connect Server Port
CHAR GlobalSocketIp[STR_VAR_SIZE + 1];                      // Connect Server Ip
struct sockaddr_in GlobalSockAddr;							// socket address
INT32 GlobalConnectStatus = 0;								// connect status
INT32 GlobalConnect = 0;							        // connect Flag

// robot receive buffer
UINT8 GlobalReceiveBuffer[RECEIVE_BUFFER_SIZE] = {0};
// the length of robot received buffer
INT32 GlobalReceivedDataLenght = 0;

// robot send buffer
UINT8 GlobalSendBuffer[SEND_BUFFER_SIZE] = {0};
// the length of send data
INT32 GlobalSendDataLenght = 0;

SEM_ID GlobalSemSendBuffer1 = NULL;								// 对发送缓冲区访问的互斥
SEM_ID GlobalSemSendBuffer2 = NULL;								// 对发送缓冲区访问的互斥

//总线通讯输入结构
struct businput_t GlobalBusInput    = {COMM_BUS_ST_ADDR_DIN, 
                                       FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 
                                       0, 0, 0, 0, 0, 0, 0};

// 总线通讯输出结构
struct busoutput_t GlobalBusOutput  = {COMM_BUS_ST_ADDR_DOUT, 
                                       FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 
                                       0, 0, 0, 0, 0, 0, 0};

INT32 GlobalBusTimeout = 30000;

VOID* GlobalStopWatch = NULL;								    // 计时器指针

vin_t GlobalVinCode = {0};              // Vin 编码
UINT8 GlobalPartId = 0;                 // 工件 编码
