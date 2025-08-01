/***********************************************************

Copyright 2018 - 2024 speedbot All Rights reserved.

file Name: lib_mpbusio_cmd.c

Description:
  Language             ==   motoplus for Yaskawa ROBOT
  Date                 ==   2023 - 10 - 26
  Modification Data    ==   2024 - 02 - 29

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

2023 - 10 - 26 ++ bus_set_byte_() ==> STATUS

2023 - 10 - 26 ++ bus_set_int16_() ==> STATUS

2023 - 10 - 26 ++ bus_set_uint16_() ==> STATUS

2023 - 10 - 26 ++ bus_set_int32_() ==> STATUS

2023 - 10 - 26 ++ bus_set_float2_() ==> STATUS

2023 - 10 - 26 ++ bus_set_jointpos_() ==> STATUS

2023 - 10 - 26 ++ bus_set_cartpos_() ==> STATUS

2023 - 10 - 26 ++ bus_get_byte_() ==> STATUS

2023 - 10 - 26 ++ bus_get_int16_() ==> STATUS

2023 - 10 - 26 ++ bus_get_uint16_() ==> STATUS

2023 - 10 - 26 ++ bus_get_int32_() ==> STATUS

2023 - 10 - 26 ++ bus_get_float2_() ==> STATUS

2023 - 10 - 26 ++ bus_get_jointpos_() ==> STATUS

2023 - 10 - 26 ++ bus_get_cartpos_() ==> STATUS

2023 - 10 - 26 ++ bus_update_input_() ==> STATUS

2023 - 10 - 26 ++ bus_update_output_() ==> STATUS

2023 - 10 - 26 ++ bus_initialize_() ==> STATUS

2023 - 10 - 26 ++ bus_wait_tell_() ==> STATUS

2023 - 10 - 26 ++ bus_feeback_tell_() ==> STATUS

2023 - 10 - 26 ++ bus_new_tell_() ==> STATUS

*/

#include "motoPlus.h"
#include "lib_mpbusio_cmd.h"
#include "lib_mptp_if.h"

LOCAL STATUS bus_command_wo__(IN UINT8 BusCommandId, 
                              IN enum bus_command_ms_e BusMstSel, 
                              INOUT struct businput_t* BusInput,
                              INOUT struct busoutput_t *BusOutput);

LOCAL STATUS bus_command_ro__(IN UINT8 BusCommandId, 
                              IN enum bus_command_ms_e BusMstSel, 
                              INOUT struct businput_t* BusInput,
                              INOUT struct busoutput_t *BusOutput,
                              IN INT32 Timeout);


STATUS bus_command_wo__(IN UINT8 BusCommandId, 
                        IN enum bus_command_ms_e BusMstSel, 
                        INOUT struct businput_t* BusInput,
                        INOUT struct busoutput_t *BusOutput)
{
    INT32 Status = ERROR;

    switch (BusMstSel)
    {
    case BUSCMD_MST:
    {
        BusOutput->RobMsgType = BusCommandId;
        Status = bus_send_tell_(BusInput, BusOutput);
        break; 
    }
    case BUSCMD_SLE:
    {
        BusOutput->MsgType = BusCommandId;
        Status = bus_feeback_tell_(BusInput, BusOutput);
        break;
    }
    }
    return(Status);
}

STATUS bus_command_ro__(IN UINT8 BusCommandId, 
                        IN enum bus_command_ms_e BusMstSel, 
                        INOUT struct businput_t* BusInput,
                        INOUT struct busoutput_t *BusOutput,
                        IN INT32 Timeout)
{
    INT32 Status = ERROR;

    switch (BusMstSel)
    {
    case BUSCMD_MST:
    {

        Status = bus_read_tell_(BusInput, BusOutput, Timeout);
        if (Status != OK)
        {
            DEBUG_ERROR("MST Read BusCommand Id Error![BusCommandId:%d, Error:%d]", BusCommandId, Status);
            return(Status);
        }

        Status = bus_set_byte_(BusOutput->BusIoStartAddr + 70, 0);
        CHECK_RESULT(Status);
        if (BusInput->MsgType != BusCommandId)
        {

            DEBUG_ERROR("MST Input BusCommand Id Error![MsgType:%d, BusCommandId:%d, Error:%d]", BusInput->MsgType, BusCommandId, Status);
            
            // 产生报警
            CHAR AlarmMsg[128] = {0};
            sprintf(AlarmMsg, "MST BusCmdIdErr[MsgType:%d, BusCommandId:%d, Error:%d]", BusInput->MsgType, BusCommandId, Status);
            mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);

            Status = ERROR;
        }
        break; 
    }
    case BUSCMD_SLE:
    {

        Status = bus_wait_tell_(BusInput, BusOutput, Timeout);
        if (Status != OK)
        {

            DEBUG_ERROR("SEL Read BusCommand Id Error![CmdId:%d, ErrCode:%d]", BusCommandId, Status);
            return(Status);
        }

        if (BusInput->AgentMsgType != BusCommandId)
        {
            DEBUG_ERROR("SEL Input BusCommand Id Error![MsgType:%d, BusCommandId:%d, Error:%d]", BusInput->AgentMsgType, BusCommandId, Status);
            
            // 产生报警
            CHAR AlarmMsg[128] = {0};
            sprintf(AlarmMsg, "SEL BusCmdIdErr[MsgType:%d, BusCommandId:%d, Error:%d]", BusInput->AgentMsgType, BusCommandId, Status);
            mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
            Status = ERROR;
        }
        break;
    }
    }
    return(Status);
}

STATUS bus_command001_( IN enum bus_command_rw_e BusOperation, 
                        IN enum bus_command_ms_e BusMstSel, 
                        INOUT struct businput_t* BusInput, 
                        INOUT struct busoutput_t *BusOutput, 
                        IN INT32 Timeout)
{
    INT32 Status = ERROR;

    switch (BusOperation)
    {
    case BUSCMD_WRITE:
    {   
        Status = bus_command_wo__(BUS_CMD001, BusMstSel, BusInput, BusOutput);
        break;
    }
    case BUSCMD_READ:
    {   
        Status = bus_command_ro__(BUS_CMD001, BusMstSel, BusInput, BusOutput, Timeout);
        break;
    }
    }
    return(Status);
}

STATUS bus_command002_( IN enum bus_command_rw_e BusOperation, 
                        IN enum bus_command_ms_e BusMstSel, 
                        INOUT struct businput_t* BusInput, 
                        INOUT struct busoutput_t* BusOutput, 
                        INOUT struct cmd_type01_t* BusData,
                        IN INT32 Timeout)
{
    INT32 Status = ERROR;
    struct cmd_type01_t InputBusData;
    switch (BusOperation)
    {
    case BUSCMD_WRITE:
    {   
        memcpy(&InputBusData, BusData, sizeof(struct cmd_type01_t));
        Status = bus_set_byte_(BusOutput->BusIoStartAddr + 80, InputBusData.Byte01);
        CHECK_RESULT(Status);
        Status = bus_set_byte_(BusOutput->BusIoStartAddr + 90, InputBusData.Byte02);
        CHECK_RESULT(Status);
        Status = bus_set_int16_(BusOutput->BusIoStartAddr + 100, InputBusData.Short03);
        CHECK_RESULT(Status);
        Status = bus_set_int16_(BusOutput->BusIoStartAddr + 120, InputBusData.Short04);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 140, InputBusData.Int05);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 180, InputBusData.Int06);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 220, InputBusData.Float07);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 260, InputBusData.Float08);
        CHECK_RESULT(Status);
        Status = bus_command_wo__(BUS_CMD002, BusMstSel, BusInput, BusOutput);
        break;
    }
    case BUSCMD_READ:
    {   
        memset(BusData, CLEAR, sizeof(struct cmd_type01_t));
        Status = bus_command_ro__(BUS_CMD002, BusMstSel, BusInput, BusOutput, Timeout);
        CHECK_RESULT(Status);
        Status = bus_get_byte_(BusInput->BusIoStartAddr + 80, &BusData->Byte01);
        CHECK_RESULT(Status);
        Status = bus_get_byte_(BusInput->BusIoStartAddr + 90, &BusData->Byte02);
        CHECK_RESULT(Status);
        Status = bus_get_int16_(BusInput->BusIoStartAddr + 100, &BusData->Short03);
        CHECK_RESULT(Status);
        Status = bus_get_int16_(BusInput->BusIoStartAddr + 120, &BusData->Short04);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 140, &BusData->Int05);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 180, &BusData->Int06);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 220, &BusData->Float07);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 260, &BusData->Float08);
        CHECK_RESULT(Status);
        break;
    }
    }

    return(Status);
}

