;***********************************************************
;
; Copyright 2018 - 2023 speedbot All Rights reserved.
;
; File Name: lib_buscmd
;
; Description:
;   Language             ==   As for KAWASAKI ROBOT
;   Date                 ==   2023 - 07 - 09
;   Modification Data    ==   2024 - 02 - 28
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


.program lib.buscmd_wo_(.BusCmdId, .BusMstSel, .BusIn[], .BusOut[])

    case .BusMstSel of

    value BUSCMD_MST:

        .BusOut[GO_ROBOTMSGTYPE]        = .BusCmdId

        call lib.bus_stell_(.BusIn[], .BusOut[])
    value BUSCMD_SLE:

        .BusOut[GO_MSGTYPE]             = 0

        call lib.bus_ftell_(.BusIn[], .BusOut[])
    any :

        halt
    end

.end

.program lib.buscmd_ro_(.BusCmdId, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .Status)

    case .BusMstSel of

    value BUSCMD_MST:

        call lib.bus_rtell_(.BusIn[], .BusOut[], .BusTimeout, .Status)

        bits .BusOut[BUSIO_ST] + 56, 8 = 0

        if (not (.Status == 0)) then 

            print 2: /S, "MST Read CMD[", /D, .BusCmdId, /S, "] Err[", /D, .Status, /S, "]"
            return
        end
        
        if (not (.BusIn[GI_MSGTYPE] == .BusCmdId)) then 

            print 2: /S, "MST CMD[", /D, .BusCmdId, /S, "] New CMD[", /D, .BusIn[GI_MSGTYPE], /S, "]"
            halt
        end


    value BUSCMD_SLE:

        call lib.bus_wtell_(.BusIn[], .BusOut[], .BusTimeout, .Status)
    
        if (not (.Status == 0)) then 

            print 2: /S, "SLE Read CMD[", /D, .BusCmdId, /S, "] Err[", /D, .Status, /S, "]"
            return
        end
        
        if (not (.BusIn[GI_AGENTMSGTYPE] == .BusCmdId)) then 

            print 2: /S, "SLE CMD[", /D, .BusCmdId, /S, "] New CMD[", /D, .BusIn[GI_MSGTYPE], /S, "]"
            halt
        end

    any :

        halt
    end

.end

.program lib.bus_cmd001_(.BusOperation, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .Status) ;[BUS CMD 001]

    case .BusOperation of

    value BUSCMD_WRITE:

        call lib.buscmd_wo_(1, .BusMstSel, .BusIn[], .BusOut[])
    value BUSCMD_READ:

        call lib.buscmd_ro_(1, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .Status)
    any :

        halt
    end

.end

.program lib.bus_cmd002_(.BusOperation, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .BusData[], .Status) ;[BUS CMD 002]

    case .BusOperation of

    value BUSCMD_WRITE:

        call lib.bus_sbyte_(.BusOut[BUSIO_ST] + 64, .BusData[0]) 
        call lib.bus_sbyte_(.BusOut[BUSIO_ST] + 72, .BusData[1]) 
        call lib.bus_ssint_(.BusOut[BUSIO_ST] + 80, .BusData[2]) 
        call lib.bus_ssint_(.BusOut[BUSIO_ST] + 96, .BusData[3]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 112, .BusData[4]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 144, .BusData[5]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 176, .BusData[6]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 208, .BusData[7]) 
        call lib.buscmd_wo_(2, .BusMstSel, .BusIn[], .BusOut[])
    value BUSCMD_READ:

        call lib.buscmd_ro_(2, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .Status)

        if .Status == 0 then

            call lib.bus_gbyte_(.BusIn[BUSIO_ST] + 64, .BusData[0]) 
            call lib.bus_gbyte_(.BusIn[BUSIO_ST] + 72, .BusData[1]) 
            call lib.bus_gsint_(.BusIn[BUSIO_ST] + 80, .BusData[2]) 
            call lib.bus_gsint_(.BusIn[BUSIO_ST] + 96, .BusData[3]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 112, .BusData[4]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 144, .BusData[5]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 176, .BusData[6]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 208, .BusData[7]) 
        else

            .BusData[0] = 0.0
            .BusData[1] = 0.0
            .BusData[2] = 0.0
            .BusData[3] = 0.0
            .BusData[4] = 0.0
            .BusData[5] = 0.0
            .BusData[6] = 0.0
            .BusData[7] = 0.0
        end
    any :

        halt
    end

.end

.program lib.bus_cmd003_(.BusOperation, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .&BusData, .Status) ;[BUS CMD 003]

    case .BusOperation of

    value BUSCMD_WRITE:

        call lib.bus_scartp_(.BusOut[BUSIO_ST] + 64, .&BusData, 6)
        call lib.buscmd_wo_(3, .BusMstSel, .BusIn[], .BusOut[])
    value BUSCMD_READ:

        call lib.buscmd_ro_(3, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .Status)

        if .Status == 0 then

            call lib.bus_gcartp_(.BusOut[BUSIO_ST] + 64, .&BusData, 6)
        else

            point .&BusData = null
        end
    any :

        halt
    end

.end

