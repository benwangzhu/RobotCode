;***********************************************************
;
; Copyright 2018 - 2023 speedbot All Rights reserved.
;
; File Name: lib_busio
;
; Description:
;   Language             ==   As for KAWASAKI ROBOT
;   Date                 ==   2023 - 07 - 09
;   Modification Data    ==   2023 - 07 - 09
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


.program lib.bus_sbyte_(.StAddr, .Value)
    if .StAddr <= 0 then
        return
    end
    bits .StAddr, 8 = .Value
.end

.program lib.bus_ssint_(.StAddr, .Value)
    if .StAddr <= 0 then
        return
    end
    if .Value <= 0 then
        return
    end
    bits .StAddr, 16 = .Value
.end

.program lib.bus_susint_(.StAddr, .Value)
    if .StAddr <= 0 then
        return
    end
    bits .StAddr, 16 = .Value
.end

.program lib.bus_sint_(.StAddr, .Value)
    if .StAddr <= 0 then
        return
    end
    
    bits .StAddr + 0, 8     = int((.Value band 255)         / 1)        band (255)
    bits .StAddr + 8, 8     = int((.Value band 65280)       / 256)      band (255)
    bits .StAddr + 16, 8    = int((.Value band 16711680)    / 65536)    band (255)
    bits .StAddr + 24, 8    = int((.Value band (-16777216)) / 16777216) band (255)
.end

.program lib.bus_sfloat2_(.StAddr, .Value) 
    if .StAddr <= 0 then
        return
    end
    .IntVal = int(.Value)
    .DecVal = round((.Value - .IntVal) * 10000.0)
    bits .StAddr + 0,  16 = .IntVal
    bits .StAddr + 16, 16 = .DecVal
.end

