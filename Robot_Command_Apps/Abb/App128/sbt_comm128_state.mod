module sbt_comm128_state
!***********************************************************
!
! Copyright 2018 - 2024 speedbot All Rights reserved.
!
! file Name: sbt_comm128_state
! 
!  Description:
!    Language             ==   RAPID for ABB ROBOT
!    Date                 ==   2024 - 03 - 05
!    Modification Data    ==   2024 - 09 - 12
! 
!  Author: speedbot
! 
!  Version: 3.0
! ***********************************************************

local record drv_stat_t  ! Define a record type named drv_stat_t to store driver status information
    pack_head_t DrvHead;  ! Header part of the package
    byte State;           ! State byte of the driver
    byte NumOfRobAxis;    ! Number of linear axes of the robot
    byte NumOfRotAxis;    ! Number of rotational axes
    byte Reserverd1;      ! Reserved field, possibly for future use
    num MoveId;           ! Movement ID, identifying a specific move command
    string DinVal;        ! Digital input value (in string format)
    jointtarget Joints;   ! Position target in joint coordinates
    num ProcessPrm01;     ! Process parameter 1
    num ProcessPrm02;     ! Process parameter 2
    num ProcessPrm03;     ! Process parameter 3
    num ProcessPrm04;     ! Process parameter 4
    num ProcessPrm05;     ! Process parameter 5
    num ProcessPrm06;     ! Process parameter 6
    pack_tail_t DrvTail;  ! Footer part of the package
endrecord

local var errnum Status := NG;  ! Define an error status variable with default value NG (Not Good)
local var socketdev UdpSocket;  ! Declare a UDP socket device variable
local var udp_cfg_t UdpConfig := ["", 0, "", 12002, 0, 0];  ! UDP configuration structure with default values
local var rawbytes Packages;  ! Variable to hold raw bytes data
!
local var drv_stat_t StatePackage;  ! Variable to hold the driver status package
!
!
local var signalgi DrvSignalGi{8};
local var byte DrvSignalGiVal{8} := [0, 0, 0, 0, 0, 0, 0, 0];

local var signaldo IsExecuting;
local var signaldo IsFault;
local var signaldo IsNotMoving;


proc main()

