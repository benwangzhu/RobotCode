module sbt_comm002
!***********************************************************
!
! Copyright 2018 - 2024 speedbot All Rights reserved.
!
! file Name: sbt_comm002
! 
!  Description:
!    Language             ==   Rapid for ABB ROBOT
!    Date                 ==   2024 - 06 - 17
!    Modification Data    ==   2024 - 06 - 17
! 
!  Author: speedbot
! 
!  Version: 3.0
! ***********************************************************

local var busin_t BusInput := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
local var busout_t BusOutput := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

local var num BusTimeout := 20;         ! 数据接收超时 5s

local var cmd_typ03_t CmdType03 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
local var cmd_typ01_t CmdType01 := [0, 0, 0, 0, 0, 0, 0.0, 0.0];

local var errnum Res := 0;

local var jointtarget CurJointPos;
local var robtarget CurPos;

pers byte VinComm002{17};

proc sbt_comm002_(\switch CMD_VPARAM | switch CMD_TRIG | switch CMD_SCANSRT | switch CMD_SCANSTP |switch CMD_END, 
                  \byte Pid, \byte Vin{*},
                  \byte PictureId)

    var errnum Res := -1;

    while true do
        ! waittime \InPos, 0.0;

        if present(CMD_VPARAM) then

            log_clear_;

            bus_init_ BusInput, BusOutput, \RobId := 0, \ProtId := PTC_GEN_CMD;

            CmdType03 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];

            CmdType01 := [0, 0, 0, 0, 0, 0, 0.0, 0.0];

            if present(Pid) then
                CmdType03.byte01 := Pid;
            endif
            
            if present(Vin) then 

                CmdType03.byte02 := Vin{1};
                CmdType03.byte03 := Vin{2};
                CmdType03.byte04 := Vin{3};
                CmdType03.byte05 := Vin{4};
                CmdType03.byte06 := Vin{5};
                CmdType03.byte07 := Vin{6};
                CmdType03.byte08 := Vin{7};
                CmdType03.byte09 := Vin{8};
                CmdType03.byte10 := Vin{9};
                CmdType03.byte11 := Vin{10};
                CmdType03.byte12 := Vin{11};
                CmdType03.byte13 := Vin{12};
                CmdType03.byte14 := Vin{13};
                CmdType03.byte15 := Vin{14};
                CmdType03.byte16 := Vin{15};
                CmdType03.byte17 := Vin{16};
                CmdType03.byte18 := Vin{17};
            endif

            Res := bus_cmd137_(BUSCMD_WRITE, BUSCMD_MST, BusInput, BusOutput, CmdType03);
            Res := bus_cmd001_(BUSCMD_READ, BUSCMD_MST, BusInput, BusOutput, \Timeout := BusTimeout);

            if Res = 0 then 
                return;
            else
                err_display_ BusInput,BusOutput;
            endif
            
        endif

        if present(CMD_TRIG) or present(CMD_SCANSRT) or present(CMD_SCANSTP) then

            waittime \InPos, 0.0;

            if present(CMD_TRIG) then
                 BusOutput.JobId := 1;
            endif
            if present(CMD_SCANSRT) then
                BusOutput.JobId := 2;
            endif
            if present(CMD_SCANSTP) then
                BusOutput.JobId := 3;
            endif

            if present(PictureId) then
                BusOutput.RobotId := PictureId;
            endif
            
            CurPos := cur_pos_ (\ThisWobj:= wobj0,\ThisTool:= tool0);
            CurJointPos := cur_jpos_();

            Res := bus_cmd129_(BUSCMD_WRITE, BUSCMD_MST, BusInput, BusOutput, CurPos);
            Res := bus_cmd001_(BUSCMD_READ, BUSCMD_MST, BusInput, BusOutput, \Timeout := BusTimeout);

            Res := bus_cmd130_(BUSCMD_WRITE, BUSCMD_MST, BusInput, BusOutput, CurJointPos);
            Res := bus_cmd001_(BUSCMD_READ, BUSCMD_MST, BusInput, BusOutput, \Timeout := BusTimeout);

            if Res = 0 then 
            else
                err_display_ BusInput,BusOutput;
            endif
            return;
              
        endif

        if present(CMD_END) then

            BusOutput.JobId := 101;

            CurJointPos := cur_jpos_();

            Res := bus_cmd130_(BUSCMD_WRITE, BUSCMD_MST, BusInput, BusOutput, CurJointPos);
            Res := bus_cmd001_(BUSCMD_READ, BUSCMD_MST, BusInput, BusOutput, \Timeout := BusTimeout);
        
            if Res = 0 then 
            else
                err_display_ BusInput,BusOutput;
            endif
            return;

        endif

        log_error_ \Tag := "999", "Calibration Param Err", \ELOG;

    endwhile


endproc


local proc err_display_(busin_t BusIn,busout_t BusOut)

    if  BusIn.SysReady = 0 then
    
        log_error_ \Tag := "901", "Software not ready", \ELOG;
        return;
    endif

    if BusIn.TellId <> BusOut.RobTellId then

        log_error_ \Tag := "902", "Software processing timeout", \ELOG;
    endif

    test BusIn.ErrorId

    case 1:
        log_warn_ \Tag := "001", "Repeat open detection", \ELOG;
    case 2:
        log_warn_ \Tag := "002", "Order cannot recognition", \ELOG;
    case 3:
        log_warn_ \Tag := "002", "Failed to obtain camera data", \ELOG;
    default :
        log_error_ \Tag := "903", "Unknow error", \ELOG;
    endtest

endproc

endmodule