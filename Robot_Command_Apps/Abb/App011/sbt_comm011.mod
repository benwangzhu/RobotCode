module sbt_comm011(noview)
!***********************************************************
!
! Copyright 2018 - 2024 speedbot All Rights reserved.
!
! file Name: sbt_comm011
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

local var num Status := OK;
local var socketdev SocketFm;
local var intnum Intrrupts;

task pers tooldata ScaningTool := [true, [[0, 0, 0], [1, 0, 0, 0]], [0.001, [0, 0, 0.001],[1, 0, 0, 0], 0, 0, 0]];
task pers wobjdata ScaningUserFrame := [false, true, "", [[0, 0, 0],[1, 0, 0, 0]],[[0, 0, 0],[1, 0, 0, 0]]];

!***********************************************************
! proc sbtcomm011_open_()
!***********************************************************
! 功能 : 链接上位机软件通讯
!       链接成功后激活通讯交互中断
!***********************************************************
proc sbtcomm011_open_()
    
    GlbPackRealTime.Header := [PACK_HEADER, 96, 1, 0, 0, 0, 0];
    GlbPackRealTime.Tail := PACK_TAIL;
    GlbSlodId := 0;
    GlbCommandId := INST_UNKNOWN;
    Status := NG;
    
    while Status <> OK do
        Status := csock_conn_(SocketFm, GlbSocketCfg);
        if Status <> OK then
            log_error_ "Failed sbtcomm011_open_", \ELOG, \Id := 101;
        endif
    endwhile
    
    idelete Intrrupts;
    connect Intrrupts with scan_handler_;
    itimer \single, NETWORK_INTR_ITP, Intrrupts;
    
endproc

!***********************************************************
! proc sbtcomm011_close_()
!***********************************************************
! 功能 : 关闭通讯交互中断
!       关闭和上位机的通讯链接
!***********************************************************
proc sbtcomm011_close_()
    idelete Intrrupts;
    waittime 0.1;
    sock_dconn_ SocketFm, GlbSocketCfg;
endproc

!***********************************************************
! proc sbtcomm011_2dScanStart_()
!***********************************************************
! 输入参数 : \SoldId    num         焊缝编号，省略时为 0
! 输入参数 : \Tool      tooldata    扫描时参考的工具坐标系，省略时为 Tool0
! 输入参数 : \Wobj      wobjdata    扫描时参考的工件坐标系，省略时为 Wobj0
!***********************************************************
! 功能 : 2D 相机扫描开始
!***********************************************************
proc sbtcomm011_2dScanStart_(\num SoldId, \pers tooldata Tool, \pers wobjdata Wobj)
    
    waittime \INPOS, 0.0;

    FlagRltAck := false;    

    if present(SoldId) then
        GlbSlodId := SoldId;
    else
        GlbSlodId := 0;
    endif
    if present(Tool) then
        ScaningTool := Tool;
    else
        ScaningTool := Tool0;
    endif
    if present(Wobj) then
        ScaningUserFrame := Wobj;
    else
        ScaningUserFrame := Wobj0;
    endif

    GlbCommandId := INST_2D_ST;

    waituntil ((GlbCommandId = INST_UNKNOWN) and (FlagRltAck = true));
endproc

!***********************************************************
! proc sbtcomm011_2dScanStop_()
!***********************************************************
! 功能 : 2D 相机扫描停止
!***********************************************************
proc sbtcomm011_2dScanStop_()

    waittime \INPOS, 0.0;

    FlagRltAck := false;    
    GlbCommandId := INST_2D_ED;

    waituntil ((GlbCommandId = INST_UNKNOWN) and (FlagRltAck = true));
endproc

!***********************************************************
! proc sbtcomm011_getPath_()
!***********************************************************
! 输入参数 : \SoldId    num         焊缝编号，省略时为 0
!***********************************************************
! 功能 : 获取扫描出的路径
!***********************************************************
proc sbtcomm011_getPath_(\num SoldId)

    FlagRltAck := false;   

    if present(SoldId) 
        GlbSlodId := SoldId;
     
    GlbTrajectoryLen := 0;

    GlbCommandId := INST_PATH;

    waituntil ((GlbCommandId = INST_UNKNOWN) and (FlagRltAck = true));
endproc