STATUS bus_command003_( IN enum bus_command_rw_e BusOperation, 
                        IN enum bus_command_ms_e BusMstSel, 
                        INOUT struct businput_t* BusInput, 
                        INOUT struct busoutput_t* BusOutput, 
                        INOUT MP_COORD* BusData,
                        IN INT32 Timeout)
{
    INT32 Status = ERROR;
    MP_COORD InputBusData;

    switch (BusOperation)
    {
    case BUSCMD_WRITE:
    {   
        memcpy(&InputBusData, BusData, sizeof(MP_COORD));
        Status = bus_set_cartpos_(BusOutput->BusIoStartAddr + 80, InputBusData, 6);
        CHECK_RESULT(Status);
        Status = bus_command_wo__(BUS_CMD003, BusMstSel, BusInput, BusOutput);
        break;
    }
    case BUSCMD_READ:
    {   
        memset(BusData, CLEAR, sizeof(MP_COORD));
        Status = bus_command_ro__(BUS_CMD003, BusMstSel, BusInput, BusOutput, Timeout);
        CHECK_RESULT(Status);
        Status = bus_get_cartpos_(BusInput->BusIoStartAddr + 80, BusData, 6);
        break;
    }
    }

    return(Status);
}

STATUS bus_command009_( IN enum bus_command_rw_e BusOperation, 
                        IN enum bus_command_ms_e BusMstSel, 
                        INOUT struct businput_t* BusInput, 
                        INOUT struct busoutput_t* BusOutput, 
                        INOUT MP_COORD* BusData,
                        IN INT32 Timeout)
{
    INT32 Status = ERROR;
    MP_COORD InputBusData;

    switch (BusOperation)
    {
    case BUSCMD_WRITE:
    {   
        memcpy(&InputBusData, BusData, sizeof(MP_COORD));
        Status = bus_set_cartpos_(BusOutput->BusIoStartAddr + 80, InputBusData, 6);
        CHECK_RESULT(Status);
        Status = bus_command_wo__(BUS_CMD009, BusMstSel, BusInput, BusOutput);
        break;
    }
    case BUSCMD_READ:
    {   
        memset(BusData, CLEAR, sizeof(MP_COORD));
        Status = bus_command_ro__(BUS_CMD009, BusMstSel, BusInput, BusOutput, Timeout);
        CHECK_RESULT(Status);
        Status = bus_get_cartpos_(BusInput->BusIoStartAddr + 80, BusData, 6);
        break;
    }
    }

    return(Status);
}

STATUS bus_command010_( IN enum bus_command_rw_e BusOperation, 
                        IN enum bus_command_ms_e BusMstSel, 
                        INOUT struct businput_t* BusInput, 
                        INOUT struct busoutput_t* BusOutput, 
                        INOUT MP_COORD* BusData,
                        IN INT32 Timeout)
{
    INT32 Status = ERROR;
    MP_COORD InputBusData;

    switch (BusOperation)
    {
    case BUSCMD_WRITE:
    {   
        memcpy(&InputBusData, BusData, sizeof(MP_COORD));
        Status = bus_set_cartpos_(BusOutput->BusIoStartAddr + 80, InputBusData, 6);
        CHECK_RESULT(Status);
        Status = bus_command_wo__(BUS_CMD010, BusMstSel, BusInput, BusOutput);
        break;
    }
    case BUSCMD_READ:
    {   
        memset(BusData, CLEAR, sizeof(MP_COORD));
        Status = bus_command_ro__(BUS_CMD010, BusMstSel, BusInput, BusOutput, Timeout);
        CHECK_RESULT(Status);
        Status = bus_get_cartpos_(BusInput->BusIoStartAddr + 80, BusData, 6);
        break;
    }
    }

    return(Status);
}

STATUS bus_command011_( IN enum bus_command_rw_e BusOperation, 
                        IN enum bus_command_ms_e BusMstSel, 
                        struct businput_t* BusInput, 
                        struct busoutput_t* BusOutput, 
                        MP_COORD* BusData,
                        IN INT32 Timeout)
{
    INT32 Status = ERROR;
    MP_COORD InputBusData;

    switch (BusOperation)
    {
    case BUSCMD_WRITE:
    {   
        memcpy(&InputBusData, BusData, sizeof(MP_COORD));
        Status = bus_set_cartpos_(BusOutput->BusIoStartAddr + 80, InputBusData, 6);
        CHECK_RESULT(Status);
        Status = bus_command_wo__(BUS_CMD011, BusMstSel, BusInput, BusOutput);
        break;
    }
    case BUSCMD_READ:
    {   
        memset(BusData, CLEAR, sizeof(MP_COORD));
        Status = bus_command_ro__(BUS_CMD011, BusMstSel, BusInput, BusOutput, Timeout);
        CHECK_RESULT(Status);
        Status = bus_get_cartpos_(BusInput->BusIoStartAddr + 80, BusData, 6);
        break;
    }
    }

    return(Status);
}

STATUS bus_command012_( IN enum bus_command_rw_e BusOperation, 
                        IN enum bus_command_ms_e BusMstSel, 
                        INOUT struct businput_t* BusInput, 
                        INOUT struct busoutput_t* BusOutput, 
                        INOUT struct cmd_type01_t* BusData,
                        IN INT32 Timeout)
{
    INT32 Status = ERROR;
    struct cmd_type01_t InputBusData;

    switch (BusOperation)
    {
    case BUSCMD_WRITE:
    {   
        memcpy(&InputBusData, BusData, sizeof(struct cmd_type01_t));

        Status = bus_set_byte_(BusOutput->BusIoStartAddr + 80, InputBusData.Byte01);
        CHECK_RESULT(Status);
        Status = bus_set_byte_(BusOutput->BusIoStartAddr + 90, InputBusData.Byte02);
        CHECK_RESULT(Status);
        Status = bus_set_int16_(BusOutput->BusIoStartAddr + 100, InputBusData.Short03);
        CHECK_RESULT(Status);
        Status = bus_set_int16_(BusOutput->BusIoStartAddr + 120, InputBusData.Short04);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 140, InputBusData.Int05);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 180, InputBusData.Int06);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 220, InputBusData.Float07);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 260, InputBusData.Float08);
        CHECK_RESULT(Status);
        Status = bus_command_wo__(BUS_CMD012, BusMstSel, BusInput, BusOutput);
        break;
    }
    case BUSCMD_READ:
    {   
        memset(BusData, CLEAR, sizeof(struct cmd_type01_t));
        Status = bus_command_ro__(BUS_CMD012, BusMstSel, BusInput, BusOutput, Timeout);
        CHECK_RESULT(Status);
        Status = bus_get_byte_(BusInput->BusIoStartAddr + 80, &BusData->Byte01);
        CHECK_RESULT(Status);
        Status = bus_get_byte_(BusInput->BusIoStartAddr + 90, &BusData->Byte02);
        CHECK_RESULT(Status);
        Status = bus_get_int16_(BusInput->BusIoStartAddr + 100, &BusData->Short03);
        CHECK_RESULT(Status);
        Status = bus_get_int16_(BusInput->BusIoStartAddr + 120, &BusData->Short04);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 140, &BusData->Int05);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 180, &BusData->Int06);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 220, &BusData->Float07);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 260, &BusData->Float08);
        CHECK_RESULT(Status);
        break;
    }
    }

    return(Status);
}

