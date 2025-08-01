/***********************************************************

Copyright 2018 - 2023 speedbot All Rights reserved.

file Name: lib_mptp_if.c

Description:
  Language             ==   motoplus for Yaskawa ROBOT
  Date                 ==   2021 - 09 - 03
  Modification Data    ==   2021 - 09 - 18

Author: speedbot

Version: 1.0
--*********************************************************************************************************--
--                                                                                                         --
--                                                      .^^^                                               --
--                                               .,~<c+{{{{{{t,                                            -- 
--                                       `^,"!t{{{{{{{{{{{{{{{{+,                                          --
--                                 .:"c+{{{{{{{{{{{{{{{{{{{{{{{{{+,                                        --
--                                "{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{~                                       --
--                               ^{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{!.  `^                                    --
--                               c{{{{{{{{{{{{{c~,^`  `.^:<+{{{!.  `<{{+,                                  --
--                              ^{{{{{{{{{{{!^              `,.  `<{{{{{{+:                                --
--                              t{{{{{{{{{!`                    ~{{{{{{{{{{+,                              --
--                             ,{{{{{{{{{:      ,uDWMMH^        `c{{{{{{{{{{{~                             --
--                             +{{{{{{{{:     ,XMMMMMMw           t{{{{{{{{{{t                             --
--                            ,{{{{{{{{t     :MMMMMMMMM"          ^{{{{{{{{{{~                             --
--                            +{{{{{{{{~     8MMMMMMMMMMWD8##      {{{{{{{{{+                              --
--                           :{{{{{{{{{~     8MMMMMMMMMMMMMMH      {{{{{{{{{~                              --
--                           +{{{{{{{{{c     :MMMMMMMMMMMMMMc     ^{{{{{{{{+                               --
--                          ^{{{{{{{{{{{,     ,%MMMMMMMMMMH"      c{{{{{{{{:                               --
--                          `+{{{{{{{{{{{^      :uDWMMMX0"       !{{{{{{{{+                                --
--                           `c{{{{{{{{{{{"                    ^t{{{{{{{{{,                                --
--                             ^c{{{{{{{{{{{".               ,c{{{{{{{{{{t                                 --
--                               ^c{{{{{{{{{{{+<,^`     .^~c{{{{{{{{{{{{{,                                 --
--                                 ^c{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{t                                  --
--                                   ^c{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{t`                                  --
--                                     ^c{{{{{{{{{{{{{{{{{{{{{{{{{{+c"^                                    --                         
--                                       ^c{{{{{{{{{{{{{{{{{+!":^.                                         --
--                                         ^!{{{{{{{{t!",^`                                                --
--                                                                                                         --
--*********************************************************************************************************--
--  

2022 - 03 - 01 ++ delay_() ==> STATUS

2022 - 03 - 01 ++ get_variable_byte_() ==> UCHAR

2022 - 03 - 01 ++ get_variable_int16_() ==> SHORT

2022 - 03 - 01 ++ get_variable_long_() ==> LONG

2022 - 03 - 01 ++ get_variable_float_() ==> FLOAT

2022 - 03 - 01 ++ get_variable_string_() ==> STATUS

2022 - 03 - 01 ++ get_variable_robot_pos_() ==> STATUS

2022 - 03 - 01 ++ get_variable_base_pos_() ==> STATUS

2022 - 03 - 01 ++ get_io_value_() ==> USHORT

2022 - 03 - 01 ++ is_alarm_() ==> BOOL

2022 - 03 - 01 ++ is_emergency_Stop_() ==> BOOL

2022 - 03 - 01 ++ is_servo_power_on_() ==> BOOL

2022 - 03 - 01 ++ is_remote_mode_() ==> BOOL

2022 - 03 - 01 ++ is_play_mode_() ==> BOOL

2022 - 03 - 01 ++ is_teach_mode_() ==> BOOL

2022 - 03 - 01 ++ set_variable_byte_() ==> STATUS

2022 - 03 - 01 ++ set_variable_int16_() ==> STATUS

2022 - 03 - 01 ++ set_variable_long_() ==> STATUS

2022 - 03 - 01 ++ set_variable_float_() ==> STATUS

2022 - 03 - 01 ++ set_variable_string_() ==> STATUS

2022 - 03 - 01 ++ set_variable_robot_pos_() ==> STATUS

2022 - 03 - 01 ++ set_variable_base_pos_() ==> STATUS

2022 - 03 - 01 ++ set_io_value_() ==> STATUS

2022 - 03 - 01 ++ pulse_io_() ==> STATUS

2022 - 03 - 01 ++ alarm_reset_() ==> BOOL

2022 - 03 - 01 ++ servo_power_on_() ==> BOOL

2022 - 04 - 01 ++ is_running_() ==> BOOL

2022 - 04 - 07 ++ get_alarm_code_() ==> INT32

*/

