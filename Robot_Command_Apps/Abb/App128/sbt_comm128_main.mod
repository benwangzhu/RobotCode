module sbt_comm128_main
!***********************************************************
!
! Copyright 2018 - 2024 speedbot All Rights reserved.
!
! file Name: sbt_comm128_main
! 
!  Description:
!    Language             ==   Rapid for ABB ROBOT
!    Date                 ==   2024 - 04 - 21
!    Modification Data    ==   2024 - 04 - 21
! 
!  Author: speedbot
! 
!  Version: 4.0
! ***********************************************************

local var trajectory_pt_t Trajectorys{MAX_TRAJ_LENGTH};
local var num TrajectorySize := 0;
local var intnum InteStopTrajectory;
local var num CurrentAcc := 100;
local var num CurrentAccRamp := 100;
var num i;

proc main()

    CtrlIpAddr := "127.0.0.1";
    OnlyCollect := false;
    NumOfRobAxis := 6;
    NumOfRotAxis := 0;
    
    if not robos() then

        IsVirRobId := 1;
    else
        IsVirRobId := 0;
    endif

    OutMapName := ["", "", "", "", "", "", "", ""];
    InMapName := ["", "", "", "", "", "", "", ""];

    MtnRestart := true;
    StatRestart := true;
    TrajectoryLock := false;
    NewTrajectory := false;
    StopMoveing := false;

    GlbMoveId := 0;

    waittime 0.016;
    !
    !Set up interrupt to watch for new trajectory
    idelete InteStopTrajectory;    ! clear interrupt handler, in case restarted with ExitCycle
    connect InteStopTrajectory WITH stop_traj_handler_;
    ipers StopMoveing, InteStopTrajectory;

    while true do
        ! Check for new Trajectory
        if (NewTrajectory) then
            init_trajectory_;
        else
            waittime 0.05;  ! Throttle loop while waiting for new command
        endif
        ! execute all points in this trajectory
        if (TrajectorySize > 0) then
            for i from 1 TO TrajectorySize do

                GlbMoveId := Trajectorys{i}.TrjMoveId;

                if not (Trajectorys{i}.TrjAcc = CurrentAcc) then
                    CurrentAcc := Trajectorys{i}.TrjAcc; 
                    AccSet CurrentAcc, CurrentAccRamp; 
                endif

                if Trajectorys{i}.TrjMoveType = MOVE_J then

                    movej Trajectorys{i}.TrjPose, v10 \V := Trajectorys{i}.TrjSpeed, Z0 \Z := Trajectorys{i}.TrjSmoot, DriveTool;
                elseif Trajectorys{i}.TrjMoveType = MOVE_L then

                    movel Trajectorys{i}.TrjPose, v10 \V := Trajectorys{i}.TrjSpeed, Z0 \Z := Trajectorys{i}.TrjSmoot, DriveTool;
                elseif Trajectorys{i}.TrjMoveType = MOVE_C1 then


                endif

            endfor
            TrajectorySize := 0;  ! trajectory done
        endif
    endwhile
    
    error
    log_warn_ "Motion Error, Error executing motion.  Aborting trajectory.", \ELOG;
    abort_traj_;
endproc

local proc init_trajectory_()
    clear_path_;                                ! cancel any active motions

    WaitTestAndSet TrajectoryLock;              ! acquire data-lock
    Trajectorys := GlbTrajectorys;              ! copy to local var
    TrajectorySize := GlbTrajectorySize;        ! copy to local var
    NewTrajectory := false;
    TrajectoryLock := false;                    ! release data-lock
endproc

local proc abort_traj_()
    TrajectorySize := 0;    ! "clear" local trajectory
    clear_path_;

    log_info_ "Restart";
    exitcycle;              ! restart program
endproc

local proc clear_path_()
    if  not (IsStopMoveAct(\FromMoveTask) or IsStopMoveAct(\FromNonMoveTask))
        StopMove;          ! stop any active motions
    clearpath;             ! clear queued motion commands
    startmove;             ! re-enable motions
endproc

local trap stop_traj_handler_    
    abort_traj_;
endtrap

endmodule