MODULE DEMO

PROC DEMO_MAIN1()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_MAIN1

    !********************************
    
    !Main program for picking and palletizing from multiple positions
    
    !Wait for the robot to be at HOME

    !Robot goes to the waiting position
    mov_to_pounce01_;

    !Pick selection
    DCD_PICK;

    !Placement selection
    DCD_DROP;

    !All completed
    path_segment_ 255;
    req_to_continue_;

ENDPROC

PROC DEMO_MAIN2()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_MAIN2

    !********************************

    !Main program for picking and palletizing from multiple positions
    
    !Wait for the robot to be at HOME

    !Robot goes to the waiting position
    mov_to_pounce01_;

    !Pick 
    DEMO_PICKUP01;

    !Placement
    DEMO_DROPOFF01;

    !All completed
    path_segment_ 255;
    req_to_continue_;

ENDPROC

PROC DEMO_MAIN3()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_MAIN3

    !********************************

    !Main program for picking and palletizing from multiple positions
    
    !Wait for the robot to be at HOME

    !Robot goes to the waiting position
    mov_to_pounce01_;

    !Job program
    !DCD_PROC
    DEMO_PROC01;

    !All completed
    path_segment_ 255;
    req_to_continue_;

ENDPROC

PROC DCD_PICK()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DCD_PICK

    !********************************

    !********************************
    !Pick program selection
    !********************************
    var num ProgramNo := 0;

    IF OpMode()<>OP_AUTO THEN
        log_info_ "The robot is not in External automatic mode";
        stop;
    ELSE
        ProgramNo:=ContDicitionCode;
    ENDIF

    TEST ProgramNo
    CASE 1:
        DEMO_PICKUP01;
    CASE 2:
        DEMO_PICKUP02;
    CASE 3:
        DEMO_PICKUP03;
    CASE 4:
        DEMO_PICKUP04;
    CASE 5:
        DEMO_PICKUP05;
    CASE 6:
        DEMO_PICKUP06;
    CASE 7:
        DEMO_PICKUP07;
    CASE 8:
        DEMO_PICKUP08;
    DEFAULT:
        log_error_ "PickProgramNo Not within the range of 1 to 8";
        stop;
    ENDTEST
ENDPROC

PROC DCD_DROP()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DCD_DROP

    !********************************

    !********************************
    !Drop program selection
    !********************************
    var num ProgramNo := 0;
    

    IF OpMode()<>OP_AUTO THEN
        log_info_ "The robot is not in External automatic mode";
        stop;
    ELSE
        ProgramNo:=ContDicitionCode;
    ENDIF

    TEST ProgramNo
    CASE 1:
        DEMO_DROPOFF01;
    CASE 2:
        DEMO_DROPOFF02;
    CASE 3:
        DEMO_DROPOFF03;
    CASE 4:
        DEMO_DROPOFF04;
    CASE 5:
        DEMO_DROPOFF05;
    CASE 6:
        DEMO_DROPOFF06;
    CASE 7:
        DEMO_DROPOFF07;
    CASE 8:
        DEMO_DROPOFF08;
    DEFAULT:
        log_error_ "DropProgramNo Not within the range of 1 to 8";
        stop;
    ENDTEST
ENDPROC

PROC DCD_PROC()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DCD_PROC

    !********************************

    !********************************
    !Proc program selection
    !********************************
    var num ProgramNo := 0;

    IF OpMode()<>OP_AUTO THEN
        log_info_ "The robot is not in External automatic mode";
        stop;
    ELSE
        ProgramNo:=ContDicitionCode;
    ENDIF

    TEST ProgramNo
    CASE 1:
        DEMO_PROC01;
    CASE 2:
        DEMO_PROC02;
    CASE 3:
        DEMO_PROC03;
    CASE 4:
        DEMO_PROC04;
    CASE 5:
        DEMO_PROC05;
    CASE 6:
        DEMO_PROC06;
    CASE 7:
        DEMO_PROC07;
    CASE 8:
        DEMO_PROC08;
    DEFAULT:
        log_error_ "ProcProgramNo Not within the range of 1 to 8";
        stop;
    ENDTEST
