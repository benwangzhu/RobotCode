/***********************************************************

Copyright 2018 - 2025 speedbot All Rights reserved.

file Name: sbt_unstack.c

Description:
  Language             ==   motoplus for Yaskawa ROBOT
  Date                 ==   2022 - 01 - 11
  Modification Data    ==   2024 - 12 - 18

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
#include "sbt_unstack.h"
#include "global_variable.h"
#include "lib\lib_mptp_if.h"
#include "lib\lib_mpmotion.h"
#include "lib\lib_mpsocket.h"
#include "lib\lib_mppackages.h"

INT32 CommDataInt[3];
FLOAT CommDataFloat[3];
CHAR CommDataString[5][JSON_MAX_STR];
FLOAT CommDataPos[3][JSON_MAX_AXS];

struct unstack_data_t UnStackPackages;


BOOL IsInit = FALSE;

LOCAL STATUS processReceived_sbt_unstack_finished_();
LOCAL STATUS processReceived_sbt_unstack_initialized_();
LOCAL STATUS processReceived_sbt_unstack_work_();
LOCAL STATUS processReceived_sbt_unstack_work_();
LOCAL STATUS processReceived_sbt_unstack_error_();

STATUS processReceived_sbt_unstack_data_()
{
    INT32 Status = ERROR;
    INT32 Offset = 0;
    
    int BytesReceived = 0;	
    BytesReceived = mpRecv(GlobalSocketHandle,							// socket address
        (char*)(GlobalReceiveBuffer),									// receive buffer
    	GlobalReceivedDataLenght,									    // the maximum allowable length of received data to be stored in buffer
    	0);
    
    if (BytesReceived == 0)
    { // 连接关闭
    	DEBUG_ERROR("Connection closed!");
        return ERROR;
    }
    else if (BytesReceived < 0)
    { // 接收错误
    	DEBUG_ERROR("Receives data error!"); 
        return ERROR;
    }

    memset(CommDataInt, CLEAR, sizeof(CommDataInt));
    memset(CommDataFloat, CLEAR, sizeof(CommDataFloat));
    memset(CommDataString, CLEAR, sizeof(CommDataString));
    memset(CommDataPos, CLEAR, sizeof(CommDataPos));

    Status = decodedataframe_json_(GlobalReceiveBuffer, CommDataInt, CommDataFloat, CommDataString, CommDataPos);
    if (Status != OK)
    { // 连接关闭


    	DEBUG_ERROR("Call decodedataframe_json_ Failed![Status:%d]", Status);
        return ERROR;
    }

    if (strcmp(CommDataString[0], "success") == 0 && strcmp(CommDataString[1], "finish") == 0)
    {
        DEBUG_INFO("Finished!");

        Status = processReceived_sbt_unstack_finished_();

        return Status;
    }
    else if (strcmp(CommDataString[0], "success") == 0 && strcmp(CommDataString[1], "next") == 0)
    {
        if (IsInit)
        {
            DEBUG_INFO("Initialized!");

            Status = processReceived_sbt_unstack_initialized_();

            return Status;
        }
        else
        {
            DEBUG_INFO("Get Data Successful!");

            Status = processReceived_sbt_unstack_work_();

            return Status;

        }
    }
    else
    {

        DEBUG_INFO("Error!");

        Status = processReceived_sbt_unstack_error_();

        return Status;

    }

    
    return ERROR;
}

STATUS processReceived_sbt_unstack_finished_()
{
    INT32 Status = ERROR;
    
    GlobalConnectStatus = -1;

    Status = set_variable_byte_(MOTOPLUS_STATUS_BYTE_NUMBER, UNSTACK_INFORM_SWITCH_CODE_FINISH);
    if (Status != OK)
    {
        DEBUG_ERROR("Call set_variable_byte_ failed![ErrorCode:%d]", Status);
    }

    return Status;
}

STATUS processReceived_sbt_unstack_initialized_()
{
    INT32 Status = ERROR;
    
    Status = set_variable_byte_(MOTOPLUS_STATUS_BYTE_NUMBER, UNSTACK_INFORM_SWITCH_CODE_INITIALIZED);
    if (Status != OK)
    {
        DEBUG_ERROR("Call set_variable_byte_ failed![ErrorCode:%d]", Status);
    }
    else
    {
        GlobalCommandNo = COMMAND_UNSTACK_GETDATA;
    }

    return Status;
}

STATUS processReceived_sbt_unstack_work_()
{
    INT32 Status = ERROR;

    UnStackPackages.PartId = CommDataInt[0];
    UnStackPackages.AreaId = CommDataInt[1];
    UnStackPackages.MagaPip = CommDataInt[2];
    UnStackPackages.BoxLength = CommDataFloat[0];
    UnStackPackages.BoxWindth = CommDataFloat[1];
    UnStackPackages.BoxHig = CommDataFloat[2];

    UnStackPackages.PickPos.x = (LONG)(CommDataPos[0][0] * 1000.0);
    UnStackPackages.PickPos.y = (LONG)(CommDataPos[0][1] * 1000.0);
    UnStackPackages.PickPos.z = (LONG)(CommDataPos[0][2] * 1000.0);
    UnStackPackages.PickPos.rx = (LONG)(CommDataPos[0][3] * 10000.0);
    UnStackPackages.PickPos.ry = (LONG)(CommDataPos[0][4] * 10000.0);
    UnStackPackages.PickPos.rz = (LONG)(CommDataPos[0][5] * 10000.0);

    UnStackPackages.DropPos.x = (LONG)(CommDataPos[1][0] * 1000.0);
    UnStackPackages.DropPos.y = (LONG)(CommDataPos[1][1] * 1000.0);
    UnStackPackages.DropPos.z = (LONG)(CommDataPos[1][2] * 1000.0);
    UnStackPackages.DropPos.rx = (LONG)(CommDataPos[1][3] * 10000.0);
    UnStackPackages.DropPos.ry = (LONG)(CommDataPos[1][4] * 10000.0);
    UnStackPackages.DropPos.rz = (LONG)(CommDataPos[1][5] * 10000.0);

    UnStackPackages.ObliPos.x = (LONG)(CommDataPos[2][0] * 1000.0);
    UnStackPackages.ObliPos.y = (LONG)(CommDataPos[2][1] * 1000.0);
    UnStackPackages.ObliPos.z = (LONG)(CommDataPos[2][2] * 1000.0);
    UnStackPackages.ObliPos.rx = (LONG)(CommDataPos[2][3] * 10000.0);
    UnStackPackages.ObliPos.ry = (LONG)(CommDataPos[2][4] * 10000.0);
    UnStackPackages.ObliPos.rz = (LONG)(CommDataPos[2][5] * 10000.0);

    Status = set_variable_long_(UNSTACK_SAVE_VARIABLE_LONG_PART_ID, UnStackPackages.PartId);
    CHECK_RESULT(Status);
    Status = set_variable_long_(UNSTACK_SAVE_VARIABLE_LONG_AREA_ID, UnStackPackages.AreaId);
    CHECK_RESULT(Status);
    Status = set_variable_long_(UNSTACK_SAVE_VARIABLE_LONG_MAG_PIP, UnStackPackages.MagaPip);
    CHECK_RESULT(Status);
    Status = set_variable_float_(UNSTACK_SAVE_VARIABLE_FLOAT_BOX_LENGTH, UnStackPackages.BoxLength);
    CHECK_RESULT(Status);
    Status = set_variable_float_(UNSTACK_SAVE_VARIABLE_FLOAT_BOX_WINDTH, UnStackPackages.BoxWindth);
    CHECK_RESULT(Status);
    Status = set_variable_float_(UNSTACK_SAVE_VARIABLE_FLOAT_BOX_HIG, UnStackPackages.BoxHig);
    CHECK_RESULT(Status);

    MP_GET_TOOL_NO_RSP_DATA rToolDataNum;
    Status = mpGetToolNo(0,&rToolDataNum);

    Status = set_variable_base_type_xyzrpy_(UNSTACK_SAVE_VARIABLE_POS_PICK, rToolDataNum.sToolNo, UnStackPackages.PickPos);
    CHECK_RESULT(Status);

    Status = set_variable_base_type_xyzrpy_(UNSTACK_SAVE_VARIABLE_POS_PLACE, rToolDataNum.sToolNo, UnStackPackages.DropPos);
    CHECK_RESULT(Status);

    Status = set_variable_base_type_xyzrpy_(UNSTACK_SAVE_VARIABLE_POS_OBLIPOS, rToolDataNum.sToolNo, UnStackPackages.ObliPos);
    CHECK_RESULT(Status);
    
    Status = set_variable_byte_(MOTOPLUS_STATUS_BYTE_NUMBER, UNSTACK_INFORM_SWITCH_CODE_WORK);
    if (Status != OK)
    {
        DEBUG_ERROR("Call set_variable_byte_ failed![ErrorCode:%d]", Status);
    }

    GlobalCommandNo = COMMAND_UNSTACK_REACH;

    return Status;
}

STATUS processReceived_sbt_unstack_error_()
{
    INT32 Status = ERROR;
    
    GlobalConnectStatus = -1;

    Status = set_variable_byte_(MOTOPLUS_STATUS_BYTE_NUMBER, UNSTACK_INFORM_SWITCH_CODE_ERROR);
    if (Status != OK)
    {
        DEBUG_ERROR("Call set_variable_byte_ failed![ErrorCode:%d]", Status);
    }

    return Status;
}

STATUS processCommand_sbt_unstack_open_()
{
    INT32 Status = OK;
    INT32 Offset = 0;

    GlobalSocketPort = UNSTACK_SERVER_PORT;
    GlobalConnect = 1;
    GlobalConnectStatus = 0;

    delay_(100);

    while (GlobalConnect)
    {
        mpTaskDelay(10);
    }

    if (GlobalConnectStatus != 1)
    {
        // 链接失败，产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, UNSTACK_ALARM_MESSAGE_SKILL_FAILED_CONNECT, GlobalSocketIp, GlobalSocketPort);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, UNSTACK_ALARM_SUBCODE_FAILED_CONNECT);

        return ERROR;
    }

    return OK;
}

STATUS processCommand_sbt_unstack_initialize_()
{
    INT32 Status = OK;
    INT32 Offset = 0;

    IsInit = TRUE;

    memset(GlobalSendBuffer, CLEAR, sizeof(UCHAR) * SEND_BUFFER_SIZE);

    sprintf((CHAR *)GlobalSendBuffer, "key{robotid:int;status:str;mode:str;athome:int}value{robotid:%d;status:%s;mode:%s;athome:%d}", 1, "init", "unstack", 1);

    GlobalSendDataLenght = strlen((CHAR *)GlobalSendBuffer);
    GlobalReceivedDataLenght = 1024;
    return OK;
}

STATUS processCommand_sbt_unstack_getData_()
{
    // INT32 Status = OK;
    // INT32 Offset = 0;
    // INT32 PartId = get_variable_long_(PARAM1_INT_NUMBER);

    // memset(GlobalSendBuffer, CLEAR, sizeof(UCHAR) * SEND_BUFFER_SIZE);

    // sprintf((CHAR *)GlobalSendBuffer, "key{robotid:int;status:str;partid:int;msg:str}value{robotid:%d;status:%s;partid:%d;msg:%d}", 1, "error", PartId, "miss");

    // GlobalSendDataLenght = strlen((CHAR *)GlobalSendBuffer);
    GlobalSendDataLenght = 0;
    GlobalReceivedDataLenght = 1024;
    return OK;
}

STATUS processCommand_sbt_unstack_miss_()
{
    // INT32 Status = OK;
    // INT32 Offset = 0;
    INT32 PartId = get_variable_long_(PARAM1_INT_NUMBER);

    memset(GlobalSendBuffer, CLEAR, sizeof(UCHAR) * SEND_BUFFER_SIZE);

    sprintf((CHAR *)GlobalSendBuffer, "key{robotid:int;status:str;partid:int;msg:str}value{robotid:%d;status:%s;partid:%d;msg:%d}", 1, "error", PartId, "miss");

    GlobalSendDataLenght = strlen((CHAR *)GlobalSendBuffer);
    GlobalReceivedDataLenght = 0;
    return OK;
}

STATUS processCommand_sbt_unstack_success_()
{
    // INT32 Status = OK;
    // INT32 Offset = 0;
    INT32 PartId = get_variable_long_(PARAM1_INT_NUMBER);

    memset(GlobalSendBuffer, CLEAR, sizeof(UCHAR) * SEND_BUFFER_SIZE);

    sprintf((CHAR *)GlobalSendBuffer, "key{robotid:int;status:str;partid:int}value{robotid:%d;status:%s;partid:%d}", 1, "success", PartId);

    GlobalSendDataLenght = strlen((CHAR *)GlobalSendBuffer);
    GlobalReceivedDataLenght = 0;
    return OK;
}

STATUS processCommand_sbt_unstack_area_()
{
    // INT32 Status = OK;
    // INT32 Offset = 0;
    INT32 AreaId = get_variable_long_(PARAM1_INT_NUMBER);

    memset(GlobalSendBuffer, CLEAR, sizeof(UCHAR) * SEND_BUFFER_SIZE);

    sprintf((CHAR *)GlobalSendBuffer, "key{robotid:int;status:str;areaid:int}value{robotid:%d;status:%s;areaid:%d}", 1, "area", AreaId);

    GlobalSendDataLenght = strlen((CHAR *)GlobalSendBuffer);
    GlobalReceivedDataLenght = 0;
    return OK;
}

STATUS processCommand_sbt_unstack_reach_()
{
    // INT32 Status = OK;
    // INT32 Offset = 0;
    // INT32 AreaId = get_variable_long_(PARAM1_INT_NUMBER);

    memset(GlobalSendBuffer, CLEAR, sizeof(UCHAR) * SEND_BUFFER_SIZE);

    sprintf((CHAR *)GlobalSendBuffer, "key{robotid:int;status:str;partid:int;isreach:int}value{robotid:%d;status:%s;partid:%d;isreach:0}", 1, "reach", UnStackPackages.PartId);

    GlobalSendDataLenght = strlen((CHAR *)GlobalSendBuffer);
    GlobalReceivedDataLenght = 0;
    return OK;
}

STATUS processCommand_sbt_unstack_unreach_()
{
    // INT32 Status = OK;
    // INT32 Offset = 0;
    // INT32 AreaId = get_variable_long_(PARAM1_INT_NUMBER);

    memset(GlobalSendBuffer, CLEAR, sizeof(UCHAR) * SEND_BUFFER_SIZE);

    sprintf((CHAR *)GlobalSendBuffer, "key{robotid:int;status:str;partid:int;isreach:int}value{robotid:%d;status:%s;partid:%d;isreach:-1}", 1, "reach", UnStackPackages.PartId);

    GlobalSendDataLenght = strlen((CHAR *)GlobalSendBuffer);
    GlobalReceivedDataLenght = 0;
    return OK;
}


















