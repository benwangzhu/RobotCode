module Comm010Main
!***********************************************************
!
! File Name: Comm010Main
!
! Description:
!   Language             ==   Rapid for ABB ROBOT
!   Date                 ==   2022 - 12 - 19
!   Modification Data    ==   2022 - 12 - 19
!
! Author: speedbot
!
! Version: 1.0
!*********************************************************************************************************!
!                                                                                                         !


local var intnum MissCondition;

local var sensor_data_table_t NewDataTable;  

local var bool KeepActive := true;

local const robtarget PlaceCartPosn01       := [[674.99,1413.94,-61.22],[0.00628194,-0.535751,0.844323,-0.00699882],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local const robtarget PlaceCartPosn02       := [[691.66,1724.02,-61.20],[0.0062829,-0.535775,0.844309,-0.00699829],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local const robtarget PlaceCartPosn03       := [[674.99,1413.94,-61.22],[0.00628194,-0.535751,0.844323,-0.00699882],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local const robtarget PlaceCartPosn04       := [[691.66,1724.02,-61.20],[0.0062829,-0.535775,0.844309,-0.00699829],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local const robtarget PlaceCartPosn05       := [[691.66,1724.02,-61.20],[0.0062829,-0.535775,0.844309,-0.00699829],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local const robtarget PlaceCartPosn06       := [[691.66,1724.02,-61.20],[0.0062829,-0.535775,0.844309,-0.00699829],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local const robtarget PlaceCartPosn07       := [[691.66,1724.02,-61.20],[0.0062829,-0.535775,0.844309,-0.00699829],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local const robtarget PlaceCartPosn08       := [[691.66,1724.02,-61.20],[0.0062829,-0.535775,0.844309,-0.00699829],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];


local var robtarget PkCartPosn01       := [[674.99,1413.94,-61.22],[0.00628194,-0.535751,0.844323,-0.00699882],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local var robtarget PkCartPosn02       := [[691.66,1724.02,-61.20],[0.0062829,-0.535775,0.844309,-0.00699829],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local var robtarget PkCartPosn03       := [[674.99,1413.94,-61.22],[0.00628194,-0.535751,0.844323,-0.00699882],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local var robtarget PkCartPosn04       := [[691.66,1724.02,-61.20],[0.0062829,-0.535775,0.844309,-0.00699829],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local var robtarget PkCartPosn05       := [[674.99,1413.94,-61.22],[0.00628194,-0.535751,0.844323,-0.00699882],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local var robtarget PkCartPosn06       := [[691.66,1724.02,-61.20],[0.0062829,-0.535775,0.844309,-0.00699829],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local var robtarget PkCartPosn07       := [[674.99,1413.94,-61.22],[0.00628194,-0.535751,0.844323,-0.00699882],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local var robtarget PkCartPosn08       := [[691.66,1724.02,-61.20],[0.0062829,-0.535775,0.844309,-0.00699829],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

local var robtarget PlCartPosn01       := [[691.66,1724.02,-61.20],[0.0062829,-0.535775,0.844309,-0.00699829],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local var robtarget PlCartPosn02       := [[691.66,1724.02,-61.20],[0.0062829,-0.535775,0.844309,-0.00699829],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local var robtarget PlCartPosn03       := [[691.66,1724.02,-61.20],[0.0062829,-0.535775,0.844309,-0.00699829],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local var robtarget PlCartPosn04       := [[691.66,1724.02,-61.20],[0.0062829,-0.535775,0.844309,-0.00699829],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local var robtarget PlCartPosn05       := [[691.66,1724.02,-61.20],[0.0062829,-0.535775,0.844309,-0.00699829],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local var robtarget PlCartPosn06       := [[691.66,1724.02,-61.20],[0.0062829,-0.535775,0.844309,-0.00699829],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local var robtarget PlCartPosn07       := [[691.66,1724.02,-61.20],[0.0062829,-0.535775,0.844309,-0.00699829],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local var robtarget PlCartPosn08       := [[691.66,1724.02,-61.20],[0.0062829,-0.535775,0.844309,-0.00699829],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

local const jointtarget PkJointPosn01    := [[39.5842,26.4985,21.3684,-1.33562,41.532,-24.2115],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local const jointtarget PkJointPosn02    := [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
local const jointtarget PkJointPosn03    := [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
local const jointtarget PkJointPosn04    := [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
local const jointtarget PkJointPosn11    := [[39.5842,26.4985,21.3684,-1.33562,41.532,-24.2115],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local const jointtarget PkJointPosn12    := [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
local const jointtarget PkJointPosn13    := [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
local const jointtarget PkJointPosn14    := [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
local const jointtarget PkJointPosn21    := [[39.5842,26.4985,21.3684,-1.33562,41.532,-24.2115],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local const jointtarget PkJointPosn22    := [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
local const jointtarget PkJointPosn23    := [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
local const jointtarget PkJointPosn24    := [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
local const jointtarget PkJointPosn31    := [[39.5842,26.4985,21.3684,-1.33562,41.532,-24.2115],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local const jointtarget PkJointPosn32    := [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
local const jointtarget PkJointPosn33    := [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
local const jointtarget PkJointPosn34    := [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
local const jointtarget PkJointPosn41    := [[39.5842,26.4985,21.3684,-1.33562,41.532,-24.2115],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local const jointtarget PkJointPosn42    := [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
local const jointtarget PkJointPosn43    := [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
local const jointtarget PkJointPosn44    := [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];

local const jointtarget PlJointPosn01    := [[64.8017,19.9752,32.0259,-1.73288,37.8349,1.376],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local const jointtarget PlJointPosn02    := [[64.8013,19.9748,32.0264,-1.73288,37.8349,1.376],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local const jointtarget PlJointPosn03    := [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
local const jointtarget PlJointPosn04    := [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
local const jointtarget PlJointPosn11    := [[64.8017,19.9752,32.0259,-1.73288,37.8349,1.376],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local const jointtarget PlJointPosn12    := [[64.8013,19.9748,32.0264,-1.73288,37.8349,1.376],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local const jointtarget PlJointPosn13    := [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
local const jointtarget PlJointPosn14    := [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
local const jointtarget PlJointPosn21    := [[64.8017,19.9752,32.0259,-1.73288,37.8349,1.376],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local const jointtarget PlJointPosn22    := [[64.8013,19.9748,32.0264,-1.73288,37.8349,1.376],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local const jointtarget PlJointPosn23    := [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
local const jointtarget PlJointPosn24    := [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
local const jointtarget PlJointPosn31    := [[64.8017,19.9752,32.0259,-1.73288,37.8349,1.376],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local const jointtarget PlJointPosn32    := [[64.8013,19.9748,32.0264,-1.73288,37.8349,1.376],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local const jointtarget PlJointPosn33    := [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
local const jointtarget PlJointPosn34    := [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
local const jointtarget PlJointPosn41    := [[64.8017,19.9752,32.0259,-1.73288,37.8349,1.376],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local const jointtarget PlJointPosn42    := [[64.8013,19.9748,32.0264,-1.73288,37.8349,1.376],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
local const jointtarget PlJointPosn43    := [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
local const jointtarget PlJointPosn44    := [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];





local proc stack_initialize_()

    ! 限位配置
    LimitUp{1}      := [3000.0, 3000.0, 3000.0];
    LimitDown{1}    := [-3000.0, -3000.0, -3000.0];
    LimitUp{2}      := [3000.0, 3000.0, 3000.0];
    LimitDown{2}    := [-3000.0, -3000.0, -3000.0];
    LimitUp{3}      := [3000.0, 3000.0, 3000.0];
    LimitDown{3}    := [-3000.0, -3000.0, -3000.0];
    LimitUp{4}      := [3000.0, 3000.0, 3000.0];
    LimitDown{4}    := [-3000.0, -3000.0, -3000.0];
    LimitUp{5}      := [3000.0, 3000.0, 3000.0];
    LimitDown{5}    := [-3000.0, -3000.0, -3000.0];
    LimitUp{6}      := [3000.0, 3000.0, 3000.0];
    LimitDown{6}    := [-3000.0, -3000.0, -3000.0];
    LimitUp{7}      := [3000.0, 3000.0, 3000.0];
    LimitDown{7}    := [-3000.0, -3000.0, -3000.0];
    LimitUp{8}      := [3000.0, 3000.0, 3000.0];
    LimitDown{8}    := [-3000.0, -3000.0, -3000.0];

    ! 通讯超时配置
    BusTimeout      := -1;

    GlobalCommandId := G_COMMAND_UNKNOWN;
    GlobalResultId  := G_RESULT_UNKNOWN;

    ToResultFlg     := false;
    KeepActive      := true;

    NewDataTable.Mode           := 0;
    NewDataTable.TaskNum        := 0;
    NewDataTable.Area           := 0;
    NewDataTable.Pip            := 0;
    NewDataTable.BoxLenght      := 0.0;
    NewDataTable.BoxWidth       := 0.0;
    NewDataTable.BoxHigh        := 0.0;
    NewDataTable.ObliPos        := null_pos_();
    NewDataTable.PickPos        := null_pos_();
    NewDataTable.PlacePos       := null_pos_();
    
    ! idelete MissCondition;
    ! connect MissCondition with trap_miss_;
    ! isleep MissCondition;
endproc

proc stack_()

    stack_initialize_;


    global_command_skill_ \COMMAND_INIT, \STACK; 


    KeepActive := (GlobalResultId = G_RESULT_OK); 

    if KeepActive
        global_command_skill_ \COMMAND_DATA1; 


    while KeepActive do

        waituntil (ToResultFlg = true), \Visualize 
                                        \Header :="CONNAND SKILL DATA01" 
                                        \Message := "Waiting For DATA01 !!!" ; 


        test GlobalResultId = G_RESULT_OK
        case true:

            NewDataTable := SensorDataTable;

            ! setgo go7,NewDataTable.Pip;
            test NewDataTable.Pip
            case 0: 
            case 0: 
            case 0: 
            case 0: 
            case 0: 
            case 0: 
            endtest

            stack_pick01_;

            if NewDataTable.Mode = COMM010_MODE_TWO then

                waituntil (ToResultFlg = true), \Visualize 
                                                \Header :="CONNAND SKILL DATA02" 
                                                \Message := "Waiting For DATA02 !!!" ; 

                if GlobalResultId <> G_RESULT_OK then

                    errwrite "STACK", "Failed Mode Two [Err :" + num_2str_(GlobalResultId \INTEGER) + "] !!!";
                    stop;
                endif

                NewDataTable := SensorDataTable;
            endif


            % "stack_place0" + num_2str_(NewDataTable.Area \INTEGER) + "_" %;
        default:

            KeepActive := false;
        endtest
    endwhile

endproc

proc unstack_()

    stack_initialize_;


    global_command_skill_ \COMMAND_INIT, \UNSTACK; 

    KeepActive := (GlobalResultId = G_RESULT_OK); 

    if KeepActive
        global_command_skill_ \COMMAND_DATA1; 

    while KeepActive do

        waituntil (ToResultFlg = true), \Visualize 
                                        \Header :="CONNAND SKILL DATA01" 
                                        \Message := "Waiting For ToResultFlg = true !!!" ; 

        test GlobalResultId = G_RESULT_OK
        case true:

            NewDataTable := SensorDataTable;

            % "unstack_pick0" + num_2str_(NewDataTable.Area \INTEGER) + "_" %;

            unstack_place01_;
        default:

            KeepActive := false;
        endtest

    endwhile

endproc

local proc stack_pick01_()

    confl\off;
    movel offs_posn_(\Posn1 := NewDataTable.PickPos, 
                     \Z     := 200.0), v1000, z100, StackTool;

        
    movel NewDataTable.PickPos, v800, fine, StackTool;

    if NewDataTable.Mode = COMM010_MODE_TWO then

        global_command_skill_ \COMMAND_DATA2; 

    endif


    movel offs_posn_(\Posn1 := NewDataTable.PickPos, 
                     \Z := 200.0), v800, z100, StackTool;

    moveabsj PkJointPosn01, v800, z100, StackTool;

    global_command_skill_ \COMMAND_AREA, \Area := 1; 

endproc

local proc stack_place01_()

    confl\off;
    moveabsj PlJointPosn11, v800, z100, StackTool;

    movel NewDataTable.ObliPos, v1000, z100, StackTool;
    movel NewDataTable.PlacePos, v800, fine, StackTool;

    global_command_skill_ \COMMAND_PKSU \TaskNum:= NewDataTable.TaskNum;
    global_command_skill_ \COMMAND_DATA1; 
    
    movel NewDataTable.ObliPos, v1000, z100, StackTool;
    moveabsj PlJointPosn12, v800, z100, StackTool;

    global_command_skill_ \COMMAND_AREA, \Area := 2; 
endproc

local proc stack_place02_()

    confl\off;
    moveabsj PlJointPosn31, v800, z100, StackTool;

    movel NewDataTable.ObliPos, v1000, z100, StackTool;
    movel NewDataTable.PlacePos, v800, fine, StackTool;

    global_command_skill_ \COMMAND_PKSU \TaskNum:= NewDataTable.TaskNum;
    global_command_skill_ \COMMAND_DATA1; 
    
    movel NewDataTable.ObliPos, v1000, z100, StackTool;

    moveabsj PlJointPosn32, v800, z100, StackTool;

    global_command_skill_ \COMMAND_AREA, \Area := 3; 
endproc


local proc unstack_pick01_()

    confl\off;
    movel offs_posn_(\Posn1 := NewDataTable.PickPos, 
                     \Z     := 200.0), v1000, z100, StackTool;

        
    movel NewDataTable.PickPos, v800, fine, StackTool;
    
    
    movel offs_posn_(\Posn1 := NewDataTable.PickPos, 
                     \Z := 200.0), v800, z100, StackTool;

    moveabsj PkJointPosn31, v800, z100, StackTool;

    global_command_skill_ \COMMAND_AREA, \Area := 2; 

endproc

local proc unstack_pick02_()

    confl\off;
    movel offs_posn_(\Posn1 := NewDataTable.PickPos, 
                     \Z     := 200.0), v1000, z100, StackTool;

        
    movel NewDataTable.PickPos, v800, fine, StackTool;
    
    
    movel offs_posn_(\Posn1 := NewDataTable.PickPos, 
                     \Z := 200.0), v800, z100, StackTool;

    moveabsj PkJointPosn41, v800, z100, StackTool;

    global_command_skill_ \COMMAND_AREA, \Area := 3; 

endproc


local proc unstack_place01_()

    confl\off;
    moveabsj PlJointPosn41, v800, z100, StackTool;
    
    movel PlaceCartPosn01, v1000, fine, StackTool;

    global_command_skill_ \COMMAND_PKSU \TaskNum:= NewDataTable.TaskNum;
    global_command_skill_ \COMMAND_DATA1; 

    movel offs_posn_(\Posn1 := PlaceCartPosn01, 
                     \Z     := 200.0), v1000, z100, StackTool;


    moveabsj PlJointPosn42, v800, z100, StackTool;
    global_command_skill_ \COMMAND_AREA, \Area := 1; 
endproc


trap trap_miss_

    global_command_skill_ \COMMAND_MISS, \TaskNum := NewDataTable.TaskNum; 
    stopmove;
    exit;
endtrap

endmodule