!***********************************************************
! proc mutil_move_()
!***********************************************************
! 输入参数 : Vel    speeddata       运行时的速度
! 输入参数 : Zone   zonedata        运行时的逼近
! 输入参数 : Tool   tooldata        运行时的工具坐标系
!***********************************************************
! 功能 : 执行扫描出的轨迹路径
!***********************************************************
proc mutil_move_(speeddata Vel \num V, zonedata Zone, pers tooldata Tool)
    var num i;
    for i from 1 to GlbTrajectoryLen do
        movel GlbTrajectoryPoint{i}, Vel \V?V, Zone, Tool;
    endfor
endproc

!***********************************************************
! 以下函数为内部使用函数
! 不需要用户调用
! 也不要修改它
!***********************************************************

local trap scan_handler_

    GlbPackRealTime.Header.Cmd := GlbCommandId;

    if GlbPackRealTime.Header.Seq < 255 then  
        incr GlbPackRealTime.Header.Seq;
    else
        GlbPackRealTime.Header.Seq := 1;
    endif
    GlbPackRealTime.Pos := crobt(\Tool := ScaningTool, \Wobj := ScaningUserFrame);
    GlbPackRealTime.ProcessPrm01 := GlbSlodId;
    GlbPackRealTime.ProcessPrm02 := 0.0;
    GlbPackRealTime.ProcessPrm03 := 0.0;
    GlbPackRealTime.ProcessPrm04 := 0.0;
    GlbPackRealTime.Reversed := "00000000";

    Status := net_spack_(GlbSocketCfg, SocketFm, GlbPackRealTime);

    if GlbPackRealTime.Header.Cmd > 0 then 

        Status := net_rpack_(GlbSocketCfg, SocketFm, GlbPackTrajeInst);
    endif

    if Status = OK then
        idelete Intrrupts;
        connect Intrrupts with scan_handler_;
        itimer \singleSafe, NETWORK_INTR_ITP, Intrrupts;
    else

        log_error_ "Failed scan_handler_", \ELOG, \Id := 102;
    endif
endtrap

local func num net_spack_(inout sock_cfg_t Sock, var socketdev SockDev, pk_realtm_t DataTable)
    var rawbytes Packages;

    pack_head_ Packages, DataTable.Header;
    packrawbytes DataTable.Pos.Trans.x,          Packages, rawbyteslen(Packages) + 1, \FLOAT4;          
    packrawbytes DataTable.Pos.Trans.y,          Packages, rawbyteslen(Packages) + 1, \FLOAT4;          
    packrawbytes DataTable.Pos.Trans.z,          Packages, rawbyteslen(Packages) + 1, \FLOAT4;          
    packrawbytes eulerzyx(\Z, DataTable.Pos.Rot),Packages, rawbyteslen(Packages) + 1, \FLOAT4;          
    packrawbytes eulerzyx(\Y, DataTable.Pos.Rot),Packages, rawbyteslen(Packages) + 1, \FLOAT4;          
    packrawbytes eulerzyx(\X, DataTable.Pos.Rot),Packages, rawbyteslen(Packages) + 1, \FLOAT4;          
    packrawbytes DataTable.Pos.ExtAx.Eax_a,      Packages, rawbyteslen(Packages) + 1, \FLOAT4;          
    packrawbytes DataTable.Pos.ExtAx.Eax_b,      Packages, rawbyteslen(Packages) + 1, \FLOAT4;          
    packrawbytes DataTable.Pos.ExtAx.Eax_c,      Packages, rawbyteslen(Packages) + 1, \FLOAT4;          
    packrawbytes DataTable.Pos.ExtAx.Eax_d,      Packages, rawbyteslen(Packages) + 1, \FLOAT4;          
    packrawbytes DataTable.Pos.ExtAx.Eax_e,      Packages, rawbyteslen(Packages) + 1, \FLOAT4;          
    packrawbytes DataTable.Pos.ExtAx.Eax_f,      Packages, rawbyteslen(Packages) + 1, \FLOAT4;          
    packrawbytes 0.0,                               Packages, rawbyteslen(Packages) + 1, \FLOAT4;          
    packrawbytes DataTable.ProcessPrm01,         Packages, rawbyteslen(Packages) + 1, \FLOAT4;       ! Pack process parameter ProcessPrm01 (default value is 0.0)
    packrawbytes DataTable.ProcessPrm02,         Packages, rawbyteslen(Packages) + 1, \FLOAT4;       ! Pack process parameter ProcessPrm02 (default value is 0.0)
    packrawbytes DataTable.ProcessPrm03,         Packages, rawbyteslen(Packages) + 1, \FLOAT4;       ! Pack process parameter ProcessPrm03 (default value is 0.0)
    packrawbytes DataTable.ProcessPrm04,         Packages, rawbyteslen(Packages) + 1, \FLOAT4;       ! Pack process parameter ProcessPrm04 (default value is 0.0)
    packrawbytes DataTable.Reversed,             Packages, rawbyteslen(Packages) + 1, \ASCII;        
    pack_tail_ Packages, DataTable.Tail;

    return(sock_sraw2_(SockDev, Sock, Packages, \len := rawbyteslen(Packages)));
