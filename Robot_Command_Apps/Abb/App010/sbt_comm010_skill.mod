module sbt_comm010_skill
!***********************************************************
!
! Copyright 2018 - 2024 speedbot All Rights reserved.
!
! file Name: sbt_comm010_skill
! 
!  Description:
!    Language             ==   Rapid for ABB ROBOT
!    Date                 ==   2024 - 05 - 21
!    Modification Data    ==   2024 - 05 - 21
! 
!  Author: speedbot
! 
!  Version: 3.0
! ***********************************************************


proc global_command_skill_(\switch COMMAND_INIT | 
                            switch COMMAND_DATA1 |
                            switch COMMAND_DATA2 |
                            switch COMMAND_PKSU |
                            switch COMMAND_MISS |
                            switch COMMAND_PRESS |
                            switch COMMAND_PKFL |
                            switch COMMAND_AREA , 
                            \switch STACK | switch UNSTACK,
                            \byte TaskNum, 
                            \byte Area)



    if GlobalCommandId <> 0 then 

        waituntil (GlobalCommandId = 0), \Visualize 
                                    \Header :="Command SKILL" 
                                    \Message := "Waiting For GlobalCommandId = 0 !!!" ;
    endif


    if present(COMMAND_INIT) then 

        ToResultFlg := false;
        GlobalResultId := G_RESULT_UNKNOWN;


        if not (present(STACK) or present(UNSTACK)) then
            errwrite "Option Parm Error", "STACK OR UNSTACK";   
            stop;
        endif

        if present(STACK) then
            RobotDataTable.WorkMode := 1;
        else
            RobotDataTable.WorkMode := 2;
        endif

        GlobalCommandId := G_COMMAND_INIT;
        waituntil (ToResultFlg = true), \Visualize 
                                        \Header :="Command SKILL" 
                                        \Message := "Waiting For COMMAND_INIT !!!" ;

        return;
    endif


    if present(COMMAND_DATA1) then 

        ToResultFlg := false;
        GlobalResultId := G_RESULT_UNKNOWN;

        GlobalCommandId := G_COMMAND_DATA1;
        return;
    endif


    if present(COMMAND_DATA2) then 

        ToResultFlg := false;
        GlobalResultId := G_RESULT_UNKNOWN;

        GlobalCommandId := G_COMMAND_DATA2;
        ! waituntil (ToResultFlg = true), \Visualize 
        !                             \Header :="Command SKILL" 
        !                             \Message := "Waiting For COMMAND_DATA2 !!!" ;

        return;
    endif


    if present(COMMAND_PKSU) then 

        if not present(TaskNum)  then
            errwrite "Option Parm Error", "TaskNum Is Invaild";   
            stop;
        endif

        RobotDataTable.TaskNum := TaskNum;
        GlobalCommandId := G_COMMAND_PKSU;

        return;
    endif

    if present(COMMAND_MISS) then 

        if not present(TaskNum)  then
            errwrite "Option Parm Error", "TaskNum Is Invaild";   
            stop;
        endif

        RobotDataTable.TaskNum := TaskNum;
        GlobalCommandId := G_COMMAND_MISS;

        return;
    endif


    if present(COMMAND_PRESS) then 

        if not present(TaskNum)  then
            errwrite "Option Parm Error", "TaskNum Is Invaild";   
            stop;
        endif

        RobotDataTable.TaskNum := TaskNum;
        GlobalCommandId := G_COMMAND_PRESS;

        return;
    endif

    if present(COMMAND_PKFL) then 

        if not present(TaskNum)  then
            errwrite "Option Parm Error", "TaskNum Is Invaild";   
            stop;
        endif

        RobotDataTable.TaskNum := TaskNum;
        GlobalCommandId := G_COMMAND_PKFL;

        return;
    endif

    if present(G_COMMAND_AREA) then 

        if not present(Area)  then
            errwrite "Option Parm Error", "Area Is Invaild";   
            stop;
        endif

        RobotDataTable.Area := Area;
        GlobalCommandId := G_COMMAND_AREA;

        return;
    endif

    errwrite "Option Parm Error", "Param 1 Invaild";   
    stop;
endproc
endmodule