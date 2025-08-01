module sbt_comm128_motion
!***********************************************************
!
! Copyright 2018 - 2024 speedbot All Rights reserved.
!
! file Name: sbt_comm128_motion
! 
!  Description:
!    Language             ==   Karel for ABB ROBOT
!    Date                 ==   2024 - 03 - 05
!    Modification Data    ==   2024 - 03 - 05
! 
!  Author: speedbot
! 
!  Version: 3.0
! ***********************************************************

local record drv_pnt_t
    num MoveId;                    
    byte MovType;                   
    byte ProcessType;            
    byte Acc;                   
    byte Smoot;
    num Velocity;
    num PrcoParm1;
    num PrcoParm2;
    num PrcoParm3;
    jointtarget Point;
endrecord

local record drv_pack_t
    pack_head_t DrvHead;
    drv_pnt_t Point;
    string Io;
    pack_tail_t DrvTail;
endrecord

local record drv_ack_t
    pack_head_t DrvHead;
    num Ack;
    pack_tail_t DrvTail;
endrecord


local var errnum Status := NG;
local var socketdev TcpSocket;
local var sock_cfg_t TcpConfig := [false, "", 12001, 0, 0];   
local var drv_pack_t CtrlPackData; 
local var drv_ack_t  CtrlAckData; 
local var rawbytes Packages;
local var num PackErrorId := OK;

local var trajectory_pt_t Trajectorys{MAX_TRAJ_LENGTH};
local var num TrajectorySize         := 0;

local var signalgo DrvSignalGo{8};
local var byte DrvSignalGoVal{8} := [0, 0, 0, 0, 0, 0, 0, 0];

proc main()
!
TCP_CREATE:

    log_info_ "Tcp Network Connecting";  
    Status := NG;  

    while Status = NG do

        TcpConfig.Host := CtrlIpAddr;
        waittime TRY_CONN_TM;                                  
        sock_dconn_ TcpSocket, TcpConfig; 
        Status := csock_conn_(TcpSocket, TcpConfig);   
    endwhile                                            

    log_info_ "Tcp Connected";
    log_info_ "Attempting handshake ";
    Status := new_mtnctrl_(TcpConfig, TcpSocket);
    if status <> OK then 

        log_error_ "Handshake with the server failed ";
        goto TCP_CREATE;
    endif

    log_info_ "Handshake with the server succeeded ";

    MtnRestart := false;

    alias_drv_do_ OutMapName;

MSG_PACKAGES:

    status := get_bits_(TcpSocket, TcpConfig);
    if status < 0 then

        log_error_ "Network Failure ";
        goto TCP_CREATE;
    endif

    if MtnRestart then

        goto TCP_CREATE;
    endif

    if status = 0 then 

        waittime 0.024;
        goto MSG_PACKAGES;
    endif

    Status := sock_rraw_(TcpSocket, TcpConfig, Packages, \ReadNoOfBytes := 16);
    if Status <= 0 then

        log_error_ "Network Failure ";
        goto TCP_CREATE;
    endif

    Status := unpack_head_(Packages, CtrlPackData.DrvHead);
    if status <> OK then

        log_error_ "Read data header failed ";
        goto TCP_CREATE;
    endif

    PackErrorId := OK;

    test CtrlPackData.DrvHead.Cmd
    case CMD_CTRL:
        Status := new_trajes_(TcpConfig, TcpSocket, CtrlPackData);
        if (status <> OK) or (PackErrorId <> OK) then

            TrajectorySize := 0;
            log_error_ "Trajectory download failed ";
        endif
    case CMD_IO:
        Status := new_io_(TcpConfig, TcpSocket, CtrlPackData);
        if status <> OK then

            log_error_ "Set IO failed ";
        endif
    case CMD_STOP:
        Status := new_stop_(TcpConfig, TcpSocket, CtrlPackData);
        if status <> OK then

            log_error_ "Trajectory stop failed ";
        endif
    default:
        log_error_ "Invalid control command ";
        goto TCP_CREATE;
    endtest

    CtrlAckData := [[PACK_HEADER, 24, 1, 255, TYPE_ABB, CtrlPackData.DrvHead.Seq, IsVirRobId], PackErrorId, PACK_TAIL];
    Status := new_ack_(TcpConfig, TcpSocket, CtrlAckData);


    goto MSG_PACKAGES;