ENDPROC

PROC DEMO_PICKUP01()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_PICKUP01

    !********************************

    !Pick example program.

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 20;

    !entering interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE1;

    !Teach the robot to the Pick point
    MoveJ Pick01,v2000,z200,tool0;
    MoveJ Pick02,v2000,z200,tool0;

    !reach the Pick point
    MoveL Pick03,v1500,fine,tool0;

    !Call the end-effector control program
    !CALL End_Program()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 21;

    !Teach to lift a certain distance
    MoveL Pick04,v1500,z200,tool0;
    MoveJ Pick05,v2000,z200,tool0;

    !Sensor detection can be invoked here
    !Confirm that it has been placed down
    !CALL DetectionProcedure()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 22;

    !Teach the pick and leave trajectory
    MoveJ Pick06,v2000,z200,tool0;
    MoveJ Pick07,v2000,z200,tool0;

    !This position has been fully cleared
    !Does not interfere with the gripper and the corresponding robot.

    !Report placement complete
    path_segment_ 23;

    !Exit the interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE1;
ENDPROC

PROC DEMO_PICKUP02()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_PICKUP02

    !********************************

    !Pick example program.

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 24;

    !entering interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE1;

    !Teach the robot to the Pick point
    MoveJ Pick01,v2000,z200,tool0;
    MoveJ Pick02,v2000,z200,tool0;

    !reach the Pick point
    MoveL Pick03,v1500,fine,tool0;

    !Call the end-effector control program
    !CALL End_Program()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 25;

    !Teach to lift a certain distance
    MoveL Pick04,v1500,z200,tool0;
    MoveJ Pick05,v2000,z200,tool0;

    !Sensor detection can be invoked here
    !Confirm that it has been placed down
    !CALL DetectionProcedure()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 26;

    !Teach the pick and leave trajectory
    MoveJ Pick06,v2000,z200,tool0;
    MoveJ Pick07,v2000,z200,tool0;


    !This position has been fully cleared
    !Does not interfere with the gripper and the corresponding robot.

    !Report placement complete
    path_segment_ 27;

    !Exit the interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE1;
ENDPROC

PROC DEMO_PICKUP03()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_PICKUP03

    !********************************

    !Pick example program.

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 28;

    !entering interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE1;

    !Teach the robot to the Pick point
    MoveJ Pick01,v2000,z200,tool0;
    MoveJ Pick02,v2000,z200,tool0;

    !reach the Pick point
    MoveL Pick03,v1500,fine,tool0;

    !Call the end-effector control program
    !CALL End_Program()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 29;

    !Teach to lift a certain distance
    MoveL Pick04,v1500,z200,tool0;
    MoveJ Pick05,v2000,z200,tool0;

    !Sensor detection can be invoked here
    !Confirm that it has been placed down
    !CALL DetectionProcedure()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 30;

    !Teach the pick and leave trajectory
    MoveJ Pick06,v2000,z200,tool0;
    MoveJ Pick07,v2000,z200,tool0;

    !This position has been fully cleared
    !Does not interfere with the gripper and the corresponding robot.

    !Report placement complete
    path_segment_ 31;

    !Exit the interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE1;
ENDPROC

PROC DEMO_PICKUP04()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_PICKUP04

    !********************************

    !Pick example program.

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 32;

    !entering interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE1;

    !Teach the robot to the Pick point
    MoveJ Pick01,v2000,z200,tool0;
    MoveJ Pick02,v2000,z200,tool0;

    !reach the Pick point
    MoveL Pick03,v1500,fine,tool0;

    !Call the end-effector control program
    !CALL End_Program()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 33;

    !Teach to lift a certain distance
    MoveL Pick04,v1500,z200,tool0;
    MoveJ Pick05,v2000,z200,tool0;

    !Sensor detection can be invoked here
    !Confirm that it has been placed down
    !CALL DetectionProcedure()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 34;

    !Teach the pick and leave trajectory
    MoveJ Pick06,v2000,z200,tool0;
    MoveJ Pick07,v2000,z200,tool0;

    !This position has been fully cleared
    !Does not interfere with the gripper and the corresponding robot.

    !Report placement complete
    path_segment_ 35;

    !Exit the interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE1;