STATUS bus_command013_( IN enum bus_command_rw_e BusOperation, 
                        IN enum bus_command_ms_e BusMstSel, 
                        INOUT struct businput_t* BusInput, 
                        INOUT struct busoutput_t* BusOutput, 
                        INOUT struct cmd_type01_t* BusData,
                        IN INT32 Timeout)
{
    INT32 Status = ERROR;
    struct cmd_type01_t InputBusData;

    switch (BusOperation)
    {
    case BUSCMD_WRITE:
    {   
        memcpy(&InputBusData, BusData, sizeof(struct cmd_type01_t));

        Status = bus_set_byte_(BusOutput->BusIoStartAddr + 80, InputBusData.Byte01);
        CHECK_RESULT(Status);
        Status = bus_set_byte_(BusOutput->BusIoStartAddr + 90, InputBusData.Byte02);
        CHECK_RESULT(Status);
        Status = bus_set_int16_(BusOutput->BusIoStartAddr + 100, InputBusData.Short03);
        CHECK_RESULT(Status);
        Status = bus_set_int16_(BusOutput->BusIoStartAddr + 120, InputBusData.Short04);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 140, InputBusData.Int05);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 180, InputBusData.Int06);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 220, InputBusData.Float07);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 260, InputBusData.Float08);
        CHECK_RESULT(Status);
        Status = bus_command_wo__(BUS_CMD013, BusMstSel, BusInput, BusOutput);
        break;
    }
    case BUSCMD_READ:
    {   
        memset(BusData, CLEAR, sizeof(struct cmd_type01_t));
        Status = bus_command_ro__(BUS_CMD013, BusMstSel, BusInput, BusOutput, Timeout);
        CHECK_RESULT(Status);
        Status = bus_get_byte_(BusInput->BusIoStartAddr + 80, &BusData->Byte01);
        CHECK_RESULT(Status);
        Status = bus_get_byte_(BusInput->BusIoStartAddr + 90, &BusData->Byte02);
        CHECK_RESULT(Status);
        Status = bus_get_int16_(BusInput->BusIoStartAddr + 100, &BusData->Short03);
        CHECK_RESULT(Status);
        Status = bus_get_int16_(BusInput->BusIoStartAddr + 120, &BusData->Short04);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 140, &BusData->Int05);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 180, &BusData->Int06);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 220, &BusData->Float07);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 260, &BusData->Float08);
        CHECK_RESULT(Status);

        break;
    }
    }

    return(Status);
}

STATUS bus_command014_( IN enum bus_command_rw_e BusOperation, 
                        IN enum bus_command_ms_e BusMstSel, 
                        INOUT struct businput_t* BusInput, 
                        INOUT struct busoutput_t* BusOutput, 
                        INOUT struct cmd_type01_t* BusData,
                        IN INT32 Timeout)
{
    INT32 Status = ERROR;
    struct cmd_type01_t InputBusData;

    switch (BusOperation)
    {
    case BUSCMD_WRITE:
    {   
        memcpy(&InputBusData, BusData, sizeof(struct cmd_type01_t));

        Status = bus_set_byte_(BusOutput->BusIoStartAddr + 80, InputBusData.Byte01);
        CHECK_RESULT(Status);
        Status = bus_set_byte_(BusOutput->BusIoStartAddr + 90, InputBusData.Byte02);
        CHECK_RESULT(Status);
        Status = bus_set_int16_(BusOutput->BusIoStartAddr + 100, InputBusData.Short03);
        CHECK_RESULT(Status);
        Status = bus_set_int16_(BusOutput->BusIoStartAddr + 120, InputBusData.Short04);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 140, InputBusData.Int05);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 180, InputBusData.Int06);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 220, InputBusData.Float07);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 260, InputBusData.Float08);
        CHECK_RESULT(Status);
        Status = bus_command_wo__(BUS_CMD014, BusMstSel, BusInput, BusOutput);
        break;
    }
    case BUSCMD_READ:
    {   
        memset(BusData, CLEAR, sizeof(struct cmd_type01_t));
        Status = bus_command_ro__(BUS_CMD014, BusMstSel, BusInput, BusOutput, Timeout);
        CHECK_RESULT(Status);
        Status = bus_get_byte_(BusInput->BusIoStartAddr + 80, &BusData->Byte01);
        CHECK_RESULT(Status);
        Status = bus_get_byte_(BusInput->BusIoStartAddr + 90, &BusData->Byte02);
        CHECK_RESULT(Status);
        Status = bus_get_int16_(BusInput->BusIoStartAddr + 100, &BusData->Short03);
        CHECK_RESULT(Status);
        Status = bus_get_int16_(BusInput->BusIoStartAddr + 120, &BusData->Short04);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 140, &BusData->Int05);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 180, &BusData->Int06);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 220, &BusData->Float07);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 260, &BusData->Float08);
        CHECK_RESULT(Status);
        break;
    }
    }

    return(Status);
}

STATUS bus_command017_( IN enum bus_command_rw_e BusOperation, 
                        IN enum bus_command_ms_e BusMstSel, 
                        INOUT struct businput_t* BusInput, 
                        INOUT struct busoutput_t* BusOutput, 
                        INOUT struct cmd_type07_t* BusData,
                        IN INT32 Timeout)
{
    INT32 Status = ERROR;
    struct cmd_type07_t InputBusData;

    switch (BusOperation)
    {
    case BUSCMD_WRITE:
    {   
        memcpy(&InputBusData, BusData, sizeof(struct cmd_type07_t));
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 80, InputBusData.Float01);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 120, InputBusData.Float02);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 160, InputBusData.Float03);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 200, InputBusData.Float04);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 240, InputBusData.Float05);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 280, InputBusData.Float06);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 320, InputBusData.Float07);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 360, InputBusData.Float08);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 400, InputBusData.Float09);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 440, InputBusData.Float10);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 480, InputBusData.Float11);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 520, InputBusData.Float12);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 560, InputBusData.Int13);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 600, InputBusData.Int14);
        CHECK_RESULT(Status);
        Status = set_io_value_(BusOutput->BusIoStartAddr + 3, 0);
        CHECK_RESULT(Status);
        Status = set_io_value_(BusOutput->BusIoStartAddr + 4, 0);
        CHECK_RESULT(Status);


        Status = bus_command_wo__(BUS_CMD017, BusMstSel, BusInput, BusOutput);
        break;
    }
    case BUSCMD_READ:
    {   
        memset(BusData, CLEAR, sizeof(struct cmd_type07_t));
        Status = bus_command_ro__(BUS_CMD017, BusMstSel, BusInput, BusOutput, Timeout);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 80, &BusData->Float01);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 120, &BusData->Float02);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 160, &BusData->Float03);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 200, &BusData->Float04);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 240, &BusData->Float05);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 280, &BusData->Float06);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 320, &BusData->Float07);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 360, &BusData->Float08);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 400, &BusData->Float09);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 440, &BusData->Float10);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 480, &BusData->Float11);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 520, &BusData->Float12);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 560, &BusData->Int13);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 600, &BusData->Int14);
        CHECK_RESULT(Status);
        break;
    }
    }

    return(Status);
}

STATUS bus_command018_( IN enum bus_command_rw_e BusOperation, 
                        IN enum bus_command_ms_e BusMstSel, 
                        INOUT struct businput_t* BusInput, 
                        INOUT struct busoutput_t* BusOutput, 
                        INOUT struct cmd_type07_t* BusData,
                        IN INT32 Timeout)
{
    INT32 Status = ERROR;
    struct cmd_type07_t InputBusData;
    
    switch (BusOperation)
    {
    case BUSCMD_WRITE:
    {   
        memcpy(&InputBusData, BusData, sizeof(struct cmd_type07_t));
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 80, InputBusData.Float01);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 120, InputBusData.Float02);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 160, InputBusData.Float03);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 200, InputBusData.Float04);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 240, InputBusData.Float05);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 280, InputBusData.Float06);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 320, InputBusData.Float07);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 360, InputBusData.Float08);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 400, InputBusData.Float09);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 440, InputBusData.Float10);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 480, InputBusData.Float11);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 520, InputBusData.Float12);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 560, InputBusData.Int13);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 600, InputBusData.Int14);
        CHECK_RESULT(Status);
        Status = set_io_value_(BusOutput->BusIoStartAddr + 3, 0);
        CHECK_RESULT(Status);
        Status = set_io_value_(BusOutput->BusIoStartAddr + 4, 0);
        CHECK_RESULT(Status);


        Status = bus_command_wo__(BUS_CMD018, BusMstSel, BusInput, BusOutput);
        break;
    }
    case BUSCMD_READ:
    {   
        memset(BusData, CLEAR, sizeof(struct cmd_type07_t));
        Status = bus_command_ro__(BUS_CMD018, BusMstSel, BusInput, BusOutput, Timeout);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 80, &BusData->Float01);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 120, &BusData->Float02);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 160, &BusData->Float03);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 200, &BusData->Float04);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 240, &BusData->Float05);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 280, &BusData->Float06);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 320, &BusData->Float07);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 360, &BusData->Float08);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 400, &BusData->Float09);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 440, &BusData->Float10);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 480, &BusData->Float11);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 520, &BusData->Float12);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 560, &BusData->Int13);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 600, &BusData->Int14);
        CHECK_RESULT(Status);
        break;
    }
    }

    return(Status);
}