!
UDP_CREATE:
    ! UDP Network Connection
    !
    ! This section initializes the UDP network connection.
    ! It attempts to create the UDP socket and retries if the creation fails.
    
    log_info_ "UDP Network Create";  
    Status := NG;  ! Set the initial status to NG (Not Good)

    ! Set the external host address
    UdpConfig.ExternalHost := CtrlIpAddr;  ! Set the ExternalHost to CtrlIpAddr

    ! Loop until the UDP socket is successfully created
    while Status = NG do
        waittime TRY_CONN_TM;                           ! Wait for 0.5 seconds before retrying
        udp_close_ UdpSocket, UdpConfig;                ! Close the existing UDP socket, if any
        Status := udp_create_(UdpSocket, UdpConfig);    ! Attempt to create the UDP socket and update the status
    endwhile                                            ! Continue looping until the UDP socket is successfully created

    log_info_ "UDP Created";

    ! Initialize the driver status package with default values
    StatePackage.DrvHead := [PACK_HEADER, 16 + 23 * 4 + 4, 1, 255, TYPE_ABB, 0, 0];    ! Set the header with specific values
    StatePackage.DrvTail := PACK_TAIL;                                          ! Set the footer
    StatePackage.DrvHead.VirtualRob := IsVirRobId;

    StatePackage.State := 0;                                                    ! Set the state to 0 (default state)
    StatePackage.NumOfRobAxis := NumOfRobAxis;                                  ! Set the number of Robot axes
    StatePackage.NumOfRotAxis := NumOfRotAxis;                                  ! Set the number of rotational axes
    StatePackage.Reserverd1 := 0;                                               ! Set the reserved byte to 0

    StatePackage.MoveId := 0;                                                   ! Set the move ID to 0
    StatePackage.DinVal := chr_(0) + chr_(0) + chr_(0) + chr_(0) + chr_(0) + chr_(0) + chr_(0) + chr_(0);  ! Set the digital input value to a null string
    StatePackage.ProcessPrm01 := 0.0;  ! Set the first process parameter to 0.0
    StatePackage.ProcessPrm02 := 0.0;  ! Set the second process parameter to 0.0
    StatePackage.ProcessPrm03 := 0.0;  ! Set the third process parameter to 0.0
    StatePackage.ProcessPrm04 := 0.0;  ! Set the fourth process parameter to 0.0
    StatePackage.ProcessPrm05 := 0.0;  ! Set the fifth process parameter to 0.0
    StatePackage.ProcessPrm06 := 0.0;  ! Set the sixth process parameter to 0.0

    StatRestart := false;

    alias_drv_di_ InMapName;

    alias_state_;

    while (Status = OK) and (StatRestart = false) do

        ! Initialize the state package's state field
        StatePackage.State := 0;  ! Initialize the state field to 0

        ! Update the sequence number
        StatePackage.DrvHead.Seq := tern_num_(StatePackage.DrvHead.Seq < 255, StatePackage.DrvHead.Seq + 1, 1);  ! Increment the sequence number if it's less than 255; otherwise, set it to 1

        ! Check if only collecting data
        if not OnlyCollect then  ! If it's not only collecting data
            
            ! Check if the robot is executing a task
            if validio(IsExecuting) then
                if doutput(IsExecuting) = 1
                    StatePackage.State := bitor(StatePackage.State, 1);  ! Set the first bit of the state field to 1 if the robot is executing a task
            endif
        endif

        ! Check if the robot has completed a task
        if validio(IsExecuting) then
            if doutput(IsExecuting) = 0
                StatePackage.State := bitor(StatePackage.State, 2);  ! Set the second bit of the state field to 1 if the robot has completed a task
        endif

        ! Check if the robot has a fault
        if validio(IsFault) then
            if doutput(IsFault) = 1
                StatePackage.State := bitor(StatePackage.State, 4);  ! Set the third bit of the state field to 1 if the robot has a fault
        endif

        ! Check if the robot is moving
        if validio(IsNotMoving) then
            if doutput(IsNotMoving) = 0
                StatePackage.State := bitor(StatePackage.State, 8);  ! Set the fourth bit of the state field to 1 if the robot is moving
        endif

        ! Get the current robot's joint angles
        StatePackage.Joints := cur_jpos_();  ! Assign the current robot's joint angles to the Joints field in the state package

        StatePackage.MoveId := GlbMoveId;                                               

        if validio(DrvSignalGi{1}) then DrvSignalGiVal{1} := ginput(DrvSignalGi{1}); else DrvSignalGiVal{1} :=0; endif
        if validio(DrvSignalGi{2}) then DrvSignalGiVal{2} := ginput(DrvSignalGi{2}); else DrvSignalGiVal{2} :=0; endif
        if validio(DrvSignalGi{3}) then DrvSignalGiVal{3} := ginput(DrvSignalGi{3}); else DrvSignalGiVal{3} :=0; endif
        if validio(DrvSignalGi{4}) then DrvSignalGiVal{4} := ginput(DrvSignalGi{4}); else DrvSignalGiVal{4} :=0; endif
        if validio(DrvSignalGi{5}) then DrvSignalGiVal{5} := ginput(DrvSignalGi{5}); else DrvSignalGiVal{5} :=0; endif
        if validio(DrvSignalGi{6}) then DrvSignalGiVal{6} := ginput(DrvSignalGi{6}); else DrvSignalGiVal{6} :=0; endif
        if validio(DrvSignalGi{7}) then DrvSignalGiVal{7} := ginput(DrvSignalGi{7}); else DrvSignalGiVal{7} :=0; endif
        if validio(DrvSignalGi{8}) then DrvSignalGiVal{8} := ginput(DrvSignalGi{8}); else DrvSignalGiVal{8} :=0; endif

        StatePackage.DinVal := chr_(DrvSignalGiVal{1}) + 
                               chr_(DrvSignalGiVal{2}) + 
                               chr_(DrvSignalGiVal{3}) + 
                               chr_(DrvSignalGiVal{4}) + 
                               chr_(DrvSignalGiVal{5}) + 
                               chr_(DrvSignalGiVal{6}) + 
                               chr_(DrvSignalGiVal{7}) + 
                               chr_(DrvSignalGiVal{8}); 


        pack_head_ Packages, StatePackage.DrvHead;                                                          ! Start packing header information
        packrawbytes StatePackage.State,                Packages, rawbyteslen(Packages) + 1, \ASCII;        ! Pack state information
        packrawbytes StatePackage.NumOfRobAxis,         Packages, rawbyteslen(Packages) + 1, \ASCII;        ! Pack number of robot axes
        packrawbytes StatePackage.NumOfRotAxis,         Packages, rawbyteslen(Packages) + 1, \ASCII;        ! Pack number of rotational axes
        packrawbytes StatePackage.Reserverd1,           Packages, rawbyteslen(Packages) + 1, \ASCII;        ! Pack reserved field (for future use or alignment)
        packrawbytes StatePackage.MoveId,               Packages, rawbyteslen(Packages) + 1, \IntX := DINT; ! Pack move ID (identifies a specific action or task)
        packrawbytes StatePackage.DinVal,               Packages, rawbyteslen(Packages) + 1, \ASCII;        ! Pack digital input value (status of digital inputs)
        packrawbytes StatePackage.Joints.robax.rax_1,   Packages, rawbyteslen(Packages) + 1, \FLOAT4;       ! Pack first robot joint angle (position of the first robot axis)
        packrawbytes StatePackage.Joints.robax.rax_2,   Packages, rawbyteslen(Packages) + 1, \FLOAT4;       ! Pack second robot joint angle (position of the second robot axis)
        packrawbytes StatePackage.Joints.robax.rax_3,   Packages, rawbyteslen(Packages) + 1, \FLOAT4;       ! Pack third robot joint angle (position of the third robot axis)
        packrawbytes StatePackage.Joints.robax.rax_4,   Packages, rawbyteslen(Packages) + 1, \FLOAT4;       ! Pack fourth robot joint angle (position of the fourth robot axis)
        packrawbytes StatePackage.Joints.robax.rax_5,   Packages, rawbyteslen(Packages) + 1, \FLOAT4;       ! Pack fifth robot joint angle (position of the fifth robot axis)
        packrawbytes StatePackage.Joints.robax.rax_6,   Packages, rawbyteslen(Packages) + 1, \FLOAT4;       ! Pack sixth robot joint angle (position of the sixth robot axis)
        packrawbytes StatePackage.Joints.extax.eax_a,   Packages, rawbyteslen(Packages) + 1, \FLOAT4;       ! Pack first external axis angle (position of the first external axis)
        packrawbytes StatePackage.Joints.extax.eax_b,   Packages, rawbyteslen(Packages) + 1, \FLOAT4;       ! Pack second external axis angle (position of the second external axis)
        packrawbytes StatePackage.Joints.extax.eax_c,   Packages, rawbyteslen(Packages) + 1, \FLOAT4;       ! Pack third external axis angle (position of the third external axis)
        packrawbytes StatePackage.Joints.extax.eax_d,   Packages, rawbyteslen(Packages) + 1, \FLOAT4;       ! Pack fourth external axis angle (position of the fourth external axis)
        packrawbytes StatePackage.Joints.extax.eax_e,   Packages, rawbyteslen(Packages) + 1, \FLOAT4;       ! Pack fifth external axis angle (position of the fifth external axis)
        packrawbytes StatePackage.Joints.extax.eax_f,   Packages, rawbyteslen(Packages) + 1, \FLOAT4;       ! Pack sixth external axis angle (position of the sixth external axis)
        packrawbytes 0.0,                               Packages, rawbyteslen(Packages) + 1, \FLOAT4;       ! Pack default value 0.0
        packrawbytes StatePackage.ProcessPrm01,         Packages, rawbyteslen(Packages) + 1, \FLOAT4;       ! Pack process parameter ProcessPrm01 (default value is 0.0)
        packrawbytes StatePackage.ProcessPrm02,         Packages, rawbyteslen(Packages) + 1, \FLOAT4;       ! Pack process parameter ProcessPrm02 (default value is 0.0)
        packrawbytes StatePackage.ProcessPrm03,         Packages, rawbyteslen(Packages) + 1, \FLOAT4;       ! Pack process parameter ProcessPrm03 (default value is 0.0)
        packrawbytes StatePackage.ProcessPrm04,         Packages, rawbyteslen(Packages) + 1, \FLOAT4;       ! Pack process parameter ProcessPrm04 (default value is 0.0)
        packrawbytes StatePackage.ProcessPrm05,         Packages, rawbyteslen(Packages) + 1, \FLOAT4;       ! Pack process parameter ProcessPrm05 (default value is 0.0)
        packrawbytes StatePackage.ProcessPrm06,         Packages, rawbyteslen(Packages) + 1, \FLOAT4;       ! Pack process parameter ProcessPrm06 (default value is 0.0)
        pack_tail_ Packages, StatePackage.DrvTail;                                                          ! End packing tail information

        Status := udp_sraw_(UdpSocket, UdpConfig, Packages);

        waittime STATE_FREQ;
    endwhile


    goto UDP_CREATE;
endproc

local proc alias_drv_di_(pers string Name{*})
    var string CopyName{8};

    CopyName := Name;
    aliasio CopyName{1}, DrvSignalGi{1};
    aliasio CopyName{2}, DrvSignalGi{2};
    aliasio CopyName{3}, DrvSignalGi{3};
    aliasio CopyName{4}, DrvSignalGi{4};
    aliasio CopyName{5}, DrvSignalGi{5};
    aliasio CopyName{6}, DrvSignalGi{6};
    aliasio CopyName{7}, DrvSignalGi{7};
    aliasio CopyName{8}, DrvSignalGi{8};

    error
    skipwarn;
    trynext;
endproc 

local proc alias_state_()
    var string Name1 := "is_executing_";
    var string Name2 := "is_fault_";
    var string Name3 := "is_not_moving_";
    
    aliasio Name1, IsExecuting;
    aliasio Name2, IsFault;
    aliasio Name3, IsNotMoving;

    error
    skipwarn;
    trynext;
endproc 


endmodule