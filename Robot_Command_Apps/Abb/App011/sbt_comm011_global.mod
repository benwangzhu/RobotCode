module sbt_comm011_global
!***********************************************************
!
! Copyright 2018 - 2024 speedbot All Rights reserved.
!
! file Name: sbt_comm011_global
! 
!  Description:
!    Language             ==   Rapid for ABB ROBOT
!    Date                 ==   2024 - 11 - 14
!    Modification Data    ==   2024 - 11 - 14
! 
!  Author: speedbot
! 
!  Version: 1.0
! ***********************************************************

! This file stores all global variables related to the sbt_comm011 function
!
!

! Set network communication parameters
! [Connected,  Ip,  Port,  Bytes,  RecvTimeout(s)]
var sock_cfg_t GlbSocketCfg := [false, "127.0.0.1", 11002, 0, 30.0];

! Real-time data sending
var pk_realtm_t GlbPackRealTime;

! Receive data
var pk_tarje_t GlbPackTrajeInst;

! Command Id
var num GlbCommandId := INST_UNKNOWN;

! Sold Id
var num GlbSlodId := 0;

! Trajectory Length
var num GlbTrajectoryLen := 0;

! Trajectory Points
var robtarget GlbTrajectoryPoint{1600};

! Trajectory Start Point
var robtarget GlbStartPosn;

! Trajectory End Point
var robtarget GlbEndPosn;

! Command completed flag
pers bool FlagRltAck := false;
endmodule