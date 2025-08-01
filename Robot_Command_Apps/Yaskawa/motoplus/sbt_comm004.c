/***********************************************************

Copyright 2018 - 2024 speedbot All Rights reserved.

file Name: sbt_comm004.c

Description:
  Language             ==   motoplus for Yaskawa ROBOT
  Date                 ==   2022 - 01 - 11
  Modification Data    ==   2024 - 10 - 16

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
*/
#include "motoPlus.h"
#include "sbt_comm004.h"
#include "global_variable.h"
#include "lib\lib_mptp_if.h"
#include "lib\lib_mpmotion.h"
#include "lib\lib_mpbusio_cmd.h"

LOCAL VOID err_display_();

STATUS processCommand_sbt_comm004_initialize_()
{
    STATUS Status = OK;
    MP_COORD NullPos;

    GlobalPartId = 0;

    memset(&GlobalVinCode, CLEAR, sizeof(GlobalVinCode));
    memset(&NullPos, CLEAR, sizeof(MP_COORD));

    Status = set_variable_base_type_xyzrpy_(SAVE_ROBOT_ASMB_POS_VARIABLE, 0, NullPos);

    Status = set_variable_byte_(SAVE_ROBOT_ASMB_STATUS_VARIABLE, 0);

    GlobalBusOutput.JobId = 0;

    GlobalCommandNo = COMMAND_UNKNOWN;

    return OK;
}

STATUS ProcessCommand_sbt_comm004_param_()
{
    STATUS Status = OK;
    cmd_type03_t CommType03;            // 创建一个通讯结构变量


    bus_initialize_(&GlobalBusInput, &GlobalBusOutput, 0, PTC_GEN_CMD);

    memset(&CommType03, CLEAR, sizeof(CommType03));
    
    // 从 D[*] 寄存器取出 PartId
    GlobalPartId = get_variable_long_(PARAM1_INT_NUMBER);

    // 从 D[*] 寄存器取出存储 VIN B[*]寄存器起始地址
    int VinByteStAddr = get_variable_long_(PARAM2_INT_NUMBER);

    // 依次从 B[*] 取出 VIN 码 
    int i;
    for (i = 0; i < sizeof(GlobalVinCode); i++)
    {
        GlobalVinCode[i] = get_variable_byte_(VinByteStAddr + i);
    }
    
    CommType03[0] = GlobalPartId;

    memcpy(&CommType03[1], &GlobalVinCode, sizeof(GlobalVinCode));
    //***************************************************************


    DEBUG_INFO("[Pid:%d, vin:%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d]", 
                CommType03[0], CommType03[1], CommType03[2], CommType03[3], CommType03[4], CommType03[5],
                CommType03[6], CommType03[7], CommType03[8], CommType03[9], CommType03[10], CommType03[11],
                CommType03[12], CommType03[13], CommType03[14], CommType03[15], CommType03[16], CommType03[17]);

    // 发送 PartId & VIN 码
    DEBUG_INFO("Call bus_command137_ To Send Part Id and Vin Code !");
    Status = bus_command137_(BUSCMD_WRITE, BUSCMD_MST, &GlobalBusInput, &GlobalBusOutput, &CommType03, GlobalBusTimeout);
    if (Status != OK)
    {
        DEBUG_ERROR("Call bus_command137_ failed![Err:%d, BusTimeout: %d]", Status, GlobalBusTimeout);  
        return Status;
    }

    // 接收应答
    DEBUG_INFO("Call bus_command001_ To Receive response !");
    Status = bus_command001_(BUSCMD_READ, BUSCMD_MST, &GlobalBusInput, &GlobalBusOutput, GlobalBusTimeout);
    if (Status != OK)
    {
        DEBUG_ERROR("Call bus_command001_ failed![Err:%d, BusTimeout: %d]", Status, GlobalBusTimeout);  
        
        // 示教器弹出报警
        err_display_();
        return Status;
    }

    return OK;
}

