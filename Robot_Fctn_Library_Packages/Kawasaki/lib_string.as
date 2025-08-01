;***********************************************************
;
; Copyright 2018 - 2023 speedbot All Rights reserved.
;
; File Name: lib_string
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

; 2021 - 10 - 12 ++ lib.int_2str_()

; 2021 - 10 - 12 ++ lib.rel_2str_()

; 2021 - 10 - 12 ++ lib.pos_2str_()

; 2021 - 10 - 12 ++ lib.axis_2str_()

; 2021 - 10 - 12 ++ lib.str_2pos_()

; 2021 - 10 - 12 ++ lib.str_2axis_() 

;***********************************************************
; func int_to_str_()
;***********************************************************
;	IN : .IntVal		    * INT *     * �������� *
;  OUT : .&OutStr           * STRING *  *����ַ��� *
;***********************************************************
; ����ת�ַ���
;***********************************************************
.program lib.int_2str_(.IntVal, .$OutStr)

    .$OutStr = $encode(/I32, .IntVal) 

    do
        .$TmpStr = $mid(.$OutStr, 1, 1)
        if .$TmpStr == $space(1) then
            .$TmpStr = $decode(.$OutStr, $space(1), 1)
        end
    until .$TmpStr <> $space(1)

    return
.end 


;***********************************************************
; func rel_to_str_()
;***********************************************************
;	IN : .RelVal		    * REAL *    * ����ʵ�� *
;  OUT : .&OutStr           * STRING *  * ����ַ��� *
;***********************************************************
; ʵ��ת�ַ���
;***********************************************************
.program lib.rel_2str_(.RelVal, .$OutStr)

    .$OutStr = ""

    .$OutStr = $encode(/F29.3, .RelVal) 

    do
        .$TmpStr = $mid(.$OutStr, 1, 1)
        if .$TmpStr == $space(1) then
            .$TmpStr = $decode(.$OutStr, $space(1), 1)
        end
    until .$TmpStr <> $space(1)

    return

.end 



;***********************************************************
; func lib.pos_2str_()
;***********************************************************
;	IN : .&PosVal		    * XYZOAT *      * ����ѿ��� *
;  OUT : .&OutStr           * STRING *      * ����ַ��� *
;***********************************************************
; �ѿ���ת�ַ���
;***********************************************************
.program lib.pos_2str_(.&PosVal, .$OutStr)

    .$OutStr = ""

    .$RelStr = ""

    decompose .PosAry[0] = .&PosVal

    for .I = 0 to 5

        call lib.rel_2str_(.PosAry[.I], .$RelStr)

        .$OutStr = .$OutStr + .$RelStr 
        
        if .I < 5 then 

            .$OutStr = .$OutStr + $chr(44) 

        end

    end

    return

.end 

;***********************************************************
; func lib.axis_2str_()
;***********************************************************
;	IN : .&PosVal		    * JOINT *       * ����ؽ����� *
;  OUT : .&OutStr           * STRING *      * ����ַ��� *
;***********************************************************
; �ؽ�ת�ַ���
;***********************************************************
.program lib.axis_2str_(.#PosVal, .$OutStr)

    .$OutStr = ""

    decompose .PosAry[0] = .#PosVal

    for .I = 0 to 5

        call lib.rel_2str_(.PosAry[.I], .$RelStr)

        .$OutStr = .$OutStr + .$RelStr 
        
        if .I < 5 then 

            .$OutStr = .$OutStr + $chr(44) 

        end

    end

    return

.end 


;***********************************************************
; func lib.str_2pos_()
;***********************************************************
;  IN  : .&InStr		    * STRING *      * �����ַ��� *
;  OUT : .&OutPos           * XYZOAT *      * ����ѿ��� *
;***********************************************************
; �ַ���ת�ѿ���
;***********************************************************
.program lib.str_2pos_(.$InStr, .&OutPos)

    .$TmpStr = .$InStr + $chr(44) 

    for .I = 0 to 5
      .$PosStr = $decode(.$TmpStr, $chr(44), 0)
      .$strEol = $decode(.$TmpStr, $chr(44), 1)
      .PosAry[.I] = val(.$PosStr)
    end

    point .&OutPos = trans(.PosAry[0], .PosAry[1], .PosAry[2], .PosAry[3], .PosAry[4], .PosAry[5])
    
    return

.end 


;***********************************************************
; func lib.str_2axis_()
;***********************************************************
;  IN  : .&InStr		    * STRING *      * �����ַ��� *
;  OUT : .#OutPos           * JOINT *       * ����ؽ� *
;***********************************************************
; �ַ���ת�ؽ�
;***********************************************************
.program lib.str_2axis_(.$InStr, .#OutPos)

    .$TmpStr = .$InStr + $chr(44) 

    for .I = 0 to 5
      .$PosStr = $decode(.$TmpStr, $chr(44), 0)
      .$strEol = $decode(.$TmpStr, $chr(44), 1)
      .PosAry[.I] = val(.$PosStr)
    end

    point .#OutPos = #ppoint(.PosAry[0], .PosAry[1], .PosAry[2], .PosAry[3], .PosAry[4], .PosAry[5])
    
    return

.end 