ENDPROC

PROC DEMO_PICKUP05()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_PICKUP05

    !********************************

    !Pick example program.

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 36;

    !entering interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE1;

    !Teach the robot to the Pick point
    MoveJ Pick01,v2000,z200,tool0;
    MoveJ Pick02,v2000,z200,tool0;

    !reach the Pick point
    MoveL Pick03,v1500,fine,tool0;

    !Call the end-effector control program
    !CALL End_Program()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 37;

    !Teach to lift a certain distance
    MoveL Pick04,v1500,z200,tool0;
    MoveJ Pick05,v2000,z200,tool0;

    !Sensor detection can be invoked here
    !Confirm that it has been placed down
    !CALL DetectionProcedure()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 38;

    !Teach the pick and leave trajectory
    MoveJ Pick06,v2000,z200,tool0;
    MoveJ Pick07,v2000,z200,tool0;

    !This position has been fully cleared
    !Does not interfere with the gripper and the corresponding robot.

    !Report placement complete
    path_segment_ 39;

    !Exit the interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE1;
ENDPROC

PROC DEMO_PICKUP06()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_PICKUP06

    !********************************

    !Pick example program.

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 40;

    !entering interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE1;

    !Teach the robot to the Pick point
    MoveJ Pick01,v2000,z200,tool0;
    MoveJ Pick02,v2000,z200,tool0;

    !reach the Pick point
    MoveL Pick03,v1500,fine,tool0;

    !Call the end-effector control program
    !CALL End_Program()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 41;

    !Teach to lift a certain distance
    MoveL Pick04,v1500,z200,tool0;
    MoveJ Pick05,v2000,z200,tool0;

    !Sensor detection can be invoked here
    !Confirm that it has been placed down
    !CALL DetectionProcedure()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 42;

    !Teach the pick and leave trajectory
    MoveJ Pick06,v2000,z200,tool0;
    MoveJ Pick07,v2000,z200,tool0;

    !This position has been fully cleared
    !Does not interfere with the gripper and the corresponding robot.

    !Report placement complete
    path_segment_ 43;

    !Exit the interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE1;
ENDPROC

PROC DEMO_PICKUP07()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_PICKUP07

    !********************************

    !Pick example program.

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 44;

    !entering interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE1;

    !Teach the robot to the Pick point
    MoveJ Pick01,v2000,z200,tool0;
    MoveJ Pick02,v2000,z200,tool0;

    !reach the Pick point
    MoveL Pick03,v1500,fine,tool0;

    !Call the end-effector control program
    !CALL End_Program()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 45;

    !Teach to lift a certain distance
    MoveL Pick04,v1500,z200,tool0;
    MoveJ Pick05,v2000,z200,tool0;

    !Sensor detection can be invoked here
    !Confirm that it has been placed down
    !CALL DetectionProcedure()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 46;

    !Teach the pick and leave trajectory
    MoveJ Pick06,v2000,z200,tool0;
    MoveJ Pick07,v2000,z200,tool0;

    !This position has been fully cleared
    !Does not interfere with the gripper and the corresponding robot.

    !Report placement complete
    path_segment_ 47;

    !Exit the interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE1;
ENDPROC