STATUS ProcessCommand_sbt_comm004_guide_()
{
    STATUS Status = OK;
    struct cmd_type01_t CommType01 = {100, 0, 0, 0, 0, 0, 0.0, 0.0};            // 创建一个通讯结构变量
    int Timeout = 5000;
    MP_COORD CurCartPos;
    MP_COORD GuideCartPos;
    SHORT UframeNo = 0;
    SHORT UtoolNo = 0;

    INT32 GuidePosLongAddr = get_variable_long_(PARAM1_INT_NUMBER);


    DEBUG_INFO("Call bus_command145_ To Send CommType01 !");
    Status = bus_command145_(BUSCMD_WRITE, BUSCMD_MST, &GlobalBusInput, &GlobalBusOutput, &CommType01, GlobalBusTimeout);
    if (Status != OK)
    {
        DEBUG_ERROR("Call bus_command145_ failed![Err:%d, BusTimeout: %d]", Status, GlobalBusTimeout);  
        return Status;
    }

    // 接收应答
    DEBUG_INFO("Call bus_command001_ To Receive response !");
    Status = bus_command001_(BUSCMD_READ, BUSCMD_MST, &GlobalBusInput, &GlobalBusOutput, Timeout);
    if (Status != OK)
    {
        DEBUG_ERROR("Call bus_command001_ failed![Err:%d, BusTimeout: %d]", Status, Timeout);  
        
        // 示教器弹出报警
        err_display_();
        return Status;
    }

    Status = current_cartposition_(UframeNo, UtoolNo, &CurCartPos);
    if (Status != OK)
    {
        DEBUG_ERROR("Call current_cartposition_ failed![Err:%d, UframeNo: %d, UtoolNo: %d]", Status, UframeNo, UtoolNo);  
        return Status;
    }

    DEBUG_INFO("Call bus_command009_ To Send Current Cart Pose ![x:%d, y:%d, z:%d, rx:%d, ry:%d, rz:%d]", 
                                                                CurCartPos.x, CurCartPos.y, CurCartPos.z, CurCartPos.rx, CurCartPos.ry, CurCartPos.rz);

    Status = bus_command009_(BUSCMD_WRITE, BUSCMD_MST, &GlobalBusInput, &GlobalBusOutput, &CurCartPos, GlobalBusTimeout);
    if (Status != OK)
    {
        DEBUG_ERROR("Call bus_command009_ failed![Err:%d, BusTimeout: %d]", Status, GlobalBusTimeout);  
        return Status;
    }

    memset(&GuideCartPos, CLEAR, sizeof(GuideCartPos));

    // 接收位置
    DEBUG_INFO("Call bus_command129_ To Receive Guide Pose !");
    Status = bus_command129_(BUSCMD_READ, BUSCMD_MST, &GlobalBusInput, &GlobalBusOutput, &GuideCartPos, GlobalBusTimeout);
    if (Status != OK)
    {
        DEBUG_ERROR("Call bus_command129_ failed![Err:%d, BusTimeout: %d]", Status, GlobalBusTimeout);  
        
        // 示教器弹出报警
        err_display_();
        return Status;
    }

    DEBUG_INFO("Set Guide Pose![robot var: %d, x:%d, y:%d, z:%d, rx:%d, ry:%d, rz:%d]", 
                                GuidePosLongAddr, GuideCartPos.x, GuideCartPos.y, GuideCartPos.z, GuideCartPos.rx, GuideCartPos.ry, GuideCartPos.rz);

    Status = set_variable_base_type_xyzrpy_(GuidePosLongAddr, CUR_ACT_TOOL_NO, GuideCartPos);

    return Status; 
}