STATUS bus_command020_( IN enum bus_command_rw_e BusOperation, 
                        IN enum bus_command_ms_e BusMstSel, 
                        INOUT struct businput_t* BusInput, 
                        INOUT struct busoutput_t* BusOutput, 
                        INOUT MP_COORD* BusData,
                        IN INT32 Timeout)
{
    INT32 Status = ERROR;
    MP_COORD InputBusData;

    switch (BusOperation)
    {
    case BUSCMD_WRITE:
    {   
        memcpy(&InputBusData, BusData, sizeof(MP_COORD));
        Status = bus_set_cartpos_(BusOutput->BusIoStartAddr + 80, InputBusData, 6);
        CHECK_RESULT(Status);
        Status = bus_command_wo__(BUS_CMD020, BusMstSel, BusInput, BusOutput);
        break;
    }
    case BUSCMD_READ:
    {   
        memset(BusData, CLEAR, sizeof(MP_COORD));
        Status = bus_command_ro__(BUS_CMD020, BusMstSel, BusInput, BusOutput, Timeout);
        CHECK_RESULT(Status);
        Status = bus_get_cartpos_(BusInput->BusIoStartAddr + 80, BusData, 6);
        break;
    }
    }

    return(Status);
}

STATUS bus_command021_( IN enum bus_command_rw_e BusOperation, 
                        IN enum bus_command_ms_e BusMstSel, 
                        INOUT struct businput_t* BusInput, 
                        INOUT struct busoutput_t* BusOutput, 
                        INOUT struct cmd_type01_t* BusData,
                        IN INT32 Timeout)
{
    INT32 Status = ERROR;
    struct cmd_type01_t InputBusData;

    switch (BusOperation)
    {
    case BUSCMD_WRITE:
    {   
        memcpy(&InputBusData, BusData, sizeof(struct cmd_type01_t));

        Status = bus_set_byte_(BusOutput->BusIoStartAddr + 80, InputBusData.Byte01);
        CHECK_RESULT(Status);
        Status = bus_set_byte_(BusOutput->BusIoStartAddr + 90, InputBusData.Byte02);
        CHECK_RESULT(Status);
        Status = bus_set_int16_(BusOutput->BusIoStartAddr + 100, InputBusData.Short03);
        CHECK_RESULT(Status);
        Status = bus_set_int16_(BusOutput->BusIoStartAddr + 120, InputBusData.Short04);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 140, InputBusData.Int05);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 180, InputBusData.Int06);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 220, InputBusData.Float07);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 260, InputBusData.Float08);
        CHECK_RESULT(Status);
        Status = bus_command_wo__(BUS_CMD021, BusMstSel, BusInput, BusOutput);
        break;
    }
    case BUSCMD_READ:
    {   
        memset(BusData, CLEAR, sizeof(struct cmd_type01_t));
        Status = bus_command_ro__(BUS_CMD021, BusMstSel, BusInput, BusOutput, Timeout);
        CHECK_RESULT(Status);
        Status = bus_get_byte_(BusInput->BusIoStartAddr + 80, &BusData->Byte01);
        CHECK_RESULT(Status);
        Status = bus_get_byte_(BusInput->BusIoStartAddr + 90, &BusData->Byte02);
        CHECK_RESULT(Status);
        Status = bus_get_int16_(BusInput->BusIoStartAddr + 100, &BusData->Short03);
        CHECK_RESULT(Status);
        Status = bus_get_int16_(BusInput->BusIoStartAddr + 120, &BusData->Short04);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 140, &BusData->Int05);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 180, &BusData->Int06);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 220, &BusData->Float07);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 260, &BusData->Float08);
        CHECK_RESULT(Status);

        break;
    }
    }

    return(Status);
}

STATUS bus_command022_( IN enum bus_command_rw_e BusOperation, 
                        IN enum bus_command_ms_e BusMstSel, 
                        INOUT struct businput_t* BusInput, 
                        INOUT struct busoutput_t* BusOutput, 
                        INOUT struct cmd_type01_t* BusData,
                        IN INT32 Timeout)
{
    INT32 Status = ERROR;
    struct cmd_type01_t InputBusData;

    switch (BusOperation)
    {
    case BUSCMD_WRITE:
    {   
        memcpy(&InputBusData, BusData, sizeof(struct cmd_type01_t));
        Status = bus_set_byte_(BusOutput->BusIoStartAddr + 80, InputBusData.Byte01);
        CHECK_RESULT(Status);
        Status = bus_set_byte_(BusOutput->BusIoStartAddr + 90, InputBusData.Byte02);
        CHECK_RESULT(Status);
        Status = bus_set_int16_(BusOutput->BusIoStartAddr + 100, InputBusData.Short03);
        CHECK_RESULT(Status);
        Status = bus_set_int16_(BusOutput->BusIoStartAddr + 120, InputBusData.Short04);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 140, InputBusData.Int05);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 180, InputBusData.Int06);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 220, InputBusData.Float07);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 260, InputBusData.Float08);
        CHECK_RESULT(Status);
        Status = bus_command_wo__(BUS_CMD022, BusMstSel, BusInput, BusOutput);
        break;
    }
    case BUSCMD_READ:
    {   
        memset(BusData, 0, sizeof(struct cmd_type01_t));
        Status = bus_command_ro__(BUS_CMD022, BusMstSel, BusInput, BusOutput, Timeout);
        CHECK_RESULT(Status);
        Status = bus_get_byte_(BusInput->BusIoStartAddr + 80, &BusData->Byte01);
        CHECK_RESULT(Status);
        Status = bus_get_byte_(BusInput->BusIoStartAddr + 90, &BusData->Byte02);
        CHECK_RESULT(Status);
        Status = bus_get_int16_(BusInput->BusIoStartAddr + 100, &BusData->Short03);
        CHECK_RESULT(Status);
        Status = bus_get_int16_(BusInput->BusIoStartAddr + 120, &BusData->Short04);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 140, &BusData->Int05);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 180, &BusData->Int06);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 220, &BusData->Float07);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 260, &BusData->Float08);
        CHECK_RESULT(Status);

        break;
    }
    }

    return(Status);
}

STATUS bus_command026_( IN enum bus_command_rw_e BusOperation, 
                        IN enum bus_command_ms_e BusMstSel, 
                        INOUT struct businput_t* BusInput, 
                        INOUT struct busoutput_t* BusOutput, 
                        INOUT struct cmd_type01_t* BusData,
                        IN INT32 Timeout)
{
    INT32 Status = ERROR;
    struct cmd_type01_t InputBusData;
    
    switch (BusOperation)
    {
    case BUSCMD_WRITE:
    {   
        memcpy(&InputBusData, BusData, sizeof(struct cmd_type01_t));
        
        Status = bus_set_byte_(BusOutput->BusIoStartAddr + 80, InputBusData.Byte01);
        CHECK_RESULT(Status);
        Status = bus_set_byte_(BusOutput->BusIoStartAddr + 90, InputBusData.Byte02);
        CHECK_RESULT(Status);
        Status = bus_set_int16_(BusOutput->BusIoStartAddr + 100, InputBusData.Short03);
        CHECK_RESULT(Status);
        Status = bus_set_int16_(BusOutput->BusIoStartAddr + 120, InputBusData.Short04);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 140, InputBusData.Int05);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 180, InputBusData.Int06);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 220, InputBusData.Float07);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 260, InputBusData.Float08);
        CHECK_RESULT(Status);
        Status = bus_command_wo__(BUS_CMD026, BusMstSel, BusInput, BusOutput);
        break;
    }
    case BUSCMD_READ:
    {   
        memset(BusData, CLEAR, sizeof(struct cmd_type01_t));
        Status = bus_command_ro__(BUS_CMD026, BusMstSel, BusInput, BusOutput, Timeout);
        CHECK_RESULT(Status);
        Status = bus_get_byte_(BusInput->BusIoStartAddr + 80, &BusData->Byte01);
        CHECK_RESULT(Status);
        Status = bus_get_byte_(BusInput->BusIoStartAddr + 90, &BusData->Byte02);
        CHECK_RESULT(Status);
        Status = bus_get_int16_(BusInput->BusIoStartAddr + 100, &BusData->Short03);
        CHECK_RESULT(Status);
        Status = bus_get_int16_(BusInput->BusIoStartAddr + 120, &BusData->Short04);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 140, &BusData->Int05);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 180, &BusData->Int06);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 220, &BusData->Float07);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 260, &BusData->Float08);
        CHECK_RESULT(Status);

        break;
    }
    }

    return(Status);
}