.program lib.bus_cmd009_(.BusOperation, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .&BusData, .Status) ;[BUS CMD 009]

    case .BusOperation of

    value BUSCMD_WRITE:

        call lib.bus_scartp_(.BusOut[BUSIO_ST] + 64, .&BusData, 6)
        call lib.buscmd_wo_(9, .BusMstSel, .BusIn[], .BusOut[])
    value BUSCMD_READ:

        call lib.buscmd_ro_(9, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .Status)

        if .Status == 0 then

            call lib.bus_gcartp_(.BusOut[BUSIO_ST] + 64, .&BusData, 6)
        else

            point .&BusData = null
        end
    any :

        halt
    end

.end

.program lib.bus_cmd010_(.BusOperation, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .&BusData, .Status) ;[BUS CMD 010]

    case .BusOperation of

    value BUSCMD_WRITE:

        call lib.bus_scartp_(.BusOut[BUSIO_ST] + 64, .&BusData, 6)
        call lib.buscmd_wo_(10, .BusMstSel, .BusIn[], .BusOut[])
    value BUSCMD_READ:

        call lib.buscmd_ro_(10, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .Status)

        if .Status == 0 then

            call lib.bus_gcartp_(.BusOut[BUSIO_ST] + 64, .&BusData, 6)
        else

            point .&BusData = null
        end
    any :

        halt
    end

.end

.program lib.bus_cmd011_(.BusOperation, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .&BusData, .Status) ;[BUS CMD 011]

    case .BusOperation of

    value BUSCMD_WRITE:

        call lib.bus_scartp_(.BusOut[BUSIO_ST] + 64, .&BusData, 6)
        call lib.buscmd_wo_(11, .BusMstSel, .BusIn[], .BusOut[])
    value BUSCMD_READ:

        call lib.buscmd_ro_(11, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .Status)

        if .Status == 0 then

            call lib.bus_gcartp_(.BusOut[BUSIO_ST] + 64, .&BusData, 6)
        else

            point .&BusData = null
        end
    any :

        halt
    end

.end

.program lib.bus_cmd012_(.BusOperation, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .BusData[], .Status) ;[BUS CMD 012]

    case .BusOperation of

    value BUSCMD_WRITE:

        call lib.bus_sbyte_(.BusOut[BUSIO_ST] + 64, .BusData[0]) 
        call lib.bus_sbyte_(.BusOut[BUSIO_ST] + 72, .BusData[1]) 
        call lib.bus_ssint_(.BusOut[BUSIO_ST] + 80, .BusData[2]) 
        call lib.bus_ssint_(.BusOut[BUSIO_ST] + 96, .BusData[3]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 112, .BusData[4]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 144, .BusData[5]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 176, .BusData[6]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 208, .BusData[7]) 
        call lib.buscmd_wo_(12, .BusMstSel, .BusIn[], .BusOut[])
    value BUSCMD_READ:

        call lib.buscmd_ro_(12, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .Status)

        if .Status == 0 then

            call lib.bus_gbyte_(.BusIn[BUSIO_ST] + 64, .BusData[0]) 
            call lib.bus_gbyte_(.BusIn[BUSIO_ST] + 72, .BusData[1]) 
            call lib.bus_gsint_(.BusIn[BUSIO_ST] + 80, .BusData[2]) 
            call lib.bus_gsint_(.BusIn[BUSIO_ST] + 96, .BusData[3]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 112, .BusData[4]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 144, .BusData[5]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 176, .BusData[6]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 208, .BusData[7]) 
        else

            .BusData[0] = 0.0
            .BusData[1] = 0.0
            .BusData[2] = 0.0
            .BusData[3] = 0.0
            .BusData[4] = 0.0
            .BusData[5] = 0.0
            .BusData[6] = 0.0
            .BusData[7] = 0.0
        end
    any :

        halt
    end

.end

.program lib.bus_cmd013_(.BusOperation, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .BusData[], .Status) ;[BUS CMD 013]

    case .BusOperation of

    value BUSCMD_WRITE:

        call lib.bus_sbyte_(.BusOut[BUSIO_ST] + 64, .BusData[0]) 
        call lib.bus_sbyte_(.BusOut[BUSIO_ST] + 72, .BusData[1]) 
        call lib.bus_ssint_(.BusOut[BUSIO_ST] + 80, .BusData[2]) 
        call lib.bus_ssint_(.BusOut[BUSIO_ST] + 96, .BusData[3]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 112, .BusData[4]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 144, .BusData[5]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 176, .BusData[6]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 208, .BusData[7]) 
        call lib.buscmd_wo_(13, .BusMstSel, .BusIn[], .BusOut[])
    value BUSCMD_READ:

        call lib.buscmd_ro_(13, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .Status)

        if .Status == 0 then

            call lib.bus_gbyte_(.BusIn[BUSIO_ST] + 64, .BusData[0]) 
            call lib.bus_gbyte_(.BusIn[BUSIO_ST] + 72, .BusData[1]) 
            call lib.bus_gsint_(.BusIn[BUSIO_ST] + 80, .BusData[2]) 
            call lib.bus_gsint_(.BusIn[BUSIO_ST] + 96, .BusData[3]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 112, .BusData[4]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 144, .BusData[5]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 176, .BusData[6]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 208, .BusData[7]) 
        else

            .BusData[0] = 0.0
            .BusData[1] = 0.0
            .BusData[2] = 0.0
            .BusData[3] = 0.0
            .BusData[4] = 0.0
            .BusData[5] = 0.0
            .BusData[6] = 0.0
            .BusData[7] = 0.0
        end
    any :

        halt
    end

