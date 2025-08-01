;***********************************************************
;
; Copyright 2018 - 2023 speedbot All Rights reserved.
;
; File Name: lib_motion
;
; Description:
;   Language             ==   As for KAWASAKI ROBOT
;   Date                 ==   2021 - 10 - 12
;   Modification Data    ==   2021 - 10 - 12
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

; 2021 - 10 - 12 ++ lib.cur_pos_()

; 2021 - 10 - 12 ++ lib.move_j_()

; 2021 - 10 - 12 ++ lib.move_l_()

; 2021 - 10 - 12 ++ lib.move_abs_j_() 

; 2021 - 10 - 12 ++ lib.mtn_def_() 

;***********************************************************
; func lib.cur_pos_()
;***********************************************************
;	IN : .&BaseFrame		* XYZOAT *  * �û����� *
;	IN : .&ToolFrame		* XYZOAT *  * �������� *
;  OUT : .&OutPos           * XYZOAT *  * ����ָ�������µĵ�λ *
;***********************************************************
; ��ȡָ������ϵ�µĵѿ���
;***********************************************************
.program lib.cur_pos_(.&BaseFrame, .&ToolFrame, .&OutPos)

    point .&OutPos = (-.&BaseFrame) + (base + here - tool) + .&ToolFrame
    return
    
.end 

;***********************************************************
; func lib.move_j_()
;***********************************************************
;	IN : .&PointName		* XYZOAT *  * Ŀ���λ *
;	IN : .MvSpeed		    * REAL *    * �ٶ� *
;	IN : .Accu		        * REAL *    * ���� *
;	IN : .&BaseFrame		* XYZOAT *  * �û����� *
;	IN : .&ToolFrame		* XYZOAT *  * �������� *
;***********************************************************
; �ؽ��˶�
;***********************************************************
.program lib.move_j_(.&PointName, .MvSpeed, .Accu, .&BaseFrame, .&ToolFrame)

    base .&BaseFrame
    tool .&ToolFrame

    if .MvSpeed < 1 then
        .MvSpeed = 1
    end

    if .MvSpeed > 100 then
        .MvSpeed = 100
    end

    speed .MvSpeed
    accuracy .Accu

    jmove .&PointName

.end 

;***********************************************************
; func lib.move_l_()
;***********************************************************
;	IN : .&PointName		* XYZOAT *  * Ŀ���λ *
;	IN : .MvSpeed		    * REAL *    * �ٶ� *
;	IN : .Accu		        * REAL *    * ���� *
;	IN : .&BaseFrame		* XYZOAT *  * �û����� *
;	IN : .&ToolFrame		* XYZOAT *  * �������� *
;***********************************************************
; �����˶�
;***********************************************************
.program lib.move_l_(.&PointName, .MvSpeed, .Accu, .&BaseFrame, .&ToolFrame)

    base .&BaseFrame
    tool .&ToolFrame

    if .MvSpeed < 1 then
        .MvSpeed = 1
    end

    if .MvSpeed > 100 then
        .MvSpeed = 100
    end

    speed .MvSpeed
    accuracy .Accu

    lmove .&PointName

.end 

;***********************************************************
; func lib.move_abs_j_()
;***********************************************************
;	IN : .&PointName		* XYZOAT *  * Ŀ���λ *
;	IN : .MvSpeed		    * REAL *    * �ٶ� *
;	IN : .Accu		        * REAL *    * ���� *
;***********************************************************
; �ؽ��˶�
;***********************************************************
.program lib.move_abs_j_(.#PointName, .MvSpeed, .Accu)

    if .MvSpeed < 1 then
        .MvSpeed = 1
    end

    if .MvSpeed > 100 then
        .MvSpeed = 100
    end

    speed .MvSpeed
    accuracy .Accu

    jmove .#PointName

.end 


;***********************************************************
; func lib.mtn_def_()
;***********************************************************
;	IN : .MvSpeed		    * REAL *    * ������ *
;	IN : .Accu		        * REAL *    * ���� *
;	IN : .Acc		        * REAL *    * ���ٶ� *
;	IN : .Dec		        * REAL *    * ���ٶ� *
;***********************************************************
; �˶������趨
;***********************************************************
.program lib.mtn_def_(.MvSpeed, .Accu, .Acc, .Dec)

    speed .MvSpeed always
    accuracy .Accu always
    accel .Acc always
    decel .Dec always

.end 