STATUS ProcessCommand_sbt_comm004_send_pos_()
{
    STATUS Status = OK;
    struct cmd_type01_t CommType01 = {103, 0, 0, 0, 0, 0, 0.0, 0.0};            // 创建一个通讯结构变量
    int Timeout = 5000;
    MP_COORD CurCartPos;
    SHORT UframeNo = get_variable_long_(PARAM1_INT_NUMBER);
    SHORT UtoolNo = get_variable_long_(PARAM2_INT_NUMBER);

    DEBUG_INFO("Call bus_command145_ To Send CommType01 !");
    Status = bus_command145_(BUSCMD_WRITE, BUSCMD_MST, &GlobalBusInput, &GlobalBusOutput, &CommType01, GlobalBusTimeout);
    if (Status != OK)
    {
        DEBUG_ERROR("Call bus_command145_ failed![Err:%d, BusTimeout: %d]", Status, GlobalBusTimeout);  
        return Status;
    }

    // 接收应答
    DEBUG_INFO("Call bus_command001_ To Receive response !");
    Status = bus_command001_(BUSCMD_READ, BUSCMD_MST, &GlobalBusInput, &GlobalBusOutput, Timeout);
    if (Status != OK)
    {
        DEBUG_ERROR("Call bus_command001_ failed![Err:%d, BusTimeout: %d]", Status, Timeout);  
        
        // 示教器弹出报警
        err_display_();
        return Status;
    }

    Status = current_cartposition_(UframeNo, UtoolNo, &CurCartPos);
    if (Status != OK)
    {
        DEBUG_ERROR("Call current_cartposition_ failed![Err:%d, UframeNo: %d, UtoolNo: %d]", Status, UframeNo, UtoolNo);  
        return Status;
    }

    DEBUG_INFO("Call bus_command009_ To Send Current Cart Pose ![x:%d, y:%d, z:%d, rx:%d, ry:%d, rz:%d]", 
                                                                CurCartPos.x, CurCartPos.y, CurCartPos.z, CurCartPos.rx, CurCartPos.ry, CurCartPos.rz);

    Status = bus_command009_(BUSCMD_WRITE, BUSCMD_MST, &GlobalBusInput, &GlobalBusOutput, &CurCartPos, GlobalBusTimeout);
    if (Status != OK)
    {
        DEBUG_ERROR("Call bus_command009_ failed![Err:%d, BusTimeout: %d]", Status, GlobalBusTimeout);  
        return Status;
    }

    // 接收位置
    DEBUG_INFO("Call bus_command001_ To Receive response !");
    Status = bus_command001_(BUSCMD_READ, BUSCMD_MST, &GlobalBusInput, &GlobalBusOutput, GlobalBusTimeout);
    if (Status != OK)
    {
        DEBUG_ERROR("Call bus_command001_ failed![Err:%d, BusTimeout: %d]", Status, GlobalBusTimeout);  
        
        // 示教器弹出报警
        err_display_();
        return Status;
    }


    return Status; 
}   

STATUS ProcessCommand_sbt_comm004_camera_()
{
    STATUS Status = OK;
    struct cmd_type01_t CommType01 = {104, 0, 0, 0, 0, 0, 0.0, 0.0};            // 创建一个通讯结构变量
    int Timeout = 5000;
    MP_COORD CurCartPos;
    SHORT UframeNo = get_variable_long_(PARAM2_INT_NUMBER);
    SHORT UtoolNo = get_variable_long_(PARAM3_INT_NUMBER);

    CommType01.Byte02 = get_variable_long_(PARAM1_INT_NUMBER);

    DEBUG_INFO("Call bus_command145_ To Send CommType01 !");
    Status = bus_command145_(BUSCMD_WRITE, BUSCMD_MST, &GlobalBusInput, &GlobalBusOutput, &CommType01, GlobalBusTimeout);
    if (Status != OK)
    {
        DEBUG_ERROR("Call bus_command145_ failed![Err:%d, BusTimeout: %d]", Status, GlobalBusTimeout);  
        return Status;
    }

    // 接收应答
    DEBUG_INFO("Call bus_command001_ To Receive response !");
    Status = bus_command001_(BUSCMD_READ, BUSCMD_MST, &GlobalBusInput, &GlobalBusOutput, Timeout);
    if (Status != OK)
    {
        DEBUG_ERROR("Call bus_command001_ failed![Err:%d, BusTimeout: %d]", Status, Timeout);  
        
        // 示教器弹出报警
        err_display_();
        return Status;
    }

    Status = current_cartposition_(UframeNo, UtoolNo, &CurCartPos);
    if (Status != OK)
    {
        DEBUG_ERROR("Call current_cartposition_ failed![Err:%d, UframeNo: %d, UtoolNo: %d]", Status, UframeNo, UtoolNo);  
        return Status;
    }

    DEBUG_INFO("Call bus_command009_ To Send Current Cart Pose ![x:%d, y:%d, z:%d, rx:%d, ry:%d, rz:%d]", 
                                                                CurCartPos.x, CurCartPos.y, CurCartPos.z, CurCartPos.rx, CurCartPos.ry, CurCartPos.rz);

    Status = bus_command009_(BUSCMD_WRITE, BUSCMD_MST, &GlobalBusInput, &GlobalBusOutput, &CurCartPos, GlobalBusTimeout);
    if (Status != OK)
    {
        DEBUG_ERROR("Call bus_command009_ failed![Err:%d, BusTimeout: %d]", Status, GlobalBusTimeout);  
        return Status;
    }

    // 接收位置
    DEBUG_INFO("Call bus_command001_ To Receive response !");
    Status = bus_command001_(BUSCMD_READ, BUSCMD_MST, &GlobalBusInput, &GlobalBusOutput, Timeout);
    if (Status != OK)
    {
        DEBUG_ERROR("Call bus_command001_ failed![Err:%d, BusTimeout: %d]", Status, Timeout);  
        
        // 示教器弹出报警
        err_display_();
        return Status;
    }


    return Status; 
}   