STATUS bus_command027_( IN enum bus_command_rw_e BusOperation, 
                        IN enum bus_command_ms_e BusMstSel, 
                        INOUT struct businput_t* BusInput, 
                        INOUT struct busoutput_t* BusOutput, 
                        INOUT struct cmd_type08_t* BusData,
                        IN INT32 Timeout)
{
    INT32 Status = ERROR;
    struct cmd_type08_t InputBusData;

    switch (BusOperation)
    {
    case BUSCMD_WRITE:
    {   
        memcpy(&InputBusData, BusData, sizeof(struct cmd_type08_t));

        Status = bus_set_byte_(BusOutput->BusIoStartAddr + 80, InputBusData.Byte01);
        CHECK_RESULT(Status);
        Status = bus_set_byte_(BusOutput->BusIoStartAddr + 90, InputBusData.Byte02);
        CHECK_RESULT(Status);
        Status = bus_set_byte_(BusOutput->BusIoStartAddr + 100, InputBusData.Byte03);
        CHECK_RESULT(Status);
        Status = bus_set_byte_(BusOutput->BusIoStartAddr + 110, InputBusData.Byte04);
        CHECK_RESULT(Status);
        Status = bus_set_int16_(BusOutput->BusIoStartAddr + 120, InputBusData.Short05);
        CHECK_RESULT(Status);
        Status = bus_set_int16_(BusOutput->BusIoStartAddr + 140, InputBusData.Short06);
        CHECK_RESULT(Status);
        Status = bus_set_int16_(BusOutput->BusIoStartAddr + 160, InputBusData.Short07);
        CHECK_RESULT(Status);
        Status = bus_set_int16_(BusOutput->BusIoStartAddr + 180, InputBusData.Short08);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 200, InputBusData.Int09);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 240, InputBusData.Int10);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 280, InputBusData.Int11);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 320, InputBusData.Int12);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 360, InputBusData.Float13);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 400, InputBusData.Float14);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 440, InputBusData.Float15);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 480, InputBusData.Float16);
        CHECK_RESULT(Status);
        Status = bus_command_wo__(BUS_CMD027, BusMstSel, BusInput, BusOutput);
        break;
    }
    case BUSCMD_READ:
    {   
        memset(BusData, CLEAR, sizeof(struct cmd_type08_t));
        Status = bus_command_ro__(BUS_CMD027, BusMstSel, BusInput, BusOutput, Timeout);
        CHECK_RESULT(Status);
        Status = bus_get_byte_(BusInput->BusIoStartAddr + 80, &BusData->Byte01);
        CHECK_RESULT(Status);
        Status = bus_get_byte_(BusInput->BusIoStartAddr + 90, &BusData->Byte02);
        CHECK_RESULT(Status);
        Status = bus_get_byte_(BusInput->BusIoStartAddr + 100, &BusData->Byte01);
        CHECK_RESULT(Status);
        Status = bus_get_byte_(BusInput->BusIoStartAddr + 110, &BusData->Byte02);
        CHECK_RESULT(Status);
        Status = bus_get_int16_(BusInput->BusIoStartAddr + 120, &BusData->Short05);
        CHECK_RESULT(Status);
        Status = bus_get_int16_(BusInput->BusIoStartAddr + 140, &BusData->Short06);
        CHECK_RESULT(Status);
        Status = bus_get_int16_(BusInput->BusIoStartAddr + 160, &BusData->Short07);
        CHECK_RESULT(Status);
        Status = bus_get_int16_(BusInput->BusIoStartAddr + 180, &BusData->Short08);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 200, &BusData->Int09);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 240, &BusData->Int10);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 280, &BusData->Int11);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 320, &BusData->Int12);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 360, &BusData->Float13);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 400, &BusData->Float14);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 440, &BusData->Float15);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 480, &BusData->Float16);
        CHECK_RESULT(Status);

        break;
    }
    }

    return(Status);
}

STATUS bus_command129_( IN enum bus_command_rw_e BusOperation, 
                        IN enum bus_command_ms_e BusMstSel, 
                        INOUT struct businput_t* BusInput, 
                        INOUT struct busoutput_t* BusOutput, 
                        INOUT MP_COORD* BusData,
                        IN INT32 Timeout)
{
    INT32 Status = ERROR;
    MP_COORD InputBusData;

    switch (BusOperation)
    {
    case BUSCMD_WRITE:
    {   
        memcpy(&InputBusData, BusData, sizeof(MP_COORD));
        Status = bus_set_cartpos_(BusOutput->BusIoStartAddr + 80, InputBusData, 6);
        CHECK_RESULT(Status);
        Status = bus_command_wo__(BUS_CMD129, BusMstSel, BusInput, BusOutput);
        break;
    }
    case BUSCMD_READ:
    {   
        memset(BusData, CLEAR, sizeof(MP_COORD));
        Status = bus_command_ro__(BUS_CMD129, BusMstSel, BusInput, BusOutput, Timeout);
        CHECK_RESULT(Status);
        Status = bus_get_cartpos_(BusInput->BusIoStartAddr + 80, BusData, 6);
        CHECK_RESULT(Status);
        break;
    }
    }

    return(Status);
}

STATUS bus_command130_( IN enum bus_command_rw_e BusOperation, 
                        IN enum bus_command_ms_e BusMstSel, 
                        INOUT struct businput_t* BusInput, 
                        INOUT struct busoutput_t* BusOutput, 
                        INOUT MP_JOINT* BusData,
                        IN INT32 Timeout)
{
    INT32 Status = ERROR;
    MP_JOINT InputBusData;

    switch (BusOperation)
    {
    case BUSCMD_WRITE:
    {   
        memcpy(&InputBusData, BusData, sizeof(MP_JOINT));
        Status = bus_set_jointpos_(BusOutput->BusIoStartAddr + 80, InputBusData, 6);
        CHECK_RESULT(Status);
        Status = bus_command_wo__(BUS_CMD130, BusMstSel, BusInput, BusOutput);
        break;
    }
    case BUSCMD_READ:
    {   
         memset(BusData, CLEAR, sizeof(MP_JOINT));
        Status = bus_command_ro__(BUS_CMD130, BusMstSel, BusInput, BusOutput, Timeout);
        CHECK_RESULT(Status);
        Status = bus_get_jointpos_(BusInput->BusIoStartAddr + 80, BusData, 6);
        CHECK_RESULT(Status);
        break;
    }
    }

    return(Status);
}