PROC DEMO_PICKUP08()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_PICKUP08

    !********************************

    !Pick example program.

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 48;

    !entering interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE1;

    !Teach the robot to the Pick point
    MoveJ Pick01,v2000,z200,tool0;
    MoveJ Pick02,v2000,z200,tool0;

    !reach the Pick point
    MoveL Pick03,v1500,fine,tool0;

    !Call the end-effector control program
    !CALL End_Program()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 49;

    !Teach to lift a certain distance
    MoveL Pick04,v1500,z200,tool0;
    MoveJ Pick05,v2000,z200,tool0;

    !Sensor detection can be invoked here
    !Confirm that it has been placed down
    !CALL DetectionProcedure()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 50;

    !Teach the pick and leave trajectory
    MoveJ Pick06,v2000,z200,tool0;
    MoveJ Pick07,v2000,z200,tool0;

    !This position has been fully cleared
    !Does not interfere with the gripper and the corresponding robot.

    !Report placement complete
    path_segment_ 51;

    !Exit the interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE1;
ENDPROC

PROC DEMO_DROPOFF01()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_DROPOFF01

    !********************************

    !place example code

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 60;

    !entering interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE1;

    !teach the robot to the placement point
    MoveJ Drop01,v2000,z200,tool0;
    MoveJ Drop02,v2000,z200,tool0;
    MoveL Drop03,v2000,z200,tool0;

    !reach the placement point
    MoveL Drop04,v2000,fine,tool0;

    !Call the end-effector control program
    !CALL End_Program()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 61;

    !Teach to lift a certain distance
    MoveL Drop05,v2000,z200,tool0;
    MoveL Drop06,v2000,z200,tool0;

    !Sensor detection can be invoked here
    !Confirm that it has been placed down
    !CALL DetectionProcedure()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 62;

    !Teach the placement and leave trajectory
    MoveJ Drop07,v2000,z200,tool0;
    MoveJ Drop08,v2000,z200,tool0;

    !This position has been fully cleared
    !Does not interfere with the gripper and the corresponding robot.

    !Report placement complete
    path_segment_ 63;

    !Exit the interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE1;
ENDPROC

PROC DEMO_DROPOFF02()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_DROPOFF02

    !********************************

    !place example code

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 64;

    !entering interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE1;

    !teach the robot to the placement point
    MoveJ Drop01,v2000,z200,tool0;
    MoveJ Drop02,v2000,z200,tool0;
    MoveL Drop03,v2000,z200,tool0;
    
    !reach the placement point
    MoveL Drop04,v2000,fine,tool0;
    
    !Call the end-effector control program
    !CALL End_Program()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 65;

    !Teach to lift a certain distance
    MoveL Drop05,v2000,z200,tool0;
    MoveL Drop06,v2000,z200,tool0;

    !Sensor detection can be invoked here
    !Confirm that it has been placed down
    !CALL DetectionProcedure()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 66;

    !Teach the placement and leave trajectory
    MoveJ Drop07,v2000,z200,tool0;
    MoveJ Drop08,v2000,z200,tool0;

    !This position has been fully cleared
    !Does not interfere with the gripper and the corresponding robot.

    !Report placement complete
    path_segment_ 67;

    !Exit the interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE1;
ENDPROC

PROC DEMO_DROPOFF03()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_DROPOFF03

    !********************************

    !place example code

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 68;

    !entering interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE1;

    !teach the robot to the placement point
    MoveJ Drop01,v2000,z200,tool0;
    MoveJ Drop02,v2000,z200,tool0;
    MoveL Drop03,v2000,z200,tool0;
    
    !reach the placement point
    MoveL Drop04,v2000,fine,tool0;
    
    !Call the end-effector control program
    !CALL End_Program()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 69;

    !Teach to lift a certain distance
    MoveL Drop05,v2000,z200,tool0;
    MoveL Drop06,v2000,z200,tool0;

    !Sensor detection can be invoked here
    !Confirm that it has been placed down
    !CALL DetectionProcedure()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 70;

    !Teach the placement and leave trajectory
    MoveJ Drop07,v2000,z200,tool0;
    MoveJ Drop08,v2000,z200,tool0;

    !This position has been fully cleared
    !Does not interfere with the gripper and the corresponding robot.

    !Report placement complete
    path_segment_ 71;

    !Exit the interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE1;
ENDPROC