endproc

local func errnum new_mtnctrl_(inout sock_cfg_t SockCfg, var socketdev CSockVar)
    var drv_ack_t Packages1;
    var drv_ack_t Packages2;
    var errnum Status := NG;
    var rawbytes Packages;

    Packages1 := [[PACK_HEADER, 24, 1, 254, TYPE_ABB, 1, IsVirRobId], 0, PACK_TAIL];
    Packages2 := [[0, 0, 0, 0, 0, 0, 0], 0, 0];

    pack_head_ Packages, Packages1.DrvHead;
    packrawbytes Packages1.Ack, Packages, rawbyteslen(Packages) + 1, \IntX := DINT;
    pack_tail_ Packages, Packages1.DrvTail;

    Status := sock_sraw2_(CSockVar, SockCfg, Packages);
    if status <> OK then

        return(Status);
    endif

    clearrawbytes Packages;
    SockCfg.RecvTimeout := SHAKE_TIME;
    Status := sock_rraw_(CSockVar, SockCfg, Packages);
    if status <= 0 then

        return(NG);
    endif

    Status := unpack_head_(Packages, Packages2.DrvHead);
    if status <> OK then

        return(Status);
    endif

    if Packages2.DrvHead.Cmd <> 254 then

        return(NG);
    endif

    unpackrawbytes Packages, 17, Packages2.Ack, \IntX := DINT;

    Status := unpack_tail_(Packages, Packages2.DrvTail);
    if status <> OK then

        return(Status);
    endif

    return(OK);
endfunc

local func errnum new_point_(inout sock_cfg_t SockCfg, var socketdev CSockVar, inout drv_pnt_t DrvPoint)
    var errnum Status := NG;
    var rawbytes Packages;

    clearrawbytes Packages;
    Status := sock_rraw_(CSockVar, SockCfg, Packages, \ReadNoOfBytes := 76);
    if status <= 0 then

        return(Status);
    endif
    
    unpackrawbytes Packages, 1,     DrvPoint.MoveId,        \IntX := DINT;
    unpackrawbytes Packages, 5,     DrvPoint.MovType,       \ASCII := 1;
    unpackrawbytes Packages, 6,     DrvPoint.ProcessType,   \ASCII := 1;
    unpackrawbytes Packages, 7,     DrvPoint.Acc,           \ASCII := 1;
    unpackrawbytes Packages, 8,     DrvPoint.Smoot,         \ASCII := 1;
    unpackrawbytes Packages, 9,     DrvPoint.Velocity,      \FLOAT4;
    unpackrawbytes Packages, 13,    DrvPoint.PrcoParm1,     \IntX := DINT;
    unpackrawbytes Packages, 17,    DrvPoint.PrcoParm2,     \IntX := DINT;
    unpackrawbytes Packages, 21,    DrvPoint.PrcoParm3,     \FLOAT4;
    unpackrawbytes Packages, 25,    DrvPoint.Point.robax.rax_1,     \FLOAT4;
    unpackrawbytes Packages, 29,    DrvPoint.Point.robax.rax_2,     \FLOAT4;
    unpackrawbytes Packages, 33,    DrvPoint.Point.robax.rax_3,     \FLOAT4;
    unpackrawbytes Packages, 37,    DrvPoint.Point.robax.rax_4,     \FLOAT4;
    unpackrawbytes Packages, 41,    DrvPoint.Point.robax.rax_5,     \FLOAT4;
    unpackrawbytes Packages, 45,    DrvPoint.Point.robax.rax_6,     \FLOAT4;
    unpackrawbytes Packages, 49,    DrvPoint.Point.extax.eax_a,     \FLOAT4;
    unpackrawbytes Packages, 53,    DrvPoint.Point.extax.eax_b,     \FLOAT4;
    unpackrawbytes Packages, 57,    DrvPoint.Point.extax.eax_c,     \FLOAT4;
    unpackrawbytes Packages, 61,    DrvPoint.Point.extax.eax_d,     \FLOAT4;
    unpackrawbytes Packages, 65,    DrvPoint.Point.extax.eax_e,     \FLOAT4;
    unpackrawbytes Packages, 69,    DrvPoint.Point.extax.eax_f,     \FLOAT4;

    return(OK);