.end

.program lib.bus_cmd014_(.BusOperation, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .BusData[], .Status) ;[BUS CMD 014]

    case .BusOperation of

    value BUSCMD_WRITE:

        call lib.bus_sbyte_(.BusOut[BUSIO_ST] + 64, .BusData[0]) 
        call lib.bus_sbyte_(.BusOut[BUSIO_ST] + 72, .BusData[1]) 
        call lib.bus_ssint_(.BusOut[BUSIO_ST] + 80, .BusData[2]) 
        call lib.bus_ssint_(.BusOut[BUSIO_ST] + 96, .BusData[3]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 112, .BusData[4]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 144, .BusData[5]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 176, .BusData[6]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 208, .BusData[7]) 
        call lib.buscmd_wo_(14, .BusMstSel, .BusIn[], .BusOut[])
    value BUSCMD_READ:

        call lib.buscmd_ro_(14, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .Status)

        if .Status == 0 then

            call lib.bus_gbyte_(.BusIn[BUSIO_ST] + 64, .BusData[0]) 
            call lib.bus_gbyte_(.BusIn[BUSIO_ST] + 72, .BusData[1]) 
            call lib.bus_gsint_(.BusIn[BUSIO_ST] + 80, .BusData[2]) 
            call lib.bus_gsint_(.BusIn[BUSIO_ST] + 96, .BusData[3]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 112, .BusData[4]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 144, .BusData[5]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 176, .BusData[6]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 208, .BusData[7]) 
        else

            .BusData[0] = 0.0
            .BusData[1] = 0.0
            .BusData[2] = 0.0
            .BusData[3] = 0.0
            .BusData[4] = 0.0
            .BusData[5] = 0.0
            .BusData[6] = 0.0
            .BusData[7] = 0.0
        end
    any :

        halt
    end

.end

.program lib.bus_cmd017_(.BusOperation, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .BusData[], .Status) ;[BUS CMD 017]

    case .BusOperation of

    value BUSCMD_WRITE:

        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 64, .BusData[0]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 96, .BusData[1]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 128, .BusData[2]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 160, .BusData[3]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 192, .BusData[4]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 224, .BusData[5]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 256, .BusData[6]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 288, .BusData[7]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 320, .BusData[8]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 352, .BusData[9]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 384, .BusData[10]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 416, .BusData[11]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 448, .BusData[12]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 480, .BusData[13]) 

        signal -(.BusOut[BUSIO_ST] + 3), -(.BusOut[BUSIO_ST] + 4)
        
        call lib.buscmd_wo_(17, .BusMstSel, .BusIn[], .BusOut[])

    value BUSCMD_READ:

        call lib.buscmd_ro_(17, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .Status)

        if .Status == 0 then

            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 64, .BusData[0]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 96, .BusData[1]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 128, .BusData[2]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 160, .BusData[3]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 192, .BusData[4]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 224, .BusData[5]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 256, .BusData[6]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 288, .BusData[7]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 320, .BusData[8]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 352, .BusData[9]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 384, .BusData[10]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 416, .BusData[11]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 448, .BusData[12]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 480, .BusData[13]) 
        else

            .BusData[0] = 0.0
            .BusData[1] = 0.0
            .BusData[2] = 0.0
            .BusData[3] = 0.0
            .BusData[4] = 0.0
            .BusData[5] = 0.0
            .BusData[6] = 0.0
            .BusData[7] = 0.0
            .BusData[8] = 0.0
            .BusData[9] = 0.0
            .BusData[10] = 0.0
            .BusData[11] = 0.0
            .BusData[12] = 0
            .BusData[13] = 0
        end
    any :

        halt
    end

.end

.program lib.bus_cmd018_(.BusOperation, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .BusData[], .Status) ;[BUS CMD 018]

    case .BusOperation of

    value BUSCMD_WRITE:

        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 64, .BusData[0]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 96, .BusData[1]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 128, .BusData[2]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 160, .BusData[3]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 192, .BusData[4]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 224, .BusData[5]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 256, .BusData[6]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 288, .BusData[7]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 320, .BusData[8]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 352, .BusData[9]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 384, .BusData[10]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 416, .BusData[11]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 448, .BusData[12]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 480, .BusData[13]) 

        signal -(.BusOut[BUSIO_ST] + 3), -(.BusOut[BUSIO_ST] + 4)
        
        call lib.buscmd_wo_(18, .BusMstSel, .BusIn[], .BusOut[])

    value BUSCMD_READ:

        call lib.buscmd_ro_(18, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .Status)

        if .Status == 0 then

            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 64, .BusData[0]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 96, .BusData[1]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 128, .BusData[2]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 160, .BusData[3]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 192, .BusData[4]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 224, .BusData[5]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 256, .BusData[6]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 288, .BusData[7]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 320, .BusData[8]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 352, .BusData[9]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 384, .BusData[10]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 416, .BusData[11]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 448, .BusData[12]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 480, .BusData[13]) 
        else

            .BusData[0] = 0.0
            .BusData[1] = 0.0
            .BusData[2] = 0.0
            .BusData[3] = 0.0
            .BusData[4] = 0.0
            .BusData[5] = 0.0
            .BusData[6] = 0.0
            .BusData[7] = 0.0
            .BusData[8] = 0.0
            .BusData[9] = 0.0
            .BusData[10] = 0.0
            .BusData[11] = 0.0
            .BusData[12] = 0
            .BusData[13] = 0
        end
    any :

        halt
    end

