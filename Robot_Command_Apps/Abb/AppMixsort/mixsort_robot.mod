module mixsort_robot
!***********************************************************
!
! file Name: mixsort_robot
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

local var bool Break___ := false;

local var part_data_t CurPartData;

local var robtarget InBoxPlaceUpPos;

local var frame_t ConvDropPosOfs;

proc mixsort_main_()

    mixsort_init_;

    mov_to_pounce01_;

    mixsort_ack_agent_ \GET_TASK;

    while not Break___ do 

        waittestandset ToRobotFlg;

        test ToRobotCmd
        case TO_TP_NEXT:

            mixsort_wait_pos_;
        case TO_TP_PICT:

            mixsort_taking_picture_;
        case TO_TP_PK :

            mixsort_cpydata_ AgentData.PartData;

            mixsort_dt2plc_ CurPartData;

            mixsort_pick_;

            if MixPkCfg.BoxOrConv then
             
                % "mixsort_box_place" + num_to_str_(CurPartData.PlaceId, \INTEGER) + "_" %;
            else

                % "mixsort_conv_drop" + num_to_str_(CurPartData.PlaceId, \INTEGER) + "_" %;
            endif
            
        case TO_TP_HOME :

            Break___ := true;
        endtest

    endwhile

endproc

proc mixsort_init_()
    var num AxisLimUp{7};
    var num AxisLimDn{7};

    ! Robot number
    MixPkCfg.RobotId                := 1;

    ! Number of placement positions
    MixPkCfg.NumPlPoint             := 1;

    ! Number of robot axes
    MixPkCfg.NumAxis                := get_axs_num_();

    ! [TRUE] for eye-in-hand      [FALSE] for eye-out-of-hand
    MixPkCfg.EyeInHand              := false;

    ! [TRUE] for palletizing frame    [FALSE] for placing on conveyor
    MixPkCfg.BoxOrConv              := false;

    MixPkCfg.PictCfg.RefPictPos     := [[0.0, 0.0, 0.0],
                                        [1.0, 0.0, 0.0, 0.0],
                                        [0, 0, 0, 0],
                                        [9E+09, 9E+09, 9E+09, 9E+09, 9E+09, 9E+09]];

    if (MixPkCfg.NumAxis > 6) then

        get_axis_lim_ \Upper := AxisLimUp, \Lower := AxisLimDn;

        ! [1] for coordination with the +X axis on the floor track
        ! [2] for coordination with the +Y axis on the floor track
        MixPkCfg.ExtCfg.E7Coordinate    := 2;
        MixPkCfg.ExtCfg.E7UpLim         := AxisLimUp{7};
        MixPkCfg.ExtCfg.E7DwLim         := AxisLimDn{7};

        ! Determines the floor track position for left or right side
        MixPkCfg.PictCfg.PtRlE7Pos      := (AxisLimUp{7} - AxisLimDn{7}) / 2.0;

        ! Minimum TCP position distance during gripping and photography
        MixPkCfg.PictCfg.PtMinDist      := 1600.0;

    endif

    ! Maximum photography position
    MixPkCfg.PictCfg.PtMaxData      := [2000.0, 2000.0, 2000.0];

    ! Minimum photography position
    MixPkCfg.PictCfg.PtMinData      := [-2000.0, -2000.0, -2000.0];

    ! Maximum pick-up coordinate
    MixPkCfg.PickCfg.PkMaxData      := [ 2000.0,  2000.0,  2000.0];

    ! Minimum pick-up coordinate
    MixPkCfg.PickCfg.PkMinData      := [-2000.0, -2000.0, -2000.0];

    ! Configuration for placing on conveyor belt number 1
    ConvConfig{1}                   := [1, 200, -200];   

    ! Configuration for placing on conveyor belt number 2
    ConvConfig{2}                   := [1, 200, -200];  

    ! Configuration for placing on conveyor belt number 3
    ConvConfig{3}                   := [1, 200, -200];  
         
    ! Configuration for placing on conveyor belt number 4
    ConvConfig{4}                   := [1, 200, -200];     

    ! Lifting point for placing on pallet number 1
    BoxConfig{1}.PlaceUpDst         := 300.0;  
    ! Floor track position for pallet number 1
    BoxConfig{1}.PlaceE7Pos         := 0.0;                 
    ! Maximum placement values for pallet number 1
    BoxConfig{1}.PlMaxData          := [2000.0, 2000.0, 2000.0];       
    ! Minimum placement values for pallet number 1
    BoxConfig{1}.PlMinData          := [-2000.0, -2000.0, -2000.0]; 

    BoxConfig{2}.PlaceUpDst         := 300.0;                          
    BoxConfig{2}.PlaceE7Pos         := 0.0;
    BoxConfig{2}.PlMaxData          := [2000.0, 2000.0, 2000.0];
    BoxConfig{2}.PlMinData          := [-2000.0, -2000.0, -2000.0];
    
    BoxConfig{3}.PlaceUpDst         := 300.0;
    BoxConfig{3}.PlaceE7Pos         := 0.0;
    BoxConfig{3}.PlMaxData          := [2000.0, 2000.0, 2000.0];
    BoxConfig{3}.PlMinData          := [-2000.0, -2000.0, -2000.0];
    
    BoxConfig{4}.PlaceUpDst         := 300.0;
    BoxConfig{4}.PlaceE7Pos         := 0.0;
    BoxConfig{4}.PlMaxData          := [2000.0, 2000.0, 2000.0];
    BoxConfig{4}.PlMinData          := [-2000.0, -2000.0, -2000.0];
    
    BoxConfig{5}.PlaceUpDst         := 300.0;
    BoxConfig{5}.PlaceE7Pos         := 0.0;
    BoxConfig{5}.PlMaxData          := [2000.0, 2000.0, 2000.0];
    BoxConfig{5}.PlMinData          := [-2000.0, -2000.0, -2000.0];
    
    BoxConfig{6}.PlaceUpDst         := 300.0;
    BoxConfig{6}.PlaceE7Pos         := 0.0;
    BoxConfig{6}.PlMaxData          := [2000.0, 2000.0, 2000.0];
    BoxConfig{6}.PlMinData          := [-2000.0, -2000.0, -2000.0];
    
    BoxConfig{7}.PlaceUpDst         := 300.0;
    BoxConfig{7}.PlaceE7Pos         := 0.0;
    BoxConfig{7}.PlMaxData          := [2000.0, 2000.0, 2000.0];
    BoxConfig{7}.PlMinData          := [-2000.0, -2000.0, -2000.0];
    
    BoxConfig{8}.PlaceUpDst         := 300.0;
    BoxConfig{8}.PlaceE7Pos         := 0.0;
    BoxConfig{8}.PlMaxData          := [2000.0, 2000.0, 2000.0];
    BoxConfig{8}.PlMinData          := [-2000.0, -2000.0, -2000.0];

    
    ToRobotCmd                      := 0;
    ToSensorCmd                     := 0;
    ToRobotFlg                      := true;               
    ToSensorFlg                     := true;    

    GlobalTaskId                    := 0;

    ! Defaults to success
    IsPicking                       := true; 

    ! Notify the backend to initialize bus communication
    mixsort_ack_agent_ \BUSIO_INIT;
    
