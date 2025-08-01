/***********************************************************

Copyright 2018 - 2023 speedbot All Rights reserved.

file Name: lib_mpmotion.c

Description:
  Language             ==   motoplus for Yaskawa ROBOT
  Date                 ==   2022 - 01 - 11
  Modification Data    ==   2022 - 01 - 11

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

2022 - 03 - 01 ++ current_cartposition_() ==> STATUS

2022 - 03 - 01 ++ current_jntposition_() ==> STATUS

2022 - 03 - 01 ++ current_position_config_() ==> SHORT

2022 - 03 - 01 ++ check_cartposition_() ==> STATUS

2022 - 03 - 01 ++ matrix_cartposition_() ==> STATUS

2022 - 03 - 01 ++ inv_cartposition_() ==> STATUS

2022 - 03 - 01 ++ null_pos_() ==> STATUS

2022 - 03 - 01 ++ num_robot_axis_() ==> STATUS

2022 - 03 - 01 ++ current_torque_() ==> STATUS

2022 - 04 - 13 ++ move_j_() ==> STATUS

2022 - 04 - 13 ++ move_l_() ==> STATUS

2022 - 04 - 13 ++ move_abs_j_() ==> STATUS

2022 - 06 - 17 ++ joint_to_pulse_() ==> STATUS

2022 - 06 - 17 ++ pulse_to_joint_() ==> STATUS

2022 - 06 - 17 ++ joint_to_cartposition_() ==> STATUS

2022 - 06 - 17 ++ cartposition_to_joint_() ==> STATUS
*/
#include "motoPlus.h"
#include "lib_mpmotion.h"

