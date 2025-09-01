/***********************************************************

Copyright 2018 - 2024 speedbot All Rights reserved.

file Name: sbt_comm011.c

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
#include "sbt_comm011.h"
#include "global_variable.h"
#include "lib\lib_mptp_if.h"
#include "lib\lib_mpmotion.h"

struct package_realtime_t PackageRealtime;
struct package_traje_t PackageTraje;

LOCAL STATUS RealtimePackages();
LOCAL STATUS RealtimeUnPackages();

STATUS RealtimePackages()
{
    INT32 Status = OK;
    INT32 Offset = 0;

    memset(GlobalSendBuffer, CLEAR, sizeof(UCHAR) * SEND_BUFFER_SIZE);

    PackageRealtime.Header.Seq = (PackageRealtime.Header.Seq == 255) ? 1 : PackageRealtime.Header.Seq++;

    Status = encodedataframe_header_(GlobalSendBuffer, &Offset, PackageRealtime.Header); 
    CHECK_RESULT(Status);

    Status = encodedataframe_coord_(GlobalSendBuffer, &Offset, &PackageRealtime.Pos); 
    CHECK_RESULT(Status);

    Status = encodedataframe_float_(GlobalSendBuffer, &Offset, (FLOAT)(PackageRealtime.Pos.ex1 / 1000.0)); 
    CHECK_RESULT(Status);

    Status = encodedataframe_float_(GlobalSendBuffer, &Offset, (FLOAT)(PackageRealtime.Pos.ex2 / 1000.0)); 
    CHECK_RESULT(Status);

    Status = encodedataframe_float_(GlobalSendBuffer, &Offset, 0.0); 
    CHECK_RESULT(Status);

    Status = encodedataframe_float_(GlobalSendBuffer, &Offset, 0.0); 
    CHECK_RESULT(Status);

    Status = encodedataframe_float_(GlobalSendBuffer, &Offset, 0.0); 
    CHECK_RESULT(Status);

    Status = encodedataframe_float_(GlobalSendBuffer, &Offset, 0.0); 
    CHECK_RESULT(Status);

    Status = encodedataframe_float_(GlobalSendBuffer, &Offset, 0.0); 
    CHECK_RESULT(Status);

    Status = encodedataframe_float_(GlobalSendBuffer, &Offset, PackageRealtime.ProcessPrm01); 
    CHECK_RESULT(Status);

    Status = encodedataframe_float_(GlobalSendBuffer, &Offset, PackageRealtime.ProcessPrm02); 
    CHECK_RESULT(Status);

    Status = encodedataframe_float_(GlobalSendBuffer, &Offset, PackageRealtime.ProcessPrm03); 
    CHECK_RESULT(Status);

    Status = encodedataframe_float_(GlobalSendBuffer, &Offset, PackageRealtime.ProcessPrm04); 
    CHECK_RESULT(Status);

    INT32 i;

    for (i = 0; i < 8; i++)
    {
        GlobalSendBuffer[Offset + i] = (INT8)PackageRealtime.Reversed[i];
    }

    Offset += 8;
    
    Status = encodedataframe_tail_(GlobalSendBuffer, &Offset, PackageRealtime.Tail); 
    CHECK_RESULT(Status);

    return OK;
}

STATUS RealtimeUnPackages()
{
    INT32 Status = OK;
    INT32 Offset = 0;
    FLOAT Tmp = 0.0;

    Status = decodedataframe_coord_(GlobalReceiveBuffer, &Offset, &PackageTraje.Pos);
    CHECK_RESULT(Status);

    Status = decodedataframe_float_(GlobalReceiveBuffer, &Offset, &Tmp);
    CHECK_RESULT(Status);
    PackageTraje.Pos.ex1 = (LONG)(Tmp * 1000.0);

    Status = decodedataframe_float_(GlobalReceiveBuffer, &Offset, &Tmp);
    CHECK_RESULT(Status);
    PackageTraje.Pos.ex2 = (LONG)(Tmp * 1000.0);

    Status = decodedataframe_float_(GlobalReceiveBuffer, &Offset, &Tmp);
    CHECK_RESULT(Status);

    Status = decodedataframe_float_(GlobalReceiveBuffer, &Offset, &Tmp);
    CHECK_RESULT(Status);

    Status = decodedataframe_float_(GlobalReceiveBuffer, &Offset, &Tmp);
    CHECK_RESULT(Status);

    Status = decodedataframe_float_(GlobalReceiveBuffer, &Offset, &Tmp);
    CHECK_RESULT(Status);

    Status = decodedataframe_float_(GlobalReceiveBuffer, &Offset, &Tmp);
    CHECK_RESULT(Status);

    Status = decodedataframe_float_(GlobalReceiveBuffer, &Offset, &PackageTraje.ProcessPrm01);
    CHECK_RESULT(Status);

    Status = decodedataframe_float_(GlobalReceiveBuffer, &Offset, &PackageTraje.ProcessPrm02);
    CHECK_RESULT(Status);

    Status = decodedataframe_float_(GlobalReceiveBuffer, &Offset, &PackageTraje.ProcessPrm03);
    CHECK_RESULT(Status);

    Status = decodedataframe_float_(GlobalReceiveBuffer, &Offset, &PackageTraje.ProcessPrm04);
    CHECK_RESULT(Status);

    INT32 i;
    for (i = 0; i < 8; i++)
    {
        PackageRealtime.Reversed[i] = GlobalReceiveBuffer[Offset + i];
    }

    Offset += 8;

    return OK;
}

STATUS ProcessReceivedSbtComm011Data()
{
    INT32 Status = ERROR;
    INT32 Offset = 0;

    // 指令为 0 时，只发送实时数据，不需要返回值
    if (PackageRealtime.Header.Cmd == INST_UNKNOWN)
    {
        delay_(16);

        return OK;
    }
    

    int BytesReceived = 0;	
    BytesReceived = mpRecv(GlobalSocketHandle,							// socket address
        (char*)(GlobalReceiveBuffer),									// receive buffer
    	sizeof(PackageRealtime.Header),										                        // the maximum allowable length of received data to be stored in buffer
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

    Status = decodedataframe_header_(GlobalReceiveBuffer, &Offset, &PackageTraje.Header);
    CHECK_RESULT(Status);

    switch (PackageRealtime.Header.Cmd)
    {
    case INST_PATH:
    {
        INT32 i;
        for (i = 0; i < PackageTraje.Header.PacketCount; i++)
        {
            BytesReceived = mpRecv(GlobalSocketHandle,							// socket address
                (char*)(GlobalReceiveBuffer),									// receive buffer
                76,										                        // the maximum allowable length of received data to be stored in buffer
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

            Status = RealtimeUnPackages();

            // set_variable_robot_position_
        }
        
        break;
    }
    case INST_2D_ST:
    {
        /* code */
        break;
    }
    case INST_2D_ED:
    {
        /* code */
        break;
    }
    }



  return OK;
}

