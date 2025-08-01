module mixsort_t
!***********************************************************
!
! file Name: mixsort_t
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

record mag_pip_data_t
    byte    PipData1;
    byte    PipData2;
    byte    PipData3;
    byte    PipData4;
    byte    PipData5;
    byte    PipData6;
    byte    PipData7;
    byte    PipData8;
endrecord

record pict_cfg_t
    robtarget   RefPictPos;
    num         PtRlE7Pos;
    num         PtMinDist;
    pos         PtPosOfs;
    pos         PtMaxData;
    pos         PtMinData;
endrecord

record ext_cfg_t
    byte    E7Coordinate;         
    num     E7UpLim;
    num     E7DwLim;
endrecord

record pick_cfg_t
    pos    PkMaxData;
    pos    PkMinData;
endrecord

record conv_cfg_t
    byte    PlOrtMode;
    num     PlMaxOfsOrt;
    num     PlMinOfsOrt;
endrecord

record box_cfg_t
    num     PlaceUpDst;
    num     PlaceE7Pos;
    pos     PlMaxData;
    pos     PlMinData;
endrecord

record pict_data_t
    byte        IsUnrefId;
    pos         PictVec;
    robtarget   PictPos;
endrecord

record part_data_t
    byte            IsUnrefId;
    byte            FromRobId;
    num             PartLen;
    robtarget       PkPos;
    robtarget       PlPos;
    num             OfsOrt;
    num             OfsRz;
    mag_pip_data_t  MagPip;
    num             GripDist1;
    num             GripDist2;
    num             Thickness;
    num             Weight;
    byte            PlaceId;    
endrecord

record agt_data_t 
    pict_data_t     PictData;
    part_data_t     PartData;
endrecord

record mix_cfg_t
    byte        RobotId;   
    byte        NumPlPoint;
    byte        NumAxis;
    bool        EyeInHand; 
    bool        BoxOrConv; 
    pict_cfg_t  PictCfg; 
    ext_cfg_t   ExtCfg;
    pick_cfg_t  PickCfg;
endrecord

const num MIX_BUSIO_INIT            := -1;              ! Inform communication task for bus initialization
const num MIX_EDG_PIT               := 1;               ! Inform communication task for Edg Picture
const num MIX_PIT_DAT               := 2;               ! Inform communication task for obtain picture position
const num MIX_LTN_PIT               := 3;               ! Inform communication task for precise positioning picture
const num MIX_PIK_DAT               := 4;               ! Inform communication task for get pick positioning
const num MIX_GET_TASK              := 255;             ! Inform communication task for get Task

const num TO_TP_NEXT                := 1;               ! Inform robot task to the next action
const num TO_TP_PICT                := 2;               ! Inform robot task to the picture action
const num TO_TP_PK                  := 3;               ! Inform robot task to the pick action
const num TO_TP_HOME                := 4;               ! Inform robot task to the home action

endmodule