STATUS ProcessCommand_sbt_comm004_vasmb_()
{
    STATUS Status = OK;
    struct cmd_type01_t CommType01 = {101, 0, 0, 0, 0, 0, 0.0, 0.0};            // 创建一个通讯结构变量
    int Timeout = 5000;
    MP_COORD CurCartPos;
    MP_COORD CurVsmbPos;
    SHORT UframeNo = 0;
    SHORT UtoolNo = 0;
    UCHAR Readying = 0;

    while (1)
    {
        Readying = get_variable_byte_(MOTOPLUS_STATUS_BYTE_NUMBER);

        // 待机器人运动到位才继续此流程
        if (Readying == 0)
        {
            break;;
        }
        mpTaskDelay(16);
    }

    if (GlobalBusOutput.JobId == 0)
    {
        DEBUG_INFO("Call bus_command145_ To Send CommType01 !");
        Status = bus_command145_(BUSCMD_WRITE, BUSCMD_MST, &GlobalBusInput, &GlobalBusOutput, &CommType01, GlobalBusTimeout);
        if (Status != OK)
        {
            DEBUG_ERROR("Call bus_command145_ failed![Err:%d, BusTimeout: %d]", Status, GlobalBusTimeout);  
            return Status;
        }

        // 接收应答
        DEBUG_INFO("Call bus_command001_ To Receive response !");
        Status = bus_command001_(BUSCMD_READ, BUSCMD_MST, &GlobalBusInput, &GlobalBusOutput, Timeout);
        if (Status != OK)
        {
            DEBUG_ERROR("Call bus_command001_ failed![Err:%d, BusTimeout: %d]", Status, Timeout);  
            
            // 示教器弹出报警
            err_display_();
            return Status;
        }
    }
    
    GlobalBusOutput.JobId = GlobalBusOutput.JobId >= 254 ? 1 : GlobalBusOutput.JobId++;

    Status = current_cartposition_(UframeNo, UtoolNo, &CurCartPos);
    if (Status != OK)
    {
        DEBUG_ERROR("Call current_cartposition_ failed![Err:%d, UframeNo: %d, UtoolNo: %d]", Status, UframeNo, UtoolNo);  
        return Status;
    }

    DEBUG_INFO("Call bus_command009_ To Send Current Cart Pose ![x:%d, y:%d, z:%d, rx:%d, ry:%d, rz:%d]", 
                                                                CurCartPos.x, CurCartPos.y, CurCartPos.z, CurCartPos.rx, CurCartPos.ry, CurCartPos.rz);

    Status = bus_command009_(BUSCMD_WRITE, BUSCMD_MST, &GlobalBusInput, &GlobalBusOutput, &CurCartPos, GlobalBusTimeout);
    if (Status != OK)
    {
        DEBUG_ERROR("Call bus_command009_ failed![Err:%d, BusTimeout: %d]", Status, GlobalBusTimeout);  
        return Status;
    }

    // 接收位置
    DEBUG_INFO("Call bus_command129_ To Receive Guide Pose !");
    Status = bus_command129_(BUSCMD_READ, BUSCMD_MST, &GlobalBusInput, &GlobalBusOutput, &CurVsmbPos, GlobalBusTimeout);
    if (Status != OK)
    {
        DEBUG_ERROR("Call bus_command129_ failed![Err:%d, BusTimeout: %d]", Status, GlobalBusTimeout);  
        
        // 示教器弹出报警
        err_display_();
        return Status;
    }

    DEBUG_INFO("Set Vsmb Pose![robot var: %d, x:%d, y:%d, z:%d, rx:%d, ry:%d, rz:%d]", 
                                SAVE_ROBOT_ASMB_STATUS_VARIABLE, CurVsmbPos.x, CurVsmbPos.y, CurVsmbPos.z, CurVsmbPos.rx, CurVsmbPos.ry, CurVsmbPos.rz);

    if (GlobalBusInput.JobId != 255)
    {
        Status = set_variable_base_type_xyzrpy_(SAVE_ROBOT_ASMB_STATUS_VARIABLE, CUR_ACT_TOOL_NO, CurVsmbPos);
        GlobalCommandNo = COMMAND_UNKNOWN;
    }
    Status = set_variable_byte_(MOTOPLUS_STATUS_BYTE_NUMBER, GlobalBusInput.JobId);


    return Status; 
}