endfunc

local func errnum new_ack_(inout sock_cfg_t SockCfg, var socketdev CSockVar, inout drv_ack_t DrvAck)
    var errnum Status := NG;
    var rawbytes Packages;

    pack_head_ Packages, DrvAck.DrvHead;
    packrawbytes DrvAck.Ack, Packages, rawbyteslen(Packages) + 1, \IntX := DINT;
    pack_tail_ Packages, DrvAck.DrvTail;

    Status := sock_sraw2_(CSockVar, SockCfg, Packages);

    return(Status);
endfunc

local func errnum new_trajes_(inout sock_cfg_t SockCfg, var socketdev CSockVar, inout drv_pack_t DrvPack)
    var errnum Status := NG;
    var rawbytes Packages;
    var num i;

    for i from 1 to DrvPack.DrvHead.PacketCount do  

        status := new_point_(SockCfg, CSockVar, DrvPack.Point);
        if status <> OK then

            return(Status);
        endif

        chk_point_ DrvPack.Point;

        add_traj_pt_ DrvPack.Point;
    endfor

    Status := sock_rraw_(CSockVar, SockCfg, Packages, \ReadNoOfBytes := 4);
    if status <= 0 then

        return(Status);
    endif

    Status := unpack_tail_(Packages, DrvPack.DrvTail);
    if status <> OK then

        return(Status);
    endif

    if (PackErrorId = OK) and (DrvPack.DrvHead.Type_ = 1) then
                
        activate_traj_;
    endif

    return(OK);
endfunc

local func errnum new_io_(inout sock_cfg_t SockCfg, var socketdev CSockVar, inout drv_pack_t DrvPack)
    var errnum Status := NG;
    var rawbytes Packages;
    var num i;

    clearrawbytes Packages;
    Status := sock_rraw_(CSockVar, SockCfg, Packages, \ReadNoOfBytes := 8);
    if status <= 0 then

        return(Status);
    endif

    unpackrawbytes Packages, 1,   DrvPack.io,   \ASCII := 8;

    for i from 1 to 8 do
        
        DrvSignalGoVal{i} := ord_(DrvPack.io, \Index := i);
    endfor


    Status := sock_rraw_(CSockVar, SockCfg, Packages, \ReadNoOfBytes := 4);
    if status <= 0 then

        return(Status);
    endif

    Status := unpack_tail_(Packages, DrvPack.DrvTail);
    if status <> OK then

        return(Status);
    endif

    chk_io_ DrvSignalGoVal;

    if PackErrorId = OK then
        if validio(DrvSignalGo{1}) setgo DrvSignalGo{1}, DrvSignalGoVal{1};
        if validio(DrvSignalGo{2}) setgo DrvSignalGo{2}, DrvSignalGoVal{2};
        if validio(DrvSignalGo{3}) setgo DrvSignalGo{3}, DrvSignalGoVal{3};
        if validio(DrvSignalGo{4}) setgo DrvSignalGo{4}, DrvSignalGoVal{4};
        if validio(DrvSignalGo{5}) setgo DrvSignalGo{5}, DrvSignalGoVal{5};
        if validio(DrvSignalGo{6}) setgo DrvSignalGo{6}, DrvSignalGoVal{6};
        if validio(DrvSignalGo{7}) setgo DrvSignalGo{7}, DrvSignalGoVal{7};
        if validio(DrvSignalGo{8}) setgo DrvSignalGo{8}, DrvSignalGoVal{8};
    endif
    
    return(OK);
endfunc

local func errnum new_stop_(inout sock_cfg_t SockCfg, var socketdev CSockVar, inout drv_pack_t DrvPack)
    var errnum Status := NG;
    var rawbytes Packages;

    Status := sock_rraw_(CSockVar, SockCfg, Packages, \ReadNoOfBytes := 4);
    if status <= 0 then

        return(Status);
    endif

    Status := unpack_tail_(Packages, DrvPack.DrvTail);
    if status <> OK then

        return(Status);
    endif

    log_info_ "Stop Move";

    TrajectorySize :=0;
    stopmove;
    clearpath;
    startmove;
    StopMoveing := true;
    
    return(OK);
endfunc

