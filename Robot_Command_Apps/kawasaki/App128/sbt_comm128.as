;***********************************************************
;
; File Name: drive_kawa.as
;
; Description:
;   Language             ==   As for KAWASAKI ROBOT
;   Date                 ==   2022 - 05 - 17
;   Modification Data    ==   2023 - 03 - 15
;
; Author: speedbot
;
; Version: 2.0
;***********************************************************
;   这个程序是针对 SPEEDVIZ 的驱动程序
;   包括 IO, STATE, MOTION 三个任务
;   支持点到点单个运动, 多个点的连续运动, 监控运动
;   使用 SOCKET ASCII 通讯
;***********************************************************

.program sbtcomm128.main()

    call sbtcomm128.glb
    call sbtcomm128.pc


.end

.program sbtcomm128.pc()

    if not OnlyCollect then

    end


    if task(1004) <> 1 then
        pcabort 4:
        twait 0.1
        pcexecute 4:sbtcomm128.s, 1
    end
.end


;
; 驱动参数配置程序
;
.program sbtcomm128.glb()
    

    NumOfRobAxis                = sysdata(zrob.nowaxis)     ; 机器人轴数
    NumOfRotAxis                = 0   

    MtcMaxSpeed                 = 2000.0                ; 最大速度 mm/s
    MtnMaxSmt                   = 250                   ; 最大的拐弯半径 
    MtnMaxTrjLen                = 500                   ; 连续运动前存储的最大轨迹长度

    CtrlDoMap[0]                = 0
    CtrlDoMap[1]                = 0
    CtrlDoMap[2]                = 0
    CtrlDoMap[3]                = 0
    CtrlDoMap[4]                = 0
    CtrlDoMap[5]                = 0
    CtrlDoMap[6]                = 0
    CtrlDoMap[7]                = 0

    CtrlDiMap[0]                = 0
    CtrlDiMap[1]                = 0
    CtrlDiMap[2]                = 0
    CtrlDiMap[3]                = 0
    CtrlDiMap[4]                = 0
    CtrlDiMap[5]                = 0
    CtrlDiMap[6]                = 0
    CtrlDiMap[7]                = 0

    $CtrlIpAddr                 = "192.168.1.103"        ; "172.16.220.9"
    OnlyCollect                 = true
    IsVirRobId                  = 0

    MtnRestart                  = true
    StatRestart                 = true


    GlbMoveId                   = 0


    CMD_CTRL                    = 1
    CMD_IO                      = 2
    CMD_STOP                    = 200



    STATE_FREQ                  = 0.048                    ; State 任务的通讯频率，单位是 HZ

    ;*******************************************************
    ; Move Type 常量, 不要修改它
    ;
    MTN_MOVJ                    = 6                   
    MTN_MOVL                    = 7                     
    MTN_MOVC1                   = 8                     
    MTN_MOVC2                   = 0    

    ERR_SUCCESS                 = 0             ; 无错误
    ERR_MOVTYPE                 = 10001         ; MoveType 错误
    ERR_ACC                     = 10002         ; 加速度错误
    ERR_SMOOT                   = 10003         ; 逼近参数错误
    ERR_VELOCITY                = 10004         ; 速度错误
    ERR_MOVEID                  = 10005         ; 运动 ID 错误

    ERR_CFG_IO1                 = 20001         ; 第一组 IO 未配置
    ERR_CFG_IO2                 = 20002         ; 第二组 IO 未配置
    ERR_CFG_IO3                 = 20003         ; 第三组 IO 未配置
    ERR_CFG_IO4                 = 20004         ; 第四组 IO 未配置
    ERR_CFG_IO5                 = 20005         ; 第五组 IO 未配置
    ERR_CFG_IO6                 = 20006         ; 第六组 IO 未配置
    ERR_CFG_IO7                 = 20007         ; 第七组 IO 未配置
    ERR_CFG_IO8                 = 20008         ; 第八组 IO 未配置
                   
    TYPE_KAWASAKI               = 4
.end 


.program sbtcomm128.s()