STATUS ProcessCommand_sbt_comm004_dqmoni_()
{
    STATUS Status = OK;
    struct cmd_type01_t CommType01 = {102, 0, 0, 0, 0, 0, 0.0, 0.0};            // 创建一个通讯结构变量
    int Timeout = 5000;
    MP_COORD CurCartPos;
    MP_COORD CurDqmoniPos;
    SHORT UframeNo = 0;
    SHORT UtoolNo = 0;
    UCHAR Readying = 0;

    while (1)
    {
        Readying = get_variable_byte_(MOTOPLUS_STATUS_BYTE_NUMBER);

        // 待机器人运动到位才继续此流程
        if (Readying == 0)
        {
            break;;
        }
        mpTaskDelay(16);
    }

    if (GlobalBusOutput.JobId == 0)
    {
        DEBUG_INFO("Call bus_command145_ To Send CommType01 !");
        Status = bus_command145_(BUSCMD_WRITE, BUSCMD_MST, &GlobalBusInput, &GlobalBusOutput, &CommType01, GlobalBusTimeout);
        if (Status != OK)
        {
            DEBUG_ERROR("Call bus_command145_ failed![Err:%d, BusTimeout: %d]", Status, GlobalBusTimeout);  
            return Status;
        }

        // 接收应答
        DEBUG_INFO("Call bus_command001_ To Receive response !");
        Status = bus_command001_(BUSCMD_READ, BUSCMD_MST, &GlobalBusInput, &GlobalBusOutput, Timeout);
        if (Status != OK)
        {
            DEBUG_ERROR("Call bus_command001_ failed![Err:%d, BusTimeout: %d]", Status, Timeout);  
            
            // 示教器弹出报警
            err_display_();
            return Status;
        }
    }
    
    GlobalBusOutput.JobId = GlobalBusOutput.JobId >= 254 ? 1 : GlobalBusOutput.JobId++;

    Status = current_cartposition_(UframeNo, UtoolNo, &CurCartPos);
    if (Status != OK)
    {
        DEBUG_ERROR("Call current_cartposition_ failed![Err:%d, UframeNo: %d, UtoolNo: %d]", Status, UframeNo, UtoolNo);  
        return Status;
    }

    DEBUG_INFO("Call bus_command009_ To Send Current Cart Pose ![x:%d, y:%d, z:%d, rx:%d, ry:%d, rz:%d]", 
                                                                CurCartPos.x, CurCartPos.y, CurCartPos.z, CurCartPos.rx, CurCartPos.ry, CurCartPos.rz);

    Status = bus_command009_(BUSCMD_WRITE, BUSCMD_MST, &GlobalBusInput, &GlobalBusOutput, &CurCartPos, GlobalBusTimeout);
    if (Status != OK)
    {
        DEBUG_ERROR("Call bus_command009_ failed![Err:%d, BusTimeout: %d]", Status, GlobalBusTimeout);  
        return Status;
    }

    // 接收位置
    DEBUG_INFO("Call bus_command129_ To Receive Guide Pose !");
    Status = bus_command129_(BUSCMD_READ, BUSCMD_MST, &GlobalBusInput, &GlobalBusOutput, &CurDqmoniPos, GlobalBusTimeout);
    if (Status != OK)
    {
        DEBUG_ERROR("Call bus_command129_ failed![Err:%d, BusTimeout: %d]", Status, GlobalBusTimeout);  
        
        // 示教器弹出报警
        err_display_();
        return Status;
    }

    DEBUG_INFO("Set Vsmb Pose![robot var: %d, x:%d, y:%d, z:%d, rx:%d, ry:%d, rz:%d]", 
                                SAVE_ROBOT_ASMB_STATUS_VARIABLE, CurDqmoniPos.x, CurDqmoniPos.y, CurDqmoniPos.z, CurDqmoniPos.rx, CurDqmoniPos.ry, CurDqmoniPos.rz);

    if (GlobalBusInput.JobId != 255)
    {
        Status = set_variable_base_type_xyzrpy_(SAVE_ROBOT_ASMB_STATUS_VARIABLE, CUR_ACT_TOOL_NO, CurDqmoniPos);
        GlobalCommandNo = COMMAND_UNKNOWN;
    }
    Status = set_variable_byte_(MOTOPLUS_STATUS_BYTE_NUMBER, GlobalBusInput.JobId);
    
    return Status; 
}