STATUS bus_command131_( IN enum bus_command_rw_e BusOperation, 
                        IN enum bus_command_ms_e BusMstSel, 
                        INOUT struct businput_t* BusInput, 
                        INOUT struct busoutput_t* BusOutput, 
                        INOUT cmd_type02_t* BusData,
                        IN INT32 Timeout)
{
    INT32 Status = ERROR;
    cmd_type02_t InputBusData;
    INT32 I;

    switch (BusOperation)
    {
    case BUSCMD_WRITE:
    {   
        memcpy(&InputBusData, BusData, sizeof(cmd_type02_t));

        for (I = 0; I < 6; I++)
        {
            Status = bus_set_float2_(BusOutput->BusIoStartAddr + 80 + I * 40, InputBusData[I]);
            CHECK_RESULT(Status);
        }

        Status = bus_command_wo__(BUS_CMD131, BusMstSel, BusInput, BusOutput);
        break;
    }
    case BUSCMD_READ:
    {   
        memset(BusData, CLEAR, sizeof(cmd_type02_t));
        Status = bus_command_ro__(BUS_CMD131, BusMstSel, BusInput, BusOutput, Timeout);
        CHECK_RESULT(Status);
        for (I = 0; I < 6; I++)
        {
            Status = bus_get_float2_(BusInput->BusIoStartAddr + 80 + I * 40, BusData[I]);
            CHECK_RESULT(Status);
        }
        break;
    }
    }

    return(Status);
}

STATUS bus_command132_( IN enum bus_command_rw_e BusOperation, 
                        IN enum bus_command_ms_e BusMstSel, 
                        INOUT struct businput_t* BusInput, 
                        INOUT struct busoutput_t* BusOutput, 
                        INOUT struct cmd_type07_t* BusData,
                        IN INT32 Timeout)
{
    INT32 Status = ERROR;
    struct cmd_type07_t InputBusData;

    switch (BusOperation)
    {
    case BUSCMD_WRITE:
    {   
        memcpy(&InputBusData, BusData, sizeof(struct cmd_type07_t));
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 80, InputBusData.Float01);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 120, InputBusData.Float02);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 160, InputBusData.Float03);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 200, InputBusData.Float04);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 240, InputBusData.Float05);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 280, InputBusData.Float06);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 320, InputBusData.Float07);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 360, InputBusData.Float08);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 400, InputBusData.Float09);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 440, InputBusData.Float10);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 480, InputBusData.Float11);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 520, InputBusData.Float12);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 560, InputBusData.Int13);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 600, InputBusData.Int14);
        CHECK_RESULT(Status);
        Status = set_io_value_(BusOutput->BusIoStartAddr + 3, 0);
        CHECK_RESULT(Status);
        Status = set_io_value_(BusOutput->BusIoStartAddr + 4, 0);
        CHECK_RESULT(Status);


        Status = bus_command_wo__(BUS_CMD132, BusMstSel, BusInput, BusOutput);
        break;
    }
    case BUSCMD_READ:
    {   
        memset(BusData, CLEAR, sizeof(struct cmd_type07_t));
        Status = bus_command_ro__(BUS_CMD132, BusMstSel, BusInput, BusOutput, Timeout);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 80, &BusData->Float01);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 120, &BusData->Float02);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 160, &BusData->Float03);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 200, &BusData->Float04);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 240, &BusData->Float05);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 280, &BusData->Float06);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 320, &BusData->Float07);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 360, &BusData->Float08);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 400, &BusData->Float09);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 440, &BusData->Float10);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 480, &BusData->Float11);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 520, &BusData->Float12);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 560, &BusData->Int13);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 600, &BusData->Int14);
        CHECK_RESULT(Status);
        break;
    }
    }

    return(Status);
}


STATUS bus_command133_( IN enum bus_command_rw_e BusOperation, 
                        IN enum bus_command_ms_e BusMstSel, 
                        INOUT struct businput_t* BusInput, 
                        INOUT struct busoutput_t* BusOutput, 
                        INOUT struct cmd_type07_t* BusData,
                        IN INT32 Timeout)
{
    INT32 Status = ERROR;
    struct cmd_type07_t InputBusData;

    switch (BusOperation)
    {
    case BUSCMD_WRITE:
    {   
        memcpy(&InputBusData, BusData, sizeof(struct cmd_type07_t));
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 80, InputBusData.Float01);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 120, InputBusData.Float02);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 160, InputBusData.Float03);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 200, InputBusData.Float04);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 240, InputBusData.Float05);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 280, InputBusData.Float06);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 320, InputBusData.Float07);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 360, InputBusData.Float08);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 400, InputBusData.Float09);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 440, InputBusData.Float10);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 480, InputBusData.Float11);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 520, InputBusData.Float12);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 560, InputBusData.Int13);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 600, InputBusData.Int14);
        CHECK_RESULT(Status);
        Status = set_io_value_(BusOutput->BusIoStartAddr + 3, 0);
        CHECK_RESULT(Status);
        Status = set_io_value_(BusOutput->BusIoStartAddr + 4, 0);
        CHECK_RESULT(Status);


        Status = bus_command_wo__(BUS_CMD133, BusMstSel, BusInput, BusOutput);
        break;
    }
    case BUSCMD_READ:
    {   
        memset(BusData, CLEAR, sizeof(struct cmd_type07_t));
        Status = bus_command_ro__(BUS_CMD133, BusMstSel, BusInput, BusOutput, Timeout);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 80, &BusData->Float01);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 120, &BusData->Float02);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 160, &BusData->Float03);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 200, &BusData->Float04);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 240, &BusData->Float05);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 280, &BusData->Float06);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 320, &BusData->Float07);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 360, &BusData->Float08);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 400, &BusData->Float09);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 440, &BusData->Float10);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 480, &BusData->Float11);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 520, &BusData->Float12);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 560, &BusData->Int13);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 600, &BusData->Int14);
        CHECK_RESULT(Status);
        break;
    }
    }

    return(Status);
}

STATUS bus_command134_( IN enum bus_command_rw_e BusOperation, 
                        IN enum bus_command_ms_e BusMstSel, 
                        INOUT struct businput_t* BusInput, 
                        INOUT struct busoutput_t* BusOutput, 
                        INOUT struct cmd_type09_t* BusData,
                        IN INT32 Timeout)
{
    INT32 Status = ERROR;
    struct cmd_type09_t InputBusData;

    switch (BusOperation)
    {
    case BUSCMD_WRITE:
    {   
        memcpy(&InputBusData, BusData, sizeof(struct cmd_type09_t));
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 80, InputBusData.Int01);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 120, InputBusData.Int02);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 160, InputBusData.Float03);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 200, InputBusData.Float04);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 240, InputBusData.Float05);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 280, InputBusData.Float06);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 320, InputBusData.Float07);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 360, InputBusData.Float08);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 400, InputBusData.Float09);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 440, InputBusData.Float10);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 480, InputBusData.Float11);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 520, InputBusData.Float12);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 560, InputBusData.Float13);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 600, InputBusData.Float14);
        CHECK_RESULT(Status);
        Status = set_io_value_(BusOutput->BusIoStartAddr + 3, 0);
        CHECK_RESULT(Status);
        Status = set_io_value_(BusOutput->BusIoStartAddr + 4, 0);
        CHECK_RESULT(Status);


        Status = bus_command_wo__(BUS_CMD134, BusMstSel, BusInput, BusOutput);
        break;
    }
    case BUSCMD_READ:
    {   
        memset(BusData, CLEAR, sizeof(struct cmd_type09_t));
        Status = bus_command_ro__(BUS_CMD134, BusMstSel, BusInput, BusOutput, Timeout);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 80, &BusData->Int01);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 120, &BusData->Int02);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 160, &BusData->Float03);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 200, &BusData->Float04);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 240, &BusData->Float05);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 280, &BusData->Float06);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 320, &BusData->Float07);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 360, &BusData->Float08);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 400, &BusData->Float09);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 440, &BusData->Float10);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 480, &BusData->Float11);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 520, &BusData->Float12);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 560, &BusData->Float13);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 600, &BusData->Float14);
        CHECK_RESULT(Status);
        break;
    }
    }

    return(Status);
}