PROC DEMO_DROPOFF04()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_DROPOFF04

    !********************************

    !place example code

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 72;

    !entering interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE1;

    !teach the robot to the placement point
    MoveJ Drop01,v2000,z200,tool0;
    MoveJ Drop02,v2000,z200,tool0;
    MoveL Drop03,v2000,z200,tool0;
    
    !reach the placement point
    MoveL Drop04,v2000,fine,tool0;
    
    !Call the end-effector control program
    !CALL End_Program()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 73;

    !Teach to lift a certain distance
    MoveL Drop05,v2000,z200,tool0;
    MoveL Drop06,v2000,z200,tool0;

    !Sensor detection can be invoked here
    !Confirm that it has been placed down
    !CALL DetectionProcedure()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 74;

    !Teach the placement and leave trajectory
    MoveJ Drop07,v2000,z200,tool0;
    MoveJ Drop08,v2000,z200,tool0;

    !This position has been fully cleared
    !Does not interfere with the gripper and the corresponding robot.

    !Report placement complete
    path_segment_ 75;

    !Exit the interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE1;
ENDPROC

PROC DEMO_DROPOFF05()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_DROPOFF05

    !********************************

    !place example code

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 76;

    !entering interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE1;

    !teach the robot to the placement point
    MoveJ Drop01,v2000,z200,tool0;
    MoveJ Drop02,v2000,z200,tool0;
    MoveL Drop03,v2000,z200,tool0;
    
    !reach the placement point
    MoveL Drop04,v2000,fine,tool0;
    
    !Call the end-effector control program
    !CALL End_Program()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 77;

    !Teach to lift a certain distance
    MoveL Drop05,v2000,z200,tool0;
    MoveL Drop06,v2000,z200,tool0;

    !Sensor detection can be invoked here
    !Confirm that it has been placed down
    !CALL DetectionProcedure()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 78;

    !Teach the placement and leave trajectory
    MoveJ Drop07,v2000,z200,tool0;
    MoveJ Drop08,v2000,z200,tool0;

    !This position has been fully cleared
    !Does not interfere with the gripper and the corresponding robot.

    !Report placement complete
    path_segment_ 79;

    !Exit the interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE1;
ENDPROC

PROC DEMO_DROPOFF06()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_DROPOFF06

    !********************************

    !place example code

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 80;

    !entering interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE1;

    !teach the robot to the placement point
    MoveJ Drop01,v2000,z200,tool0;
    MoveJ Drop02,v2000,z200,tool0;
    MoveL Drop03,v2000,z200,tool0;
    
    !reach the placement point
    MoveL Drop04,v2000,fine,tool0;
    
    !Call the end-effector control program
    !CALL End_Program()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 81;

    !Teach to lift a certain distance
    MoveL Drop05,v2000,z200,tool0;
    MoveL Drop06,v2000,z200,tool0;

    !Sensor detection can be invoked here
    !Confirm that it has been placed down
    !CALL DetectionProcedure()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 82;

    !Teach the placement and leave trajectory
    MoveJ Drop07,v2000,z200,tool0;
    MoveJ Drop08,v2000,z200,tool0;

    !This position has been fully cleared
    !Does not interfere with the gripper and the corresponding robot.

    !Report placement complete
    path_segment_ 83;

    !Exit the interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE1;
ENDPROC

PROC DEMO_DROPOFF07()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_DROPOFF07

    !********************************

    !place example code

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 84;

    !entering interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE1;

    !teach the robot to the placement point
    MoveJ Drop01,v2000,z200,tool0;
    MoveJ Drop02,v2000,z200,tool0;
    MoveL Drop03,v2000,z200,tool0;
    
    !reach the placement point
    MoveL Drop04,v2000,fine,tool0;
    
    !Call the end-effector control program
    !CALL End_Program()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 85;

    !Teach to lift a certain distance
    MoveL Drop05,v2000,z200,tool0;
    MoveL Drop06,v2000,z200,tool0;

    !Sensor detection can be invoked here
    !Confirm that it has been placed down
    !CALL DetectionProcedure()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 86;

    !Teach the placement and leave trajectory
    MoveJ Drop07,v2000,z200,tool0;
    MoveJ Drop08,v2000,z200,tool0;

    !This position has been fully cleared
    !Does not interfere with the gripper and the corresponding robot.

    !Report placement complete
    path_segment_ 87;

    !Exit the interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE1;