STATUS current_cartposition_(IN SHORT UserFrameNo, IN SHORT UserToolNo, OUT MP_COORD *CartPosition)
{
    MP_CARTPOS_EX_SEND_DATA InData;
    MP_CART_POS_RSP_DATA_EX OutData;
    INT32 Status;

    InData.sRobotNo = 0;
    InData.sFrame   = UserFrameNo;
    InData.sToolNo  = UserToolNo;

    Status = mpGetCartPosEx(&InData, &OutData);
    if (Status != OK) 
    {   
        DEBUG_ERROR("Get Current Coord Error[Uf:%d, Ut:%d, Status:%d]", UserFrameNo, UserToolNo, Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Get Current Coord Error[Uf:%d, Ut:%d, Status:%d]", UserFrameNo, UserToolNo, Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
    }
    else
    {
        memcpy(CartPosition, &OutData.lPos, sizeof(MP_COORD));
    }

    return(Status);
}

STATUS current_jntposition_(OUT MP_JOINT *JointPosition)
{
    MP_CTRL_GRP_SEND_DATA InData;
    MP_DEG_POS_RSP_DATA_EX OutData;
    INT32 Status;

    InData.sCtrlGrp = 0;

    Status = mpGetDegPosEx(&InData, &OutData);
    if (Status != OK) 
    {
        DEBUG_ERROR("Get Current Joint Error[Status:=%d]", Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Get Current Joint Error[Status:=%d]", Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
    }
    else
    {
        memcpy(JointPosition, &OutData.lDegPos, sizeof(MP_JOINT));
    }

    return(Status);
}

SHORT current_position_config_()
{
    MP_CARTPOS_EX_SEND_DATA InData;
    MP_CART_POS_RSP_DATA_EX OutData;
    INT32 Status;

    InData.sRobotNo = 0;
    InData.sFrame = 0;
    InData.sToolNo = 0;

    Status = mpGetCartPosEx(&InData, &OutData);
    if (Status != OK) 
    {
        DEBUG_ERROR("Get Current Pos Config Error[Status:=%d]", Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Get Current Pos Config Error[Status:=%d]", Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
    }

    return(OutData.sConfig);

}

STATUS check_cartposition_(IN MP_COORD NeedChkPos, IN LONG Coordinate, IN SHORT UserFrameNo, IN SHORT UserToolNo, IN struct pulse_lim_t PulseLim)
{
    MP_CARTPOS_EX_SEND_DATA InData;
    MP_CART_POS_RSP_DATA_EX OutData;
    MP_JOINT ConvJoint;
    MP_JOINT ConvPulse;
    MP_COORD NeedChkPosCopy;
    STATUS ConvStat = OK;
    INT32 Status;

    memcpy(&NeedChkPosCopy, &NeedChkPos, sizeof(MP_COORD));


    // 基座坐标系转机器人坐标系
    if (UserFrameNo == 0)
    {
        switch (Coordinate)
        {
        case 1:
            NeedChkPosCopy.x -= NeedChkPosCopy.ex1;
            break;
        case 2:
            NeedChkPosCopy.y -= NeedChkPosCopy.ex1;
            break;
        default:
            break;
        }
    }
    
    InData.sRobotNo = 0;
    InData.sFrame = UserFrameNo;
    InData.sToolNo = UserToolNo;

    Status = mpGetCartPosEx(&InData, &OutData);
    if (Status != OK) 
    {
        DEBUG_ERROR("Get Current Coord Error[Uf:%d, Ut:%d, Status:%d]", UserFrameNo, UserToolNo, Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Get Current Coord Error[Uf:%d, Ut:%d, Status:%d]", UserFrameNo, UserToolNo, Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
        return(Status);
    }

    FOREVER
    {
        ConvStat = mpConvCartPosToAxes(0, &NeedChkPosCopy, UserToolNo, (BITSTRING)OutData.sConfig, NULL, MP_KINEMA_DEFAULT, ConvJoint);
        if (ConvStat != E_KINEMA_FAILURE) break;
        mpTaskDelay(1);
    }

    if (ConvStat == OK){

        FOREVER
        {
            ConvStat = mpConvAngleToPulse(0, ConvJoint, ConvPulse);
            if (ConvStat != E_KINEMA_FAILURE) break;
            mpTaskDelay(1);
        }

        if (ConvStat == OK)
        {
               
           ConvStat = ((ConvPulse[0] >= PulseLim.SLower) && (ConvPulse[0] <= PulseLim.SUpper) &&
                       (ConvPulse[1] >= PulseLim.LLower) && (ConvPulse[1] <= PulseLim.LUpper) &&
                       (ConvPulse[2] >= PulseLim.ULower) && (ConvPulse[2] <= PulseLim.UUpper) &&
                       (ConvPulse[3] >= PulseLim.RLower) && (ConvPulse[3] <= PulseLim.RUpper) &&
                       (ConvPulse[4] >= PulseLim.BLower) && (ConvPulse[4] <= PulseLim.BUpper) &&
                       (ConvPulse[5] >= PulseLim.TLower) && (ConvPulse[5] <= PulseLim.TUpper)) ? OK : ERROR; 


        }
        
    }
    return(ConvStat);
}

STATUS matrix_cartposition_(IN MP_COORD CartPosition1, IN MP_COORD CartPosition2, OUT MP_COORD *CartPosition3)
{
    MP_FRAME Frame1;
    MP_FRAME Frame2;
    MP_FRAME Frame3;

    if (mpZYXeulerToFrame(&CartPosition1, &Frame1) < 0) return(ERROR);
    if (mpZYXeulerToFrame(&CartPosition2, &Frame2) < 0) return(ERROR);
    if (mpMulFrame(&Frame1, &Frame2, &Frame3) < 0) return(ERROR);
    if (mpFrameToZYXeuler(&Frame3, CartPosition3) < 0) return(ERROR);

    return(OK);
}

STATUS inv_cartposition_(IN MP_COORD CartPosition1, OUT MP_COORD *CartPosition2)
{
    MP_FRAME Frame1;
    MP_FRAME Frame2;

    if (mpZYXeulerToFrame(&CartPosition1, &Frame1) < 0) return(ERROR);
    if (mpInvFrame(&Frame1, &Frame2) < 0) return(ERROR);
    if (mpFrameToZYXeuler(&Frame2, CartPosition2) < 0) return(ERROR);

    return(OK);
}

MP_COORD null_pos_()
{
    MP_COORD NullPos;

    memset(&NullPos, CLEAR, sizeof(MP_COORD));

    return(NullPos);

}

INT32 num_robot_axis_()
{
    MP_GRP_ID_TYPE GroupId;

    GroupId = MP_B1_GID;

    if (mpCtrlGrpId2GrpNo(GroupId) > 0) return(7);

    return(6);

}

STATUS current_torque_(OUT mp_torq_t *CurTurq)
{

    MP_CTRL_GRP_SEND_DATA SData;
    MP_TORQUE_EX_RSP_DATA RData;
    INT32 Status;

    SData.sCtrlGrp = 0;

    Status = mpGetTorqueEx(&SData, &RData);
    if (Status != OK) 
    {
        DEBUG_ERROR("Get Current Torq Error[Status:%d]", Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Get Current Torq Error[Status:%d]", Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
    }
    else
    {
        memcpy(CurTurq, RData.lTorqueNm, sizeof(RData.lTorqueNm));
    }

    return(Status);

}

STATUS move_j_(IN MP_COORD ThisPoint, IN LONG Speed, IN SHORT UserFrameNo, IN SHORT UserToolNo)
{
    MP_MOVJ_SEND_DATA SData;
    MP_STD_RSP_DATA RData;

    memset(&SData, CLEAR, sizeof(SData));
    SData.sCtrlGrp = 0;
    SData.sConfig = current_position_config_();
    SData.lSpeed = Speed;
    SData.sFrame = UserFrameNo;
    SData.sToolNo = UserToolNo;
    memcpy(&SData.lPos, &ThisPoint, sizeof(MP_COORD));
    mpMOVJ(&SData, &RData);

    return((STATUS)RData.err_no);
}

STATUS move_l_(IN MP_COORD ThisPoint, IN LONG Speed, IN SHORT UserFrameNo, IN SHORT UserToolNo)
{
    MP_MOVL_SEND_DATA SData;
    MP_STD_RSP_DATA RData;

    memset(&SData, CLEAR, sizeof(SData));
    SData.sCtrlGrp = 0;
    SData.sConfig = current_position_config_();
    SData.sVType = 0;
    SData.lSpeed = Speed;
    SData.sFrame = UserFrameNo;
    SData.sToolNo = UserToolNo;
    memcpy(&SData.lPos, &ThisPoint, sizeof(MP_COORD));
    mpMOVL(&SData, &RData);

    return((STATUS)RData.err_no);
}

STATUS move_abs_j_(IN MP_JOINT ThisPoint, IN LONG Speed, IN SHORT UserToolNo)
{
    MP_PMOVJ_SEND_DATA SData;
    MP_STD_RSP_DATA RData;
    LONG Angle[MP_GRP_AXES_NUM];
    LONG Pulse[MP_GRP_AXES_NUM];
    int ConvStat = 0;

    memcpy(&Angle, &ThisPoint, sizeof(MP_JOINT));
    ConvStat = joint_to_pulse_(0, Angle, Pulse); 
    if (ConvStat != 0) return(ConvStat);
    memset(&SData, CLEAR, sizeof(SData));
    SData.sCtrlGrp = 0;
    SData.lSpeed = Speed;
    SData.sToolNo = UserToolNo;
    memcpy(&SData.lPos, &Pulse, sizeof(MP_JOINT));
    mpPulseMOVJ(&SData, &RData);

    return((STATUS)RData.err_no);
}

STATUS joint_to_pulse_(IN UINT8 GroupNo, IN LONG *JointData, OUT LONG *PulseData)
{
    int ConvStatus;

    FOREVER
    {
        ConvStatus = mpConvAngleToPulse(GroupNo, JointData, PulseData);
        if (ConvStatus != E_KINEMA_FAILURE) break;
        mpTaskDelay(1);
    }

    return(ConvStatus);
}

STATUS pulse_to_joint_(IN UINT8 GroupNo, IN LONG *PulseData, OUT LONG *JointData)
{
    int ConvStatus;

    FOREVER
    {
        ConvStatus = mpConvPulseToAngle(GroupNo, PulseData, JointData);
        if (ConvStatus != E_KINEMA_FAILURE) break;
        mpTaskDelay(1);
    }

    return(ConvStatus);
}

STATUS joint_to_cartposition_(IN UINT8 GroupNo, IN LONG *JointData, OUT BITSTRING *ConfigData, OUT LONG *CartData)
{
    int ConvStatus;

    FOREVER
    {
        ConvStatus = mpConvAxesToCartPos(GroupNo, JointData, 0, ConfigData, (MP_COORD *)CartData);
        if (ConvStatus != E_KINEMA_FAILURE) break;
        mpTaskDelay(1);
    }
    return(ConvStatus);
}

STATUS cartposition_to_joint_(IN UINT8 GroupNo, IN LONG *CartData, IN BITSTRING ConfigData, OUT LONG *JointData)
{
    int ConvStatus;
    MP_JOINT CurJpos;

    current_jntposition_(&CurJpos);
    FOREVER
    {
        ConvStatus = mpConvCartPosToAxes(GroupNo, (MP_COORD *)CartData, 0, ConfigData, (LONG *)CurJpos, MP_KINEMA_DEFAULT, JointData);
        if (ConvStatus != E_KINEMA_FAILURE) break;
        mpTaskDelay(1);
    }
    return(ConvStatus);
}