STATUS bus_command137_( IN enum bus_command_rw_e BusOperation, 
                        IN enum bus_command_ms_e BusMstSel, 
                        INOUT struct businput_t* BusInput, 
                        INOUT struct busoutput_t* BusOutput, 
                        INOUT cmd_type03_t* BusData,
                        IN INT32 Timeout)
{
    INT32 Status = ERROR;
    cmd_type03_t InputBusData;
    INT32 I;

    switch (BusOperation)
    {
    case BUSCMD_WRITE:
    {   
        memcpy(&InputBusData, BusData, sizeof(cmd_type03_t));

        for (I = 0; I < sizeof(cmd_type03_t); I++)
        {
            Status = bus_set_byte_(BusOutput->BusIoStartAddr + 80 + I * 10, InputBusData[I]);
            CHECK_RESULT(Status);
        }

        Status = bus_command_wo__(BUS_CMD137, BusMstSel, BusInput, BusOutput);
        break;
    }
    case BUSCMD_READ:
    {   
        memset(BusData, CLEAR, sizeof(cmd_type03_t));
        Status = bus_command_ro__(BUS_CMD137, BusMstSel, BusInput, BusOutput, Timeout);
        CHECK_RESULT(Status);
        for (I = 0; I < sizeof(cmd_type03_t); I++)
        {
            Status = bus_get_byte_(BusInput->BusIoStartAddr + 80 + I * 10, BusData[I]);
            CHECK_RESULT(Status);
        }
        break;
    }
    }

    return(Status);
}

STATUS bus_command145_( IN enum bus_command_rw_e BusOperation, 
                        IN enum bus_command_ms_e BusMstSel, 
                        INOUT struct businput_t* BusInput, 
                        INOUT struct busoutput_t* BusOutput, 
                        INOUT struct cmd_type01_t* BusData,
                        IN INT32 Timeout)
{
    INT32 Status = ERROR;
    struct cmd_type01_t InputBusData;

    switch (BusOperation)
    {
    case BUSCMD_WRITE:
    {   
        memcpy(&InputBusData, BusData, sizeof(struct cmd_type01_t));

        Status = bus_set_byte_(BusOutput->BusIoStartAddr + 80, InputBusData.Byte01);
        CHECK_RESULT(Status);
        Status = bus_set_byte_(BusOutput->BusIoStartAddr + 90, InputBusData.Byte02);
        CHECK_RESULT(Status);
        Status = bus_set_int16_(BusOutput->BusIoStartAddr + 100, InputBusData.Short03);
        CHECK_RESULT(Status);
        Status = bus_set_int16_(BusOutput->BusIoStartAddr + 120, InputBusData.Short04);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 140, InputBusData.Int05);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 180, InputBusData.Int06);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 220, InputBusData.Float07);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 260, InputBusData.Float08);
        CHECK_RESULT(Status);
        Status = bus_command_wo__(BUS_CMD145, BusMstSel, BusInput, BusOutput);
        break;
    }
    case BUSCMD_READ:
    {   
        memset(BusData, CLEAR, sizeof(struct cmd_type01_t));
        Status = bus_command_ro__(BUS_CMD145, BusMstSel, BusInput, BusOutput, Timeout);
        CHECK_RESULT(Status);
        Status = bus_get_byte_(BusInput->BusIoStartAddr + 80, &BusData->Byte01);
        CHECK_RESULT(Status);
        Status = bus_get_byte_(BusInput->BusIoStartAddr + 90, &BusData->Byte02);
        CHECK_RESULT(Status);
        Status = bus_get_int16_(BusInput->BusIoStartAddr + 100, &BusData->Short03);
        CHECK_RESULT(Status);
        Status = bus_get_int16_(BusInput->BusIoStartAddr + 120, &BusData->Short04);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 140, &BusData->Int05);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 180, &BusData->Int06);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 220, &BusData->Float07);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 260, &BusData->Float08);
        CHECK_RESULT(Status);

        break;
    }
    }

    return(Status);
}

STATUS bus_command148_( IN enum bus_command_rw_e BusOperation, 
                        IN enum bus_command_ms_e BusMstSel, 
                        INOUT struct businput_t* BusInput, 
                        INOUT struct busoutput_t* BusOutput, 
                        INOUT struct cmd_type08_t* BusData,
                        IN INT32 Timeout)
{
    INT32 Status = ERROR;
    struct cmd_type08_t InputBusData;

    switch (BusOperation)
    {
    case BUSCMD_WRITE:
    {   
        memcpy(&InputBusData, BusData, sizeof(struct cmd_type08_t));

        Status = bus_set_byte_(BusOutput->BusIoStartAddr + 80, InputBusData.Byte01);
        CHECK_RESULT(Status);
        Status = bus_set_byte_(BusOutput->BusIoStartAddr + 90, InputBusData.Byte02);
        CHECK_RESULT(Status);
        Status = bus_set_byte_(BusOutput->BusIoStartAddr + 100, InputBusData.Byte03);
        CHECK_RESULT(Status);
        Status = bus_set_byte_(BusOutput->BusIoStartAddr + 110, InputBusData.Byte04);
        CHECK_RESULT(Status);
        Status = bus_set_int16_(BusOutput->BusIoStartAddr + 120, InputBusData.Short05);
        CHECK_RESULT(Status);
        Status = bus_set_int16_(BusOutput->BusIoStartAddr + 140, InputBusData.Short06);
        CHECK_RESULT(Status);
        Status = bus_set_int16_(BusOutput->BusIoStartAddr + 160, InputBusData.Short07);
        CHECK_RESULT(Status);
        Status = bus_set_int16_(BusOutput->BusIoStartAddr + 180, InputBusData.Short08);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 200, InputBusData.Int09);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 240, InputBusData.Int10);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 280, InputBusData.Int11);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 320, InputBusData.Int12);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 360, InputBusData.Float13);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 400, InputBusData.Float14);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 440, InputBusData.Float15);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 480, InputBusData.Float16);
        CHECK_RESULT(Status);
        Status = bus_command_wo__(BUS_CMD148, BusMstSel, BusInput, BusOutput);
        break;
    }
    case BUSCMD_READ:
    {   
        memset(BusData, CLEAR, sizeof(struct cmd_type08_t));
        Status = bus_command_ro__(BUS_CMD148, BusMstSel, BusInput, BusOutput, Timeout);
        CHECK_RESULT(Status);
        Status = bus_get_byte_(BusInput->BusIoStartAddr + 80, &BusData->Byte01);
        CHECK_RESULT(Status);
        Status = bus_get_byte_(BusInput->BusIoStartAddr + 90, &BusData->Byte02);
        CHECK_RESULT(Status);
        Status = bus_get_byte_(BusInput->BusIoStartAddr + 100, &BusData->Byte01);
        CHECK_RESULT(Status);
        Status = bus_get_byte_(BusInput->BusIoStartAddr + 110, &BusData->Byte02);
        CHECK_RESULT(Status);
        Status = bus_get_int16_(BusInput->BusIoStartAddr + 120, &BusData->Short05);
        CHECK_RESULT(Status);
        Status = bus_get_int16_(BusInput->BusIoStartAddr + 140, &BusData->Short06);
        CHECK_RESULT(Status);
        Status = bus_get_int16_(BusInput->BusIoStartAddr + 160, &BusData->Short07);
        CHECK_RESULT(Status);
        Status = bus_get_int16_(BusInput->BusIoStartAddr + 180, &BusData->Short08);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 200, &BusData->Int09);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 240, &BusData->Int10);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 280, &BusData->Int11);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 320, &BusData->Int12);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 360, &BusData->Float13);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 400, &BusData->Float14);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 440, &BusData->Float15);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 480, &BusData->Float16);
        CHECK_RESULT(Status);

        break;
    }
    }

    return(Status);
}

STATUS bus_command151_( IN enum bus_command_rw_e BusOperation, 
                        IN enum bus_command_ms_e BusMstSel, 
                        INOUT struct businput_t* BusInput, 
                        INOUT struct busoutput_t* BusOutput, 
                        INOUT struct cmd_type06_t* BusData,
                        IN INT32 Timeout)
{
    INT32 Status = ERROR;
    struct cmd_type06_t InputBusData;

    switch (BusOperation)
    {
    case BUSCMD_WRITE:
    {   
        memcpy(&InputBusData, BusData, sizeof(struct cmd_type06_t));

        Status = bus_set_byte_(BusOutput->BusIoStartAddr + 80, InputBusData.Byte01);
        CHECK_RESULT(Status);
        Status = bus_set_int16_(BusOutput->BusIoStartAddr + 90, InputBusData.Short02);
        CHECK_RESULT(Status);
        Status = bus_set_int16_(BusOutput->BusIoStartAddr + 110, InputBusData.Short03);
        CHECK_RESULT(Status);
        Status = bus_set_int16_(BusOutput->BusIoStartAddr + 130, InputBusData.Short04);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 150, InputBusData.Float05);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 190, InputBusData.Float06);
        CHECK_RESULT(Status);
        Status = bus_command_wo__(BUS_CMD151, BusMstSel, BusInput, BusOutput);
        break;
    }
    case BUSCMD_READ:
    {   
        memset(BusData, CLEAR, sizeof(struct cmd_type06_t));
        Status = bus_command_ro__(BUS_CMD151, BusMstSel, BusInput, BusOutput, Timeout);
        CHECK_RESULT(Status);
        Status = bus_get_byte_(BusInput->BusIoStartAddr + 80, &BusData->Byte01);
        CHECK_RESULT(Status);
        Status = bus_get_int16_(BusInput->BusIoStartAddr + 90, &BusData->Short02);
        CHECK_RESULT(Status);
        Status = bus_get_int16_(BusInput->BusIoStartAddr + 110, &BusData->Short03);
        CHECK_RESULT(Status);
        Status = bus_get_int16_(BusInput->BusIoStartAddr + 130, &BusData->Short04);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 150, &BusData->Float05);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 190, &BusData->Float06);
        CHECK_RESULT(Status);

        break;
    }
    }

    return(Status);
}