.end

.program lib.bus_cmd020_(.BusOperation, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .&BusData, .Status) ;[BUS CMD 020]

    case .BusOperation of

    value BUSCMD_WRITE:

        call lib.bus_scartp_(.BusOut[BUSIO_ST] + 64, .&BusData, 6)
        call lib.buscmd_wo_(20, .BusMstSel, .BusIn[], .BusOut[])
    value BUSCMD_READ:

        call lib.buscmd_ro_(20, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .Status)

        if .Status == 0 then

            call lib.bus_gcartp_(.BusOut[BUSIO_ST] + 64, .&BusData, 6)
        else

            point .&BusData = null
        end
    any :

        halt
    end

.end

.program lib.bus_cmd021_(.BusOperation, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .BusData[], .Status) ;[BUS CMD 021]

    case .BusOperation of

    value BUSCMD_WRITE:

        call lib.bus_sbyte_(.BusOut[BUSIO_ST] + 64, .BusData[0]) 
        call lib.bus_sbyte_(.BusOut[BUSIO_ST] + 72, .BusData[1]) 
        call lib.bus_ssint_(.BusOut[BUSIO_ST] + 80, .BusData[2]) 
        call lib.bus_ssint_(.BusOut[BUSIO_ST] + 96, .BusData[3]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 112, .BusData[4]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 144, .BusData[5]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 176, .BusData[6]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 208, .BusData[7]) 
        call lib.buscmd_wo_(21, .BusMstSel, .BusIn[], .BusOut[])
    value BUSCMD_READ:

        call lib.buscmd_ro_(21, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .Status)

        if .Status == 0 then

            call lib.bus_gbyte_(.BusIn[BUSIO_ST] + 64, .BusData[0]) 
            call lib.bus_gbyte_(.BusIn[BUSIO_ST] + 72, .BusData[1]) 
            call lib.bus_gsint_(.BusIn[BUSIO_ST] + 80, .BusData[2]) 
            call lib.bus_gsint_(.BusIn[BUSIO_ST] + 96, .BusData[3]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 112, .BusData[4]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 144, .BusData[5]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 176, .BusData[6]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 208, .BusData[7]) 
        else

            .BusData[0] = 0.0
            .BusData[1] = 0.0
            .BusData[2] = 0.0
            .BusData[3] = 0.0
            .BusData[4] = 0.0
            .BusData[5] = 0.0
            .BusData[6] = 0.0
            .BusData[7] = 0.0
        end
    any :

        halt
    end

.end

.program lib.bus_cmd022_(.BusOperation, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .BusData[], .Status) ;[BUS CMD 022]

    case .BusOperation of

    value BUSCMD_WRITE:

        call lib.bus_sbyte_(.BusOut[BUSIO_ST] + 64, .BusData[0]) 
        call lib.bus_sbyte_(.BusOut[BUSIO_ST] + 72, .BusData[1]) 
        call lib.bus_ssint_(.BusOut[BUSIO_ST] + 80, .BusData[2]) 
        call lib.bus_ssint_(.BusOut[BUSIO_ST] + 96, .BusData[3]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 112, .BusData[4]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 144, .BusData[5]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 176, .BusData[6]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 208, .BusData[7]) 
        call lib.buscmd_wo_(22, .BusMstSel, .BusIn[], .BusOut[])
    value BUSCMD_READ:

        call lib.buscmd_ro_(22, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .Status)

        if .Status == 0 then

            call lib.bus_gbyte_(.BusIn[BUSIO_ST] + 64, .BusData[0]) 
            call lib.bus_gbyte_(.BusIn[BUSIO_ST] + 72, .BusData[1]) 
            call lib.bus_gsint_(.BusIn[BUSIO_ST] + 80, .BusData[2]) 
            call lib.bus_gsint_(.BusIn[BUSIO_ST] + 96, .BusData[3]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 112, .BusData[4]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 144, .BusData[5]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 176, .BusData[6]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 208, .BusData[7]) 
        else

            .BusData[0] = 0.0
            .BusData[1] = 0.0
            .BusData[2] = 0.0
            .BusData[3] = 0.0
            .BusData[4] = 0.0
            .BusData[5] = 0.0
            .BusData[6] = 0.0
            .BusData[7] = 0.0
        end
    any :

        halt
    end

.end