VOID err_display_()
{
    char alm_msg[128] = {0};
    STATUS Status = OK;

    if (!GlobalBusInput.SysReady)
    {
        sprintf(alm_msg, COMM004_ALARM_MESSAGE_SKILL_SOFTWARE_NOT_READY);
        Status = mpSetAlarm(COMM004_ALARM_CODE, alm_msg, COMM004_ALARM_SUBCODE_SOFTWARE_NOT_READY);
        return;
    }

    if (GlobalBusInput.TellId != GlobalBusOutput.RobTellId)
    {
        sprintf(alm_msg, COMM004_ALARM_MESSAGE_SKILL_SOFTWARE_TIMEOUT);
        Status = mpSetAlarm(COMM004_ALARM_CODE, alm_msg, COMM004_ALARM_SUBCODE_SOFTWARE_TIMEOUT);
        return;
    }

    switch (GlobalBusInput.ErrorId)
    {
    case 1:
        sprintf(alm_msg, COMM004_ALARM_MESSAGE_SKILL_CAMERA_CONN_FAIL);
        Status = mpSetAlarm(COMM004_ALARM_CODE, alm_msg, COMM004_ALARM_SUBCODE_CAMERA_CONN_FAIL);
        break;
    case 2:
        sprintf(alm_msg, COMM004_ALARM_MESSAGE_SKILL_CAMERA_PHOTO_FAIL);
        Status = mpSetAlarm(COMM004_ALARM_CODE, alm_msg, COMM004_ALARM_SUBCODE_CAMERA_PHOTO_FAIL);
        break;
    case 3:
        sprintf(alm_msg, COMM004_ALARM_MESSAGE_SKILL_MATER_LOAD_FAIL);
        Status = mpSetAlarm(COMM004_ALARM_CODE, alm_msg, COMM004_ALARM_SUBCODE_CAMERA_MATER_LOAD_FAIL);
        break;
    case 4:
        sprintf(alm_msg, COMM004_ALARM_MESSAGE_SKILL_HINGE_FIT_ALGO_FAIL);
        Status = mpSetAlarm(COMM004_ALARM_CODE, alm_msg, COMM004_ALARM_SUBCODE_HINGE_FIT_ALGO_FAIL);
        break;
    case 5:
        sprintf(alm_msg, COMM004_ALARM_MESSAGE_SKILL_HINGE_ALGO_FAIL);
        Status = mpSetAlarm(COMM004_ALARM_CODE, alm_msg, COMM004_ALARM_SUBCODE_HINGE_ALGO_FAIL);
        break;
    case 6:
        sprintf(alm_msg, COMM004_ALARM_MESSAGE_SKILL_GAP_CALC_FAIL);
        Status = mpSetAlarm(COMM004_ALARM_CODE, alm_msg, COMM004_ALARM_SUBCODE_GAP_CALC_FAIL);
        break;
    case 7:
        sprintf(alm_msg, COMM004_ALARM_MESSAGE_SKILL_ASSEMBLY_ALGO_FAIL);
        Status = mpSetAlarm(COMM004_ALARM_CODE, alm_msg, COMM004_ALARM_SUBCODE_ASSEMBLY_ALGO_FAIL);
        break;
    case 8:
        sprintf(alm_msg, COMM004_ALARM_MESSAGE_SKILL_TIGHT_INVO_FAIL);
        Status = mpSetAlarm(COMM004_ALARM_CODE, alm_msg, COMM004_ALARM_SUBCODE_TIGHT_INVO_FAIL);
        break;
    case 9:
        sprintf(alm_msg, COMM004_ALARM_MESSAGE_SKILL_LEVEL_INVO_FAIL);
        Status = mpSetAlarm(COMM004_ALARM_CODE, alm_msg, COMM004_ALARM_SUBCODE_LEVEL_INVO_FAIL);
        break;
    case 10:
        sprintf(alm_msg, COMM004_ALARM_MESSAGE_SKILL_CORR_RANGE);
        Status = mpSetAlarm(COMM004_ALARM_CODE, alm_msg, COMM004_ALARM_SUBCODE_CORR_RANGE);
        break;
    default:
        sprintf(alm_msg, COMM004_ALARM_MESSAGE_SKILL_UNKNOWN);
        Status = mpSetAlarm(COMM004_ALARM_CODE, alm_msg, COMM004_ALARM_SUBCODE_UNKNOWN);
        break;
    }
}