#include "motoPlus.h"
#include "lib_mptp_if.h"

STATUS delay_(IN UINT32 Msec) 
{
    #if (CONTROL_VER == YRC1000)
    return(mpTaskDelay((int)(Msec * ((double)mpGetSysClkRate() / 1000))));
    #else
    return(mpTaskDelay((int)Msec));
    #endif
}

UCHAR get_variable_byte_(IN USHORT Index)
{
    MP_USR_VAR_INFO Info;
    INT32 Status;

    Info.var_type = MP_VAR_B;
    Info.var_no = Index;

    Status = mpGetUserVars(&Info);
	if (Status != OK) 
    {
	    DEBUG_ERROR("Get Byte Var Error![Index:%d, Status:%d]", Index, Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Get Byte Var Error![Index:%d, Status:%d]", Index, Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
    }
	return(Info.val.b);
}

SHORT get_variable_int16_(IN USHORT Index)
{
    MP_USR_VAR_INFO Info;
    INT32 Status;

    Info.var_type = MP_VAR_I;
    Info.var_no = Index;

    Status = mpGetUserVars(&Info);
	if (Status != OK) 
    {
    	DEBUG_ERROR("Get Int Var Error![Index:%d, Status:%d]", Index, Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Get Int Var Error![Index:%d, Status:%d]", Index, Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
    }
	return(Info.val.i);
}

LONG get_variable_long_(IN USHORT Index)
{
    MP_USR_VAR_INFO Info;
    INT32 Status;

    Info.var_type = MP_VAR_D;
    Info.var_no = Index;

    Status = mpGetUserVars(&Info);
	if (Status != OK) 
    {
	    DEBUG_ERROR("Get Long Var Error![Index:%d, Status:%d]", Index, Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Get Long Var Error![Index:%d, Status:%d]", Index, Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
    }
	return(Info.val.d);
}

FLOAT get_variable_float_(IN USHORT Index)
{
    MP_USR_VAR_INFO Info;
    INT32 Status;

    Info.var_type = MP_VAR_R;
    Info.var_no = Index;

    Status = mpGetUserVars(&Info);
	if (Status != OK) 
    {
	    DEBUG_ERROR("Get Real Var Error![Index:%d, Status:%d]", Index, Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Get Real Var Error![Index:%d, Status:%d]", Index, Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
    }
	return(Info.val.r);
}

STATUS get_variable_string_(IN USHORT Index, OUT CHAR StringValue[STR_VAR_SIZE + 1])
{
    MP_USR_VAR_INFO Info;
    INT32 Status;

    Info.var_type = MP_VAR_S;
    Info.var_no = Index;

    memset(&Info.val.s, '\0', sizeof(Info.val.s));

    Status = mpGetUserVars(&Info);
	if (Status != OK) 
    {
    	DEBUG_ERROR("Get String Var Error![Index:%d, Status:%d]", Index, Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Get String Var Error![Index:%d, Status:%d]", Index, Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);

        return(ERROR);
    }

    strncpy(StringValue, (char *)Info.val.s, STR_VAR_SIZE + 1);

    return(OK);
}

STATUS get_variable_robot_position_(IN USHORT Index, OUT MP_P_VAR_BUFF* PositionValue)
{
    MP_USR_VAR_INFO Info;
    INT32 Status;
    
    Info.var_type = MP_VAR_P;
    Info.var_no = Index;

    Status = mpGetUserVars(&Info);
	if (Status != OK) 
    {
    	DEBUG_ERROR("Get Pos Var Error![Index:%d, Status:%d]", Index, Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Get Pos Var Error![Index:%d, Status:%d]", Index, Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);

        return(ERROR);
    }

    memcpy(PositionValue, &Info.val.p, sizeof(MP_P_VAR_BUFF));

    return(OK);
}

STATUS get_variable_base_position_(IN USHORT Index, OUT MP_P_VAR_BUFF* PositionValue)
{
    MP_USR_VAR_INFO Info;
    INT32 Status;
    
    Info.var_type = MP_VAR_BP;
    Info.var_no = Index;

    Status = mpGetUserVars(&Info);
	if (Status != OK) 
    {
    	DEBUG_ERROR("Get BPos Var Error![Index:%d, Status:%d]", Index, Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Get BPos Var Error![Index:%d, Status:%d]", Index, Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
        return(ERROR);
    }

    memcpy(PositionValue, &Info.val.bp, sizeof(MP_P_VAR_BUFF));

    return(OK);
}

USHORT get_io_value_(IN UINT32 Index)
{
	MP_IO_INFO Info;
	USHORT Signal;
    INT32 Status;

	Info.ulAddr = Index;
    Status = mpReadIO(&Info, &Signal, 1);
	if (Status != OK) 
    {
    	DEBUG_ERROR("Get IO Error![Index:%d, Status:%d]", Index, Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Get IO Error![Index:%d, Status:%d]", Index, Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
        return(ERROR);
    }
    
	return(Signal);
}

BOOL is_alarm_() 
{
    int Ans = 0;
    MP_ALARM_STATUS_RSP_DATA Output;
    INT32 Status;

    Status = mpGetAlarmStatus(&Output);
	if (Status != OK) 
    {
    	DEBUG_ERROR("Get Alarm Error![Status:%d]", Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Get Alarm Error![Status:%d]", Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
    }

    Ans = ((Output.sIsAlarm & 0x02) != 0) ? TRUE : FALSE;

    return(Ans);
}

BOOL is_error_() 
{
    int Ans = 0;
    MP_ALARM_STATUS_RSP_DATA Output;
    INT32 Status;

    Status = mpGetAlarmStatus(&Output);
	if (Status != OK) 
    {
    	DEBUG_ERROR("Get Fault Error![Status:%d]", Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Get Fault Error![Status:%d]", Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
    }

    Ans = ((Output.sIsAlarm & 0x01) != 0) ? TRUE : FALSE;

    return (Ans);
}

BOOL is_emergency_Stop_() 
{
    USHORT Signal = 0;
    MP_IO_INFO Info;
    INT32 Status;

    Info.ulAddr = 80026;
    Status = mpReadIO(&Info, &Signal, 1);
	if (Status != OK) 
    {
    	DEBUG_ERROR("Get Emergency Error![Status:%d]", Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Get Emergency Error![Status:%d]", Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
    }
    return (Signal > 0 ? FALSE : TRUE);
}

BOOL is_servo_power_on_() 
{
    MP_SERVO_POWER_RSP_DATA Output;
    INT32 Status;

    Status = mpGetServoPower(&Output);
	if (Status != OK) 
    {
    	DEBUG_ERROR("Get Servo Power Error![Status:%d]", Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Get Servo Power Error![Status:%d]", Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
    }
    return (Output.sServoPower == 0 ? FALSE : TRUE);
}

BOOL is_remote_mode_() 
{
    USHORT Signal = 0;
    MP_IO_INFO Info;
    INT32 Status;

    Info.ulAddr = 80011;
    Status = mpReadIO(&Info, &Signal, 1);
	if (Status != OK) 
    {
    	DEBUG_ERROR("Get Remote Switch Error![Status:%d]", Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Get Remote Switch Error![Status:%d]", Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
    }
    return (Signal <= 0 ? FALSE : TRUE);
}

BOOL is_play_mode_() 
{
    USHORT Signal = 0;
    MP_IO_INFO Info;
    INT32 Status;

    Info.ulAddr = 50054;
    Status = mpReadIO(&Info, &Signal, 1);
	if (Status != OK) 
    {
    	DEBUG_ERROR("Get Play Switch Error![Status:%d]", Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Get Play Switch Error![Status:%d]", Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
    }
    return (Signal <= 0 ? FALSE : TRUE);
}

BOOL is_teach_mode_() 
{
    USHORT Signal = 0;
    MP_IO_INFO Info;
    INT32 Status;

    Info.ulAddr = 50053;
    Status = mpReadIO(&Info, &Signal, 1);
	if (Status != OK) 
    {
    	DEBUG_ERROR("Get Mode Error![Status:%d]", Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Get Mode Error![Status:%d]", Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
    }
    return (Signal <= 0 ? FALSE : TRUE);
}

STATUS set_variable_byte_(IN USHORT Index, IN UCHAR Value)
{
    MP_USR_VAR_INFO Info;
    INT32 Status;

    Info.var_type = MP_VAR_B;
    Info.var_no = Index;
    Info.val.b = Value;

    Status = mpPutUserVars(&Info);
    if (Status != OK) 
    {
    	DEBUG_ERROR("Set Byte Reg Error![Index:%d, Status:%d]", Index, Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Set Byte Reg Error![Index:%d, Status:%d]", Index, Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
    }

    return(Status);
}

STATUS set_variable_int16_(IN USHORT Index, IN SHORT Value)
{
    MP_USR_VAR_INFO Info;
    INT32 Status;

    Info.var_type = MP_VAR_I;
    Info.var_no = Index;
    Info.val.i = Value;

    Status = mpPutUserVars(&Info);
    if (Status != OK) 
    {
    	DEBUG_ERROR("Set Int Reg Error![Index:%d, Status:%d]", Index, Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Set Int Reg Error![Index:%d, Status:%d]", Index, Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
    }

    return(Status);
}

STATUS set_variable_long_(IN USHORT Index, IN INT32 Value)
{
    MP_USR_VAR_INFO Info;
    INT32 Status;

    Info.var_type = MP_VAR_D;
    Info.var_no = Index;
    Info.val.d = Value;

    Status = mpPutUserVars(&Info);
    if (Status != OK) 
    {
    	DEBUG_ERROR("Set Long Reg Error![Index:%d, Status:%d]", Index, Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Set Long Reg Error![Index:%d, Status:%d]", Index, Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
    }

    return(Status);
}

STATUS set_variable_float_(IN USHORT Index, IN FLOAT Value)
{
    MP_USR_VAR_INFO Info;
    INT32 Status;

    Info.var_type = MP_VAR_R;
    Info.var_no = Index;
    Info.val.r = Value;

    Status = mpPutUserVars(&Info);
    if (Status != OK) 
    {
    	DEBUG_ERROR("Set Real Reg Error![Index:%d, Status:%d]", Index, Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Set Real Reg Error![Index:%d, Status:%d]", Index, Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
    }

    return(Status);
}

STATUS set_variable_string_(IN USHORT Index, IN const CHAR StringValue[STR_VAR_SIZE + 1])
{
    MP_USR_VAR_INFO Info;
    INT32 Status;

    Info.var_type = MP_VAR_S;
    Info.var_no = Index;

    strncpy((char *)Info.val.s, StringValue, STR_VAR_SIZE);

    Status = mpPutUserVars(&Info);
    if (Status != OK) 
    {
    	DEBUG_ERROR("Set String Reg Error![Index:%d, Status:%d]", Index, Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Set String Reg Error![Index:%d, Status:%d]", Index, Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
    }

    return(Status);
}

STATUS set_variable_robot_position_(IN USHORT Index, IN MP_P_VAR_BUFF PositionValue)
{
    MP_USR_VAR_INFO Info;
	MP_CTRL_GRP_SEND_DATA CurSendData;
	MP_CART_POS_RSP_DATA CurCardPosData;
    INT32 Status;

    CurSendData.sCtrlGrp = 0;
    Status = mpGetCartPos(&CurSendData, &CurCardPosData);
	if (Status != OK) 
    {
	    DEBUG_ERROR("Get Current Pos Error![Index:%d, Status:%d]", Index, Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Get Current Pos Error![Index:%d, Status:%d]", Index, Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
        return(Status);
    }

    Info.var_type = MP_VAR_P;
    Info.var_no = Index;
    memcpy(&Info.val.p, &PositionValue, sizeof(MP_P_VAR_BUFF));
    Info.val.p.fig_ctrl = (BITSTRING)(CurCardPosData.sConfig);

    Status = mpPutUserVars(&Info);
    if (Status != OK) 
    {
    	DEBUG_ERROR("Set Pos Reg Error![Index:%d, Status:%d]", Index, Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Set Pos Reg Error![Index:%d, Status:%d]", Index, Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
    }

    return(Status);
}

STATUS set_variable_robot_type_xyzrpy_(IN USHORT Index, IN INT32 ToolNo, IN MP_COORD PositionValue)
{	
	STATUS status = OK;
	
	MP_CTRL_GRP_SEND_DATA curSendData;
	MP_CART_POS_RSP_DATA curCardPosData;

    MP_GET_TOOL_NO_RSP_DATA tool_no_rsp_data;
	memset(&tool_no_rsp_data, 0, sizeof(MP_GET_TOOL_NO_RSP_DATA));
	status = mpGetToolNo(MP_R1_GID, &tool_no_rsp_data);
	if ((status != OK) || (tool_no_rsp_data.err_no != 0))
	{
		DEBUG_ERROR("Call mpGetToolNo failed![ErrorCode:%d]\n", status);		
		return status;
	}

    curSendData.sCtrlGrp = 0;
	status = mpGetCartPos(&curSendData, &curCardPosData);
	if (status != OK)
	{
        DEBUG_ERROR("Cal1 mpGetCartPos failed![ErrorCode:%d]", status);
		return status;
	}

	MP_USR_VAR_INFO usr_var_info;
	memset(&usr_var_info, 0, sizeof(MP_USR_VAR_INFO));

	usr_var_info.val.p.data[0] = PositionValue.x;
	usr_var_info.val.p.data[1] = PositionValue.y;
	usr_var_info.val.p.data[2] = PositionValue.z;
		
    usr_var_info.val.p.data[3] = PositionValue.rx;
	usr_var_info.val.p.data[4] = PositionValue.ry;
	usr_var_info.val.p.data[5] = PositionValue.rz;
		
	usr_var_info.var_type = MP_VAR_P;
	usr_var_info.var_no = Index;
	usr_var_info.val.p.dtype = MP_ROBO_DTYPE;
	usr_var_info.val.p.tool_no = ToolNo < 0 ? tool_no_rsp_data.sToolNo : ToolNo;
	usr_var_info.val.p.uf_no = 0;
	usr_var_info.val.p.fig_ctrl = (BITSTRING)(curCardPosData.sConfig);

			
	// 写入机器人系统
	status = mpPutUserVars(&usr_var_info);
	if (status != OK)
	{
        DEBUG_ERROR("Call mpPutUserVars failed![ErrorCode:%d]", status);
		return status;
	}
	
	return OK;
}

STATUS set_variable_base_type_xyzrpy_(IN USHORT Index, IN INT32 ToolNo, IN MP_COORD PositionValue)
{	
	STATUS status = OK;
	
	MP_CTRL_GRP_SEND_DATA curSendData;
	MP_CART_POS_RSP_DATA curCardPosData;

    MP_GET_TOOL_NO_RSP_DATA tool_no_rsp_data;
	memset(&tool_no_rsp_data, 0, sizeof(MP_GET_TOOL_NO_RSP_DATA));
	status = mpGetToolNo(MP_R1_GID, &tool_no_rsp_data);
	if ((status != OK) || (tool_no_rsp_data.err_no != 0))
	{
		DEBUG_ERROR("Call mpGetToolNo failed![ErrorCode:%d]\n", status);		
		return status;
	}

    curSendData.sCtrlGrp = 0;
	status = mpGetCartPos(&curSendData, &curCardPosData);
	if (status != OK)
	{
        DEBUG_ERROR("Cal1 mpGetCartPos failed![ErrorCode:%d]", status);
		return status;
	}

	MP_USR_VAR_INFO usr_var_info;
	memset(&usr_var_info, 0, sizeof(MP_USR_VAR_INFO));

	usr_var_info.val.p.data[0] = PositionValue.x;
	usr_var_info.val.p.data[1] = PositionValue.y;
	usr_var_info.val.p.data[2] = PositionValue.z;
		
    usr_var_info.val.p.data[3] = PositionValue.rx;
	usr_var_info.val.p.data[4] = PositionValue.ry;
	usr_var_info.val.p.data[5] = PositionValue.rz;


	usr_var_info.var_type = MP_VAR_P;
	usr_var_info.var_no = Index;
	usr_var_info.val.p.dtype = MP_BASE_DTYPE;
	usr_var_info.val.p.tool_no = ToolNo < 0 ? tool_no_rsp_data.sToolNo : ToolNo;
	usr_var_info.val.p.uf_no = 0;
	usr_var_info.val.p.fig_ctrl = (BITSTRING)(curCardPosData.sConfig);

			
	// 写入机器人系统
	status = mpPutUserVars(&usr_var_info);
	if (status != OK)
	{
        DEBUG_ERROR("Call mpPutUserVars failed![ErrorCode:%d]", status);
		return status;
	}
	
	return OK;
}

STATUS set_variable_base_position_(IN USHORT Index, IN MP_P_VAR_BUFF PositionValue)
{
    MP_USR_VAR_INFO Info;
    INT32 Status;
    
    Info.var_type = MP_VAR_BP;
    Info.var_no = Index;
    memcpy(&Info.val.bp, &PositionValue, sizeof(MP_P_VAR_BUFF));

    Status = mpPutUserVars(&Info);
    if (Status != OK) 
    {
    	DEBUG_ERROR("Set BPos Reg Error![Index:%d, Status:%d]", Index, Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Set BPos Reg Error![Index:%d, Status:%d]", Index, Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
    }

    return(Status);
}

STATUS set_io_value_(IN UINT32 Index, IN USHORT Signal)
{
	MP_IO_DATA IoData;
    INT32 Status;

	IoData.ulAddr = Index;
	IoData.ulValue = Signal;

    Status = mpWriteIO(&IoData, 1);
	if (Status != OK) 
    {
    	DEBUG_ERROR("Set IO Error![Index:%d, Status:%d]", Index, Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Set IO Error![Index:%d, Status:%d]", Index, Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
    }
    return(Status);
}

STATUS pulse_io_(IN UINT32 Index, IN UINT32 PulseTime)
{
    set_io_value_(Index, ON);
    mpTaskDelay(PulseTime);
    set_io_value_(Index, OFF);

    return(OK);
}

BOOL alarm_reset_()
{
    MP_STD_RSP_DATA Output;

    return(mpResetAlarm(&Output) == 0 ? TRUE : FALSE);

}

BOOL servo_power_on_() 
{
    MP_SERVO_POWER_SEND_DATA input;
    MP_STD_RSP_DATA output;

    input.sServoPower = 1;
    if (mpSetServoPower(&input, &output) < 0)
        return(FALSE);
    else 
    {
        delay_(2000);
        if (is_servo_power_on_()) return(TRUE);;
    }
    return(FALSE);
}

BOOL is_running_(IN INT32 TaskId)
{
    MP_PLAY_STATUS_RSP_DATA RData;
    USHORT TaskNoSn[8] = {10022, 10023, 10024, 10025, 10026, 10027, 10030, 10031};
    int Mask[8] = {1, 2, 4, 8, 16, 32, 64, 128};
    int I;
    int CurTaskId = (int)NULL;

    if (TaskId != (int)NULL)
    {
        for(I = 0; I < 8; I++)
        {
            CurTaskId += get_io_value_(TaskNoSn[I]) * Mask[I];
        }
    }
    
    mpGetPlayStatus(&RData);

    return(RData.sStart && (TaskId == CurTaskId));
}

INT32 get_alarm_code_()
{
	MP_ALARM_CODE_RSP_DATA AlarmData;

	memset(&AlarmData, CLEAR, sizeof(AlarmData));
	if (mpGetAlarmCode(&AlarmData) == 0)
	{
		if (AlarmData.usAlarmNum > 0)
			return(AlarmData.AlarmData.usAlarmNo[0]);
		else
			return(OK);
	}
	return(ERROR);
}

STATUS io_list_display_(IN USHORT IoAddrs, IN USHORT Size, OUT UINT8 IoValue[])
{
    UINT8 Mask[8] = {1, 2, 4, 8, 16, 32, 64, 128};
    int I, J;

    for(I = 0; I < Size; I++)
    {
        IoValue[I] = 0;
        for(J = 0; J < 8; J++)
        {
            IoValue[I] += Mask[J] * (get_io_value_(IoAddrs + 10 * I + J) > 0);
        }
    }

    return(OK);
}

STATUS io_list_setup_(IN USHORT IoAddrs, IN USHORT Size, IN const UINT8 IoValue[])
{
    UINT8 Mask[8] = {1, 2, 4, 8, 16, 32, 64, 128};
    int I, J;

    for(I = 0; I < Size; I++)
    {
        for(J = 0; J < 8; J++)
        {
            set_io_value_(IoAddrs + 10 * I + J, ((IoValue[I] &  Mask[J]) > 0));
        }
    }

    return(OK);
}