ENDPROC

PROC DEMO_DROPOFF08()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_DROPOFF08

    !********************************

    !place example code

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 88;

    !entering interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE1;

    !teach the robot to the placement point
    MoveJ Drop01,v2000,z200,tool0;
    MoveJ Drop02,v2000,z200,tool0;
    MoveL Drop03,v2000,z200,tool0;
    
    !reach the placement point
    MoveL Drop04,v2000,fine,tool0;
    
    !Call the end-effector control program
    !CALL End_Program()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 89;

    !Teach to lift a certain distance
    MoveL Drop05,v2000,z200,tool0;
    MoveL Drop06,v2000,z200,tool0;

    !Sensor detection can be invoked here
    !Confirm that it has been placed down
    !CALL DetectionProcedure()

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 90;

    !Teach the placement and leave trajectory
    MoveJ Drop07,v2000,z200,tool0;
    MoveJ Drop08,v2000,z200,tool0;

    !This position has been fully cleared
    !Does not interfere with the gripper and the corresponding robot.

    !Report placement complete
    path_segment_ 91;

    !Exit the interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE1;
ENDPROC

PROC DEMO_MULTIPROC01()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_MULTIPROC01

    !********************************

    !Example program for Process 1
    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 120;

    !entering interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE1;

    !Teach the robot to execute the first process trajectory.
    MoveJ MultiProc01,v1000,z100,tool0;
    MoveL MultiProc02,v1000,z100,tool0;
    MoveJ MultiProc03,v1000,z100,tool0;
    MoveL MultiProc04,v1000,z100,tool0;
    MoveJ MultiProc05,v1000,z100,tool0;

    !This position has been fully cleared
    !Does not interfere with the gripper and the corresponding robot.

    !Report the completion of the first process cycle
    path_segment_ 150;

    !Exit the interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE1;

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 121;

    !entering interference zone 2 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE2;

    !Teach the robot to execute the first process trajectory.
    MoveJ MultiProc06,v1000,z100,tool0;
    MoveL MultiProc07,v1000,z100,tool0;
    MoveJ MultiProc08,v1000,z100,tool0;
    MoveL MultiProc09,v1000,z100,tool0;
    MoveJ MultiProc10,v1000,z100,tool0;
    
    !Report the completion of the first process cycle
    path_segment_ 151;

    !Exit the interference zone 2 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE2;
ENDPROC

PROC DEMO_MULTIPROC02()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_MULTIPROC02

    !********************************

    !Example program for Process 2
    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 122;

    !entering interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE1;

    !Teach the robot to execute the first process trajectory.
    MoveJ MultiProc01,v1000,z100,tool0;
    MoveL MultiProc02,v1000,z100,tool0;
    MoveJ MultiProc03,v1000,z100,tool0;
    MoveL MultiProc04,v1000,z100,tool0;
    MoveJ MultiProc05,v1000,z100,tool0;

    !This position has been fully cleared
    !Does not interfere with the gripper and the corresponding robot.

    !Report the completion of the first process cycle
    path_segment_ 152;

    !Exit the interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE1;

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 123;

    !entering interference zone 2 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE2;

    !Teach the robot to execute the first process trajectory.
    MoveJ MultiProc06,v1000,z100,tool0;
    MoveL MultiProc07,v1000,z100,tool0;
    MoveJ MultiProc08,v1000,z100,tool0;
    MoveL MultiProc09,v1000,z100,tool0;
    MoveJ MultiProc10,v1000,z100,tool0;
    
    !Report the completion of the first process cycle
    path_segment_ 153;

    !Exit the interference zone 2 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE2;
