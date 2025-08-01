;***********************************************************
;
; Copyright 2018 - 2023 speedbot All Rights reserved.
;
; File Name: lib_tp_if.as
;
; Description:
;   Language             ==   As for KAWASAKI ROBOT
;   Date                 ==   2022 - 04 - 26
;   Modification Data    ==   2022 - 04 - 26
;
; Author: speedbot
;
; Version: 1.0
;*********************************************************************************************************;
;                                                                                                         ;
;                                                      .^^^                                               ;
;                                               .,~<c+{{{{{{t,                                            ; 
;                                       `^,"!t{{{{{{{{{{{{{{{{+,                                          ;
;                                 .:"c+{{{{{{{{{{{{{{{{{{{{{{{{{+,                                        ;
;                                "{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{~                                       ;
;                               ^{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{!.  `^                                    ;
;                               c{{{{{{{{{{{{{c~,^`  `.^:<+{{{!.  `<{{+,                                  ;
;                              ^{{{{{{{{{{{!^              `,.  `<{{{{{{+:                                ;
;                              t{{{{{{{{{!`                    ~{{{{{{{{{{+,                              ;
;                             ,{{{{{{{{{:      ,uDWMMH^        `c{{{{{{{{{{{~                             ;
;                             +{{{{{{{{:     ,XMMMMMMw           t{{{{{{{{{{t                             ;
;                            ,{{{{{{{{t     :MMMMMMMMM"          ^{{{{{{{{{{~                             ;
;                            +{{{{{{{{~     8MMMMMMMMMMWD8##      {{{{{{{{{+                              ;
;                           :{{{{{{{{{~     8MMMMMMMMMMMMMMH      {{{{{{{{{~                              ;
;                           +{{{{{{{{{c     :MMMMMMMMMMMMMMc     ^{{{{{{{{+                               ;
;                          ^{{{{{{{{{{{,     ,%MMMMMMMMMMH"      c{{{{{{{{:                               ;
;                          `+{{{{{{{{{{{^      :uDWMMMX0"       !{{{{{{{{+                                ;
;                           `c{{{{{{{{{{{"                    ^t{{{{{{{{{,                                ;
;                             ^c{{{{{{{{{{{".               ,c{{{{{{{{{{t                                 ;
;                               ^c{{{{{{{{{{{+<,^`     .^~c{{{{{{{{{{{{{,                                 ;
;                                 ^c{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{t                                  ;
;                                   ^c{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{t`                                  ;
;                                     ^c{{{{{{{{{{{{{{{{{{{{{{{{{{+c"^                                    ;                         
;                                       ^c{{{{{{{{{{{{{{{{{+!":^.                                         ;
;                                         ^!{{{{{{{{t!",^`                                                ;
;                                                                                                         ;
;*********************************************************************************************************;
;

; 2022 - 04 - 26 ++ lib.sys_sig_()

; 2022 - 04 - 26 ++ lib.user_sig_()

; 2022 - 04 - 26 ++ lib.autostart.pc()

; 2022 - 04 - 26 ++ lib.magnet_on_()

; 2022 - 04 - 26 ++ lib.magnet_off_() 

; 2022 - 04 - 26 ++ lib.wait_servo_() 

; 2022 - 04 - 26 ++ lib.home_io_() 

; 2022 - 04 - 26 ++ lib.mov_home_() 

; 2022 - 04 - 26 ++ lib.enter_zone_() 

; 2022 - 04 - 26 ++ lib.exit_zone_() 

;***********************************************************
; func autostart.pc()
;***********************************************************
; 外部控制机器人程序启停和继续
;***********************************************************
.program autostart.pc()

    if existinteger("@SYS_SIG_DEFED") == 0 then 

        call lib.sys_sig_
    end

    call lib.prg_name_
    call lib.logs_sys2_("autostart.pc Running")

10
    ;Is Pause ?
    if task(1) == 2 then 
        signal Do3Pause
    else
        signal -Do3Pause
    end

    OverSpeed = 10
    
    ;Program Start
    if (switch(repeat) == true) and (switch(cs) == false) and (switch(teach_lock) == false) and (switch(error) == false) and (sig(Do2Running) == false) then

        if sig(Di3RmtStart) == true then

            call lib.logs_sys2_("Remote Start")

            .RmtProgNo = bits(GiProgNumSt ,8)

            call lib.logs_sys2_("Program Num = " + $encode(/D, .RmtProgNo))

            if (.RmtProgNo <= 0) or (.RmtProgNo > 31) goto 10

            if (existpgm($ProgName[.RmtProgNo]) == true) and (existpgm($ProgName[0]) == true) then
                bits GoProgNumSt ,GoProgNumLen = .RmtProgNo
                if switch(power) == false then
                    mc zpower on 
                    twait 0.5
                    if switch(power) == false then
                        call lib.logs_sys2_("Motor Power On Failed")
                        goto 10
                    end    
                end
                if OverSpeed < 0 then
                  OverSpeed = 1
                end
                if OverSpeed > 100 then
                  OverSpeed = 100
                end                
                mc speed OverSpeed
                mc prime pg.main
                twait 0.2
                call lib.logs_sys2_("Execute pg.main")
                mc execute pg.main
            else
                call lib.logs_sys2_($ProgName[.RmtProgNo] + " Or " + $ProgName[0] + " Not Found")
                bits GoProgNumSt ,GoProgNumLen = 0
                goto 10
            end
        else
            if sig(LocalMain) == true then
                signal -LocalMain
                if existpgm($ProgName[1]) == true  then
                    if switch(power) == false then
                        mc zpower on 
                        twait 0.5
                        if switch(power) == false then
                            call lib.logs_sys2_("Motor Power On Failed")
                            goto 10
                        end    
                    end
                    call lib.logs_sys2_("Execute " + $ProgName[1])
                    mc speed 50
                    mc execute pg.mixsort_main
                else
                    call lib.logs_sys2_($ProgName[1] + " Not Found")
                end
            else
                if sig(LocalGoHome) == true then
                    signal -LocalGoHome
                    if existpgm($ProgName[25]) == true then
                        if switch(power) == false then
                            mc zpower on 
                            twait 0.5
                            if switch(power) == false then
                                call lib.logs_sys2_("Motor Power On Failed")
                                goto 10
                            end    
                        end
                        call lib.logs_sys2_("Execute " + $ProgName[25])
                        mc speed 30
                        mc execute pg.go_home
                    else
                        call lib.logs_sys2_($ProgName[25] + " Not Found")
                    end
                else
                    if sig(LocalCalib) == true then
                        signal -LocalCalib
                        if (existpgm($ProgName[26]) == true) and (switch(power) == true) then
                            if switch(power) == false then
                                mc zpower on 
                                twait 0.5
                                if switch(power) == false then
                                    call lib.logs_sys2_("Motor Power On Failed")
                                    goto 10
                                end    
                            end
                            call lib.logs_sys2_("Execute " + $ProgName[26])
                            mc execute pg.traje_move
                        else
                            call lib.logs_sys2_($ProgName[26] + " Not Found")
                        end
                    end
                end
            end
        end
    end

    ;Pause
    if ((sig(Di5RmtPause) == true) or (sig(LocalPause) == true)) and (sig(Do2Running) == true) then 
        signal -LocalPause
        call lib.logs_sys2_("Contrl Cmd Is Hold")
        mc hold 
        twait 0.5
        mc zpower off
    end

    ;Continue
    if (switch(repeat) == true) and (switch(cs) == false) and (switch(teach_lock) == false) and (switch(error) == false) and (sig(Do2Running) == false) then
        if sig(Di4RmtReStart) or sig(LocalContinue) then 
            call lib.logs_sys2_("Contrl Cmd Is Continue") 
            signal -LocalContinue
            if switch(power) == false then
                mc zpower on
                twait 0.5
                if switch(power) == false then
                    call lib.logs_sys2_("Motor Power On Failed")
                    goto 10
                end    
            end
            if whichtask($ProgName[0]) == 1 then
                call lib.logs_sys2_("Program Continue")
                mc continue
            else
                call lib.logs_sys2_("pg.mian Not Active")
            end
        end
    end

    GOTO 10

.end

;***********************************************************
; func lib.echo_chnl_()
;***********************************************************
; 
;***********************************************************
.program lib.echo_chnl_(.Channecll, .Channecl2, .Channecl3, .Channecl4)
    if existinteger("@USER_SIG_DEFED") == 0 then 

        call lib.user_sig_
    end

    bits Go007Channel01, 8 = .Channecll    
    bits Go008Channel02, 8 = .Channecl2
    bits Go009Channel03, 8 = .Channecl3    
    bits Go010Channel04, 8 = .Channecl4    
.end

;***********************************************************
; func lib.echo_jbif_()
;***********************************************************
; 
;***********************************************************
.program lib.echo_jbif_(.Info1, .Info2, .Info3, .Info4)
    if existinteger("@USER_SIG_DEFED") == 0 then 

        call lib.user_sig_
    end

    bits Go003InfoEho01, 8 = .Info1    
    bits Go004InfoEho02, 8 = .Info2
    bits Go005InfoEho03, 8 = .Info3    
    bits Go006InfoEho04, 8 = .Info4    
.end

;***********************************************************
; func lib.magnet_on_()
;***********************************************************
; 标准开磁程序
;***********************************************************
.program lib.magtool_on_()

    if existinteger("@USER_SIG_DEFED") == 0 then 

        call lib.user_sig_
    end
    
    utimer .@Timer = 0
    signal Do045ToolCtrl01, -Do046ToolCtrl02
    twait 0.2
    call lib.logs_sys1_("Waiting For Magnet On")
    wait (sig(Di045ToolEh01) == true) and (sig(Di046ToolEh02) == false) or (utimer(.@Timer) > 3)
    if utimer(.@Timer) > 3 then
        call lib.logs_sys1_("Magnet Off Timeout")
    end
    signal -Do045ToolCtrl01, -Do046ToolCtrl02
.end 

;***********************************************************
; func lib.magnet_on_()
;***********************************************************
; 标准关磁程序
;***********************************************************
.program lib.magtool_off_()

    if existinteger("@USER_SIG_DEFED") == 0 then 

        call lib.user_sig_
    end

    utimer .@Timer = 0
    signal -Do045ToolCtrl01, Do046ToolCtrl02
    twait 0.2
    call lib.logs_sys1_("Waiting For Magnet Off")
    wait (sig(Di045ToolEh01) == false) and (sig(Di046ToolEh02) == true)
    signal -Do045ToolCtrl01, -Do046ToolCtrl02
.end 

;***********************************************************
; func lib.wait_servo_()
;***********************************************************
; 标准抓手伺服控制程序
;***********************************************************
.program lib.sv01_ctrl_(.CtrlMode, .Dist)

    if existinteger("@USER_SIG_DEFED") == 0 then 

        call lib.user_sig_
    end

    case .CtrlMode

    value 1:
        call lib.logs_sys1_("Servo01 Ctrl")
        bits Go011AxisPos01, 16 = .Dist
        pulse Do057EAxsCtll01
    value 2:
        call lib.logs_sys1_("Waiting For Servo01 At Pos")
        while sig(Di057ExAxsEh01) == false do
            utimer .@Timer = 0
            wait (sig(Di057ExAxsEh01) == true) or (utimer(.@Timer) > 3)
            if sig(Di057ExAxsEh01) <> true then
                pulse Do057EAxsCtll01
            end
        end
    any :

    end
.end

;***********************************************************
; func lib.wait_servo_()
;***********************************************************
; 标准 HOME I/O 程序
;***********************************************************
.program lib.home_io_()

    if existinteger("@USER_SIG_DEFED") == 0 then 

        call lib.user_sig_
    end

    swait Do7AtHome

    bits Go001ProgNo, 8 = 0
    bits Go002PathSeg, 8 = 0
    signal -Do041EndOfSeg

    ;Zone
    signal Do021EnterZ01, Do022EnterZ02, Do023EnterZ03, Do024EnterZ04
    signal Do025EnterZ05, Do026EnterZ06, Do027EnterZ07, Do028EnterZ08
    signal Do029EnterZ09, Do030EnterZ10, Do031EnterZ11, Do032EnterZ12

    signal -Do241InZone01, -Do242InZone02, -Do243InZone03, -Do244InZone04
    signal -Do245InZone05, -Do246InZone06, -Do247InZone07, -Do248InZone08
    signal -Do249InZone09, -Do250InZone10, -Do251InZone11, -Do252InZone12
    call lib.logs_sys1_("Exec Home Io Comp")
.end 

;***********************************************************
; func lib.path_seg_()
;***********************************************************
; 标准路径段反馈程序
;***********************************************************
.program lib.path_seg_(.SegmentNo)
    if existinteger("@USER_SIG_DEFED") == 0 then 

        call lib.user_sig_
    end
    bits Go002PathSeg, 8 = .SegmentNo
    signal -Do041EndOfSeg
.end

;***********************************************************
; func lib.req_cont_()
;***********************************************************
; 标准路径段请求程序
;***********************************************************
.program lib.req_cont_(.SegmentNo)
    if existinteger("@USER_SIG_DEFED") == 0 then 

        call lib.user_sig_
    end
    signal -Do041EndOfSeg
    swait -Di041EndOfSeg
    signal Do041EndOfSeg
    swait Di041EndOfSeg
    ContDiciCode = bits(Gi002DiciCode, 8)
.end

;***********************************************************
; func lib.chk_home01_()
;***********************************************************
; 
;***********************************************************
.program lib.chk_home01_()
    .AtHome = true
    decompose .Joints[0] = #here
    decompose .JointsHome[0] = #home(1)
    .NumOfAxis = sysdata(zrob.nowaxis)
    for .i = 0 to (.NumOfAxis - 1)
        if abs(.Joints[.i] - .JointsHome[.i]) > 1 then

            .AtHome = false
        end
    end

    if .AtHome == false then
        call lib.logs_sys1_("Robot Not At Home01")
        halt
    end

    swait Do7AtHome

.end

;***********************************************************
; func lib.mov_home_()
;***********************************************************
; 标准回 HOME 程序
;***********************************************************
.program lib.mov_home_()

    speed 80
    accuracy 1

    call lib.logs_sys1_("Robot Moving Home Pos")

    jmove #home(1)

    call lib.home_io_

.end 

;***********************************************************
; func lib.enter_zone_()
;***********************************************************
;  IN  : .ZoneNo		    * INT *      * 干涉区编号 *
;***********************************************************
; 标准进干涉区程序
;***********************************************************
.program lib.enter_zone_(.ZoneNo)

    if existinteger("@USER_SIG_DEFED") == 0 then 

        call lib.user_sig_
    end

    case .ZoneNo of 

    value 1:
        signal -Do021EnterZ01
        call lib.logs_sys1_("Waiting For Zone 1 Clear")
        swait Di021ZReady01
        signal Do241InZone01
    value 2:
        signal -Do022EnterZ2
        call lib.logs_sys1_("Waiting For Zone 2 Clear")
        swait Di022ZReady02
        signal Do242InZone02
    value 3:
        signal -Do023EnterZ3
        call lib.logs_sys1_("Waiting For Zone 3 Clear")
        swait Di023ZReady03
        signal Do243InZone03
    value 4:
        signal -Do024EnterZ4
        call lib.logs_sys1_("Waiting For Zone 4 Clear")
        swait Di024ZReady04
        signal Do244InZone04
    value 5:
        signal -Do025EnterZ5
        call lib.logs_sys1_("Waiting For Zone 5 Clear")
        swait Di025ZReady05
        signal Do245InZone05
    value 6:
        signal -Do026EnterZ6
        call lib.logs_sys1_("Waiting For Zone 6 Clear")
        swait Di026ZReady06
        signal Do246InZone06
    value 7:
        signal -Do027EnterZ7
        call lib.logs_sys1_("Waiting For Zone 7 Clear")
        swait Di027ZReady07
        signal Do247InZone07
    value 8:
        signal -Do028EnterZ8
        call lib.logs_sys1_("Waiting For Zone 8 Clear")
        swait Di028ZReady08
        signal Do248InZone08
    value 9:
        signal -Do029EnterZ9
        call lib.logs_sys1_("Waiting For Zone 9 Clear")
        swait Di029ZReady09
        signal Do249InZone09
    value 10:
        signal -Do030EnterZ10
        call lib.logs_sys1_("Waiting For Zone 10 Clear")
        swait Di030ZReady10
        signal Do250InZone10
    value 11:
        signal -Do031EnterZ11
        call lib.logs_sys1_("Waiting For Zone 11 Clear")
        swait Di031ZReady11
        signal Do251InZone11
    value 12:
        signal -Do032EnterZ12
        call lib.logs_sys1_("Waiting For Zone 12 Clear")
        swait Di032ZReady12
        signal Do252InZone12
    any :
        call lib.logs_sys1_("Zone Num Error")
        halt
    end
.end
;***********************************************************
; func lib.enter_zone_()
;***********************************************************
;  IN  : .ZoneNo		    * INT *      * 干涉区编号 *
;***********************************************************
; 标准退干涉区程序
;***********************************************************
.program lib.exit_zone_(.ZoneNo)

    if existinteger("@USER_SIG_DEFED") == 0 then 

        call lib.user_sig_
    end

    case .ZoneNo of 

    value 1:
        call lib.logs_sys1_("Exit Zone 1")
        signal Do021EnterZ01
        signal -Do241InZone01
    value 2:
        call lib.logs_sys1_("Exit Zone 2")
        signal Do022EnterZ02
        signal -Do242InZone02
    value 3:
        call lib.logs_sys1_("Exit Zone 3")
        signal Do023EnterZ03
        signal -Do243InZone03
    value 4:
        call lib.logs_sys1_("Exit Zone 4")
        signal Do024EnterZ04
        signal -Do244InZone04
    value 5:
        call lib.logs_sys1_("Exit Zone 5")
        signal Do025EnterZ05
        signal -Do245InZone05
    value 6:
        call lib.logs_sys1_("Exit Zone 6")
        signal Do026EnterZ06
        signal -Do246InZone06
    value 7:
        call lib.logs_sys1_("Exit Zone 7")
        signal Do027EnterZ07
        signal -Do247InZone07
    value 8:
        call lib.logs_sys1_("Exit Zone 8")
        signal Do028EnterZ08
        signal -Do248InZone08
    value 9:
        call lib.logs_sys1_("Exit Zone 9")
        signal Do029EnterZ09
        signal -Do249InZone09
    value 10:
        call lib.logs_sys1_("Exit Zone 10")
        signal Do030EnterZ10
        signal -Do250InZone10
    value 11:
        call lib.logs_sys1_("Exit Zone 11")
        signal Do031EnterZ11
        signal -Do251InZone11
    value 12:
        call lib.logs_sys1_("Exit Zone 12")
        signal Do032EnterZ12
        signal -Do252InZone12
    any :
        call lib.logs_sys1_("Zone Num Error")
        halt
    end
.end

;***********************************************************
; func lib.sys_sig_()
;***********************************************************
; 根据标准信号表定义系统信号得别名
;***********************************************************
.program lib.sys_sig_()

    ;In
    Di1MotorOn                          = 1001      ; 马达开
    Di2MotorOff                         = 1002      ; 马达关
    Di3RmtStart                         = 1003      ; 程序启动
    Di4RmtReStart                       = 1004      ; 程序再启动
    Di5RmtPause                         = 1005      ; 程序暂停
    Di6                                 = 1006      ; 预留
    Di7RstFault                         = 1007      ; 错误复位
    Di8                                 = 1008      ; 预留
    GiProgNumSt                         = 1009      ; 程序号开始位
    Di17                                = 1017      ; 预留
    Di18                                = 1018      ; 预留
    Di19Pc1Run                          = 1019      ; Pc1程序运行
    Di20Pc1Stop                         = 1020      ; Pc1程序停止

    ;Out
    Do1MotorOn                          = 1         ; 马达已开启
    Do2Running                          = 2         ; 程序运行中
    Do3Pause                            = 3         ; 程序已暂停         
    Do4CtrlManu                         = 4         ; 控制柜手动模式 
    Do5TpEnable                         = 5         ; 示教器手动模式
    Do6Fault                            = 6         ; 报错中
    Do7AtHome                           = 7         ; 在原点
    Do8BattAlarm                        = 8         ; 编码器电池电量低
    Do9                                 = 9         ; 预留
    Do10EStop                           = 10        ; 急停中
    GoProgNumSt                         = 11        ; 程序号开始位
    GoProgNumLen                        = 8         ; 程序号信号长度
    Do19PcRunning                       = 19        ; Pc1程序运行中
    Do20                                = 20        ; 预留

    ;Local Ctrl
    LocalMain                           = 2001      ; 本地启动主程序
    LocalGoHome                         = 2002      ; 本地启动回原点程序
    LocalCalib                          = 2003      ; 本地启动回标定程序
    LocalPause                          = 2004      ; 暂停程序
    LocalContinue                       = 2005      ; 继续程序

    SYS_SIG_DEFED                       = 0

.end

;***********************************************************
; func lib.user_sig_()
;***********************************************************
; 根据标准信号表定义用户信号得别名
;***********************************************************
.program lib.user_sig_()

    ;Out GO
    Go001ProgNo                         = 11
    Go002PathSeg                        = 33
    Go003InfoEho01                      = 97
    Go004InfoEho02                      = 105
    Go005InfoEho03                      = 113
    Go006InfoEho04                      = 121
    Go007Channel01                      = 129
    Go008Channel02                      = 137
    Go009Channel03                      = 145
    Go010Channel04                      = 153
    Go011AxisPos01                      = 161

    ;Out DO
    Do021EnterZ01                       = 21
    Do022EnterZ02                       = 22
    Do023EnterZ03                       = 23
    Do024EnterZ04                       = 24
    Do025EnterZ05                       = 25
    Do026EnterZ06                       = 26
    Do027EnterZ07                       = 27
    Do028EnterZ08                       = 28
    Do029EnterZ09                       = 29
    Do030EnterZ10                       = 30
    Do031EnterZ11                       = 31
    Do032EnterZ12                       = 32
    Do041EndOfSeg                       = 41
    Do042Reserved                       = 42
    Do043Reserved                       = 43
    Do044Reserved                       = 44

    Do045ToolCtrl01                     = 45
    Do046ToolCtrl02                     = 46
    Do047ToolCtrl03                     = 47
    Do048ToolCtrl04                     = 48
    Do049ToolCtrl05                     = 49
    Do050ToolCtrl06                     = 50
    Do051ToolCtrl07                     = 51
    Do052ToolCtrl08                     = 52
    Do053ToolCtrl09                     = 53
    Do054ToolCtrl10                     = 54
    Do055ToolCtrl11                     = 55
    Do056ToolCtrl12                     = 56

    Do057EAxsCtll01                     = 57
    Do058EAxsCtll02                     = 58
    Do059EAxsCtll03                     = 59

    Do060Reserved                       = 60
    Do061Reserved                       = 61
    Do062Reserved                       = 62
    Do063Reserved                       = 63
    Do064Reserved                       = 64
    Do065Reserved                       = 65
    Do066Reserved                       = 66
    Do067Reserved                       = 67

    Do068TakPict01                      = 68
    Do069TakPict02                      = 69
    Do070TakPict03                      = 70
    Do071LaserOn01                      = 71
    Do072LaserOn02                      = 72

    Do073ExDCtl01                       = 73
    Do074ExDCtl02                       = 74
    Do075ExDCtl03                       = 75
    Do076ExDCtl04                       = 76
    Do077ExDCtl05                       = 77
    Do078ExDCtl06                       = 78
    Do079ExDCtl07                       = 79
    Do080ExDCtl08                       = 80
    Do081ExDCtl09                       = 81
    Do082ExDCtl10                       = 82
    Do083ExDCtl11                       = 83
    Do084ExDCtl12                       = 84

    Do085Reserved                       = 85
    Do086Reserved                       = 86
    Do087Reserved                       = 87
    Do088Reserved                       = 88
    Do089Reserved                       = 89
    Do090Reserved                       = 90
    Do091Reserved                       = 91
    Do092Reserved                       = 92
    Do093Reserved                       = 93
    Do094Reserved                       = 94
    Do095Reserved                       = 95
    Do096Reserved                       = 96

    Do241InZone01                       = 241
    Do242InZone02                       = 242
    Do243InZone03                       = 243
    Do244InZone04                       = 244
    Do245InZone05                       = 245
    Do246InZone06                       = 246
    Do247InZone07                       = 247
    Do248InZone08                       = 248
    Do249InZone09                       = 249
    Do250InZone10                       = 250
    Do251InZone11                       = 251
    Do252InZone12                       = 252
    
    ;In GI
    Gi001ProgNo                         = 1009
    Gi002DiciCode                       = 1033
    Gi003InfoEh01                       = 1097
    Gi004InfoEh02                       = 1113
    Gi005InfoEh03                       = 1121
    Gi006InfoEh04                       = 1129
    Gi007AxisPos01                      = 1161


    ;In DI
    Di021ZReady01                       = 1021
    Di022ZReady02                       = 1022
    Di023ZReady03                       = 1023
    Di024ZReady04                       = 1024
    Di025ZReady05                       = 1025
    Di026ZReady06                       = 1026
    Di027ZReady07                       = 1027
    Di028ZReady08                       = 1028
    Di029ZReady09                       = 1029
    Di030ZReady10                       = 1030
    Di031ZReady11                       = 1031
    Di032ZReady12                       = 1032

    Di041EndOfSeg                       = 1041
    Di042Reserved                       = 1042
    Di043Reserved                       = 1043
    Di044Reserved                       = 1044

    Di045ToolEh01                       = 1045
    Di046ToolEh02                       = 1046
    Di047ToolEh03                       = 1047
    Di048ToolEh04                       = 1048
    Di049ToolEh05                       = 1049
    Di050ToolEh06                       = 1050
    Di051ToolEh07                       = 1051
    Di052ToolEh08                       = 1052
    Di053ToolEh09                       = 1053
    Di054ToolEh10                       = 1054
    Di055ToolEh11                       = 1055
    Di056ToolEh12                       = 1056

    Di057ExAxsEh01                      = 1057
    Di058ExAxsEh02                      = 1058
    Di059ExAxsEh03                      = 1059

    Di060Reserved                       = 1060
    Di061Reserved                       = 1061
    Di062Reserved                       = 1062
    Di063Reserved                       = 1063
    Di064Reserved                       = 1064
    Di065Reserved                       = 1065
    Di066Reserved                       = 1066
    Di067Reserved                       = 1067

    Di068PictEh01                       = 1068
    Di069PictEh02                       = 1069
    Di070PictEh03                       = 1070
    Di071Reserved                       = 1071
    Di072Reserved                       = 1072

    Di073ExDevEh01                      = 1073
    Di074ExDevEh02                      = 1074
    Di075ExDevEh03                      = 1075
    Di076ExDevEh04                      = 1076
    Di077ExDevEh05                      = 1077
    Di078ExDevEh06                      = 1078
    Di079ExDevEh07                      = 1079
    Di080ExDevEh08                      = 1080
    Di081ExDevEh09                      = 1081
    Di082ExDevEh10                      = 1082
    Di083ExDevEh11                      = 1083
    Di084ExDevEh12                      = 1084

    Di085Reserved                       = 1085
    Di086Reserved                       = 1086
    Di087Reserved                       = 1087
    Di088Reserved                       = 1088
    Di089Reserved                       = 1089
    Di090Reserved                       = 1090
    Di091Reserved                       = 1091
    Di092Reserved                       = 1092
    Di093Reserved                       = 1093
    Di094Reserved                       = 1094
    Di095Reserved                       = 1095
    Di096Reserved                       = 1096
    USER_SIG_DEFED                      = 0                                     
.end

;***********************************************************
; func pg.main()
;***********************************************************
; 根据标准信号表定义用户信号得别名
;***********************************************************
.program pg.main()
    
    if existinteger("@SYS_SIG_DEFED") == 0 then 

        call lib.sys_sig_
    end
  
    CurPrgNum = bits(GiProgNumSt ,8)

    case CurPrgNum
    value 1:
        call lib.chk_home01_
        scall "pg.mixsort_main"
    value 2:
    value 3:
    value 4:
    value 5:
    value 6:
    value 7:
    value 8:
    value 9:
    value 10:
    value 11:
    value 12:
    value 13:
    value 14:
    value 15:
    value 16:
    value 17:
    value 18:
    value 19:
    value 20:
    value 21:
    value 22:
    value 23:
    value 24:
    value 25:
        scall "pg.go_home"
    value 26:
    value 27:
    value 28:
    value 29:
    value 30:
    value 21:
    end
.end