.program lib.bus_sjoint_(.StAddr, .#Value, .NumOfAxis)
    if .StAddr <= 0 then
        return
    end
    decompose .Array[0] = .#Value
    for .I = 0 to (.NumOfAxis - 1)
        .IntVal = int(.Array[.I])
        .DecVal = round((.Array[.I] - .IntVal) * 10000.0)
        bits .StAddr + .I * 32 + 0,  16 = .IntVal
        bits .StAddr + .I * 32 + 16, 16 = .DecVal
    end
.end

.program lib.bus_scartp_(.StAddr, .&Value, .NumOfAxis)
    if .StAddr <= 0 then
        return
    end
    decompose .Array[0] = .&Value
    for .I = 0 to (.NumOfAxis - 1)
        .IntVal = int(.Array[.I])
        .DecVal = round((.Array[.I] - .IntVal) * 10000.0)
        bits .StAddr + .I * 32 + 0,  16 = .IntVal
        bits .StAddr + .I * 32 + 16, 16 = .DecVal
    end
.end

.program lib.bus_gbyte_(.StAddr, .Value)
    if .StAddr <= 0 then
        .Value = 0
        return
    end

    .Value = bits(.StAddr, 8)
.end

.program lib.bus_gsint_(.StAddr, .Value)
    if .StAddr <= 0 then
        .Value = 0
        return
    end

    .Value = bits(.StAddr, 16)

    if .Value > 32767 then 

        .Value = .Value - 65536
    end
.end

.program lib.bus_gusint_(.StAddr, .Value)
    if .StAddr <= 0 then
        .Value = 0
        return
    end

    .Value = bits(.StAddr, 16)
.end

.program lib.bus_gint_(.StAddr, .Value)
    if .StAddr <= 0 then
        .Value = 0
        return
    end

	.$Hex[0] = $encode(/J2, bits(.StAddr + 0, 8))
	.$Hex[1] = $encode(/J2, bits(.StAddr + 8, 8))
	.$Hex[2] = $encode(/J2, bits(.StAddr + 16, 8))
	.$Hex[3] = $encode(/J2, bits(.StAddr + 24, 8))
	
    .Value      = val("^h" + .$Hex[3] + .$Hex[2] + .$Hex[1] + .$Hex[0])
.end

.program lib.bus_gfloat2_(.StAddr, .Value)
    if .StAddr <= 0 then
        .Value = 0
        return
    end

    .IntVal = bits(.StAddr + 0, 16)
    .DecVal = bits(.StAddr + 16, 16)
    if .IntVal > 32767 then 

        .IntVal = .IntVal - 65536
    end
    if .DecVal > 32767 then 

        .DecVal = .DecVal - 65536
    end
    .Value = .IntVal + .DecVal / 10000.0
.end

.program lib.bus_gjoint_(.StAddr, .#Value, .NumOfAxis)
    
    point .#Value = #here

    for .I = 0 to (.NumOfAxis - 1)

        .JointAry[I] = 0.0
        call lib.bus_gfloat2_(.StAddr + I * 32, .JointAry[I])
    end

    if .NumOfAxis == 1 then 

        point .#Value = #ppoint(.JointAry[1], , , , , ,)
        return
    end
    if .NumOfAxis == 2 then 

        point .#Value = #ppoint(.JointAry[1], .JointAry[2], , , , ,)
        return
    end
    if .NumOfAxis == 3 then 

        point .#Value = #ppoint(.JointAry[1], .JointAry[2], .JointAry[3], , , ,)
        return
    end
    if .NumOfAxis == 4 then 

        point .#Value = #ppoint(.JointAry[1], .JointAry[2], .JointAry[3], .JointAry[4], , ,)
        return
    end
    if .NumOfAxis == 5 then 

        point .#Value = #ppoint(.JointAry[1], .JointAry[2], .JointAry[3], .JointAry[4], .JointAry[5], ,)
        return
    end
    if .NumOfAxis == 6 then 

        point .#Value = #ppoint(.JointAry[1], .JointAry[2], .JointAry[3], .JointAry[4], .JointAry[5], .JointAry[6],)
        return
    end
    if .NumOfAxis == 7 then 

        point .#Value = #ppoint(.JointAry[1], .JointAry[2], .JointAry[3], .JointAry[4], .JointAry[5], .JointAry[6], .JointAry[7])
        return
    end
    if .NumOfAxis == 8 then 

        point .#Value = #ppoint(.JointAry[1], .JointAry[2], .JointAry[3], .JointAry[4], .JointAry[5], .JointAry[6], .JointAry[7], .JointAry[8])
        return
    end
    if .NumOfAxis == 9 then 

        point .#Value = #ppoint(.JointAry[1], .JointAry[2], .JointAry[3], .JointAry[4], .JointAry[5], .JointAry[6], .JointAry[7], .JointAry[8], .JointAry[9])
        return
    end
.end

.program lib.bus_gcartp_(.StAddr, .&Value, .NumOfAxis)
    
    point .&Value = here

    for .I = 0 to (.NumOfAxis - 1)

        .CartAry[I] = 0.0
        call lib.bus_gfloat2_(.StAddr + I * 32, .CartAry[I])
    end

    if .NumOfAxis == 1 then 

        point .&Value = trans(.CartAry[1], , , , , ,)
        return
    end
    if .NumOfAxis == 2 then 

        point .&Value = trans(.CartAry[1], .CartAry[2], , , , ,)
        return
    end
    if .NumOfAxis == 3 then 

        point .&Value = trans(.CartAry[1], .CartAry[2], .CartAry[3], , , ,)
        return
    end
    if .NumOfAxis == 4 then 

        point .&Value = trans(.CartAry[1], .CartAry[2], .CartAry[3], .CartAry[4], , ,)
        return
    end
    if .NumOfAxis == 5 then 

        point .&Value = trans(.CartAry[1], .CartAry[2], .CartAry[3], .CartAry[4], .CartAry[5], ,)
        return
    end
    if .NumOfAxis == 6 then 

        point .&Value = trans(.CartAry[1], .CartAry[2], .CartAry[3], .CartAry[4], .CartAry[5], .CartAry[6],)
        return
    end
    if .NumOfAxis == 7 then 

        point .&Value = trans(.CartAry[1], .CartAry[2], .CartAry[3], .CartAry[4], .CartAry[5], .CartAry[6], .CartAry[7])
        return
    end
    if .NumOfAxis == 8 then 

        point .&Value = trans(.CartAry[1], .CartAry[2], .CartAry[3], .CartAry[4], .CartAry[5], .CartAry[6], .CartAry[7], .CartAry[8])
        return
    end
    if .NumOfAxis == 9 then 

        point .&Value = trans(.CartAry[1], .CartAry[2], .CartAry[3], .CartAry[4], .CartAry[5], .CartAry[6], .CartAry[7], .CartAry[8], .CartAry[9])
        return
    end
.end

.program lib.bus_uptin_(.BusIn[])

    if existinteger("@BUSIO_DEFED") == 0 then 

        call lib.def_busio_
    end

    .BusIn[DI_SYSREADT]         = sig(.BusIn[BUSIO_ST] + 0)
    .BusIn[DI_INITED]           = sig(.BusIn[BUSIO_ST] + 1)
    .BusIn[DI_STOPMOV]          = sig(.BusIn[BUSIO_ST] + 2)
    .BusIn[DI_ONMEASURE]        = sig(.BusIn[BUSIO_ST] + 3)
    .BusIn[DI_MEASUREOVER]      = sig(.BusIn[BUSIO_ST] + 4)
    .BusIn[DI_RESULTOK]         = sig(.BusIn[BUSIO_ST] + 5)
    .BusIn[DI_RESULTNG]         = sig(.BusIn[BUSIO_ST] + 6)
    .BusIn[DI_FINISHED]         = sig(.BusIn[BUSIO_ST] + 7)
    .BusIn[GI_DEVICEID]         = bits(.BusIn[BUSIO_ST] + 8, 8)
    .BusIn[GI_JOBID]            = bits(.BusIn[BUSIO_ST] + 16, 8)
    .BusIn[GI_ERRORID]          = bits(.BusIn[BUSIO_ST] + 24, 8)
    .BusIn[GI_AGENTTELLID]      = bits(.BusIn[BUSIO_ST] + 32, 8)
    .BusIn[GI_AGENTMSGTYPE]     = bits(.BusIn[BUSIO_ST] + 40, 8)
    .BusIn[GI_TELLID]           = bits(.BusIn[BUSIO_ST] + 48, 8)
    .BusIn[GI_MSGTYPE]          = bits(.BusIn[BUSIO_ST] + 56, 8)
.end

.program lib.bus_uptout_(.BusOut[])

    if existinteger("@BUSIO_DEFED") == 0 then 

        call lib.def_busio_
    end

    bits .BusOut[BUSIO_ST] + 0, 1  = .BusOut[DO_SYSENABLE]
    bits .BusOut[BUSIO_ST] + 1, 1  = .BusOut[DO_INIT]
    bits .BusOut[BUSIO_ST] + 2, 1  = .BusOut[DO_ROBMOVING]
    bits .BusOut[BUSIO_ST] + 3, 1  = .BusOut[DO_MEASUREST]
    bits .BusOut[BUSIO_ST] + 4, 1  = .BusOut[DO_MEASUREED]
    bits .BusOut[BUSIO_ST] + 5, 1  = .BusOut[DO_RESERVER1]
    bits .BusOut[BUSIO_ST] + 6, 1  = .BusOut[DO_RESERVER2]
    bits .BusOut[BUSIO_ST] + 7, 1  = .BusOut[DO_CYCLEEND]
    bits .BusOut[BUSIO_ST] + 8, 8  = .BusOut[GO_ROBOTID]
    bits .BusOut[BUSIO_ST] + 16, 8 = .BusOut[GO_JOBID]
    bits .BusOut[BUSIO_ST] + 24, 8 = .BusOut[GO_PROTOCOLID]
    bits .BusOut[BUSIO_ST] + 32, 8 = .BusOut[GO_TELLID]
    bits .BusOut[BUSIO_ST] + 40, 8 = .BusOut[GO_MSGTYPE]
    bits .BusOut[BUSIO_ST] + 48, 8 = .BusOut[GO_ROBOTTELLID]
    bits .BusOut[BUSIO_ST] + 56, 8 = .BusOut[GO_ROBOTMSGTYPE]
.end

.program lib.bus_init_(.BusIn[], .BusOut[], .RobId, .ProtId)

    if existinteger("@BUSIO_DEFED") == 0 then 

        call lib.def_busio_
    end

    if sig(.BusOut[BUSIO_ST] + 1) == true then

        signal -(.BusOut[BUSIO_ST] + 1)

        twait 0.2
    end
    
    .BusOut[DO_SYSENABLE]           = true
    .BusOut[DO_INIT]                = true   
    .BusOut[DO_ROBMOVING]           = false
    .BusOut[DO_MEASUREST]           = false
    .BusOut[DO_MEASUREED]           = false
    .BusOut[DO_RESERVER1]           = false
    .BusOut[DO_RESERVER2]           = false
    .BusOut[DO_CYCLEEND]            = false

    .BusOut[GO_ROBOTID]             = .RobId
    .BusOut[GO_JOBID]               = 0
    .BusOut[GO_PROTOCOLID]          = .ProtId
    .BusOut[GO_TELLID]              = 0
    .BusOut[GO_MSGTYPE]             = 0
    .BusOut[GO_ROBOTTELLID]         = 0

    ; Code Modified on 2025.05.01
    ; 不初始化 RobMsgType, 以免 lib_buscmd 函数传参受到影响 
    ; .BusOut[GO_ROBOTMSGTYPE]        = 0
    ;

    call lib.bus_uptout_(.BusOut[])

    twait 0.2

    ;if not ((.BusOut[GO_PROTOCOLID] == PTC_LN_PL) or (.BusOut[GO_PROTOCOLID] == PTC_ST_PK)) then
        do
            call lib.bus_uptin_(.BusIn[])
        until (.BusIn[GI_TELLID] == 0) and (.BusIn[DI_INITED] == true)
    ;end

    call lib.bus_uptin_(.BusIn[])

    .BusOut[GO_TELLID]              = .BusIn[GI_AGENTTELLID]
    .BusOut[GO_MSGTYPE]             = .BusIn[GI_AGENTMSGTYPE]
    .BusOut[DO_INIT]                = false   
    
    call lib.bus_uptout_(.BusOut[])

    ;swait .BusIn[BUSIO_ST]
.end

.program lib.bus_wtell_(.BusIn[], .BusOut[], .Timeout, .Status)

    if existinteger("@BUSIO_DEFED") == 0 then 

        call lib.def_busio_
    end

    utimer .@Timer = 0    

    do
        .BusOut[GO_TELLID]      = bits(.BusOut[BUSIO_ST] + 32, 8)       
        .BusIn[GI_AGENTTELLID]  = bits(.BusIn[BUSIO_ST] + 32, 8)

        if (.BusIn[GI_AGENTTELLID] == 0) or (.BusOut[GO_TELLID] == .BusIn[GI_AGENTTELLID]) then 
            if .Timeout == 0.0 then 
                .Status = -3
                return
            end

            twait 0.012
        else
            .BusIn[GI_JOBID]            = bits(.BusIn[BUSIO_ST] + 16, 8)
            .BusIn[GI_ERRORID]          = bits(.BusIn[BUSIO_ST] + 24, 8)
            .BusIn[GI_AGENTMSGTYPE]     = bits(.BusIn[BUSIO_ST] + 40, 8)
            .Status                     = .BusIn[GI_ERRORID]
            return
        end
        .BusIn[DI_SYSREADT]         = sig(.BusIn[BUSIO_ST] + 0)
        .BusOut[DO_SYSENABLE]       = sig(.BusOut[BUSIO_ST] + 0)
        .BusOut[DO_INIT]            = sig(.BusOut[BUSIO_ST] + 1)

    until ((utimer(.@Timer) > .Timeout) and (.Timeout > 0)) or (.BusIn[DI_SYSREADT] == 0) or (.BusOut[DI_SYSREADT] == 0) or (.BusOut[DO_INIT] == true)

    if (.BusIn[DI_SYSREADT] == 0) or (.BusOut[DO_SYSENABLE] == 0) or (.BusOut[DO_INIT] == true) then
        .Status = -2
        return
    end

    .Status = -1
.end

.program lib.bus_ftell_(.BusIn[], .BusOut[])

    if existinteger("@BUSIO_DEFED") == 0 then 

        call lib.def_busio_
    end

    .BusIn[GI_AGENTTELLID]      = bits(.BusIn[BUSIO_ST] + 32, 8)
    .BusIn[GI_AGENTMSGTYPE]     = bits(.BusIn[BUSIO_ST] + 40, 8)
    .BusOut[GO_TELLID]          = .BusIn[GI_AGENTTELLID]
    .BusOut[GO_MSGTYPE]         = .BusIn[GI_AGENTMSGTYPE]
    bits .BusOut[BUSIO_ST] + 32, 8 = .BusOut[GO_TELLID]
    bits .BusOut[BUSIO_ST] + 40, 8 = .BusOut[GO_MSGTYPE]
   
.end

.program lib.bus_ntell_(.BusIn[], .BusOut[], .Timeout, .Status)

    if existinteger("@BUSIO_DEFED") == 0 then 

        call lib.def_busio_
    end

    utimer .@Timer = 0  

    .BusIn[GI_TELLID]           = bits(.BusIn[BUSIO_ST] + 48, 8)
    .BusOut[GO_ROBOTTELLID]     = .BusIn[GI_TELLID] + 1

    if .BusOut[GO_ROBOTTELLID] > 255 then 

        .BusOut[GO_ROBOTTELLID] = 1
    end

    bits .BusOut[BUSIO_ST] + 8, 8 = .BusOut[GO_ROBOTID]
    bits .BusOut[BUSIO_ST] + 16, 8 = .BusOut[GO_JOBID]
    bits .BusOut[BUSIO_ST] + 56, 8 = .BusOut[GO_ROBOTMSGTYPE]
    bits .BusOut[BUSIO_ST] + 48, 8 = .BusOut[GO_ROBOTTELLID]

    if .Timeout >= 0 then
        wait (bits(.BusOut[BUSIO_ST] + 48, 8) == bits(.BusIn[BUSIO_ST] + 48, 8)) or (sig(.BusIn[BUSIO_ST] + 0) == 0) or (sig(.BusOut[BUSIO_ST] + 0) == 0) or (sig(.BusOut[BUSIO_ST] + 1) == true) or (utimer(.@Timer) > .Timeout)
    else
        wait (bits(.BusOut[BUSIO_ST] + 48, 8) == bits(.BusIn[BUSIO_ST] + 48, 8)) or (sig(.BusIn[BUSIO_ST] + 0) == 0) or (sig(.BusOut[BUSIO_ST] + 0) == 0) or (sig(.BusOut[BUSIO_ST] + 1) == true)
    end

    .BusIn[GI_TELLID]       = bits(.BusIn[BUSIO_ST] + 48, 8)
    .BusIn[DI_SYSREADT]     = sig(.BusIn[BUSIO_ST] + 0)
    .BusOut[DO_SYSENABLE]   = sig(.BusOut[BUSIO_ST] + 0)
    .BusOut[DO_INIT]        = sig(.BusOut[BUSIO_ST] + 1)

    if .BusOut[GO_ROBOTTELLID] == .BusIn[GI_TELLID] then 
        .BusIn[GI_JOBID]            = bits(.BusIn[BUSIO_ST] + 16, 8)
        .BusIn[GI_ERRORID]          = bits(.BusIn[BUSIO_ST] + 24, 8)
        .BusIn[GI_MSGTYPE]          = bits(.BusIn[BUSIO_ST] + 56, 8)
        .Status                     = .BusIn[GI_ERRORID]
        return
    end

    if (.BusIn[DI_SYSREADT] == 0) or (.BusOut[DO_SYSENABLE] == 0) or (.BusOut[DO_INIT] == true) then
        .Status = -2
        return
    end

    .Status = -1
.end

.program lib.bus_stell_(.BusIn[], .BusOut[])

    if existinteger("@BUSIO_DEFED") == 0 then 

        call lib.def_busio_
    end

    .BusIn[GI_TELLID]           = bits(.BusIn[BUSIO_ST] + 48, 8)
    .BusOut[GO_ROBOTTELLID]     = bits(.BusOut[BUSIO_ST] + 48, 8) 
    .BusOut[DO_SYSENABLE]       = sig(.BusOut[BUSIO_ST] + 0)

    ; Code Modified on 2025.05.16
    ; 修复当机器人没有使能 SysEnable 信号时，重新进行初始化
    if (.BusIn[GI_TELLID] <> .BusOut[GO_ROBOTTELLID]) or (.BusOut[DO_SYSENABLE] == 0) then

        call lib.bus_init_(.BusIn, .BusOut, .BusOut[GO_ROBOTID], PTC_GEN_CMD)
    end
    ;

    .BusOut[GO_ROBOTTELLID]     = .BusIn[GI_TELLID] + 1

    if .BusOut[GO_ROBOTTELLID] > 255 then 

        .BusOut[GO_ROBOTTELLID] = 1
    end

    bits .BusOut[BUSIO_ST] + 8, 8 = .BusOut[GO_ROBOTID]
    bits .BusOut[BUSIO_ST] + 16, 8 = .BusOut[GO_JOBID]
    bits .BusOut[BUSIO_ST] + 56, 8 = .BusOut[GO_ROBOTMSGTYPE]
    bits .BusOut[BUSIO_ST] + 48, 8 = .BusOut[GO_ROBOTTELLID]
.end

.program lib.bus_rtell_(.BusIn[], .BusOut[], .Timeout, .Status)

    if existinteger("@BUSIO_DEFED") == 0 then 

        call lib.def_busio_
    end

    utimer .@Timer = 0  

    .BusOut[GO_ROBOTTELLID] = bits(.BusOut[BUSIO_ST] + 48, 8) 

    if .Timeout >= 0 then
        wait (bits(.BusOut[BUSIO_ST] + 48, 8) == bits(.BusIn[BUSIO_ST] + 48, 8)) or (sig(.BusIn[BUSIO_ST] + 0) == 0) or (sig(.BusOut[BUSIO_ST] + 0) == 0) or (sig(.BusOut[BUSIO_ST] + 1) == true) or (utimer(.@Timer) > .Timeout)
    else
        wait (bits(.BusOut[BUSIO_ST] + 48, 8) == bits(.BusIn[BUSIO_ST] + 48, 8)) or (sig(.BusIn[BUSIO_ST] + 0) == 0) or (sig(.BusOut[BUSIO_ST] + 0) == 0) or (sig(.BusOut[BUSIO_ST] + 1) == true)
    end

    .BusOut[GO_ROBOTTELLID] = bits(.BusOut[BUSIO_ST] + 48, 8) 
    .BusIn[GI_TELLID]       = bits(.BusIn[BUSIO_ST] + 48, 8)
    .BusIn[DI_SYSREADT]     = sig(.BusIn[BUSIO_ST] + 0)
    .BusOut[DO_SYSENABLE]   = sig(.BusOut[BUSIO_ST] + 0)
    .BusOut[DO_INIT]        = sig(.BusOut[BUSIO_ST] + 1)

    if .BusOut[GO_ROBOTTELLID] == .BusIn[GI_TELLID] then 
        .BusIn[GI_JOBID]            = bits(.BusIn[BUSIO_ST] + 16, 8)
        .BusIn[GI_ERRORID]          = bits(.BusIn[BUSIO_ST] + 24, 8)
        .BusIn[GI_MSGTYPE]          = bits(.BusIn[BUSIO_ST] + 56, 8)
        .Status                     = .BusIn[GI_ERRORID]
        return
    end

    if (.BusIn[DI_SYSREADT] == 0) or (.BusOut[DO_SYSENABLE] == 0) or (.BusOut[DO_INIT] == true) then
        .Status = -2
        return
    end

    .Status = -1
.end


.program lib.def_busio_()

    BUSIO_ST                        = 0

    DI_SYSREADT                     = 1
    DI_INITED                       = 2
    DI_STOPMOV                      = 3
    DI_ONMEASURE                    = 4
    DI_MEASUREOVER                  = 5
    DI_RESULTOK                     = 6
    DI_RESULTNG                     = 7
    DI_FINISHED                     = 8
    GI_DEVICEID                     = 9
    GI_JOBID                        = 10
    GI_ERRORID                      = 11
    GI_AGENTTELLID                  = 12
    GI_AGENTMSGTYPE                 = 13
    GI_TELLID                       = 14
    GI_MSGTYPE                      = 15

    DO_SYSENABLE                    = 1
    DO_INIT                         = 2
    DO_ROBMOVING                    = 3
    DO_MEASUREST                    = 4
    DO_MEASUREED                    = 5
    DO_RESERVER1                    = 6
    DO_RESERVER2                    = 7
    DO_CYCLEEND                     = 8
    GO_ROBOTID                      = 9
    GO_JOBID                        = 10
    GO_PROTOCOLID                   = 11
    GO_TELLID                       = 12
    GO_MSGTYPE                      = 13
    GO_ROBOTTELLID                  = 14
    GO_ROBOTMSGTYPE                 = 15


    PTC_LN_PL                       = 1
    PTC_ST_PK                       = 2
    PTC_GEN_CMD                     = 64
    PTC_ROB_CTL                     = 128

    BUSCMD_WRITE                    = 1              
    BUSCMD_READ                     = 2             

    BUSCMD_MST                      = -1             
    BUSCMD_SLE                      = -2             

    BUSIO_DEFED                     = 0 


.end