ENDPROC

PROC DEMO_MULTIPROC03()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_MULTIPROC03

    !********************************

    !Example program for Process 3
    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 124;

    !entering interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE1;

    !Teach the robot to execute the first process trajectory.
    MoveJ MultiProc01,v1000,z100,tool0;
    MoveL MultiProc02,v1000,z100,tool0;
    MoveJ MultiProc03,v1000,z100,tool0;
    MoveL MultiProc04,v1000,z100,tool0;
    MoveJ MultiProc05,v1000,z100,tool0;

    !This position has been fully cleared
    !Does not interfere with the gripper and the corresponding robot.

    !Report the completion of the first process cycle
    path_segment_ 154;

    !Exit the interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE1;

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 125;

    !entering interference zone 2 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE2;

    !Teach the robot to execute the first process trajectory.
    MoveJ MultiProc06,v1000,z100,tool0;
    MoveL MultiProc07,v1000,z100,tool0;
    MoveJ MultiProc08,v1000,z100,tool0;
    MoveL MultiProc09,v1000,z100,tool0;
    MoveJ MultiProc10,v1000,z100,tool0;
    
    !Report the completion of the first process cycle
    path_segment_ 155;

    !Exit the interference zone 2 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE2;
ENDPROC

PROC DEMO_MULTIPROC04()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_MULTIPROC04

    !********************************

    !Example program for Process 4
    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 126;

    !entering interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE1;

    !Teach the robot to execute the first process trajectory.
    MoveJ MultiProc01,v1000,z100,tool0;
    MoveL MultiProc02,v1000,z100,tool0;
    MoveJ MultiProc03,v1000,z100,tool0;
    MoveL MultiProc04,v1000,z100,tool0;
    MoveJ MultiProc05,v1000,z100,tool0;

    !This position has been fully cleared
    !Does not interfere with the gripper and the corresponding robot.

    !Report the completion of the first process cycle
    path_segment_ 156;

    !Exit the interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE1;

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 127;

    !entering interference zone 2 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE2;

    !Teach the robot to execute the first process trajectory.
    MoveJ MultiProc06,v1000,z100,tool0;
    MoveL MultiProc07,v1000,z100,tool0;
    MoveJ MultiProc08,v1000,z100,tool0;
    MoveL MultiProc09,v1000,z100,tool0;
    MoveJ MultiProc10,v1000,z100,tool0;
    
    !Report the completion of the first process cycle
    path_segment_ 157;

    !Exit the interference zone 2 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE2;
ENDPROC

PROC DEMO_PROC01()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_PROC01

    !********************************

    !Example program for Process 1

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 120;

    !entering interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE1;

    !Teach the robot the process trajectory
    MoveJ Proc01,v800,z100,tool0;
    MoveJ Proc02,v800,z100,tool0;
    MoveL Proc03,v800,z100,tool0;
    MoveL Proc04,v800,z100,tool0;
    MoveJ Proc05,v800,z100,tool0;

    !This position has been fully cleared
    !Does not interfere with the gripper and the corresponding robot.

    !Report placement complete
    path_segment_ 150;

    !Exit the interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE1;
ENDPROC

PROC DEMO_PROC02()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_PROC02

    !********************************

    !Example program for Process 2

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 121;

    !entering interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE1;

    !Teach the robot the process trajectory
    MoveJ Proc01,v800,z100,tool0;
    MoveJ Proc02,v800,z100,tool0;
    MoveL Proc03,v800,z100,tool0;
    MoveL Proc04,v800,z100,tool0;
    MoveJ Proc05,v800,z100,tool0;

    !This position has been fully cleared
    !Does not interfere with the gripper and the corresponding robot.

    !Report placement complete
    path_segment_ 151;

    !Exit the interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE1;
ENDPROC