.program lib.bus_cmd026_(.BusOperation, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .BusData[], .Status) ;[BUS CMD 026]

    case .BusOperation of

    value BUSCMD_WRITE:

        call lib.bus_sbyte_(.BusOut[BUSIO_ST] + 64, .BusData[0]) 
        call lib.bus_sbyte_(.BusOut[BUSIO_ST] + 72, .BusData[1]) 
        call lib.bus_ssint_(.BusOut[BUSIO_ST] + 80, .BusData[2]) 
        call lib.bus_ssint_(.BusOut[BUSIO_ST] + 96, .BusData[3]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 112, .BusData[4]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 144, .BusData[5]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 176, .BusData[6]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 208, .BusData[7]) 
        call lib.buscmd_wo_(26, .BusMstSel, .BusIn[], .BusOut[])
    value BUSCMD_READ:

        call lib.buscmd_ro_(26, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .Status)

        if .Status == 0 then

            call lib.bus_gbyte_(.BusIn[BUSIO_ST] + 64, .BusData[0]) 
            call lib.bus_gbyte_(.BusIn[BUSIO_ST] + 72, .BusData[1]) 
            call lib.bus_gsint_(.BusIn[BUSIO_ST] + 80, .BusData[2]) 
            call lib.bus_gsint_(.BusIn[BUSIO_ST] + 96, .BusData[3]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 112, .BusData[4]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 144, .BusData[5]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 176, .BusData[6]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 208, .BusData[7]) 
        else

            .BusData[0] = 0.0
            .BusData[1] = 0.0
            .BusData[2] = 0.0
            .BusData[3] = 0.0
            .BusData[4] = 0.0
            .BusData[5] = 0.0
            .BusData[6] = 0.0
            .BusData[7] = 0.0
        end
    any :

        halt
    end

.end

.program lib.bus_cmd027_(.BusOperation, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .BusData[], .Status) ;[BUS CMD 027]

    case .BusOperation of

    value BUSCMD_WRITE:

        call lib.bus_sbyte_(.BusOut[BUSIO_ST] + 64, .BusData[0]) 
        call lib.bus_sbyte_(.BusOut[BUSIO_ST] + 72, .BusData[1]) 
        call lib.bus_sbyte_(.BusOut[BUSIO_ST] + 80, .BusData[2]) 
        call lib.bus_sbyte_(.BusOut[BUSIO_ST] + 88, .BusData[3]) 
        call lib.bus_ssint_(.BusOut[BUSIO_ST] + 96, .BusData[4]) 
        call lib.bus_ssint_(.BusOut[BUSIO_ST] + 112, .BusData[5]) 
        call lib.bus_ssint_(.BusOut[BUSIO_ST] + 128, .BusData[6]) 
        call lib.bus_ssint_(.BusOut[BUSIO_ST] + 144, .BusData[7]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 160, .BusData[8]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 192, .BusData[9]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 224, .BusData[10]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 256, .BusData[11]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 288, .BusData[12]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 320, .BusData[13]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 352, .BusData[14]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 384, .BusData[15]) 
        call lib.buscmd_wo_(27, .BusMstSel, .BusIn[], .BusOut[])
    value BUSCMD_READ:

        call lib.buscmd_ro_(27, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .Status)

        if .Status == 0 then

            call lib.bus_gbyte_(.BusIn[BUSIO_ST] + 64, .BusData[0]) 
            call lib.bus_gbyte_(.BusIn[BUSIO_ST] + 72, .BusData[1]) 
            call lib.bus_gbyte_(.BusIn[BUSIO_ST] + 80, .BusData[2]) 
            call lib.bus_gbyte_(.BusIn[BUSIO_ST] + 88, .BusData[3]) 
            call lib.bus_gsint_(.BusIn[BUSIO_ST] + 96, .BusData[4]) 
            call lib.bus_gsint_(.BusIn[BUSIO_ST] + 112, .BusData[5]) 
            call lib.bus_gsint_(.BusIn[BUSIO_ST] + 128, .BusData[6]) 
            call lib.bus_gsint_(.BusIn[BUSIO_ST] + 144, .BusData[7]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 160, .BusData[8]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 192, .BusData[9]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 224, .BusData[10]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 256, .BusData[11]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 288, .BusData[12]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 320, .BusData[13]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 352, .BusData[14]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 384, .BusData[15]) 
        else

            .BusData[0] = 0.0
            .BusData[1] = 0.0
            .BusData[2] = 0.0
            .BusData[3] = 0.0
            .BusData[4] = 0.0
            .BusData[5] = 0.0
            .BusData[6] = 0.0
            .BusData[7] = 0.0
            .BusData[8] = 0.0
            .BusData[9] = 0.0
            .BusData[10] = 0.0
            .BusData[11] = 0.0
            .BusData[12] = 0.0
            .BusData[13] = 0.0
            .BusData[14] = 0.0
            .BusData[15] = 0.0
        end
    any :

        halt
    end

.end

.program lib.bus_cmd129_(.BusOperation, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .&BusData, .Status) ;[BUS CMD 129]

    case .BusOperation of

    value BUSCMD_WRITE:

        call lib.bus_scartp_(.BusOut[BUSIO_ST] + 64, .&BusData, 6)
        call lib.buscmd_wo_(129, .BusMstSel, .BusIn[], .BusOut[])
    value BUSCMD_READ:

        call lib.buscmd_ro_(129, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .Status)

        if .Status == 0 then

            call lib.bus_gcartp_(.BusOut[BUSIO_ST] + 64, .&BusData, 6)
        else

            point .&BusData = null
        end
    any :

        halt
    end

.end