10
    .Head = 232425
    .Length = 0
    .PacketCount = 1
    .Cmd = 255
    .Type_ = TYPE_KAWASAKI
    .Seq = 0
    .VirtualRobId = IsVirRobId
    .DrvTail = 485868 

    .State = 0
    .NumRobAxis = NumOfRobAxis
    .NumRotAxis = NumOfRotAxis
    .Reserverd1 = 0
    .MoveId = 0

    .DinVal[0] = 0
    .DinVal[1] = 0
    .DinVal[2] = 0
    .DinVal[3] = 0
    .DinVal[4] = 0
    .DinVal[5] = 0
    .DinVal[6] = 0
    .DinVal[7] = 0

    .Joints[0] = 0.0
    .Joints[1] = 0.0
    .Joints[2] = 0.0
    .Joints[3] = 0.0
    .Joints[4] = 0.0
    .Joints[5] = 0.0
    .Joints[6] = 0.0
    .Joints[7] = 0.0
    .Joints[8] = 0.0
    .Joints[9] = 0.0
    .Joints[10] = 0.0
    .Joints[11] = 0.0
    .Joints[12] = 0.0

    .ProcessPrm[0] = 0.0
    .ProcessPrm[1] = 0.0
    .ProcessPrm[2] = 0.0
    .ProcessPrm[3] = 0.0
    .ProcessPrm[4] = 0.0
    .ProcessPrm[5] = 0.0

    .$ServerIp = $CtrlIpAddr + "."
	for .I = 0 to 3
		.$IpStr = $decode(.$ServerIp, ".", 0)
		.$TmpStr = $decode(.$ServerIp, ".", 1)
		.Ip[.I] = val(.$Ipstr)
	end

    MtnRestart = false
20
    decompose .Joints[0] = #here

    .Seq = .Seq + 1
    if .Seq > 255 then
        .Seq = 1
    end

    .State = 0

    if not OnlyCollect then

        if task(1) == 1 then
            .State = int(.State bor 1)
        end
    end

    if task(1) == 2 then
        .State = int(.State bor 2)
    end

    if switch(error) == true then
        .State = int(.State bor 4)
    end

    .MoveId = GlbMoveId

    for .i = 0 to 7
        if (CtrlDiMap[.i] > 1000) and (CtrlDiMap[.i] < 1993) then

            .DinVal[.i] = bits(CtrlDiMap[i], 8)
        else
        
            .DinVal[.i] = 0
        end
    end

   .$SendStr[0] = $encode(/L, .Head, "|", /L, .Length, "|", /L, .PacketCount, "|",  /L, .Cmd,  "|", /L, .Type_, "|", /L, .Seq, "|", /L, .VirtualRobId, "|") 
   .$SendStr[1] = $encode(/L, .State, "|", /L, .NumRobAxis, "|", /L, .NumRotAxis, "|",  /L, .Reserverd1,  "|", /L, .MoveId, "|") 
   .$SendStr[2] = $encode(/L, .DinVal[0], "|", /L, .DinVal[1], "|", /L, .DinVal[2], "|",  /L, .DinVal[3],  "|", /L, .DinVal[4], "|", /L, .DinVal[5], "|", /L, .DinVal[6], "|", /L, .DinVal[7], "|") 
   .$SendStr[3] = $encode(/F10.3, .Joints[0], "|", /F10.3, .Joints[1], "|", /F10.3, .Joints[2], "|",  /F10.3, .Joints[3],  "|", /F10.3, .Joints[4], "|", /F10.3, .Joints[5], "|") 
   .$SendStr[4] = $encode(/F10.3, .Joints[6], "|", /F10.3, .Joints[7], "|", /F10.3, .Joints[8], "|",  /F10.3, .Joints[9],  "|", /F10.3, .Joints[10], "|", /F10.3, .Joints[11], "|", /F10.3, .Joints[12], "|") 
   .$SendStr[5] = $encode(/F10.3, .ProcessPrm[0], "|", /F10.3, .ProcessPrm[1], "|", /F10.3, .ProcessPrm[2], "|",  /F10.3, .ProcessPrm[3],  "|", /F10.3, .ProcessPrm[4], "|", /F10.3, .ProcessPrm[5], "|") 
   .$SendStr[6] = $encode(/L, .DrvTail, "|") 

    udp_sendto .Res, .Ip[0], 12002, .$SendStr[0], 7

    twait STATE_FREQ
    if StatRestart == false goto 20
    goto 10
.end 