local proc chk_point_(drv_pnt_t Packages)

    if Packages.MoveId <= 0 then 
        PackErrorId := ERR_MOVEID;
        return;
    endif
    if not ((Packages.MovType = MOVE_J) or (Packages.MovType = MOVE_L) or (Packages.MovType = MOVE_C1) or (Packages.MovType = MOVE_C2)) then 
        PackErrorId := ERR_MOVTYPE;
        return;
    endif
    if (Packages.Acc < 20) or (Packages.Acc > 100) then 
        PackErrorId := ERR_ACC;
        return;
    endif
    if (Packages.Smoot < 0) or (Packages.Smoot > 100) then 
        PackErrorId := ERR_SMOOT;
        return;
    endif
    if (Packages.Velocity <= 0.0) or (Packages.Velocity  > vmax.v_tcp) then 
        PackErrorId := ERR_VELOCITY;
        return;
    endif 
endproc

local proc add_traj_pt_(drv_pnt_t Packages)

    incr TrajectorySize;

    Trajectorys{TrajectorySize}.TrjMoveId := Packages.MoveId;
    Trajectorys{TrajectorySize}.TrjMoveType := Packages.MovType;
    Trajectorys{TrajectorySize}.TrjProcessType := Packages.ProcessType;
    Trajectorys{TrajectorySize}.TrjAcc := Packages.Acc;
    Trajectorys{TrajectorySize}.TrjSmoot := MTN_MAX_SMT / 100.0 * Packages.Smoot;
    Trajectorys{TrajectorySize}.TrjSpeed := Packages.Velocity / 10.0;
    Trajectorys{TrajectorySize}.TrjProcParm1 := Packages.PrcoParm1;
    Trajectorys{TrajectorySize}.TrjProcParm2 := Packages.PrcoParm2;
    Trajectorys{TrajectorySize}.TrjProcParm3 := Packages.PrcoParm3;
    Trajectorys{TrajectorySize}.TrjPose := jnt_2cart_(Packages.Point, DriveTool);
endproc


local proc activate_traj_()
    waituntil (not NewTrajectory) or (MtnRestart = true);

    if not NewTrajectory then
        waittestandset TrajectoryLock;  ! acquire data-lock
        log_info_ "Sending " + ValToStr(TrajectorySize) + " points to MOTION task";
        GlbTrajectorys := Trajectorys;
        GlbTrajectorySize := TrajectorySize;
        NewTrajectory := true;
        TrajectoryLock := false;  ! release data-lock
    endif

    TrajectorySize := 0;
endproc


local proc chk_io_(byte Io{*})
    if (Io{1} > 0) and (not validio(DrvSignalGo{1})) PackErrorId := ERR_CFG_IO1;
    if (Io{2} > 0) and (not validio(DrvSignalGo{2})) PackErrorId := ERR_CFG_IO2;
    if (Io{3} > 0) and (not validio(DrvSignalGo{3})) PackErrorId := ERR_CFG_IO3;
    if (Io{4} > 0) and (not validio(DrvSignalGo{4})) PackErrorId := ERR_CFG_IO4;
    if (Io{5} > 0) and (not validio(DrvSignalGo{5})) PackErrorId := ERR_CFG_IO5;
    if (Io{6} > 0) and (not validio(DrvSignalGo{6})) PackErrorId := ERR_CFG_IO6;
    if (Io{7} > 0) and (not validio(DrvSignalGo{7})) PackErrorId := ERR_CFG_IO7;
    if (Io{8} > 0) and (not validio(DrvSignalGo{8})) PackErrorId := ERR_CFG_IO8;
endproc

local proc alias_drv_do_(pers string Name{*})
    var string CopyName{8};

    CopyName := Name;
    aliasio CopyName{1}, DrvSignalGo{1};
    aliasio CopyName{2}, DrvSignalGo{2};
    aliasio CopyName{3}, DrvSignalGo{3};
    aliasio CopyName{4}, DrvSignalGo{4};
    aliasio CopyName{5}, DrvSignalGo{5};
    aliasio CopyName{6}, DrvSignalGo{6};
    aliasio CopyName{7}, DrvSignalGo{7};
    aliasio CopyName{8}, DrvSignalGo{8};

    error
    skipwarn;
    trynext;
endproc 
endmodule