STATUS ProcessCommandSbtComm011Open()
{
    INT32 Status = OK;
    
    memset(&PackageRealtime, CLEAR, sizeof(PackageRealtime));
    memset(&PackageRealtime, CLEAR, sizeof(PackageTraje));

    PackageRealtime.Header.Header = PACKAGE_HEADER;
    PackageRealtime.Header.Length = 96;
    PackageRealtime.Header.Cmd = 0;
    PackageRealtime.Header.PacketCount = 1;
    PackageRealtime.Header.Type = 1;
    PackageRealtime.Header.VirtualRob = 0;
    PackageRealtime.Tail = PACKAGE_TAIL;

    GlobalSocketPort = COMM011_SERVER_PORT;             // 链接端口
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
        sprintf(AlarmMsg, COMM011_ALARM_MESSAGE_SKILL_FAILED_CONNECT, GlobalSocketIp, GlobalSocketPort);        
        mpSetAlarm(COMM011_ALARM_CODE, AlarmMsg, COMM011_ALARM_SUBCODE_FAILED_CONNECT);

        return ERROR;
    }
    
    return OK;
}

STATUS ProcessCommandSbtComm011Close()
{

    GlobalConnect = 0;
    GlobalConnectStatus = 0;
    
    return OK;
}

STATUS ProcessCommandSbtComm011Realtime()
{

    INT32 Status = OK;

    PackageRealtime.Header.Cmd = INST_UNKNOWN;

    Status = current_cartposition_(0, 0, &PackageRealtime.Pos);
    if (Status != OK)
    {
        DEBUG_ERROR("Failed Call current_cartposition_[Error:%d]", Status);
        return Status;
    }

    Status = RealtimePackages();
    CHECK_RESULT(Status);

    GlobalSendDataLenght = PackageRealtime.Header.Length;
    // GlobalReceivedDataLenght = sizeof(PackageRealtime.Header);
    
    return OK;
}

STATUS ProcessCommandSbtComm011ScanStart()
{

    INT32 Status = OK;

    PackageRealtime.Header.Cmd = INST_2D_ST;

    Status = current_cartposition_(0, 0, &PackageRealtime.Pos);
    if (Status != OK)
    {
        DEBUG_ERROR("Failed Call current_cartposition_[Error:%d]", Status);
        return Status;
    }

    Status = RealtimePackages();
    CHECK_RESULT(Status);

    GlobalSendDataLenght = PackageRealtime.Header.Length;
    // GlobalReceivedDataLenght = sizeof(PackageRealtime.Header);
    
    return OK;
}

STATUS ProcessCommandSbtComm011ScanStop()
{

    INT32 Status = OK;

    PackageRealtime.Header.Cmd = INST_2D_ED;

    Status = current_cartposition_(0, 0, &PackageRealtime.Pos);
    if (Status != OK)
    {
        DEBUG_ERROR("Failed Call current_cartposition_[Error:%d]", Status);
        return Status;
    }

    Status = RealtimePackages();
    CHECK_RESULT(Status);

    GlobalSendDataLenght = PackageRealtime.Header.Length;
    // GlobalReceivedDataLenght = sizeof(PackageRealtime.Header);
    
    return OK;
}

STATUS ProcessCommandSbtComm011GetPath()
{

    INT32 Status = OK;

    PackageRealtime.Header.Cmd = INST_2D_ED;

    Status = current_cartposition_(0, 0, &PackageRealtime.Pos);
    if (Status != OK)
    {
        DEBUG_ERROR("Failed Call current_cartposition_[Error:%d]", Status);
        return Status;
    }

    Status = RealtimePackages();
    CHECK_RESULT(Status);

    GlobalSendDataLenght = PackageRealtime.Header.Length;
    // GlobalReceivedDataLenght = sizeof(PackageRealtime.Header);
    
    return OK;
}