.program lib.bus_cmd130_(.BusOperation, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .#BusData, .Status) ;[BUS CMD 130]

    case .BusOperation of

    value BUSCMD_WRITE:

        call lib.bus_sjoint_(.BusOut[BUSIO_ST] + 64, .#BusData, 6)
        call lib.buscmd_wo_(130, .BusMstSel, .BusIn[], .BusOut[])
    value BUSCMD_READ:

        call lib.buscmd_ro_(130, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .Status)

        if .Status == 0 then

            call lib.bus_gjoint_(.BusOut[BUSIO_ST] + 64, .#BusData, 6)
        else

            point .#BusData = #here
        end
    any :

        halt
    end

.end

.program lib.bus_cmd131_(.BusOperation, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .BusData[], .Status) ;[BUS CMD 131]

    case .BusOperation of

    value BUSCMD_WRITE:

        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 64, .BusData[0]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 96, .BusData[1]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 128, .BusData[2]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 160, .BusData[3]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 192, .BusData[4]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 224, .BusData[5]) 
        call lib.buscmd_wo_(131, .BusMstSel, .BusIn[], .BusOut[])

    value BUSCMD_READ:

        call lib.buscmd_ro_(131, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .Status)

        if .Status == 0 then

            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 64, .BusData[0]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 96, .BusData[1]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 128, .BusData[2]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 160, .BusData[3]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 192, .BusData[4]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 224, .BusData[5]) 
        else

            .BusData[0] = 0.0
            .BusData[1] = 0.0
            .BusData[2] = 0.0
            .BusData[3] = 0.0
            .BusData[4] = 0.0
            .BusData[5] = 0.0
        end
    any :

        halt
    end

.end

.program lib.bus_cmd132_(.BusOperation, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .BusData[], .Status) ;[BUS CMD 132]

    case .BusOperation of

    value BUSCMD_WRITE:

        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 64, .BusData[0]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 96, .BusData[1]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 128, .BusData[2]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 160, .BusData[3]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 192, .BusData[4]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 224, .BusData[5]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 256, .BusData[6]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 288, .BusData[7]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 320, .BusData[8]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 352, .BusData[9]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 384, .BusData[10]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 416, .BusData[11]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 448, .BusData[12]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 480, .BusData[13]) 
        call lib.buscmd_wo_(132, .BusMstSel, .BusIn[], .BusOut[])

    value BUSCMD_READ:

        call lib.buscmd_ro_(132, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .Status)

        if .Status == 0 then

            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 64, .BusData[0]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 96, .BusData[1]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 128, .BusData[2]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 160, .BusData[3]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 192, .BusData[4]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 224, .BusData[5]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 256, .BusData[6]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 288, .BusData[7]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 320, .BusData[8]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 352, .BusData[9]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 384, .BusData[10]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 416, .BusData[11]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 448, .BusData[12]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 480, .BusData[13]) 
        else

            .BusData[0] = 0.0
            .BusData[1] = 0.0
            .BusData[2] = 0.0
            .BusData[3] = 0.0
            .BusData[4] = 0.0
            .BusData[5] = 0.0
            .BusData[6] = 0.0
            .BusData[7] = 0.0
            .BusData[8] = 0.0
            .BusData[9] = 0.0
            .BusData[10] = 0.0
            .BusData[11] = 0.0
            .BusData[12] = 0
            .BusData[13] = 0
        end
    any :

        halt
    end

.end

.program lib.bus_cmd133_(.BusOperation, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .BusData[], .Status) ;[BUS CMD 133]

    case .BusOperation of

    value BUSCMD_WRITE:

        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 64, .BusData[0]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 96, .BusData[1]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 128, .BusData[2]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 160, .BusData[3]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 192, .BusData[4]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 224, .BusData[5]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 256, .BusData[6]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 288, .BusData[7]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 320, .BusData[8]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 352, .BusData[9]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 384, .BusData[10]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 416, .BusData[11]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 448, .BusData[12]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 480, .BusData[13]) 
        call lib.buscmd_wo_(133, .BusMstSel, .BusIn[], .BusOut[])

    value BUSCMD_READ:

        call lib.buscmd_ro_(133, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .Status)

        if .Status == 0 then

            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 64, .BusData[0]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 96, .BusData[1]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 128, .BusData[2]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 160, .BusData[3]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 192, .BusData[4]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 224, .BusData[5]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 256, .BusData[6]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 288, .BusData[7]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 320, .BusData[8]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 352, .BusData[9]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 384, .BusData[10]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 416, .BusData[11]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 448, .BusData[12]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 480, .BusData[13]) 
        else

            .BusData[0] = 0.0
            .BusData[1] = 0.0
            .BusData[2] = 0.0
            .BusData[3] = 0.0
            .BusData[4] = 0.0
            .BusData[5] = 0.0
            .BusData[6] = 0.0
            .BusData[7] = 0.0
            .BusData[8] = 0.0
            .BusData[9] = 0.0
            .BusData[10] = 0.0
            .BusData[11] = 0.0
            .BusData[12] = 0
            .BusData[13] = 0
        end
    any :

        halt
    end

.end

