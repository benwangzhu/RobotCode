module sbt_comm000
!***********************************************************
!
! Copyright 2018 - 2024 speedbot All Rights reserved.
!
! file Name: sbt_comm000
! 
!  Description:
!    Language             ==   Rapid for ABB ROBOT
!    Date                 ==   2024 - 04 - 01
!    Modification Data    ==   2024 - 05 - 29
! 
!  Author: speedbot
! 
!  Version: 3.0
! ***********************************************************

local var busin_t BusInput := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];            ! 通讯输入接口
local var busout_t BusOutput := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];          ! 通讯输出接口

local var num BusTimeout := 5;         ! 数据接收超时 20s

local var num Count := 0;

local var cmd_typ01_t CmdType01 := [0, 0, 0, 0, 0, 0, 0.0, 0.0];

local var errnum Res := 0;

local var robtarget CurPos;         ! 存储拍照时的当前位姿

proc sbt_comm000_(\switch CALIB_START | switch CALIB_PICT | switch CALIB_END, \num PictureId)

    var errnum Res := -1;

    while true do

        waittime \InPos,0.0;

        if present(CALIB_START) then                ! 标定开始

            bus_init_ BusInput, BusOutput, \RobId := 0, \ProtId := PTC_GEN_CMD;

            CmdType01 := [1, PictureId, 0, 0, 0, 0, 0.0, 0.0];

            Count := 0;

            Res := bus_cmd002_(BUSCMD_WRITE, BUSCMD_MST, BusInput, BusOutput, CmdType01);
            Res := bus_cmd001_(BUSCMD_READ, BUSCMD_MST, BusInput, BusOutput, \Timeout := BusTimeout);

            if Res = 0 then 

                log_info_ \Tag := "COMM000", "Init [CMD002] Succ";
            else

                errwrite "38001","CALIB_START CMD002 ERR";
                stop;
                
            endif

            return;  

        endif

        if present(CALIB_PICT) then                 ! 标定拍照

            incr Count;

            CurPos := cur_pos_();

            Res := bus_cmd003_(BUSCMD_WRITE, BUSCMD_MST, BusInput, BusOutput, CurPos);
            Res := bus_cmd001_(BUSCMD_READ, BUSCMD_MST, BusInput, BusOutput, \Timeout := BusTimeout);

            if Res = 0 then 

                log_info_ \Tag := "COMM000", "CALIB_PICT [CMD003] Succ";

            else

                errwrite \W ,"38002","CALIB_PICT CMD003 Warn";    

            endif

            return;

        endif

        if present(CALIB_END) then                  ! 标定结束

            CmdType01 := [2, 0, 0, 0, 0, 0, 0.0, 0.0];

            Res := bus_cmd002_(BUSCMD_WRITE, BUSCMD_MST, BusInput, BusOutput, CmdType01);
            Res := bus_cmd001_(BUSCMD_READ, BUSCMD_MST, BusInput, BusOutput, \Timeout := BusTimeout);
        
            if Res = 0 then 

                log_info_ \Tag := "COMM000", "CALIB_END [CMD002] Succ";

            else

                errwrite "38003","CALIB_END CMD002 ERR";
                stop; 

            endif

            return;

        endif

        errwrite "38000","Calibration Param Err";
        stop;

    endwhile


endproc

endmodule