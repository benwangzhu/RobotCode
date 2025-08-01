//mpMain.c
#include "motoPlus.h"
#include "global_variable.h"
#include "lib/operating_environment.h"

int  SetApplicationInfo();

IMPORT VOID Command_Receive_Task_(VOID);
IMPORT VOID Command_Process_Task_(VOID);
IMPORT VOID Network_Process_Task_(VOID);

//GLOBAL DATA DEFINITIONS
int nTaskID1;
int nTaskID2;
int nTaskID3;

void mpUsrRoot(int arg1, int arg2, int arg3, int arg4, int arg5, int arg6, int arg7, int arg8, int arg9, int arg10)
{
	int rc;

	//Creates and starts a new task in a seperate thread of execution.
	//All arguments will be passed to the new task if the function
	//prototype will accept them.
	nTaskID1 = mpCreateTask(MP_PRI_TIME_NORMAL, MP_STACK_SIZE, (FUNCPTR)Network_Process_Task_,
						arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
						
	// 开机后只激活这一个线程，来接收示教器宏程序发出的指令
	nTaskID2 = mpCreateTask(MP_PRI_TIME_NORMAL, MP_STACK_SIZE, (FUNCPTR)Command_Receive_Task_,
						arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
						
	// nTaskID3 = mpCreateTask(MP_PRI_IO_CLK_TAKE, MP_STACK_SIZE, (FUNCPTR)Command_Process_Task_,
	// 					arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
							
	GlobalSemSendBuffer1 = mpSemBCreate(SEM_Q_FIFO, SEM_EMPTY);
	GlobalSemSendBuffer2 = mpSemBCreate(SEM_Q_FIFO, SEM_FULL);
	
	//Set application information.
	rc = SetApplicationInfo();

	//Ends the initialization task.
	mpExitUsrRoot;
}

//Set application information.
int SetApplicationInfo(void)
{
	int                     rc = 0;

	#if (CONTROL_VER == YRC1000)
	MP_APPINFO_SEND_DATA    sData;
	MP_STD_RSP_DATA         rData;
	
	memset(&sData, 0x00, sizeof(sData));
	memset(&rData, 0x00, sizeof(rData));

	strncpy(sData.AppName,  "Speedbot",  	MP_MAX_APP_NAME);
	strncpy(sData.Version,  "0.03",      	MP_MAX_APP_VERSION);
	strncpy(sData.Comment,  "Speedbot", 	MP_MAX_APP_COMMENT);

	rc = mpApplicationInfoNotify(&sData, &rData);
	#endif
	
	return rc;
}