.program lib.bus_cmd145_(.BusOperation, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .BusData[], .Status) ;[BUS CMD 145]

    case .BusOperation of

    value BUSCMD_WRITE:

        call lib.bus_sbyte_(.BusOut[BUSIO_ST] + 64, .BusData[0]) 
        call lib.bus_sbyte_(.BusOut[BUSIO_ST] + 72, .BusData[1]) 
        call lib.bus_ssint_(.BusOut[BUSIO_ST] + 80, .BusData[2]) 
        call lib.bus_ssint_(.BusOut[BUSIO_ST] + 96, .BusData[3]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 112, .BusData[4]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 144, .BusData[5]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 176, .BusData[6]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 208, .BusData[7]) 
        call lib.buscmd_wo_(145, .BusMstSel, .BusIn[], .BusOut[])
    value BUSCMD_READ:

        call lib.buscmd_ro_(145, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .Status)

        if .Status == 0 then

            call lib.bus_gbyte_(.BusIn[BUSIO_ST] + 64, .BusData[0]) 
            call lib.bus_gbyte_(.BusIn[BUSIO_ST] + 72, .BusData[1]) 
            call lib.bus_gsint_(.BusIn[BUSIO_ST] + 80, .BusData[2]) 
            call lib.bus_gsint_(.BusIn[BUSIO_ST] + 96, .BusData[3]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 112, .BusData[4]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 144, .BusData[5]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 176, .BusData[6]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 208, .BusData[7]) 
        else

            .BusData[0] = 0.0
            .BusData[1] = 0.0
            .BusData[2] = 0.0
            .BusData[3] = 0.0
            .BusData[4] = 0.0
            .BusData[5] = 0.0
            .BusData[6] = 0.0
            .BusData[7] = 0.0
        end
    any :

        halt
    end

.end

.program lib.bus_cmd148_(.BusOperation, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .BusData[], .Status) ;[BUS CMD 148]

    case .BusOperation of

    value BUSCMD_WRITE:

        call lib.bus_sbyte_(.BusOut[BUSIO_ST] + 64, .BusData[0]) 
        call lib.bus_sbyte_(.BusOut[BUSIO_ST] + 72, .BusData[1]) 
        call lib.bus_sbyte_(.BusOut[BUSIO_ST] + 80, .BusData[2]) 
        call lib.bus_sbyte_(.BusOut[BUSIO_ST] + 88, .BusData[3]) 
        call lib.bus_ssint_(.BusOut[BUSIO_ST] + 96, .BusData[4]) 
        call lib.bus_ssint_(.BusOut[BUSIO_ST] + 112, .BusData[5]) 
        call lib.bus_ssint_(.BusOut[BUSIO_ST] + 128, .BusData[6]) 
        call lib.bus_ssint_(.BusOut[BUSIO_ST] + 144, .BusData[7]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 160, .BusData[8]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 192, .BusData[9]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 224, .BusData[10]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 256, .BusData[11]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 288, .BusData[12]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 320, .BusData[13]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 352, .BusData[14]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 384, .BusData[15]) 
        call lib.buscmd_wo_(148, .BusMstSel, .BusIn[], .BusOut[])
    value BUSCMD_READ:

        call lib.buscmd_ro_(148, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .Status)

        if .Status == 0 then

            call lib.bus_gbyte_(.BusIn[BUSIO_ST] + 64, .BusData[0]) 
            call lib.bus_gbyte_(.BusIn[BUSIO_ST] + 72, .BusData[1]) 
            call lib.bus_gbyte_(.BusIn[BUSIO_ST] + 80, .BusData[2]) 
            call lib.bus_gbyte_(.BusIn[BUSIO_ST] + 88, .BusData[3]) 
            call lib.bus_gsint_(.BusIn[BUSIO_ST] + 96, .BusData[4]) 
            call lib.bus_gsint_(.BusIn[BUSIO_ST] + 112, .BusData[5]) 
            call lib.bus_gsint_(.BusIn[BUSIO_ST] + 128, .BusData[6]) 
            call lib.bus_gsint_(.BusIn[BUSIO_ST] + 144, .BusData[7]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 160, .BusData[8]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 192, .BusData[9]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 224, .BusData[10]) 
            call lib.bus_gint_(.BusIn[BUSIO_ST] + 256, .BusData[11]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 288, .BusData[12]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 320, .BusData[13]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 352, .BusData[14]) 
            call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 384, .BusData[15]) 
        else

            .BusData[0] = 0.0
            .BusData[1] = 0.0
            .BusData[2] = 0.0
            .BusData[3] = 0.0
            .BusData[4] = 0.0
            .BusData[5] = 0.0
            .BusData[6] = 0.0
            .BusData[7] = 0.0
            .BusData[8] = 0.0
            .BusData[9] = 0.0
            .BusData[10] = 0.0
            .BusData[11] = 0.0
            .BusData[12] = 0.0
            .BusData[13] = 0.0
            .BusData[14] = 0.0
            .BusData[15] = 0.0
        end
    any :

        halt
    end

.end

.program lib.bus_cmd151_(.BusOperation, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .BusData[], .Status) ;[BUS CMD 151]

    case .BusOperation of

    value BUSCMD_WRITE:

        call lib.bus_sbyte_(.BusOut[BUSIO_ST] + 64, .BusData[0]) 
        call lib.bus_ssint_(.BusOut[BUSIO_ST] + 72, .BusData[1]) 
        call lib.bus_ssint_(.BusOut[BUSIO_ST] + 88, .BusData[2]) 
        call lib.bus_ssint_(.BusOut[BUSIO_ST] + 104, .BusData[3]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 120, .BusData[4]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 152, .BusData[5]) 
        call lib.buscmd_wo_(151, .BusMstSel, .BusIn[], .BusOut[])
    value BUSCMD_READ:

        call lib.buscmd_ro_(151, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .Status)

        if .Status == 0 then

            call lib.bus_gbyte_(.BusOut[BUSIO_ST] + 64, .BusData[0]) 
            call lib.bus_gsint_(.BusOut[BUSIO_ST] + 72, .BusData[1]) 
            call lib.bus_gsint_(.BusOut[BUSIO_ST] + 88, .BusData[2]) 
            call lib.bus_gsint_(.BusOut[BUSIO_ST] + 104, .BusData[3]) 
            call lib.bus_gfloat2_(.BusOut[BUSIO_ST] + 120, .BusData[4]) 
            call lib.bus_gfloat2_(.BusOut[BUSIO_ST] + 152, .BusData[5]) 
        else

            .BusData[0] = 0.0
            .BusData[1] = 0.0
            .BusData[2] = 0.0
            .BusData[3] = 0.0
            .BusData[4] = 0.0
            .BusData[5] = 0.0
        end
    any :

        halt
    end

