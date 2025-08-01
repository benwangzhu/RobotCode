/***********************************************************

Copyright 2018 - 2023 speedbot All Rights reserved.

 file Name: lib_mpbusio.h

 Description:
   Language             ==   motoplus for Yaskawa ROBOT
  Date                 ==   2023 - 10 - 26
  Modification Data    ==   2023 - 10 - 27

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
#ifndef __SBT_MPBUS_IO_H__
#define __SBT_MPBUS_IO_H__

#include "operating_environment.h"

#define PTC_LN_PL               1
#define PTC_ST_PK               2
#define PTC_GEN_CMD             64
#define PTC_ROB_CTL             128

struct businput_t
{
    INT32 BusIoStartAddr;
    BOOL SysReady;
    BOOL SysInitialized;
    BOOL StopMove;
    BOOL OnMeasure;
    BOOL MeasuerOver;
    BOOL ResultOk;
    BOOL ResultNG;
    BOOL Finished;
    UINT8 DeviceId;
    UINT8 JobId;
    UINT8 ErrorId;
    UINT8 AgentTellId;
    UINT8 AgentMsgType;
    UINT8 TellId;
    UINT8 MsgType;    
};

struct busoutput_t 
{
    INT32 BusIoStartAddr;
    BOOL SysEnable;
    BOOL SysInitialize;
    BOOL RobotMoveing;
    BOOL MeasureStart;
    BOOL MeasuerStop;
    BOOL Reserverd1;
    BOOL Reserverd2;
    BOOL CycleEnd;
    UINT8 RobotId;
    UINT8 JobId;
    UINT8 ProtocolId;
    UINT8 TellId;
    UINT8 MsgType;
    UINT8 RobTellId;
    UINT8 RobMsgType;    
};

IMPORT STATUS bus_set_byte_(IN UINT32 StartPortAddr, IN UINT8 Value);

IMPORT STATUS bus_set_int16_(IN UINT32 StartPortAddr, IN INT16 Value);

IMPORT STATUS bus_set_uint16_(IN UINT32 StartPortAddr, IN UINT16 Value);

IMPORT STATUS bus_set_int32_(IN UINT32 StartPortAddr, IN INT32 Value); 

IMPORT STATUS bus_set_float2_(IN UINT32 StartPortAddr, IN FLOAT Value); 

IMPORT STATUS bus_set_jointpos_(IN UINT32 StartPortAddr, IN const MP_JOINT Value, IN UINT32 NumOfAxis);

IMPORT STATUS bus_set_cartpos_(IN UINT32 StartPortAddr, IN MP_COORD Value, IN UINT32 NumOfAxis); 

IMPORT STATUS bus_get_byte_(IN UINT32 StartPortAddr, OUT UINT8* Value); 

IMPORT STATUS bus_get_int16_(IN UINT32 StartPortAddr, OUT INT16* Value); 

IMPORT STATUS bus_get_uint16_(IN UINT32 StartPortAddr, OUT UINT16* Value); 

IMPORT STATUS bus_get_int32_(IN UINT32 StartPortAddr, OUT INT32* Value);

IMPORT STATUS bus_get_float2_(IN UINT32 StartPortAddr, OUT FLOAT* Value); 

IMPORT STATUS bus_get_jointpos_(IN UINT32 StartPortAddr, OUT MP_JOINT* Value, IN UINT32 NumOfAxis); 

IMPORT STATUS bus_get_cartpos_(IN UINT32 StartPortAddr, OUT MP_COORD* Value, IN UINT32 NumOfAxis); 

IMPORT STATUS bus_update_input_(INOUT struct businput_t* BusInput); 

IMPORT STATUS bus_update_output_(INOUT struct busoutput_t* BusOutput);

IMPORT STATUS bus_initialize_(INOUT struct businput_t* BusInput, INOUT struct busoutput_t *BusOutput, IN INT8 RobId, IN INT8 ProtId); 

IMPORT STATUS bus_wait_tell_(INOUT struct businput_t* BusInput, INOUT struct busoutput_t *BusOutput, IN INT32 Timeout);

IMPORT STATUS bus_feeback_tell_(INOUT struct businput_t* BusInput, INOUT struct busoutput_t *BusOutput);

IMPORT STATUS bus_new_tell_(INOUT struct businput_t* BusInput, INOUT struct busoutput_t *BusOutput, IN INT32 Timeout);

IMPORT STATUS bus_send_tell_(INOUT struct businput_t* BusInput, INOUT struct busoutput_t *BusOutput);

IMPORT STATUS bus_read_tell_(INOUT struct businput_t* BusInput, INOUT struct busoutput_t *BusOutput, IN INT32 Timeout);


#endif
