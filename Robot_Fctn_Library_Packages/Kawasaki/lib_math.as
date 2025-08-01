;***********************************************************
;
; Copyright 2018 - 2023 speedbot All Rights reserved.
;
; File Name: lib_math
;
; Description:
;   Language             ==   As for KAWASAKI ROBOT
;   Date                 ==   2022 - 12 - 31
;   Modification Data    ==   2022 - 12 - 31
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

; 2022 - 12 - 31 ++ lib.deg_to_rad_()

; 2022 - 12 - 31 ++ lib.rad_to_deg_()

; 2023 - 01 - 03 ++ lib.random_()

; 2023 - 01 - 04 ++ lib.sint_2raw_()

; 2023 - 01 - 04 ++ lib.dint_2raw_()

; 2023 - 01 - 04 ++ lib.raw_2dint_()

; 2023 - 01 - 04 ++ lib.raw_2int_()

; 2023 - 01 - 04 ++ lib.raw_2sint_()

;***********************************************************
; func lib.deg_to_rad_()
;***********************************************************
;	IN : .DegVal		    * Real *  * 输入角度 *
;  OUT : .RadVal		    * Real *  * 输出弧度 *
;***********************************************************
; 角度转弧度
;***********************************************************
.program lib.deg_to_rad_(.DegVal, .RadVal)

    .RadVal = .DegVal * PI / 180.0
.end

;***********************************************************
; func lib.rad_to_deg_()
;***********************************************************
;	IN : .RadVal		    * Real *  * 输入弧度 *
;  OUT : .DegVal		    * Real *  * 输出角度 *
;***********************************************************
; 弧度转角度
;***********************************************************
.program lib.rad_to_deg_(.RadVal, .DegVal)

    .DegVal = .RadVal * 180.0 / PI
.end

;***********************************************************
; func lib.random_()
;***********************************************************
;	IN : .MinVal		    * Real *  * 输入最小值 *
;	IN : .MaxVal		    * Real *  * 输入最大值 *
;  OUT : .RandomVal		    * Real *  * 输出随机数 *
;***********************************************************
; 返回指定范围的随机数
;***********************************************************
.program lib.random_(.MinVal, .MaxVal, .RandomVal)

    .RandomVal = .MinVal + (.MaxVal - .MinVal) * random
.end

;***********************************************************
; func lib.sint_2raw_()
;***********************************************************
;	IN : .ByteVal		    * Byte *    * 一个字节的整数 *
;	IN : .$RawPack[]		* String *  * 缓存包 *
;  OUT : .Start		        * Int *     * 起始地址 *
;***********************************************************
; 将一个字节的整数打包进字符串数组
;***********************************************************
.program lib.sint_2raw_(.ByteVal, .$RawPack[], .Start)

    if .ByteVal < 0 then  

        .CnvVal = .ByteVal + MAX_USINT + 1
    else

        .CnvVal = .ByteVal
    end
    .$RawPack[.Start] = $chr(.CnvVal)
.end

;***********************************************************
; func lib.int_2raw_()
;***********************************************************
;	IN : .ShortVal		    * Short *   * 两个字节的整数 *
;	IN : .$RawPack[]		* String *  * 缓存包 *
;  OUT : .Start		        * Int *     * 起始地址 *
;***********************************************************
; 将两个字节的整数打包进字符串数组
;***********************************************************
.program lib.int_2raw_(.ShortVal, .$RawPack[], .Start)

    if .ShortVal < 0 then  

        .CnvVal = .ShortVal + MAX_UINT + 1
    else

        .CnvVal = .ShortVal
    end

    .$HexVal = $encode(/J4, .CnvVal)

    for .I = 0 to 1
        .$RawPack[.Start + .I] = $chr(val("^h" + $mid(.$HexVal, (1 - .I) * 2 + 1, 2)))
    end
.end

;***********************************************************
; func lib.dint_2raw_()
;***********************************************************
;	IN : .IntVal		    * Int *     * 四个字节的整数 *
;	IN : .$RawPack[]		* String *  * 缓存包 *
;  OUT : .Start		        * Int *     * 起始地址 *
;***********************************************************
; 将四个字节的整数打包进字符串数组
;***********************************************************
.program lib.dint_2raw_(.IntVal, .$RawPack[], .Start)

    .$HexVal = $encode(/J8, .IntVal)

    for .I = 0 to 3
        .$RawPack[.Start + .I] = $chr(val("^h" + $mid(.$HexVal, (3 - .I) * 2 + 1, 2)))
    end
.end