endproc

proc mixsort_dt2plc_(part_data_t ThisPartData)

    ! Feedback the length of the workpiece
    echo_job_info_ \Info1 := ThisPartData.PartLen mod 256,
                   \Info2 := ThisPartData.PartLen div 256,
                   \Info3 := 0,
                   \Info4 := 0;
    
    ! Feedback the magnet channel states
    echo_channel_ \channel1 := ThisPartData.MagPip.PipData1,
                  \channel2 := ThisPartData.MagPip.PipData2,
                  \channel3 := ThisPartData.MagPip.PipData3,
                  \channel4 := ThisPartData.MagPip.PipData4;
    
    ! Move the gripper servo
    servo01_ctrl_ \MOVING, \Dist := ThisPartData.GripDist1;
endproc

proc mixsort_cpydata_(part_data_t ThisPartData)

    CurPartData := ThisPartData;
    
    if MixPkCfg.BoxOrConv then  

        InBoxPlaceUpPos         := CurPartData.PlPos;
        InBoxPlaceUpPos.Trans.Z := BoxConfig{CurPartData.PlaceId}.PlaceUpDst;
    else

        CurPartData.OfsOrt     := min_(CurPartData.OfsOrt, ConvConfig{CurPartData.PlaceId}.PlMaxOfsOrt);
        CurPartData.OfsOrt     := max_(CurPartData.OfsOrt, ConvConfig{CurPartData.PlaceId}.PlMinOfsOrt);
        
        test (ConvConfig{CurPartData.PlaceId}.PlOrtMode)

        case 1:
            ConvDropPosOfs  := [CurPartData.OfsOrt, 0.0, 0.0, CurPartData.OfsRz, 0.0, 0.0];
        case 2:
            ConvDropPosOfs  := [0.0, CurPartData.OfsOrt, 0.0, CurPartData.OfsRz, 0.0, 0.0];
        case -1:
            ConvDropPosOfs  := [CurPartData.OfsOrt * (-1), 0.0, 0.0, CurPartData.OfsRz, 0.0, 0.0];
        case -2:
            ConvDropPosOfs  := [0.0, CurPartData.OfsOrt * (-1), 0.0, CurPartData.OfsRz, 0.0, 0.0];
        endtest
    endif
