module sbt_comm011_t
!***********************************************************
!
! Copyright 2018 - 2024 speedbot All Rights reserved.
!
! file Name: sbt_comm011_t
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

! Real-time data structure for transmission
record pk_realtm_t
    pack_head_t Header;
    robtarget Pos;
    num ProcessPrm01;
    num ProcessPrm02;
    num ProcessPrm03;
    num ProcessPrm04;
    string Reversed;
    pack_tail_t Tail;
endrecord

! Data receiving structure
record pk_tarje_t
    pack_head_t Header;
    robtarget Pos;
    num ProcessPrm01;
    num ProcessPrm02;
    num ProcessPrm03;
    num ProcessPrm04;
    string Reversed;
    pack_tail_t Tail;
endrecord

const num INST_UNKNOWN    := 0;                 ! Unknown command
const num INST_PATH       := 1;                 ! Receive path trajectory command
const num INST_2D_ST      := 2;                 ! 2D camera scan start command
const num INST_2D_ED      := 3;                 ! 2D camera scan end command
const num INST_3D_ST      := 4;                 ! 3D camera scan start command
const num INST_3D_ED      := 5;                 ! 3D camera scan end command
const num INST_LS_ST      := 6;                 ! Laser camera scan start command
const num INST_LS_ED      := 7;                 ! Laser camera scan end command
const num INST_PRM_ST     := 8;                 ! Welding parameter real-time correction start command
const num INST_PRM_ED     := 9;                 ! Welding parameter real-time correction end command


const num NETWORK_INTR_ITP  := 0.020;           ! Real-time communication interruption duration

endmodule