PROC DEMO_PROC03()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_PROC03

    !********************************

    !Example program for Process 3

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 122;

    !entering interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE1;

    !Teach the robot the process trajectory
    MoveJ Proc01,v800,z100,tool0;
    MoveJ Proc02,v800,z100,tool0;
    MoveL Proc03,v800,z100,tool0;
    MoveL Proc04,v800,z100,tool0;
    MoveJ Proc05,v800,z100,tool0;

    !This position has been fully cleared
    !Does not interfere with the gripper and the corresponding robot.

    !Report placement complete
    path_segment_ 152;

    !Exit the interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE1;
ENDPROC

PROC DEMO_PROC04()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_PROC04

    !********************************

    !Example program for Process 4

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 123;

    !entering interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE1;

    !Teach the robot the process trajectory
    MoveJ Proc01,v800,z100,tool0;
    MoveJ Proc02,v800,z100,tool0;
    MoveL Proc03,v800,z100,tool0;
    MoveL Proc04,v800,z100,tool0;
    MoveJ Proc05,v800,z100,tool0;

    !This position has been fully cleared
    !Does not interfere with the gripper and the corresponding robot.

    !Report placement complete
    path_segment_ 153;

    !Exit the interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE1;
ENDPROC

PROC DEMO_PROC05()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_PROC05

    !********************************

    !Example program for Process 5

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 124;

    !entering interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE1;

    !Teach the robot the process trajectory
    MoveJ Proc01,v800,z100,tool0;
    MoveJ Proc02,v800,z100,tool0;
    MoveL Proc03,v800,z100,tool0;
    MoveL Proc04,v800,z100,tool0;
    MoveJ Proc05,v800,z100,tool0;

    !This position has been fully cleared
    !Does not interfere with the gripper and the corresponding robot.

    !Report placement complete
    path_segment_ 154;

    !Exit the interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE1;
ENDPROC

PROC DEMO_PROC06()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_PROC06

    !********************************

    !Example program for Process 6

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 125;

    !entering interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE1;

    !Teach the robot the process trajectory
    MoveJ Proc01,v800,z100,tool0;
    MoveJ Proc02,v800,z100,tool0;
    MoveL Proc03,v800,z100,tool0;
    MoveL Proc04,v800,z100,tool0;
    MoveJ Proc05,v800,z100,tool0;

    !This position has been fully cleared
    !Does not interfere with the gripper and the corresponding robot.

    !Report placement complete
    path_segment_ 155;

    !Exit the interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE1;
ENDPROC

PROC DEMO_PROC07()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_PROC07

    !********************************

    !Example program for Process 7

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 126;

    !entering interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE1;

    !Teach the robot the process trajectory
    MoveJ Proc01,v800,z100,tool0;
    MoveJ Proc02,v800,z100,tool0;
    MoveL Proc03,v800,z100,tool0;
    MoveL Proc04,v800,z100,tool0;
    MoveJ Proc05,v800,z100,tool0;

    !This position has been fully cleared
    !Does not interfere with the gripper and the corresponding robot.

    !Report placement complete
    path_segment_ 156;

    !Exit the interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE1;
ENDPROC

PROC DEMO_PROC08()
    !********************************

    !CREATOR : SPEEDBOT
    !DATE    : 2024-09-23
    !PROGRAM : DEMO_PROC08

    !********************************

    !Example program for Process 8

    !waiting for PLC clearance to proceed
    req_to_continue_;
    path_segment_ 127;

    !entering interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_ENTER\ZONE1;

    !Teach the robot the process trajectory
    MoveJ Proc01,v800,z100,tool0;
    MoveJ Proc02,v800,z100,tool0;
    MoveL Proc03,v800,z100,tool0;
    MoveL Proc04,v800,z100,tool0;
    MoveJ Proc05,v800,z100,tool0;

    !This position has been fully cleared
    !Does not interfere with the gripper and the corresponding robot.

    !Report placement complete
    path_segment_ 157;

    !Exit the interference zone 1 with robot *.
    !Enter Zone With R***
    zone_ctrl_\I_EXIT\ZONE1;
ENDPROC
ENDMODULE