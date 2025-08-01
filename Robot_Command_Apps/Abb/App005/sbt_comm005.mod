module sbt_comm005
!***********************************************************
!
! Copyright 2018 - 2024 speedbot All Rights reserved.
!
! file Name: sbt_comm005
! 
!  Description:
!    Language             ==   Rapid for ABB ROBOT
!    Date                 ==   2024 - 05 - 17
!    Modification Data    ==   2024 - 05 - 17
! 
!  Author: speedbot
! 
!  Version: 3.0
! ***********************************************************

local var busin_t BusInput := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
local var busout_t BusOutput := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

local var num BusTimeout := 5;         ! 数据接收超时 20s

local var num Count := 0;

local var num I := 0;

local var cmd_typ03_t CmdType03 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
local var cmd_typ01_t CmdType01 := [0, 0, 0, 0, 0, 0, 0.0, 0.0];

local var errnum Res := 0;

local var robtarget CurPos;

pers byte VinComm005{17};

proc sbt_comm005_(\switch CMD_VPARAM | switch CMD_PICTURE | switch CMD_END, \byte Pid, \byte Vin{*},\byte PictureId)

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

            !Count := 0;

            log_info_ \Tag := "COMM005_", "Init [CMD137] ?";

            Res := bus_cmd137_(BUSCMD_WRITE, BUSCMD_MST, BusInput, BusOutput, CmdType03);
            Res := bus_cmd001_(BUSCMD_READ, BUSCMD_MST, BusInput, BusOutput, \Timeout := BusTimeout);

            if Res = 0 then 

                log_info_ \Tag := "COMM005", "Init [CMD137] Succ";
                return;
            else

                err_display_ BusInput,BusOutput;
            endif

              
        endif

        if present(CMD_PICTURE) then

            waittime \InPos, 0.0;

            !incr Count;
            if present(PictureId) then
                BusOutput.RobotId := PictureId;
            else
                BusOutput.RobotId := 0;
            endif

            log_info_ \Tag := "COMM005", "Picture [CMD009] ?";

            CurPos := cur_pos_();

            Res := bus_cmd009_(BUSCMD_WRITE, BUSCMD_MST, BusInput, BusOutput, CurPos);
            Res := bus_cmd001_(BUSCMD_READ, BUSCMD_MST, BusInput, BusOutput, \Timeout := BusTimeout);

            if Res = 0 then 

                log_info_ \Tag := "COMM005", "Picture [CMD009] Succ";
            else

                err_display_ BusInput,BusOutput;

            endif

            return;  
        endif

        if present(CMD_END) then

            log_info_ \Tag := "COMM005", "Finish [CMD012] ?";

            Res := bus_cmd012_(BUSCMD_WRITE, BUSCMD_MST, BusInput, BusOutput, CmdType01);
            Res := bus_cmd001_(BUSCMD_READ, BUSCMD_MST, BusInput, BusOutput, \Timeout := BusTimeout);
        
            if Res = 0 then 

                log_info_ \Tag := "COMM005", "Finish [CMD012] Succ";
            else

                err_display_ BusInput,BusOutput;
            endif

            return;  
        endif

    endwhile

    errwrite "38000","Calibration Param Err";
    stop;

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