endfunc

local func num net_rpack_(inout sock_cfg_t Sock, var socketdev SockDev, inout pk_tarje_t DataTable)
    var rawbytes Packages;
    var num Res := OK;
    var num i;

    Res := sock_rraw_(SockDev, Sock, Packages, \ReadNoOfBytes := 16);
    if Res <= 0 then
        return(NG);
    endif

    Res := unpack_head_ (Packages, DataTable.Header);

    test DataTable.Header.Cmd
    case INST_PATH :

        if DataTable.Header.PacketCount > 0 then
            for i from 1 to DataTable.Header.PacketCount do

                Res := sock_rraw_(SockDev, Sock, Packages, \ReadNoOfBytes := 76);
                if Res <= 0 then
                    return(NG);
                endif

                new_rtraje_ Packages, DataTable;

                incr GlbTrajectoryLen;

                GlbTrajectoryPoint{GlbTrajectoryLen} := crobt(\WObj := wobj0);
                GlbTrajectoryPoint{GlbTrajectoryLen}.Trans := [DataTable.Pos.Trans.x, DataTable.Pos.Trans.y, DataTable.Pos.Trans.z];
            endfor
        endif

        if (DataTable.Header.Type_ = 1) then

            if GlbTrajectoryLen > 0 then
                GlbStartPosn := GlbTrajectoryPoint{1};
                GlbEndPosn := GlbTrajectoryPoint{GlbTrajectoryLen};
            endif
            GlbCommandId := INST_UNKNOWN;
            FlagRltAck := true;
        endif
    case INST_2D_ST :
        GlbCommandId := INST_UNKNOWN;
        FlagRltAck := true;
    case INST_2D_ED :
        GlbCommandId := INST_UNKNOWN;
        FlagRltAck := true;
    case INST_3D_ST :
        GlbCommandId := INST_UNKNOWN;
        FlagRltAck := true;
    case INST_3D_ED :
        GlbCommandId := INST_UNKNOWN;
        FlagRltAck := true;
    case INST_LS_ST :
        GlbCommandId := INST_UNKNOWN;
        FlagRltAck := true;
    case INST_LS_ED :
        GlbCommandId := INST_UNKNOWN;
        FlagRltAck := true;
    case INST_PRM_ST :
    case INST_PRM_ED :
    default :
    endtest

    Res := sock_rraw_(SockDev, Sock, Packages, \ReadNoOfBytes := 4);
    if Res <= 0 then
        return(NG);
    endif

    Res := unpack_tail_ (Packages, DataTable.Tail);

    return(Res);
endfunc

local proc new_rtraje_(var rawbytes Raw, inout pk_tarje_t DataTable)
    var num PosArray{13} := [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    var num i;

    for i from 1 to dim(PosArray, 1) do 
        unpackrawbytes Raw, 1 + (i - 1) * 4, PosArray{i} \FLOAT4;
    endfor
    DataTable.Pos := crobt();
    DataTable.Pos.Trans := [PosArray{1}, PosArray{2}, PosArray{3}];
    DataTable.Pos.Rot := orientzyx(PosArray{4}, PosArray{5}, PosArray{6});
    DataTable.Pos.extax := [PosArray{7}, PosArray{8}, PosArray{9}, PosArray{10}, PosArray{11}, PosArray{12}];
    unpackrawbytes Raw, 53, DataTable.ProcessPrm01 \FLOAT4;
    unpackrawbytes Raw, 57, DataTable.ProcessPrm02 \FLOAT4;
    unpackrawbytes Raw, 61, DataTable.ProcessPrm03 \FLOAT4;
    unpackrawbytes Raw, 65, DataTable.ProcessPrm04 \FLOAT4;
    unpackrawbytes Raw, 69, DataTable.Reversed, \ASCII := 8;
endproc

endmodule