.end

.program lib.bus_cmd254_(.BusOperation, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .BusData[], .Status) ;[BUS CMD 254]

    case .BusOperation of

    value BUSCMD_WRITE:

        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 64, .BusData[0]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 96, .BusData[1]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 128, .BusData[2]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 160, .BusData[3]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 192, .BusData[4]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 224, .BusData[5]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 256, .BusData[6]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 288, .BusData[7]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 320, .BusData[8]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 352, .BusData[9]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 384, .BusData[10]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 416, .BusData[11]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 448, .BusData[12]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 480, .BusData[13]) 

        bits .BusOut[BUSIO_ST] + 56, 8 = 254


        if (sig(.BusOut[BUSIO_ST] + 3) == 1) and (sig(.BusOut[BUSIO_ST] + 4) == 0) then

            signal -(.BusOut[BUSIO_ST] + 3), (.BusOut[BUSIO_ST] + 4)
        else

            signal (.BusOut[BUSIO_ST] + 3), -(.BusOut[BUSIO_ST] + 4)
        end

        wait (bits(.BusIn[BUSIO_ST] + 3, 2) == bits(.BusOut[BUSIO_ST] + 3, 2))

    value BUSCMD_READ:

        if (sig(.BusOut[BUSIO_ST] + 5) == 1) and (sig(.BusOut[BUSIO_ST] + 6) == 0) then

            swait -(.BusIn[BUSIO_ST] + 5), (.BusIn[BUSIO_ST] + 6)
        else

            swait (.BusIn[BUSIO_ST] + 5), -(.BusIn[BUSIO_ST] + 6)
        end

        call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 64, .BusData[0]) 
        call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 96, .BusData[1]) 
        call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 128, .BusData[2]) 
        call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 160, .BusData[3]) 
        call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 192, .BusData[4]) 
        call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 224, .BusData[5]) 
        call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 256, .BusData[6]) 
        call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 288, .BusData[7]) 
        call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 320, .BusData[8]) 
        call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 352, .BusData[9]) 
        call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 384, .BusData[10]) 
        call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 416, .BusData[11]) 
        call lib.bus_gint_(.BusIn[BUSIO_ST] + 448, .BusData[12]) 
        call lib.bus_gint_(.BusIn[BUSIO_ST] + 480, .BusData[13]) 

        bits (.BusOut[BUSIO_ST] + 5), 2 = bits(.BusIn[BUSIO_ST] + 5, 2)
    any :

        halt
    end

.end

.program lib.bus_cmd255_(.BusOperation, .BusMstSel, .BusIn[], .BusOut[], .BusTimeout, .BusData[], .Status) ;[BUS CMD 255]

    case .BusOperation of

    value BUSCMD_WRITE:

        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 64, .BusData[0]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 96, .BusData[1]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 128, .BusData[2]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 160, .BusData[3]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 192, .BusData[4]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 224, .BusData[5]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 256, .BusData[6]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 288, .BusData[7]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 320, .BusData[8]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 352, .BusData[9]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 384, .BusData[10]) 
        call lib.bus_sfloat2_(.BusOut[BUSIO_ST] + 416, .BusData[11]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 448, .BusData[12]) 
        call lib.bus_sint_(.BusOut[BUSIO_ST] + 480, .BusData[13]) 

        bits .BusOut[BUSIO_ST] + 56, 8 = 255

        if (sig(.BusOut[BUSIO_ST] + 3) == 1) and (sig(.BusOut[BUSIO_ST] + 4) == 0) then

            signal -(.BusOut[BUSIO_ST] + 3), (.BusOut[BUSIO_ST] + 4)
        else

            signal (.BusOut[BUSIO_ST] + 3), -(.BusOut[BUSIO_ST] + 4)
        end

    value BUSCMD_READ:


        call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 64, .BusData[0]) 
        call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 96, .BusData[1]) 
        call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 128, .BusData[2]) 
        call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 160, .BusData[3]) 
        call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 192, .BusData[4]) 
        call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 224, .BusData[5]) 
        call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 256, .BusData[6]) 
        call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 288, .BusData[7]) 
        call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 320, .BusData[8]) 
        call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 352, .BusData[9]) 
        call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 384, .BusData[10]) 
        call lib.bus_gfloat2_(.BusIn[BUSIO_ST] + 416, .BusData[11]) 
        call lib.bus_gint_(.BusIn[BUSIO_ST] + 448, .BusData[12]) 
        call lib.bus_gint_(.BusIn[BUSIO_ST] + 480, .BusData[13]) 
    any :

        halt
    end

.end








