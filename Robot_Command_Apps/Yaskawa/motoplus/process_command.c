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
* 功  能：接收JOB发送的SKILLSND命令，并处理											  *
* 参  数：无																		*
* 返回值：无																		*
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
		Status = mpReceiveSkillCommand(MP_SL_ID1, &Msg);		// 接收SKILLSND发送的命令
		
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
						else if (strcmp(Msg.cmd, COMMAND_SKILLSND_STR_COMM004_PARAM) == 0)						// Comm004 发送 VIN 和 PID 参数指令
						{
							DEBUG_INFO("Command Receive %s", COMMAND_SKILLSND_STR_COMM004_PARAM);
							
							// 初始化 Comm004 数据
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
						else if (strcmp(Msg.cmd, COMMAND_SKILLSND_STR_COMM004_GUIDE) == 0)						// Comm004 引导指令
						{
							DEBUG_INFO("Command Receive %s", COMMAND_SKILLSND_STR_COMM004_GUIDE);

							GlobalCommandNo = COMMAND_COMM004_GUIDE;
														
						}
						else if (strcmp(Msg.cmd, COMMAND_SKILLSND_STR_COMM004_SEND_POS) == 0)					// Comm004 发送制定坐标系位置指令
						{
							DEBUG_INFO("Command Receive %s", COMMAND_SKILLSND_STR_COMM004_SEND_POS);

							GlobalCommandNo = COMMAND_COMM004_SEND_POS;
														
						}
						else if (strcmp(Msg.cmd, COMMAND_SKILLSND_STR_COMM004_CAMERA) == 0)						// Comm004 选择相机指令
						{
							DEBUG_INFO("Command Receive %s", COMMAND_SKILLSND_STR_COMM004_CAMERA);

							GlobalCommandNo = COMMAND_COMM004_CAMERA;
														
						}
						else if (strcmp(Msg.cmd, COMMAND_SKILLSND_STR_COMM004_VASMB) == 0)						// Comm004 装调指令
						{
							DEBUG_INFO("Command Receive %s", COMMAND_SKILLSND_STR_COMM004_VASMB);

							Status = processCommand_sbt_comm004_initialize_();

							GlobalCommandNo = COMMAND_COMM004_VASMB;
														
						}
						else if (strcmp(Msg.cmd, COMMAND_SKILLSND_STR_COMM004_DQMONI) == 0)						// Comm004 指令监控指令
						{
							DEBUG_INFO("Command Receive %s", COMMAND_COMM004_DQMONI);

							Status = processCommand_sbt_comm004_initialize_();

							GlobalCommandNo = COMMAND_COMM004_DQMONI;
														
						}

						/* COMM011 SKILLSND*/
						else if (strcmp(Msg.cmd, COMMAND_SKILLSND_STR_COMM011_OPEN) == 0)						// Comm011 指令链接通讯
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
						else if (strcmp(Msg.cmd, COMMAND_SKILLSND_STR_COMM011_CLOSE) == 0)						// Comm011 指令断开通讯
						{
							DEBUG_INFO("Command Receive %s", COMMAND_SKILLSND_STR_COMM011_CLOSE);

							Status = processCommand_sbt_comm011_close_();

							GlobalCommandNo = COMMAND_UNKNOWN;
						}	
						
						/* UNSTACK SKILLSND*/
						else if (strcmp(Msg.cmd, COMMAND_SKILLSND_STR_UNSTACK_INIT) == 0)							// UnStack 指令初始化
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
						// else if (strcmp(Msg.cmd, COMMAND_SKILLSND_STR_UNSTACK_GETDATA) == 0)						// UnStack 指令获取数据
						// {
						// 	DEBUG_INFO("Command Receive %s", COMMAND_SKILLSND_STR_UNSTACK_GETDATA);

						// 	GlobalCommandNo = COMMAND_UNSTACK_GETDATA;
						// }
						else if (strcmp(Msg.cmd, COMMAND_SKILLSND_STR_UNSTACK_SUCCESS) == 0)						// UnStack 指令反馈任务成功
						{
							DEBUG_INFO("Command Receive %s", COMMAND_SKILLSND_STR_UNSTACK_SUCCESS);

							GlobalCommandNo = COMMAND_UNSTACK_SUCCESS;
						}
						else if (strcmp(Msg.cmd, COMMAND_SKILLSND_STR_UNSTACK_MISS) == 0)							// Comm011 指令反馈掉箱
						{
							DEBUG_INFO("Command Receive %s", COMMAND_SKILLSND_STR_UNSTACK_MISS);

							GlobalCommandNo = COMMAND_UNSTACK_MISS;
						}
						else if (strcmp(Msg.cmd, COMMAND_SKILLSND_STR_UNSTACK_AREA) == 0)							// Comm011 指令反馈区域
						{
							DEBUG_INFO("Command Receive %s", COMMAND_SKILLSND_STR_UNSTACK_AREA);

							GlobalCommandNo = COMMAND_UNSTACK_AREA;
						}
						else																					// 未知指令
						{
							DEBUG_INFO("Unknown Command %s", Msg.cmd);
														
							GlobalCommandNo = COMMAND_UNKNOWN;
						}
						break;
					}
					case MP_SKILL_END:
					{
						DEBUG_INFO("MP_SKILL_END");
						
						GlobalCommandNo = COMMAND_UNKNOWN;												// 恢复成未知状态
						
						break;
					}
					default:
					{
						DEBUG_INFO("Unknown Sub Command[main_comm:%d, Msg.sub_comm:%d]", Msg.main_comm, Msg.sub_comm);
						
						GlobalCommandNo = COMMAND_UNKNOWN;												// 恢复成未知状态
					
						break;
					}
				}
				
				break;
			}
			default:
			{
				DEBUG_INFO("Unknown Main Command Or Command Reserved by the system[main_comm:%d]", Msg.main_comm);
				
				GlobalCommandNo = COMMAND_UNKNOWN;														// 恢复成未知状态
				
				break;
			}
		} // switch end
		
	} // FOREVER end
	
	// 如果程序运行到这里，线程即将退出，用户需要重启控制柜。
	mpSetAlarm(8201, "Command Process Task quit", 1);
}