endproc

proc go_home_(num SafetyZ)
    var robtarget CurrentPos;

    CurrentPos := cur_pos_(\ThisWobj := Wobj0, \ThisTool := Tool0);
    CurrentPos.Trans.Z := SafetyZ;
    movel CurrentPos, v1000, z20, tool0;
    mov_to_home01_;
endproc

proc mixsort_taking_picture_()


    movel AgentData.PictData.PictPos, v1500, fine, tool0;

    waittime 0.5;
    mixsort_ack_agent_ \TAKING_LTN_PICTURE;
endproc

proc mixsort_wait_pos_()
    ! Move the robot to the waiting position
    ! This procedure can be automatically added based on actual conditions

    waittime 0.5;

    ! Request to acquire data
    mixsort_ack_agent_ \GET_TASK;
endproc

proc mixsort_pick_()
    
    ! Avoid sudden changes in Robot Axis 6
    confl\off;
    movel PkCartPosn1, v1000, z100, MixTool;
    movel offs_posn_(\Posn1 := CurPartData.PkPos, \Z := 200), v1000, z100, MixTool;
    
    ! Wait for the servos to reach their positions; this line can be ignored if there are no servos
    servo01_ctrl_ \WAITING;
    
    ! Move to the pick-up point
    movel CurPartData.PkPos, v800, fine, MixTool;
    
    ! Turn on the magnet
    mag_tool_ctrl_ \ON \SleepTime := 500;
    
    movel offs_posn_(\Posn1 := CurPartData.PkPos, \Z := 200), v800, z100, MixTool;
    moveabsj PkJointPosn1, v800, z100, MixTool;
endproc

proc mixsort_conv_drop1_()

    moveabsj Conv1JointPosn1, v1000, z100, MixTool;
    movel offs_posn_(\Posn1 := Conv1DropPosn, 
                     \X     := ConvDropPosOfs.X, 
                     \Y     := ConvDropPosOfs.Y,
                     \Oz    := ConvDropPosOfs.Rz), v800, fine, MixTool;

    mixsort_ack_agent_ \GET_TASK;

    mag_tool_ctrl_ \OFF, \SleepTime := 500;

    moveabsj Conv1JointPosn2, v1000, z100, MixTool;
endproc     

proc mixsort_conv_drop2_()

    moveabsj Conv2JointPosn1, v1000, z100, MixTool;
    movel offs_posn_(\Posn1 := Conv2DropPosn, 
                     \X     := ConvDropPosOfs.X, 
                     \Y     := ConvDropPosOfs.Y,
                     \Oz    := ConvDropPosOfs.Rz), v800, fine, MixTool;

    mixsort_ack_agent_ \GET_TASK;

    mag_tool_ctrl_ \OFF, \SleepTime := 500;

    moveabsj Conv2JointPosn2, v1000, z100, MixTool;
endproc

proc mixsort_conv_drop3_()

    moveabsj Conv3JointPosn1, v1000, z100, MixTool;
    movel offs_posn_(\Posn1 := Conv3DropPosn, 
                     \X     := ConvDropPosOfs.X, 
                     \Y     := ConvDropPosOfs.Y,
                     \Oz    := ConvDropPosOfs.Rz), v800, fine, MixTool;

    mixsort_ack_agent_ \GET_TASK;

    mag_tool_ctrl_ \OFF, \SleepTime := 500;

    moveabsj Conv3JointPosn2, v1000, z100, MixTool;
endproc

