module sbt_comm004
!***********************************************************
!
! Copyright 2018 - 2024 speedbot All Rights reserved.
!
! file Name: sbt_comm004
! 
!  Description:
!    Language             ==   Rapid for ABB ROBOT
!    Date                 ==   2025 - 06 - 07
!    Modification Data    ==   2025 - 06 - 07
! 
!  Author: speedbot
! 
!  Version: 3.0
! ***********************************************************

local var busin_t BusInput := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
local var busout_t BusOutput := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

local var num BusTimeout := 5;
local var vector_t MaxCorr :=[10,10,10];        

local var cmd_typ03_t CmdType03 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
local var cmd_typ01_t CmdType01 := [0, 0, 0, 0, 0, 0, 0.0, 0.0];

local var errnum Res := 0;
local var num Count :=0;

local var robtarget PicturePose;
local var robtarget CommandPose;
local var robtarget GuidePose;

pers wobjdata NowWobj;
pers tooldata NowTool;

pers byte VinComm004{17};

proc sbt_comm004_(\switch CMD_VPARAM | switch CMD_VGIDE | switch CMD_VASMB | switch CMD_DQMONI , 
                  \byte Pid, \byte Vin{*},
                  \byte Code, \inout robtarget ThisPose,
                  \speeddata SpeedL,\num Delay)

    var errnum Res := -1;

    Count := 0;
    
    while true do

        waittime \InPos, 0.0;

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

        if present(CMD_VGIDE)  then

            waittime \InPos, 0.0;


            CmdType01.Byte01 := 100;
            
            if present(Code) then

                CmdType01.Byte02 := Code;

            endif

            CmdType01.Short03 := 0;
            CmdType01.Short04 := 0;
            CmdType01.Int05 := 0;
            CmdType01.Int06 := 0;
            CmdType01.Float07 := 0;
            CmdType01.Float08 := 0;

            Res := bus_cmd145_(BUSCMD_WRITE, BUSCMD_MST, BusInput, BusOutput, CmdType01);
            Res := bus_cmd001_(BUSCMD_READ, BUSCMD_MST, BusInput, BusOutput, \Timeout := BusTimeout);

            if Res = 0 then

                Count := Count +1;
                BusOutput.JobId := Count;

                PicturePose := cur_pos_(\ThisWobj:=wobj0,\ThisTool:=tool0);

                Res := bus_cmd009_(BUSCMD_WRITE, BUSCMD_MST, BusInput, BusOutput, PicturePose);
                Res := bus_cmd129_(BUSCMD_READ, BUSCMD_MST, BusInput, BusOutput, CommandPose, \Timeout := BusTimeout);

                if Res = 0 then

                    if present(ThisPose) then

                        ThisPose := PicturePose;

                        ThisPose.trans := CommandPose.trans;
                        ThisPose.rot := CommandPose.rot;

                    endif

                    return;
                else

                    err_display_ BusInput,BusOutput;
                    
                    bus_init_ BusInput, BusOutput, \RobId := 0, \ProtId := PTC_GEN_CMD;

                    Count := Count -1;
                endif
                
            else
                err_display_ BusInput,BusOutput;
                
                bus_init_ BusInput, BusOutput, \RobId := 0, \ProtId := PTC_GEN_CMD;

            endif
        endif

        if present(CMD_VASMB) or present(CMD_DQMONI) then

            if Count = 0 then

                if present(MaxCorr.X) then
                    MaxCorr.X := 10;
                endif

                if present(MaxCorr.Y) then
                    MaxCorr.Y := 10;
                endif

                if present(MaxCorr.Z) then
                    MaxCorr.Z := 10;
                endif

                if present(CMD_VASMB) then

                    CmdType01.Byte01 := 101;

                endif

                if present(CMD_DQMONI) then

                    CmdType01.Byte01 := 102;

                endif

                CmdType01.Byte02 := 0;
                CmdType01.Short03 := 0;
                CmdType01.Short04 := 0;
                CmdType01.Int05 := 0;
                CmdType01.Int06 := 0;
                CmdType01.Float07 := 0;
                CmdType01.Float08 := 0;

                Res := bus_cmd145_(BUSCMD_WRITE, BUSCMD_MST, BusInput, BusOutput, CmdType01);
                Res := bus_cmd001_(BUSCMD_READ, BUSCMD_MST, BusInput, BusOutput, \Timeout := BusTimeout);

            endif

            if Res = 0 then

                Count := tern_num_(Count >= 254, 1, Count + 1);

                BusOutput.JobId := Count;

                PicturePose := cur_pos_();

                Res := bus_cmd009_(BUSCMD_WRITE, BUSCMD_MST, BusInput, BusOutput, PicturePose);
                Res := bus_cmd129_(BUSCMD_READ, BUSCMD_MST, BusInput, BusOutput, CommandPose, \Timeout := BusTimeout);

                if Res = 0 then

                    if BusInput.JobId = 255 then

                        return;

                    endif

                    if BusInput.JobId = BusOutput.JobId then

                        GuidePose := PicturePose;

                        GuidePose.trans := CommandPose.trans;
                        GuidePose.rot := CommandPose.rot;

                        if (abs(GuidePose.trans.x -  CommandPose.trans.x) <= MaxCorr.X) and
                           (abs(GuidePose.trans.y -  CommandPose.trans.y) <= MaxCorr.Y) and
                           (abs(GuidePose.trans.z -  CommandPose.trans.z) <= MaxCorr.Z) then

                            NowTool := Ctool();
                            NowWobj := cwobj();

                            movel GuidePose,SpeedL,fine,NowTool\WObj:=NowWobj; 

                            if present(Delay) then
                                waittime Delay;
                            else
                                waittime 0.5;
                            endif

                        else

                            log_error_ \Tag := "801", "Move out of range", \ELOG;
                        endif
                    else

                        log_error_ \Tag := "802", "The times series Err", \ELOG;
                    endif

                else

                    err_display_ BusInput,BusOutput;
                    
                    bus_init_ BusInput, BusOutput, \RobId := 0, \ProtId := PTC_GEN_CMD;

                    count := 0;

                endif
            else

                err_display_ BusInput,BusOutput;
                
                bus_init_ BusInput, BusOutput, \RobId := 0, \ProtId := PTC_GEN_CMD;

            endif
                

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
        log_error_ \Tag := "001", "Camera connection failed", \ELOG;
    case 2:
        log_error_ \Tag := "002", "Camera shot failed", \ELOG;
    case 3:
        log_error_ \Tag := "003", "Loading identification failed", \ELOG;
    case 4:
        log_error_ \Tag := "004", "The hinge fit calculation failed", \ELOG;
    case 5:
        log_error_ \Tag := "005", "Hinge adjustment calculation failed", \ELOG;
    case 6:
        log_error_ \Tag := "006", "The gap surface difference calculation failed", \ELOG;
    case 7:
        log_error_ \Tag := "007", "Call adjustment failed", \ELOG;
    case 8:
        log_error_ \Tag := "008", "Call screw down failed", \ELOG;
    case 9:
        log_error_ \Tag := "009", "Call car door failed", \ELOG;
    case 10:
        log_error_ \Tag := "010", "Out of range", \ELOG;
    default :
        log_error_ \Tag := "903", "Unknow error", \ELOG;
    endtest

endproc

endmodule