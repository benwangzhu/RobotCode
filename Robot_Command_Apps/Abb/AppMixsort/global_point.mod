module global_point
!***********************************************************
!
! file Name: global_point
! 
!  Copyright 2018 - 2024 speedbot All Rights reserved.
! 
!  Description:
!    Language             ==   Karel for ABB ROBOT
!    Date                 ==   2022 - 06 - 25
!    Modification Data    ==   2024 - 03 - 29
! 
!  Author: speedbot
! 
!  Version: 4.0
! ***********************************************************

const robtarget PkCartPosn1         := [[9E+09,9E+09,9E+09],[1,0,0,0],[1,1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const robtarget PkCartPosn2         := [[9E+09,9E+09,9E+09],[1,0,0,0],[1,1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const robtarget PkCartPosn3         := [[9E+09,9E+09,9E+09],[1,0,0,0],[1,1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

const robtarget Conv1DropPosn       := [[9E+09,9E+09,9E+09],[1,0,0,0],[1,1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const robtarget Conv2DropPosn       := [[9E+09,9E+09,9E+09],[1,0,0,0],[1,1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const robtarget Conv3DropPosn       := [[9E+09,9E+09,9E+09],[1,0,0,0],[1,1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const robtarget Conv4DropPosn       := [[9E+09,9E+09,9E+09],[1,0,0,0],[1,1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

const jointtarget PkJointPosn1      := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const jointtarget PkJointPosn2      := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const jointtarget PkJointPosn3      := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

const jointtarget Conv1JointPosn1   := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const jointtarget Conv1JointPosn2   := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const jointtarget Conv1JointPosn3   := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

const jointtarget Conv2JointPosn1   := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const jointtarget Conv2JointPosn2   := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const jointtarget Conv2ointPosn3    := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

const jointtarget Conv3JointPosn1   := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const jointtarget Conv3JointPosn2   := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const jointtarget Conv3JointPosn3   := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

const jointtarget Conv4JointPosn1   := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const jointtarget Conv4JointPosn2   := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const jointtarget Conv4JointPosn3   := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

const jointtarget Box1JointPosn1    := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const jointtarget Box1JointPosn2    := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const jointtarget Box1JointPosn3    := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

const jointtarget Box2JointPosn1    := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const jointtarget Box2JointPosn2    := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const jointtarget Box2JointPosn3    := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

const jointtarget Box3JointPosn1    := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const jointtarget Box3JointPosn2    := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const jointtarget Box3JointPosn3    := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

const jointtarget Box4JointPosn1    := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const jointtarget Box4JointPosn2    := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const jointtarget Box4JointPosn3    := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

const jointtarget Box5JointPosn1    := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const jointtarget Box5JointPosn2    := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const jointtarget Box5JointPosn3    := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

const jointtarget Box6JointPosn1    := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const jointtarget Box6JointPosn2    := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const jointtarget Box6JointPosn3    := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

const jointtarget Box7JointPosn1    := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const jointtarget Box7JointPosn2    := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const jointtarget Box7JointPosn3    := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

const jointtarget Box8JointPosn1    := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const jointtarget Box8JointPosn2    := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
const jointtarget Box8JointPosn3    := [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

const robtarget PouncePos           := [[9E+09,9E+09,9E+09],[1,0,0,0],[1,1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
endmodule