module mixsort_global
!***********************************************************
!
! file Name: mixsort_global
! 
!  Copyright 2018 - 2024 speedbot All Rights reserved.
! 
!  Description:
!    Language             ==   Karel for ABB ROBOT
!    Date                 ==   2022 - 06 - 25
!    Modification Data    ==   2024 - 11 - 11
! 
!  Author: speedbot
! 
!  Version: 4.0
! ***********************************************************

! Bus I/O interface variables
pers busin_t    BusInput            := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
pers busout_t   BusOutput           := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

! Sorting configuration variables
pers mix_cfg_t  MixPkCfg;

! Palletizing frame configuration variables
pers box_cfg_t  BoxConfig{12};

! Conveyor placement configuration variables
pers conv_cfg_t ConvConfig{4};

! Shared data variables for tasks
pers agt_data_t AgentData;

! Bus communication timeout time
pers num BusTimeout                 := 60;

! Do not change these variables
pers num ToRobotCmd                 := 0;
pers num ToSensorCmd                := 0;
pers bool ToRobotFlg                := true;               
pers bool ToSensorFlg               := true;     

! Code added on 2025.05.02
! Task ID sent by the software
pers num GlobalTaskId               := 0;
! Success flag for Picking
pers bool IsPicking                 := true;        ! [1] Success  [0] Failed
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

! Tool coordinate system used for sorting
pers tooldata MixTool               := [true, [[0, 0, 0], [1, 0, 0, 0]],
                                        [0.001, [0, 0, 0.001], [1, 0, 0, 0], 0, 0, 0]];

endmodule