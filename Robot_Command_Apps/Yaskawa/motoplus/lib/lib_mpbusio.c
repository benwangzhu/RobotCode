/***********************************************************

Copyright 2018 - 2025 speedbot All Rights reserved.

file Name: lib_mpbusio.c

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
#include "lib_mpbusio.h"
#include "lib_mptp_if.h"

STATUS bus_set_byte_(IN UINT32 StartPortAddr, IN UINT8 Value) 
{
	MP_IO_DATA IoData[8];
    INT32 Status;
    INT32 I;

    for(I = 0; I < 8; I++)
	{
        IoData[I].ulAddr = StartPortAddr + I;
        IoData[I].ulValue = (Value & (0x01<<I)) == (0x01<<I) ? 1 : 0;
    }

    Status = mpWriteIO(IoData, 8);
	CHECK_RESULT(Status);
    return(OK);
}

STATUS bus_set_int16_(IN UINT32 StartPortAddr, IN INT16 Value) 
{
    INT32 Status;

    Status = bus_set_byte_(StartPortAddr + 0, (UINT8)Value);
	CHECK_RESULT(Status);

    Status = bus_set_byte_(StartPortAddr + 10, (UINT8)(Value >> 8));
	CHECK_RESULT(Status);

    return(OK);
}

STATUS bus_set_uint16_(IN UINT32 StartPortAddr, IN UINT16 Value) 
{
    INT32 Status;

    Status = bus_set_byte_(StartPortAddr + 0, (UINT8)Value);
	CHECK_RESULT(Status);

    Status = bus_set_byte_(StartPortAddr + 10, (UINT8)(Value >> 8));
	CHECK_RESULT(Status);

    return(OK);
}

STATUS bus_set_int32_(IN UINT32 StartPortAddr, IN INT32 Value) 
{
    INT32 Status;

    Status = bus_set_byte_(StartPortAddr + 0, (UINT8)Value);
	CHECK_RESULT(Status);

    Status = bus_set_byte_(StartPortAddr + 10, (UINT8)(Value >> 8));
	CHECK_RESULT(Status);

    Status = bus_set_byte_(StartPortAddr + 20, (UINT8)(Value >> 16));
	CHECK_RESULT(Status);

    Status = bus_set_byte_(StartPortAddr + 30, (UINT8)(Value >> 24));
	CHECK_RESULT(Status);

    return(OK);
}

STATUS bus_set_float2_(IN UINT32 StartPortAddr, IN FLOAT Value) 
{
    INT32 Status;

    INT16 IntVal = (INT16)Value;
    INT16 DecVal = (INT16)(fmod(Value, 1.0) * 10000.0);

    Status = bus_set_int16_(StartPortAddr + 0, IntVal);
	CHECK_RESULT(Status);
    
    Status = bus_set_int16_(StartPortAddr + 20, DecVal);
	CHECK_RESULT(Status);
    
    return(OK);
}

STATUS bus_set_jointpos_(IN UINT32 StartPortAddr, IN const MP_JOINT Value, IN UINT32 NumOfAxis) 
{
    INT32 Status;
    INT32 I;

    if ((NumOfAxis > 8) || (NumOfAxis <= 0))
    {
    	DEBUG_ERROR("bus_set_jointpos_ Error[Index:%d, Status:%d]", StartPortAddr, Status);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "bus_set_jointpos_ Error[Index:%d, Status:%d]", StartPortAddr, Status);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
        return(ERROR);
    }

    for(I = 0; I < NumOfAxis; I++)
    {
        Status = bus_set_float2_(StartPortAddr + (I * 40), (FLOAT)(Value[I] / 10000.0));
    	CHECK_RESULT(Status);
    }

    return(OK);
}

STATUS bus_set_cartpos_(IN UINT32 StartPortAddr, IN MP_COORD Value, IN UINT32 NumOfAxis) 
{
    INT32 Status;
    INT32 I;
    FLOAT PosDataFloat[8] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
    LONG PosDataLong[8] = {0, 0, 0, 0, 0, 0, 0, 0};

    memcpy(PosDataLong, &Value, sizeof(MP_COORD));

    PosDataFloat[0] = (FLOAT)(PosDataLong[0] / 1000.0);
    PosDataFloat[1] = (FLOAT)(PosDataLong[1] / 1000.0);
    PosDataFloat[2] = (FLOAT)(PosDataLong[2] / 1000.0);
    PosDataFloat[3] = (FLOAT)(PosDataLong[3] / 10000.0);
    PosDataFloat[4] = (FLOAT)(PosDataLong[4] / 10000.0);
    PosDataFloat[5] = (FLOAT)(PosDataLong[5] / 10000.0);
    PosDataFloat[6] = (FLOAT)(PosDataLong[6] / 1000.0);
    PosDataFloat[7] = (FLOAT)(PosDataLong[7] / 1000.0);

    if ((NumOfAxis > 8) || (NumOfAxis <= 0))
    {
    	DEBUG_ERROR("bus_set_cartpos_ Error[NumOfAxis:%d]", NumOfAxis);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "bus_set_cartpos_ Error[NumOfAxis:%d]", NumOfAxis);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
        return(ERROR);
    }

    for(I = 0; I < NumOfAxis; I++)
    {
        Status = bus_set_float2_(StartPortAddr + (I * 40), PosDataFloat[I]);
        if (Status != OK)
    	CHECK_RESULT(Status);
    }

    return(OK);
}

STATUS bus_get_byte_(IN UINT32 StartPortAddr, OUT UINT8* Value) 
{
	MP_IO_INFO Info[8];
	USHORT Signal[8];
    INT32 Status;
    INT32 I;

    for(I = 0; I < 8; I++)
    {
	    Info[I].ulAddr = StartPortAddr + I;
    }

    Status = mpReadIO(Info, Signal, 8);
	CHECK_RESULT(Status);

    *Value = Signal[0]|(Signal[1]<<1)|(Signal[2]<<2)|(Signal[3]<<3)|(Signal[4]<<4)|(Signal[5]<<5)|(Signal[6]<<6)|(Signal[7]<<7);

	return(OK);
}

STATUS bus_get_int16_(IN UINT32 StartPortAddr, OUT INT16* Value) 
{
    INT32 Status;
    UINT8 ByteValue[4] = {0, 0, 0, 0};
    INT32 I;

    for(I = 0; I < 2; I++)
    {
        Status = bus_get_byte_(StartPortAddr + I * 10, &ByteValue[I]);
    	CHECK_RESULT(Status);      
    }
    
    *Value = (INT16)((ByteValue[1] << 8) | ByteValue[0]);

	return(OK);
}

STATUS bus_get_uint16_(IN UINT32 StartPortAddr, OUT UINT16* Value) 
{
    INT32 Status;
    UINT8 ByteValue[4] = {0, 0, 0, 0};
    INT32 I;

    for(I = 0; I < 2; I++)
    {
        Status = bus_get_byte_(StartPortAddr + I * 10, &ByteValue[I]);
    	CHECK_RESULT(Status);        
    }

    *Value = (UINT16)((ByteValue[1] << 8) | ByteValue[0]);

	return(OK);
}

STATUS bus_get_int32_(IN UINT32 StartPortAddr, OUT INT32* Value) 
{
    INT32 Status;
    UINT8 ByteValue[4] = {0, 0, 0, 0};
    INT32 I;

    for(I = 0; I < 4; I++)
    {
        Status = bus_get_byte_(StartPortAddr + I * 10, &ByteValue[I]);
    	if (Status != OK) 
    	CHECK_RESULT(Status);       
    }

    *Value = (INT32)((ByteValue[3] << 24) | (ByteValue[2] << 16) | (ByteValue[1] << 8) | ByteValue[0]);

	return(OK);
}

STATUS bus_get_float2_(IN UINT32 StartPortAddr, OUT FLOAT* Value) 
{
    INT32 Status;
    INT16 IntValue;
    INT16 DecValue;

    Status = bus_get_int16_(StartPortAddr, &IntValue);
	CHECK_RESULT(Status);

    Status = bus_get_int16_(StartPortAddr + 20, &DecValue);
	CHECK_RESULT(Status);

    *Value = (FLOAT)(IntValue + (DecValue / 10000.0));
	return(OK);
}

STATUS bus_get_jointpos_(IN UINT32 StartPortAddr, OUT MP_JOINT* Value, IN UINT32 NumOfAxis) 
{
    INT32 Status;
    INT32 I;
    FLOAT PosDataFloat[8] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
    LONG PosDataLong[8] = {0, 0, 0, 0, 0, 0, 0, 0};

    if ((NumOfAxis > 8) || (NumOfAxis <= 0))
    {
    	DEBUG_ERROR("bus_get_jointpos_ Error[NumOfAxis:%d]", NumOfAxis);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "bus_get_jointpos_ Error[NumOfAxis:%d]", NumOfAxis);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
        return(ERROR);
    }

    for(I = 0; I < NumOfAxis; I++)
    {
        Status = bus_get_float2_(StartPortAddr + (I * 40), &PosDataFloat[I]);
    	CHECK_RESULT(Status);

        PosDataLong[I] = (LONG)(PosDataFloat[I] * 10000.0);
    }

    memcpy(Value, PosDataLong, sizeof(MP_JOINT));

    return(OK);
}

STATUS bus_get_cartpos_(IN UINT32 StartPortAddr, OUT MP_COORD* Value, IN UINT32 NumOfAxis) 
{
    INT32 Status;
    INT32 I;
    FLOAT PosDataFloat[8] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
    LONG PosDataLong[8] = {0, 0, 0, 0, 0, 0, 0, 0};

    if ((NumOfAxis > 8) || (NumOfAxis <= 0))
    {
    	DEBUG_ERROR("bus_get_cartpos_ Error[NumOfAxis:%d]", NumOfAxis);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "bus_get_cartpos_ Error[NumOfAxis:%d]", NumOfAxis);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);
        return(ERROR);
    }

    for(I = 0; I < NumOfAxis; I++)
    {
        Status = bus_get_float2_(StartPortAddr + (I * 40), &PosDataFloat[I]);
    	CHECK_RESULT(Status);
    }

    PosDataLong[0] = (LONG)(PosDataFloat[0] * 1000.0);
    PosDataLong[1] = (LONG)(PosDataFloat[1] * 1000.0);
    PosDataLong[2] = (LONG)(PosDataFloat[2] * 1000.0);
    PosDataLong[3] = (LONG)(PosDataFloat[3] * 10000.0);
    PosDataLong[4] = (LONG)(PosDataFloat[4] * 10000.0);
    PosDataLong[5] = (LONG)(PosDataFloat[5] * 10000.0);
    PosDataLong[6] = (LONG)(PosDataFloat[6] * 1000.0);
    PosDataLong[7] = (LONG)(PosDataFloat[7] * 1000.0);

    memcpy(Value, PosDataLong, sizeof(MP_COORD));

    return(OK);
}

STATUS bus_update_input_(INOUT struct businput_t* BusInput) 
{   
	MP_IO_INFO Info[8];
	USHORT Signal[8];
    INT32 Status;
    INT32 I;

    for(I = 0; I < 8; I++)
    {
	    Info[I].ulAddr = BusInput->BusIoStartAddr + I;
    }

    Status = mpReadIO(Info, Signal, 8);
	CHECK_RESULT(Status);
    
    BusInput->SysReady          = Signal[0];
    BusInput->SysInitialized    = Signal[1];
    BusInput->StopMove          = Signal[2];
    BusInput->OnMeasure         = Signal[3];
    BusInput->MeasuerOver       = Signal[4];
    BusInput->ResultOk          = Signal[5];
    BusInput->ResultNG          = Signal[6];
    BusInput->Finished          = Signal[7];

    Status = bus_get_byte_(BusInput->BusIoStartAddr + 10, &BusInput->DeviceId);
	CHECK_RESULT(Status);

    Status = bus_get_byte_(BusInput->BusIoStartAddr + 20, &BusInput->JobId);
	CHECK_RESULT(Status);

    Status = bus_get_byte_(BusInput->BusIoStartAddr + 30, &BusInput->ErrorId);
	CHECK_RESULT(Status);

    Status = bus_get_byte_(BusInput->BusIoStartAddr + 40, &BusInput->AgentTellId);
	CHECK_RESULT(Status);

    Status = bus_get_byte_(BusInput->BusIoStartAddr + 50, &BusInput->AgentMsgType);
	CHECK_RESULT(Status);

    Status = bus_get_byte_(BusInput->BusIoStartAddr + 60, &BusInput->TellId);
	CHECK_RESULT(Status);

    Status = bus_get_byte_(BusInput->BusIoStartAddr + 70, &BusInput->MsgType);
	CHECK_RESULT(Status);

	DEBUG_INFO("BusInput[SysReady:%d, SysInitialized:%d, StopMove:%d, OnMeasure:%d, MeasuerOver:%d, ResultOk:%d, ResultNG:%d, Finished:%d]", 
                BusInput->SysReady, BusInput->SysInitialized, BusInput->StopMove, BusInput->OnMeasure, BusInput->MeasuerOver, BusInput->ResultOk, BusInput->ResultNG, BusInput->Finished);
	DEBUG_INFO("BusInput[DeviceId:%d, JobId:%d, ErrorId:%d, AgentTellId:%d, AgentMsgType:%d, TellId:%d, MsgType:%d]", 
                BusInput->DeviceId, BusInput->JobId, BusInput->ErrorId, BusInput->AgentTellId, BusInput->AgentMsgType, BusInput->TellId, BusInput->MsgType);

    return(OK);
}

STATUS bus_update_output_(INOUT struct busoutput_t* BusOutput) 
{   
	MP_IO_DATA IoData[8];
    INT32 Status;
    INT32 I;

    for(I = 0; I < 8; I++)
	{
        IoData[I].ulAddr = BusOutput->BusIoStartAddr + I;
    }

    IoData[0].ulValue = (ULONG)BusOutput->SysEnable;
    IoData[1].ulValue = (ULONG)BusOutput->SysInitialize;
    IoData[2].ulValue = (ULONG)BusOutput->RobotMoveing;
    IoData[3].ulValue = (ULONG)BusOutput->MeasureStart;
    IoData[4].ulValue = (ULONG)BusOutput->MeasuerStop;
    IoData[5].ulValue = (ULONG)BusOutput->Reserverd1;
    IoData[6].ulValue = (ULONG)BusOutput->Reserverd2;
    IoData[7].ulValue = (ULONG)BusOutput->CycleEnd;

    Status = mpWriteIO(IoData, 8);
	CHECK_RESULT(Status);
    
    Status = bus_set_byte_(BusOutput->BusIoStartAddr + 10, BusOutput->RobotId);
	CHECK_RESULT(Status);

    Status = bus_set_byte_(BusOutput->BusIoStartAddr + 20, BusOutput->JobId);
	CHECK_RESULT(Status);

    Status = bus_set_byte_(BusOutput->BusIoStartAddr + 30, BusOutput->ProtocolId);
	CHECK_RESULT(Status);

    Status = bus_set_byte_(BusOutput->BusIoStartAddr + 40, BusOutput->TellId);
	CHECK_RESULT(Status);

    Status = bus_set_byte_(BusOutput->BusIoStartAddr + 50, BusOutput->MsgType);
	CHECK_RESULT(Status);

    Status = bus_set_byte_(BusOutput->BusIoStartAddr + 60, BusOutput->RobTellId);
	CHECK_RESULT(Status);

    Status = bus_set_byte_(BusOutput->BusIoStartAddr + 70, BusOutput->RobMsgType);
	CHECK_RESULT(Status);

	DEBUG_INFO("BusOutput[SysEnable:%d, SysInitialize:%d, RobotMoveing:%d, MeasureStart:%d, MeasuerStop:%d, Reserverd1:%d, Reserverd2:%d, CycleEnd:%d]", 
                BusOutput->SysEnable, BusOutput->RobotMoveing, BusOutput->MeasureStart, BusOutput->MeasuerStop, BusOutput->Reserverd1, BusOutput->Reserverd2, BusOutput->CycleEnd);
	DEBUG_INFO("BusOutput[RobotId:%d, JobId:%d, ProtocolId:%d, TellId:%d, MsgType:%d, RobTellId:%d, RobMsgType:%d]", 
                BusOutput->RobotId, BusOutput->ProtocolId, BusOutput->TellId, BusOutput->MsgType, BusOutput->RobTellId, BusOutput->RobMsgType);
    
    return(OK);
}

STATUS bus_initialize_(INOUT struct businput_t* BusInput, INOUT struct busoutput_t *BusOutput, IN INT8 RobId, IN INT8 ProtId) 
{
    INT32 Status;

	DEBUG_INFO("Robot Id            = %d  ", RobId);
	DEBUG_INFO("Protocol Id         = %d  ", ProtId);

    if (get_io_value_(BusOutput->BusIoStartAddr + 1))
    {
        set_io_value_(BusOutput->BusIoStartAddr + 1, 0);

        mpTaskDelay(200);
    }
    
    BusOutput->SysEnable        = TRUE;
    BusOutput->SysInitialize    = TRUE;
    BusOutput->RobotMoveing     = FALSE;
    BusOutput->MeasureStart     = FALSE;
    BusOutput->MeasuerStop      = FALSE;
    BusOutput->Reserverd1       = FALSE;
    BusOutput->Reserverd2       = FALSE;
    BusOutput->CycleEnd         = FALSE;
    BusOutput->RobotId          = RobId;
    BusOutput->JobId            = 0;
    BusOutput->ProtocolId       = ProtId;
    BusOutput->RobTellId        = 0;

    // Code Modified on 2025.04.28
    // 不初始化 RobMsgType, 以免 lib_mpbusio_cmd 函数传参受到影响 
    //
    // BusOutput->RobMsgType       = 0;
    //

    Status = bus_update_output_(BusOutput);
	CHECK_RESULT(Status);

    mpTaskDelay(200);

    //if (!((BusOutput->ProtocolId == PTC_LN_PL) || (BusOutput->ProtocolId == PTC_ST_PK)))
    //{

        while (TRUE)
        {
            Status = bus_update_input_(BusInput);
            CHECK_RESULT(Status);
            if ((BusInput->TellId == 0) & (BusInput->SysInitialized))
            {
               break;
            }
            
            mpTaskDelay(100);
        }
    //}

    Status = bus_update_input_(BusInput);
	CHECK_RESULT(Status);

    BusOutput->SysInitialize    = FALSE;
    BusOutput->TellId           = BusInput->AgentTellId;
    BusOutput->MsgType          = BusInput->AgentMsgType;

    Status = bus_update_output_(BusOutput);
	CHECK_RESULT(Status);


    return(OK);
}

STATUS bus_wait_tell_(INOUT struct businput_t* BusInput, INOUT struct busoutput_t *BusOutput, IN INT32 Timeout)
{
    void* BusStopWatch;
    INT32 Status;
    UINT Timer;

	BusStopWatch = mpStopWatchCreate(100);
	mpStopWatchStop(BusStopWatch);
	mpStopWatchReset(BusStopWatch);
    mpStopWatchStart(BusStopWatch);
    FOREVER
    {

        Status = bus_get_byte_(BusOutput->BusIoStartAddr + 40, &BusOutput->TellId);
    	if (Status != OK) 
        {
            mpStopWatchDelete(BusStopWatch);
        	CHECK_RESULT(Status);
        }

        Status = bus_get_byte_(BusInput->BusIoStartAddr + 40, &BusInput->AgentTellId);
    	if (Status != OK) 
        {
            mpStopWatchDelete(BusStopWatch);
        	CHECK_RESULT(Status);
        }

        if ((BusInput->AgentTellId == 0) || (BusOutput->TellId == BusInput->AgentTellId))
        {
            if (Timeout == 0)
            {
            	DEBUG_INFO("Wait Tell Bus Null Data  ");
                break;
            }
            mpTaskDelay(4);
        }
        else
        {
            Status = bus_get_byte_(BusInput->BusIoStartAddr + 20, &BusInput->JobId);
        	if (Status != OK) 
            {
                mpStopWatchDelete(BusStopWatch);
            	CHECK_RESULT(Status);
            }
            
            Status = bus_get_byte_(BusInput->BusIoStartAddr + 30, &BusInput->ErrorId);
        	if (Status != OK) 
            {
                mpStopWatchDelete(BusStopWatch);
            	CHECK_RESULT(Status);
            }
            
            Status = bus_get_byte_(BusInput->BusIoStartAddr + 50, &BusInput->AgentMsgType);
        	if (Status != OK) 
            {
                mpStopWatchDelete(BusStopWatch);
            	CHECK_RESULT(Status);
            }


        	DEBUG_INFO("BusInput[JobId:%d, ErrorId:%d, AgentMsgType:%d]", BusInput->JobId, BusInput->ErrorId, BusInput->AgentMsgType);

            mpStopWatchDelete(BusStopWatch);
            return(BusInput->ErrorId);

        }

        BusInput->SysReady = (BOOL)get_io_value_(BusInput->BusIoStartAddr);
        BusOutput->SysEnable = (BOOL)get_io_value_(BusOutput->BusIoStartAddr);
        BusOutput->SysInitialize = (BOOL)get_io_value_(BusOutput->BusIoStartAddr + 1);

        if ((!BusInput->SysReady) || (!BusOutput->SysEnable) || (BusOutput->SysInitialize))
        {
        	DEBUG_INFO("New Tell Bus Not Enable[SysReady:%d, SysEnable:%d, SysInitialize:%d]", BusInput->SysReady, BusOutput->SysEnable, BusOutput->SysInitialize);
            break;
        }

		mpStopWatchLap(BusStopWatch);
        Timer = (UINT)(mpStopWatchGetTime(BusStopWatch));

        if (((INT32)Timer > Timeout) && (Timeout > 0))
        {
        	DEBUG_INFO("Wait Tell Bus Timeout  ");
            break;
        }

    }
    
    mpStopWatchDelete(BusStopWatch);
    return(ERROR);
}

STATUS bus_feeback_tell_(INOUT struct businput_t* BusInput, INOUT struct busoutput_t *BusOutput)
{
    INT32 Status;

    Status = bus_get_byte_(BusInput->BusIoStartAddr + 40, &BusInput->AgentTellId);
	CHECK_RESULT(Status);
    
    Status = bus_get_byte_(BusInput->BusIoStartAddr + 50, &BusInput->AgentMsgType);
	CHECK_RESULT(Status);

    BusOutput->TellId = BusInput->AgentTellId;
    BusOutput->MsgType = BusInput->AgentMsgType;
    Status = bus_set_byte_(BusOutput->BusIoStartAddr + 40, BusOutput->TellId);
    CHECK_RESULT(Status);

    Status = bus_set_byte_(BusOutput->BusIoStartAddr + 50, BusOutput->MsgType);
    CHECK_RESULT(Status);

    return(OK);
}

STATUS bus_new_tell_(INOUT struct businput_t* BusInput, INOUT struct busoutput_t *BusOutput, IN INT32 Timeout)
{
    void* BusStopWatch;
    INT32 Status;
    UINT Timer;

	BusStopWatch = mpStopWatchCreate(100);
	mpStopWatchReset(BusStopWatch);
    mpStopWatchStart(BusStopWatch);

    Status = bus_get_byte_(BusInput->BusIoStartAddr + 60, &BusInput->TellId);
	if (Status != OK) 
    {
        mpStopWatchDelete(BusStopWatch);
    	CHECK_RESULT(Status);
    }

    BusOutput->RobTellId = (BusInput->TellId >= 255) ? 1 : (BusInput->TellId + 1);

    Status = bus_set_byte_(BusOutput->BusIoStartAddr + 10, BusOutput->RobotId);
    if (Status != OK) 
    {
        mpStopWatchDelete(BusStopWatch);
    	CHECK_RESULT(Status);
    }

    Status = bus_set_byte_(BusOutput->BusIoStartAddr + 20, BusOutput->JobId);
    if (Status != OK) 
    {
        mpStopWatchDelete(BusStopWatch);
    	CHECK_RESULT(Status);
    }

    Status = bus_set_byte_(BusOutput->BusIoStartAddr + 70, BusOutput->RobMsgType);
    if (Status != OK) 
    {
        mpStopWatchDelete(BusStopWatch);
    	CHECK_RESULT(Status);
    }

    Status = bus_set_byte_(BusOutput->BusIoStartAddr + 60, BusOutput->RobTellId);
    if (Status != OK) 
    {
        mpStopWatchDelete(BusStopWatch);
    	CHECK_RESULT(Status);
    }

    FOREVER
    {

        Status = bus_get_byte_(BusInput->BusIoStartAddr + 60, &BusInput->TellId);
    	if (Status != OK) 
        {
            mpStopWatchDelete(BusStopWatch);
        	CHECK_RESULT(Status);
        }

        if (BusOutput->RobTellId == BusInput->TellId)
        {
            Status = bus_get_byte_(BusInput->BusIoStartAddr + 20, &BusInput->JobId);
        	if (Status != OK) 
            {
                mpStopWatchDelete(BusStopWatch);
            	CHECK_RESULT(Status);
            }
            
            Status = bus_get_byte_(BusInput->BusIoStartAddr + 30, &BusInput->ErrorId);
        	if (Status != OK) 
            {
                mpStopWatchDelete(BusStopWatch);
            	CHECK_RESULT(Status);
            }
            
            Status = bus_get_byte_(BusInput->BusIoStartAddr + 70, &BusInput->MsgType);
        	if (Status != OK) 
            {
                mpStopWatchDelete(BusStopWatch);
            	CHECK_RESULT(Status);
            }

        	DEBUG_INFO("BusInput[JobId:%d, ErrorId:%d, MsgType:%d]", BusInput->JobId, BusInput->ErrorId, BusInput->MsgType);

            mpStopWatchDelete(BusStopWatch);
            return(BusInput->ErrorId);

        }
        else
        {
            if (Timeout == 0)
            {
            	DEBUG_WARN("New Tell Bus Null Data  ");
                break;
            }
            mpTaskDelay(4);
        }

        BusInput->SysReady = (BOOL)get_io_value_(BusInput->BusIoStartAddr);
        BusOutput->SysEnable = (BOOL)get_io_value_(BusOutput->BusIoStartAddr);
        BusOutput->SysInitialize = (BOOL)get_io_value_(BusOutput->BusIoStartAddr + 1);

        if ((!BusInput->SysReady) || (!BusOutput->SysEnable) || (BusOutput->SysInitialize))
        {
        	DEBUG_INFO("New Tell Bus Not Enable[SysReady:%d, SysEnable:%d, SysInitialize:%d]", BusInput->SysReady, BusOutput->SysEnable, BusOutput->SysInitialize);
            break;
        }

		mpStopWatchLap(BusStopWatch);
        Timer = (UINT)(mpStopWatchGetTime(BusStopWatch));

        if (((INT32)Timer > Timeout) && (Timeout > 0))
        {
        	DEBUG_ERROR("New Tell Bus Timeout  ");
            break;
        }

    }
    
    mpStopWatchDelete(BusStopWatch);
    return(ERROR);
}

STATUS bus_send_tell_(INOUT struct businput_t* BusInput, INOUT struct busoutput_t *BusOutput)
{
    INT32 Status;

    Status = bus_get_byte_(BusInput->BusIoStartAddr + 60, &BusInput->TellId);
	CHECK_RESULT(Status);
    Status = bus_get_byte_(BusOutput->BusIoStartAddr + 60, &BusOutput->RobTellId);
    CHECK_RESULT(Status);
    BusOutput->SysEnable = (BOOL)get_io_value_(BusOutput->BusIoStartAddr);

    // Code Modified on 2025.05.16
    // 修复当机器人没有使能 SysEnable 信号时，重新进行初始化
    if ((BusInput->TellId != BusOutput->RobTellId) || (!BusOutput->SysEnable))
    {
        bus_initialize_(BusInput, BusOutput, BusOutput->RobotId, PTC_GEN_CMD);
    }
    //

    BusOutput->RobTellId = (BusInput->TellId >= 255) ? 1 : (BusInput->TellId + 1);

    Status = bus_set_byte_(BusOutput->BusIoStartAddr + 10, BusOutput->RobotId);
	CHECK_RESULT(Status);

    Status = bus_set_byte_(BusOutput->BusIoStartAddr + 20, BusOutput->JobId);
	CHECK_RESULT(Status);

    Status = bus_set_byte_(BusOutput->BusIoStartAddr + 70, BusOutput->RobMsgType);
	CHECK_RESULT(Status);

    Status = bus_set_byte_(BusOutput->BusIoStartAddr + 60, BusOutput->RobTellId);
	CHECK_RESULT(Status);

    return(OK);
}

STATUS bus_read_tell_(INOUT struct businput_t* BusInput, INOUT struct busoutput_t *BusOutput, IN INT32 Timeout)
{
    void* BusStopWatch;
    INT32 Status;
    UINT Timer;

    mpClkAnnounce(MP_IO_CLK);

    Status = bus_get_byte_(BusOutput->BusIoStartAddr + 60, &BusOutput->RobTellId);
    CHECK_RESULT(Status);

	BusStopWatch = mpStopWatchCreate(100);
	mpStopWatchReset(BusStopWatch);
    mpStopWatchStart(BusStopWatch);

    FOREVER
    {

        Status = bus_get_byte_(BusInput->BusIoStartAddr + 60, &BusInput->TellId);
    	if (Status != OK) 
        {
            mpStopWatchDelete(BusStopWatch);
        	CHECK_RESULT(Status);
        }

        if (BusOutput->RobTellId == BusInput->TellId)
        {
            Status = bus_get_byte_(BusInput->BusIoStartAddr + 20, &BusInput->JobId);
        	if (Status != OK) 
            {
                mpStopWatchDelete(BusStopWatch);
            	CHECK_RESULT(Status);
            }
            
            Status = bus_get_byte_(BusInput->BusIoStartAddr + 30, &BusInput->ErrorId);
        	if (Status != OK) 
            {
                mpStopWatchDelete(BusStopWatch);
            	CHECK_RESULT(Status);
            }
            
            Status = bus_get_byte_(BusInput->BusIoStartAddr + 70, &BusInput->MsgType);
        	if (Status != OK) 
            {
                mpStopWatchDelete(BusStopWatch);
            	CHECK_RESULT(Status);
            }

        	DEBUG_INFO("BusInput[JobId:%d, ErrorId:%d, MsgType:%d]", BusInput->JobId, BusInput->ErrorId, BusInput->MsgType);

            mpStopWatchDelete(BusStopWatch);
            return(BusInput->ErrorId);

        }
        else
        {
            if (Timeout == 0)
            {
            	DEBUG_WARN("New Tell Bus Null Data  ");
                break;
            }
            mpClkAnnounce(MP_IO_CLK);
        }

        BusInput->SysReady          = (BOOL)get_io_value_(BusInput->BusIoStartAddr + 0);
        BusOutput->SysEnable        = (BOOL)get_io_value_(BusOutput->BusIoStartAddr + 0);
        BusOutput->SysInitialize    = (BOOL)get_io_value_(BusOutput->BusIoStartAddr + 1);

        if ((!BusInput->SysReady) || (!BusOutput->SysEnable) || (BusOutput->SysInitialize))
        {
        	DEBUG_INFO("New Tell Bus Not Enable[SysReady:%d, SysEnable:%d, SysInitialize:%d]", BusInput->SysReady, BusOutput->SysEnable, BusOutput->SysInitialize);
            break;
        }

		mpStopWatchLap(BusStopWatch);
        Timer = (UINT)(mpStopWatchGetTime(BusStopWatch));

        if (((INT32)Timer > Timeout) && (Timeout > 0))
        {
        	DEBUG_ERROR("New Tell Bus Timeout  ");
            break;
        }

    }
    
    mpStopWatchDelete(BusStopWatch);
    return(ERROR);
}