/************************************************************************************
* 功  能：处理 GlobalCommandNo 命令过程												 *
*  		  GlobalCommandNo 命令由 command_receive_task_ 赋值 						*
* 参  数：无																		*
* 返回值：无																		*
************************************************************************************/
VOID Command_Process_Task_(VOID)
{
	STATUS Status = OK;
	
	// FOREVER begin
	FOREVER
	{
		// 阻塞一个 IO 周期时间
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
				Status = ProcessCommand_sbt_comm004_param_();															// 处理 Comm004 发送 VIN 和 PID 参数指令
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
			case COMMAND_COMM004_GUIDE:																					// 处理 Comm004 引导指令
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
			case COMMAND_COMM004_SEND_POS:																				// 处理 Comm004 选择相机指令
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
			case COMMAND_COMM004_CAMERA:																				// 处理 Comm004 选择相机指令
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
			case COMMAND_COMM004_VASMB:																					// 处理 Comm004 装调指令		
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
			case COMMAND_COMM004_DQMONI:																				// 处理 Comm004 指令监控指令
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
					// 发行 GlobalSemSendBuffer1 一个信号量，通知 network_process_task_ 任务继续处理
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
					// 发行 GlobalSemSendBuffer1 一个信号量，通知 network_process_task_ 任务继续处理
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
					// 发行 GlobalSemSendBuffer1 一个信号量，通知 network_process_task_ 任务继续处理
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
					// 发行 GlobalSemSendBuffer1 一个信号量，通知 network_process_task_ 任务继续处理
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
					// 发行 GlobalSemSendBuffer1 一个信号量，通知 network_process_task_ 任务继续处理
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
					// 发行 GlobalSemSendBuffer1 一个信号量，通知 network_process_task_ 任务继续处理
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
					// 发行 GlobalSemSendBuffer1 一个信号量，通知 network_process_task_ 任务继续处理
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
					// 发行 GlobalSemSendBuffer1 一个信号量，通知 network_process_task_ 任务继续处理
					mpSemGive(GlobalSemSendBuffer1);
				}

				// 反馈区域成功后继续拿下一个任务
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
					// 发行 GlobalSemSendBuffer1 一个信号量，通知 network_process_task_ 任务继续处理
					mpSemGive(GlobalSemSendBuffer1);
				}
				
				// 上一个任务不可达时，继续拿一下数据
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
					// 发行 GlobalSemSendBuffer1 一个信号量，通知 network_process_task_ 任务继续处理
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
	
	// 如果程序运行到这里，线程即将退出，用户需要重启控制柜。
	mpSetAlarm(8201, "Command Process Task quit", 1);
}

/************************************************************************************
* 功  能： 创建 Command_Process_Task_ 任务线程										 *
*  		  						
* 参  数：无																		*
* 返回值：创建成功与否																 *
************************************************************************************/
STATUS Create_Command_Receive_Task_(VOID)
{
	// 创建 Command_Process_Task_ 任务来处理命令
	DEBUG_INFO("Delete Command_Process_Task_ Task ! Task Id = %d ", GlobalProcessTaskId);
	// 避免杀死自身
	if (GlobalProcessTaskId > 0)
		mpDeleteTask(GlobalProcessTaskId);

	delay_(100);

	// 创建过程处理任务
	GlobalProcessTaskId = mpCreateTask(MP_PRI_IO_CLK_TAKE, MP_STACK_SIZE, (FUNCPTR)Command_Process_Task_,
							0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	if (GlobalProcessTaskId == ERROR)	
	{
		DEBUG_ERROR("Fail mpCreateTask --> Command_Process_Task_ ");

        // 产生报警
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