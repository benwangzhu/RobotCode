;***********************************************************
;
; Copyright 2018 - 2023 speedbot All Rights reserved.
;
; File Name: sbt_comm000
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


.program sbt.comm000(.CommandId, .TrajeNo) ; Calibration 20240529

    case .CommandId of

    value 1:            ; 标定开始                        

        .Status = 0

        BusInput[0] = 1513          ; 通讯输入起始地址
        BusOutput[0] = 513          ; 通讯输出起始地址

        BusTimeout = 4              ; 通讯超时时间 [s]

        call lib.bus_init_(BusInput[], BusOutput[], 0, PTC_GEN_CMD)

        Count = 0

        CommType01[0] = 1
        CommType01[1] = .TrajeNo
        CommType01[2] = 0
        CommType01[3] = 0
        CommType01[4] = 0
        CommType01[5] = 0
        CommType01[6] = 0.0
        CommType01[7] = 0.0

        call lib.bus_cmd002_(BUSCMD_WRITE, BUSCMD_MST, BusInput[], BusOutput[], 0, CommType01[], .Status)
        call lib.bus_cmd001_(BUSCMD_READ, BUSCMD_MST, BusInput[], BusOutput[], BusTimeout, .Status)
    
    value 2:            ; 标定拍照

        Count = Count + 1
        
        point .CalibPos = base + here - tool            ; 存储拍照时的当前位姿

        call lib.bus_cmd003_(BUSCMD_WRITE, BUSCMD_MST, BusInput[], BusOutput[], 0, .&CalibPos, .Status)
        call lib.bus_cmd001_(BUSCMD_READ, BUSCMD_MST, BusInput[], BusOutput[], BusTimeout, .Status)

    value 3:            ; 标定结束

        CommType01[0] = 2
        call lib.bus_cmd002_(BUSCMD_WRITE, BUSCMD_MST, BusInput[], BusOutput[], 0, CommType01[], .Status)
        call lib.bus_cmd001_(BUSCMD_READ, BUSCMD_MST, BusInput[], BusOutput[], BusTimeout, .Status)
    
    any :

        print 2: /S, "comm000 : Error Command Id[Id:", /D, .CommandId /S, "]"
        halt
    end

.end