proc mixsort_conv_drop4_()

    moveabsj Conv4JointPosn1, v1000, z100, MixTool;
    movel offs_posn_(\Posn1 := Conv4DropPosn, 
                     \X     := ConvDropPosOfs.X, 
                     \Y     := ConvDropPosOfs.Y,
                     \Oz    := ConvDropPosOfs.Rz), v800, fine, MixTool;

    mixsort_ack_agent_ \GET_TASK;

    mag_tool_ctrl_ \OFF, \SleepTime := 500;

    moveabsj Conv4JointPosn2, v1000, z100, MixTool;
endproc

proc mixsort_box_place1_()

    moveabsj Box1JointPosn1, v1000, z100, MixTool;

    movel InBoxPlaceUpPos, v1000, z100, MixTool;

    movel CurPartData.PlPos, v800, fine, MixTool;

    mixsort_ack_agent_ \GET_TASK;

    mag_tool_forc_ctrl_ \OFF, \SleepTime := 500;

    movel InBoxPlaceUpPos, v1000, z100, MixTool;

    moveabsj Box1JointPosn2, v1000, z100, MixTool;

endproc

proc mixsort_box_place2_()

    moveabsj Box2JointPosn1, v1000, z100, MixTool;

    movel InBoxPlaceUpPos, v1000, z100, MixTool;

    movel CurPartData.PlPos, v800, fine, MixTool;

    mixsort_ack_agent_ \GET_TASK;

    mag_tool_forc_ctrl_ \OFF, \SleepTime := 500;

    movel InBoxPlaceUpPos, v1000, z100, MixTool;

    moveabsj Box2JointPosn2, v1000, z100, MixTool;

endproc

proc mixsort_box_place3_()

    moveabsj Box3JointPosn1, v1000, z100, MixTool;

    movel InBoxPlaceUpPos, v1000, z100, MixTool;

    movel CurPartData.PlPos, v800, fine, MixTool;

    mixsort_ack_agent_ \GET_TASK;

    mag_tool_forc_ctrl_ \OFF, \SleepTime := 500;

    movel InBoxPlaceUpPos, v1000, z100, MixTool;

    moveabsj Box3JointPosn2, v1000, z100, MixTool;

endproc

proc mixsort_box_place4_()

    moveabsj Box4JointPosn1, v1000, z100, MixTool;

    movel InBoxPlaceUpPos, v1000, z100, MixTool;

    movel CurPartData.PlPos, v800, fine, MixTool;

    mixsort_ack_agent_ \GET_TASK;

    mag_tool_forc_ctrl_ \OFF, \SleepTime := 500;

    movel InBoxPlaceUpPos, v1000, z100, MixTool;

    moveabsj Box4JointPosn2, v1000, z100, MixTool;

endproc

local proc mixsort_ack_robot_(\switch ROBOT_TO_NEXT | switch ROBOT_TO_PICTURE | switch ROBOT_TO_PICK | switch ROBOT_TO_HOME)

    if present(ROBOT_TO_NEXT)       ToRobotCmd := TO_TP_NEXT;           
    if present(ROBOT_TO_PICTURE)    ToRobotCmd := TO_TP_PICT;
    if present(ROBOT_TO_PICK)       ToRobotCmd := TO_TP_PK;
    if present(ROBOT_TO_HOME)       ToRobotCmd := TO_TP_HOME;
    ToRobotFlg := false;
endproc

local proc mixsort_ack_agent_(\switch BUSIO_INIT | switch TAKING_EDG_PICTURE | switch GET_PICTURE_DATA | switch TAKING_LTN_PICTURE | switch GET_PICK_DATA | switch GET_TASK)
    
    if present(BUSIO_INIT)              ToSensorCmd := MIX_BUSIO_INIT;
    if present(TAKING_EDG_PICTURE)      ToSensorCmd := MIX_EDG_PIT;
    if present(GET_PICTURE_DATA)        ToSensorCmd := MIX_PIT_DAT;
    if present(TAKING_LTN_PICTURE)      ToSensorCmd := MIX_LTN_PIT;
    if present(GET_PICK_DATA)           ToSensorCmd := MIX_PIK_DAT;

    ! Code added on 2025.05.02
    ! 添加获取任务指令
    if present(GET_TASK)                ToSensorCmd := MIX_GET_TASK;
    !

    ToSensorFlg := false;

    if present(BUSIO_INIT)              waittestandset ToRobotFlg;
endproc


endmodule