;***********************************************************
; func lib.raw_2dint_()
;***********************************************************
;	IN : .$RawPack[]		* String *  * 缓存包 *
;   IN : .Start		        * Int *     * 起始地址 *
;  OUT : .IntVal		    * Int *     * 四个字节的整数 *
;***********************************************************
; 将打包的字符串数组转化成四个字节的整数
;***********************************************************
.program lib.raw_2dint_(.$RawPack[], .Start, .IntVal)

    .$HexVal = "^h"

    for .I = 0 to 3 
        .$HexVal = .$HexVal + $encode(/J2, asc(.$RawPack[.Start + 3 - .I]))
    end

    .IntVal = val(.$HexVal)

.end

;***********************************************************
; func lib.raw_2int_()
;***********************************************************
;	IN : .$RawPack[]		* String *  * 缓存包 *
;   IN : .Start		        * Int *     * 起始地址 *
;   IN : .UIntFlag		    * bool *    * true 为无符号 *
;  OUT : .ShortVal		    * Short *   * 两个字节的整数 *
;***********************************************************
; 将打包的字符串数组转化成两个字节的整数
;***********************************************************
.program lib.raw_2int_(.$RawPack[], .Start, .UIntFlag, .ShortVal)

    .$HexVal = "^h"

    for .I = 0 to 1 
        .$HexVal = .$HexVal + $encode(/J2, asc(.$RawPack[.Start + 3 - .I]))
    end

    .IntVal = val(.$HexVal)

    if .UIntFlag == false then  

        if .IntVal > MAX_INT then  

            .IntVal = .IntVal - (MAX_UINT + 1)
        end
    end
.end

;***********************************************************
; func lib.raw_2sint_()
;***********************************************************
;	IN : .$RawPack[]		* String *  * 缓存包 *
;   IN : .Start		        * Int *     * 起始地址 *
;   IN : .USintFlag		    * bool *    * true 为无符号 *
;  OUT : .ByteVal		    * Byte *    * 一个字节的整数 *
;***********************************************************
; 将打包的字符串数组转化成一个字节的整数
;***********************************************************
.program lib.raw_2sint_(.$RawPack[], .Start, .USintFlag, .ByteVal)

    .ByteVal = asc(.$RawPack[.Start])

    if .USintFlag == false then  

        if .ByteVal > MAX_SINT then  

            .ByteVal = .ByteVal - (MAX_USINT + 1)
        end
    end
.end

.program lib.def_math_()

    DEG_2_RAD                   = 0.017453
    RAD_2_DEG                   = 57.29578


    MIN_DINT	                =  -2147483648
    MAX_DINT	                =  2147483647

    MIN_INT	                    =  -32768
    MAX_INT	                    =  32767

    MIN_SINT	                =  -128
    MAX_SINT	                =  127

    MIN_UINT	                =  0
    MAX_UINT	                =  65535

    MIN_USINT	                =  0
    MAX_USINT	                =  255

    SIZE_OF_BYTE                = 1
    SIZE_OF_REAL                = 4
    SIZE_OF_INT                 = 4


    MASK8[0]                    = 1
    MASK8[1]                    = 2
    MASK8[2]                    = 4
    MASK8[3]                    = 8
    MASK8[4]                    = 16
    MASK8[5]                    = 32
    MASK8[6]                    = 64
    MASK8[7]                    = -128

    UMASK8[1]                   = 1
    UMASK8[2]                   = 2
    UMASK8[3]                   = 4
    UMASK8[4]                   = 8
    UMASK8[5]                   = 16
    UMASK8[6]                   = 32
    UMASK8[7]                   = 64
    UMASK8[8]                   = 128

    MASK16[1]                   = 1
    MASK16[2]                   = 2
    MASK16[3]                   = 4
    MASK16[4]                   = 8
    MASK16[5]                   = 16
    MASK16[6]                   = 32
    MASK16[7]                   = 64
    MASK16[8]                   = 128
    MASK16[9]                   = 256
    MASK16[10]                  = 512
    MASK16[11]                  = 1024
    MASK16[12]                  = 2048
    MASK16[13]                  = 4096
    MASK16[14]                  = 8192
    MASK16[15]                  = 16384
    MASK16[16]                  = -32768

    UMASK16[1]                  = 1
    UMASK16[2]                  = 2
    UMASK16[3]                  = 4
    UMASK16[4]                  = 8
    UMASK16[5]                  = 16
    UMASK16[6]                  = 32
    UMASK16[7]                  = 64
    UMASK16[8]                  = 128
    UMASK16[9]                  = 256
    UMASK16[10]                 = 512
    UMASK16[11]                 = 1024
    UMASK16[12]                 = 2048
    UMASK16[13]                 = 4096
    UMASK16[14]                 = 8192
    UMASK16[15]                 = 16384
    UMASK16[16]                 = 32768

.end