STATUS bus_command254_( IN enum bus_command_rw_e BusOperation, 
                        IN enum bus_command_ms_e BusMstSel, 
                        INOUT struct businput_t* BusInput, 
                        INOUT struct busoutput_t* BusOutput, 
                        INOUT struct cmd_type07_t* BusData,
                        IN INT32 Timeout)
{
    INT32 Status = ERROR;
    struct cmd_type07_t InputBusData;

    switch (BusOperation)
    {
    case BUSCMD_WRITE:
    {   
        memcpy(&InputBusData, BusData, sizeof(struct cmd_type07_t));
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 80, InputBusData.Float01);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 120, InputBusData.Float02);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 160, InputBusData.Float03);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 200, InputBusData.Float04);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 240, InputBusData.Float05);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 280, InputBusData.Float06);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 320, InputBusData.Float07);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 360, InputBusData.Float08);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 400, InputBusData.Float09);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 440, InputBusData.Float10);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 480, InputBusData.Float11);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 520, InputBusData.Float12);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 560, InputBusData.Int13);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 600, InputBusData.Int14);
        CHECK_RESULT(Status);

        if (!get_io_value_(BusOutput->BusIoStartAddr + 3) && !get_io_value_(BusOutput->BusIoStartAddr + 4))
        {
            Status = set_io_value_(BusOutput->BusIoStartAddr + 3, 1);
            CHECK_RESULT(Status);
            Status = set_io_value_(BusOutput->BusIoStartAddr + 4, 0);
            CHECK_RESULT(Status);
        }
        else
        {
            Status = set_io_value_(BusOutput->BusIoStartAddr + 3, !get_io_value_(BusOutput->BusIoStartAddr + 3));
            CHECK_RESULT(Status);
            Status = set_io_value_(BusOutput->BusIoStartAddr + 4, !get_io_value_(BusOutput->BusIoStartAddr + 4));
            CHECK_RESULT(Status);
        }

        FOREVER
        {

            if (get_io_value_(BusOutput->BusIoStartAddr + 3) == get_io_value_(BusInput->BusIoStartAddr + 3) &&
                get_io_value_(BusOutput->BusIoStartAddr + 4) == get_io_value_(BusInput->BusIoStartAddr + 4))

                break;

            mpClkAnnounce(MP_IO_CLK);
        }
        break;
    }
    case BUSCMD_READ:
    {   

        FOREVER
        {

            if (get_io_value_(BusOutput->BusIoStartAddr + 5) && !get_io_value_(BusOutput->BusIoStartAddr + 5))
            {    
                if (!get_io_value_(BusInput->BusIoStartAddr + 5) && get_io_value_(BusInput->BusIoStartAddr + 6))
                    break;
            }
            else
            {
                if (get_io_value_(BusInput->BusIoStartAddr + 5) && !get_io_value_(BusInput->BusIoStartAddr + 6))
                    break;
            }  
            mpClkAnnounce(MP_IO_CLK);
        }

        Status = bus_get_float2_(BusInput->BusIoStartAddr + 80, &BusData->Float01);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 120, &BusData->Float02);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 160, &BusData->Float03);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 200, &BusData->Float04);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 240, &BusData->Float05);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 280, &BusData->Float06);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 320, &BusData->Float07);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 360, &BusData->Float08);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 400, &BusData->Float09);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 440, &BusData->Float10);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 480, &BusData->Float11);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 520, &BusData->Float12);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 560, &BusData->Int13);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 600, &BusData->Int14);
        CHECK_RESULT(Status);

        Status = set_io_value_(BusOutput->BusIoStartAddr + 5, get_io_value_(BusOutput->BusIoStartAddr + 5));
        CHECK_RESULT(Status);
        Status = set_io_value_(BusOutput->BusIoStartAddr + 6, get_io_value_(BusOutput->BusIoStartAddr + 6));
        CHECK_RESULT(Status);

        break;
    }
    }

    return(Status);
}

STATUS bus_command255_( IN enum bus_command_rw_e BusOperation, 
                        IN enum bus_command_ms_e BusMstSel, 
                        INOUT struct businput_t* BusInput, 
                        INOUT struct busoutput_t* BusOutput, 
                        INOUT struct cmd_type07_t* BusData,
                        IN INT32 Timeout)
{
    INT32 Status = ERROR;
    struct cmd_type07_t InputBusData;

    switch (BusOperation)
    {
    case BUSCMD_WRITE:
    {   
        memcpy(&InputBusData, BusData, sizeof(struct cmd_type07_t));
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 80, InputBusData.Float01);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 120, InputBusData.Float02);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 160, InputBusData.Float03);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 200, InputBusData.Float04);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 240, InputBusData.Float05);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 280, InputBusData.Float06);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 320, InputBusData.Float07);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 360, InputBusData.Float08);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 400, InputBusData.Float09);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 440, InputBusData.Float10);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 480, InputBusData.Float11);
        CHECK_RESULT(Status);
        Status = bus_set_float2_(BusOutput->BusIoStartAddr + 520, InputBusData.Float12);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 560, InputBusData.Int13);
        CHECK_RESULT(Status);
        Status = bus_set_int32_(BusOutput->BusIoStartAddr + 600, InputBusData.Int14);
        CHECK_RESULT(Status);
        Status = set_io_value_(BusOutput->BusIoStartAddr + 3, 0);
        CHECK_RESULT(Status);
        Status = set_io_value_(BusOutput->BusIoStartAddr + 4, 0);
        CHECK_RESULT(Status);

        if (!get_io_value_(BusOutput->BusIoStartAddr + 3) && !get_io_value_(BusOutput->BusIoStartAddr + 4))
        {
            Status = set_io_value_(BusOutput->BusIoStartAddr + 3, 1);
            CHECK_RESULT(Status);
            Status = set_io_value_(BusOutput->BusIoStartAddr + 4, 0);
            CHECK_RESULT(Status);
        }
        else
        {
            Status = set_io_value_(BusOutput->BusIoStartAddr + 3, !get_io_value_(BusOutput->BusIoStartAddr + 3));
            CHECK_RESULT(Status);
            Status = set_io_value_(BusOutput->BusIoStartAddr + 4, !get_io_value_(BusOutput->BusIoStartAddr + 4));
            CHECK_RESULT(Status);
        }

    break;
    }
    case BUSCMD_READ:
    {   
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 80, &BusData->Float01);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 120, &BusData->Float02);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 160, &BusData->Float03);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 200, &BusData->Float04);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 240, &BusData->Float05);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 280, &BusData->Float06);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 320, &BusData->Float07);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 360, &BusData->Float08);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 400, &BusData->Float09);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 440, &BusData->Float10);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 480, &BusData->Float11);
        CHECK_RESULT(Status);
        Status = bus_get_float2_(BusInput->BusIoStartAddr + 520, &BusData->Float12);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 560, &BusData->Int13);
        CHECK_RESULT(Status);
        Status = bus_get_int32_(BusInput->BusIoStartAddr + 600, &BusData->Int14);
        CHECK_RESULT(Status);
        break;
    }
    }

    return(Status);
}
