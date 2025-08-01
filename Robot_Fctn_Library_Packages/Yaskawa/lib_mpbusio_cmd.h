/***********************************************************

Copyright 2018 - 2023 speedbot All Rights reserved.

 file Name: lib_mpbusio_cmd.h

 Description:
   Language             ==   motoplus for Yaskawa ROBOT
  Date                 ==   2023 - 10 - 26
  Modification Data    ==   2023 - 10 - 27

 Author: speedbot

 Version: 1.0
--*********************************************************************************************************--
--                                                                                                         --
--                                                      .^^^                                               --
--                                               .,~<c+{{{{{{t,                                            -- 
--                                       `^,"!t{{{{{{{{{{{{{{{{+,                                          --
--                                 .:"c+{{{{{{{{{{{{{{{{{{{{{{{{{+,                                        --
--                                "{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{~                                       --
--                               ^{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{!.  `^                                    --
--                               c{{{{{{{{{{{{{c~,^`  `.^:<+{{{!.  `<{{+,                                  --
--                              ^{{{{{{{{{{{!^              `,.  `<{{{{{{+:                                --
--                              t{{{{{{{{{!`                    ~{{{{{{{{{{+,                              --
--                             ,{{{{{{{{{:      ,uDWMMH^        `c{{{{{{{{{{{~                             --
--                             +{{{{{{{{:     ,XMMMMMMw           t{{{{{{{{{{t                             --
--                            ,{{{{{{{{t     :MMMMMMMMM"          ^{{{{{{{{{{~                             --
--                            +{{{{{{{{~     8MMMMMMMMMMWD8##      {{{{{{{{{+                              --
--                           :{{{{{{{{{~     8MMMMMMMMMMMMMMH      {{{{{{{{{~                              --
--                           +{{{{{{{{{c     :MMMMMMMMMMMMMMc     ^{{{{{{{{+                               --
--                          ^{{{{{{{{{{{,     ,%MMMMMMMMMMH"      c{{{{{{{{:                               --
--                          `+{{{{{{{{{{{^      :uDWMMMX0"       !{{{{{{{{+                                --
--                           `c{{{{{{{{{{{"                    ^t{{{{{{{{{,                                --
--                             ^c{{{{{{{{{{{".               ,c{{{{{{{{{{t                                 --
--                               ^c{{{{{{{{{{{+<,^`     .^~c{{{{{{{{{{{{{,                                 --
--                                 ^c{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{t                                  --
--                                   ^c{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{t`                                  --
--                                     ^c{{{{{{{{{{{{{{{{{{{{{{{{{{+c"^                                    --                         
--                                       ^c{{{{{{{{{{{{{{{{{+!":^.                                         --
--                                         ^!{{{{{{{{t!",^`                                                --
--                                                                                                         --
--*********************************************************************************************************--
--  
*/ 
#ifndef __SBT_MPBUS_IO_CMD_H__
#define __SBT_MPBUS_IO_CMD_H__

#include "lib_mpbusio.h"
#include "operating_environment.h"

enum bus_command_rw_e 
{
    BUSCMD_WRITE = 1,
    BUSCMD_READ
};

enum bus_command_ms_e
{
    BUSCMD_SLE = -2,
    BUSCMD_MST
};

#define BUS_CMD000                                0                 
#define BUS_CMD001                                1
#define BUS_CMD002                                2
#define BUS_CMD003                                3
#define BUS_CMD004                                4
#define BUS_CMD005                                5
#define BUS_CMD006                                6
#define BUS_CMD007                                7
#define BUS_CMD008                                8
#define BUS_CMD009                                9
#define BUS_CMD010                                10
#define BUS_CMD011                                11
#define BUS_CMD012                                12
#define BUS_CMD013                                13
#define BUS_CMD014                                14
#define BUS_CMD015                                15
#define BUS_CMD016                                16
#define BUS_CMD017                                17
#define BUS_CMD018                                18
#define BUS_CMD019                                19
#define BUS_CMD020                                20
#define BUS_CMD021                                21
#define BUS_CMD022                                22
#define BUS_CMD023                                23
#define BUS_CMD024                                24
#define BUS_CMD025                                25
#define BUS_CMD026                                26
#define BUS_CMD027                                27
#define BUS_CMD028                                28
#define BUS_CMD029                                29
#define BUS_CMD030                                30
#define BUS_CMD031                                31
#define BUS_CMD032                                32
#define BUS_CMD033                                33
#define BUS_CMD034                                34
#define BUS_CMD035                                35
#define BUS_CMD036                                36
#define BUS_CMD037                                37
#define BUS_CMD038                                38
#define BUS_CMD039                                39
#define BUS_CMD040                                40
#define BUS_CMD041                                41
#define BUS_CMD042                                42
#define BUS_CMD043                                43
#define BUS_CMD044                                44
#define BUS_CMD045                                45
#define BUS_CMD046                                46
#define BUS_CMD047                                47
#define BUS_CMD048                                48
#define BUS_CMD049                                49
#define BUS_CMD050                                50
#define BUS_CMD051                                51
#define BUS_CMD052                                52
#define BUS_CMD053                                53
#define BUS_CMD054                                54
#define BUS_CMD055                                55
#define BUS_CMD056                                56
#define BUS_CMD057                                57
#define BUS_CMD058                                58
#define BUS_CMD059                                59
#define BUS_CMD060                                60
#define BUS_CMD061                                61
#define BUS_CMD062                                62
#define BUS_CMD063                                63
#define BUS_CMD064                                64
#define BUS_CMD065                                65
#define BUS_CMD066                                66
#define BUS_CMD067                                67
#define BUS_CMD068                                68
#define BUS_CMD069                                69
#define BUS_CMD070                                70
#define BUS_CMD071                                71
#define BUS_CMD072                                72
#define BUS_CMD073                                73
#define BUS_CMD074                                74
#define BUS_CMD075                                75
#define BUS_CMD076                                76
#define BUS_CMD077                                77
#define BUS_CMD078                                78
#define BUS_CMD079                                79
#define BUS_CMD080                                80
#define BUS_CMD081                                81
#define BUS_CMD082                                82
#define BUS_CMD083                                83
#define BUS_CMD084                                84
#define BUS_CMD085                                85
#define BUS_CMD086                                86
#define BUS_CMD087                                87
#define BUS_CMD088                                88
#define BUS_CMD089                                89
#define BUS_CMD090                                90
#define BUS_CMD091                                91
#define BUS_CMD092                                92
#define BUS_CMD093                                93
#define BUS_CMD094                                94
#define BUS_CMD095                                95
#define BUS_CMD096                                96
#define BUS_CMD097                                97
#define BUS_CMD098                                98
#define BUS_CMD099                                99
#define BUS_CMD100                                100
#define BUS_CMD101                                101
#define BUS_CMD102                                102
#define BUS_CMD103                                103
#define BUS_CMD104                                104
#define BUS_CMD105                                105
#define BUS_CMD106                                106
#define BUS_CMD107                                107
#define BUS_CMD108                                108
#define BUS_CMD109                                109
#define BUS_CMD110                                110
#define BUS_CMD111                                111
#define BUS_CMD112                                112
#define BUS_CMD113                                113
#define BUS_CMD114                                114
#define BUS_CMD115                                115
#define BUS_CMD116                                116
#define BUS_CMD117                                117
#define BUS_CMD118                                118
#define BUS_CMD119                                119
#define BUS_CMD120                                120
#define BUS_CMD121                                121
#define BUS_CMD122                                122
#define BUS_CMD123                                123
#define BUS_CMD124                                124
#define BUS_CMD125                                125
#define BUS_CMD126                                126
#define BUS_CMD127                                127
#define BUS_CMD128                                128
#define BUS_CMD129                                129
#define BUS_CMD130                                130
#define BUS_CMD131                                131
#define BUS_CMD132                                132
#define BUS_CMD133                                133
#define BUS_CMD134                                134
#define BUS_CMD135                                135
#define BUS_CMD136                                136
#define BUS_CMD137                                137
#define BUS_CMD138                                138
#define BUS_CMD139                                139
#define BUS_CMD140                                140
#define BUS_CMD141                                141
#define BUS_CMD142                                142
#define BUS_CMD143                                143
#define BUS_CMD144                                144
#define BUS_CMD145                                145
#define BUS_CMD146                                146
#define BUS_CMD147                                147
#define BUS_CMD148                                148
#define BUS_CMD149                                149
#define BUS_CMD150                                150
#define BUS_CMD151                                151
#define BUS_CMD152                                152
#define BUS_CMD153                                153
#define BUS_CMD154                                154
#define BUS_CMD155                                155
#define BUS_CMD156                                156
#define BUS_CMD157                                157
#define BUS_CMD158                                158
#define BUS_CMD159                                159
#define BUS_CMD160                                160
#define BUS_CMD161                                161
#define BUS_CMD162                                162
#define BUS_CMD163                                163
#define BUS_CMD164                                164
#define BUS_CMD165                                165
#define BUS_CMD166                                166
#define BUS_CMD167                                167
#define BUS_CMD168                                168
#define BUS_CMD169                                169
#define BUS_CMD170                                170
#define BUS_CMD171                                171
#define BUS_CMD172                                172
#define BUS_CMD173                                173
#define BUS_CMD174                                174
#define BUS_CMD175                                175
#define BUS_CMD176                                176
#define BUS_CMD177                                177
#define BUS_CMD178                                178
#define BUS_CMD179                                179
#define BUS_CMD180                                180
#define BUS_CMD181                                181
#define BUS_CMD182                                182
#define BUS_CMD183                                183
#define BUS_CMD184                                184
#define BUS_CMD185                                185
#define BUS_CMD186                                186
#define BUS_CMD187                                187
#define BUS_CMD188                                188
#define BUS_CMD189                                189
#define BUS_CMD190                                190
#define BUS_CMD191                                191
#define BUS_CMD192                                192
#define BUS_CMD193                                193
#define BUS_CMD194                                194
#define BUS_CMD195                                195
#define BUS_CMD196                                196
#define BUS_CMD197                                197
#define BUS_CMD198                                198
#define BUS_CMD199                                199
#define BUS_CMD200                                200
#define BUS_CMD201                                201
#define BUS_CMD202                                202
#define BUS_CMD203                                203
#define BUS_CMD204                                204
#define BUS_CMD205                                205
#define BUS_CMD206                                206
#define BUS_CMD207                                207
#define BUS_CMD208                                208
#define BUS_CMD209                                209
#define BUS_CMD210                                210
#define BUS_CMD211                                211
#define BUS_CMD212                                212
#define BUS_CMD213                                213
#define BUS_CMD214                                214
#define BUS_CMD215                                215
#define BUS_CMD216                                216
#define BUS_CMD217                                217
#define BUS_CMD218                                218
#define BUS_CMD219                                219
#define BUS_CMD220                                220
#define BUS_CMD221                                221
#define BUS_CMD222                                222
#define BUS_CMD223                                223
#define BUS_CMD224                                224
#define BUS_CMD225                                225
#define BUS_CMD226                                226
#define BUS_CMD227                                227
#define BUS_CMD228                                228
#define BUS_CMD229                                229
#define BUS_CMD230                                230
#define BUS_CMD231                                231
#define BUS_CMD232                                232
#define BUS_CMD233                                233
#define BUS_CMD234                                234
#define BUS_CMD235                                235
#define BUS_CMD236                                236
#define BUS_CMD237                                237
#define BUS_CMD238                                238
#define BUS_CMD239                                239
#define BUS_CMD240                                240
#define BUS_CMD241                                241
#define BUS_CMD242                                242
#define BUS_CMD243                                243
#define BUS_CMD244                                244
#define BUS_CMD245                                245
#define BUS_CMD246                                246
#define BUS_CMD247                                247
#define BUS_CMD248                                248
#define BUS_CMD249                                249
#define BUS_CMD250                                250
#define BUS_CMD251                                251
#define BUS_CMD252                                252
#define BUS_CMD253                                253
#define BUS_CMD254                                254
#define BUS_CMD255                                255         

struct cmd_type01_t
{
    UINT8 Byte01;
    UINT8 Byte02;
    INT16 Short03;
    INT16 Short04;
    INT32 Int05;
    INT32 Int06;
    FLOAT Float07;
    FLOAT Float08;
};

typedef FLOAT cmd_type02_t[6];

typedef UINT8 cmd_type03_t[18];

struct cmd_type04_t
{
    UINT8 Byte01;
    INT16 Short02;
    INT16 Short03;
    INT16 Short04;
    UINT8 Byte05;
    UINT8 Byte06;
    UINT8 Byte07;
    UINT8 Byte08;
    UINT8 Byte09;
    UINT8 Byte10;
    UINT8 Byte11;
    UINT8 Byte12;
    INT16 Short13;
    INT16 Short14;
    UINT8 Byte15;
    UINT8 Byte16;
    UINT8 Byte17;
};

struct cmd_type05_t
{
    INT32 Int01;
    UINT8 Byte02;
    UINT8 Byte03;
    INT16 Short04;
    INT32 Int05 ;
    INT16 Short06;
    INT16 Short07;
    UINT8 Byte08;
    UINT8 Byte09;
    UINT8 Byte10;
} ;

struct cmd_type06_t
{
    UINT8 Byte01;
    INT16 Short02;
    INT16 Short03;
    INT16 Short04;
    FLOAT Float05;
    FLOAT Float06;
};

struct cmd_type07_t
{
    FLOAT Float01;
    FLOAT Float02;
    FLOAT Float03;
    FLOAT Float04;
    FLOAT Float05;
    FLOAT Float06;
    FLOAT Float07;
    FLOAT Float08;
    FLOAT Float09;
    FLOAT Float10;
    FLOAT Float11;
    FLOAT Float12;
    INT32 Int13;
    INT32 Int14;
};

struct cmd_type08_t
{
    UINT8 Byte01;
    UINT8 Byte02;
    UINT8 Byte03;
    UINT8 Byte04;
    INT16 Short05;
    INT16 Short06;
    INT16 Short07;
    INT16 Short08;
    INT32 Int09;
    INT32 Int10;
    INT32 Int11;
    INT32 Int12;
    FLOAT Float13;
    FLOAT Float14;
    FLOAT Float15;
    FLOAT Float16;
};

struct cmd_type09_t
{
    INT32 Int01;
    INT32 Int02;
    FLOAT Float03;
    FLOAT Float04;
    FLOAT Float05;
    FLOAT Float06;
    FLOAT Float07;
    FLOAT Float08;
    FLOAT Float09;
    FLOAT Float10;
    FLOAT Float11;
    FLOAT Float12;
    FLOAT Float13;
    FLOAT Float14;
};

IMPORT STATUS bus_command001_(IN enum bus_command_rw_e BusOperation, 
                              IN enum bus_command_ms_e BusMstSel, 
                              INOUT struct businput_t* BusInput, 
                              INOUT struct busoutput_t *BusOutput, 
                              IN INT32 Timeout);

IMPORT STATUS bus_command002_(IN enum bus_command_rw_e BusOperation, 
                              IN enum bus_command_ms_e BusMstSel, 
                              INOUT struct businput_t* BusInput, 
                              INOUT struct busoutput_t* BusOutput, 
                              INOUT struct cmd_type01_t* BusData,
                              IN INT32 Timeout);

IMPORT STATUS bus_command003_(IN enum bus_command_rw_e BusOperation, 
                              IN enum bus_command_ms_e BusMstSel, 
                              INOUT struct businput_t* BusInput, 
                              INOUT struct busoutput_t* BusOutput, 
                              INOUT MP_COORD* BusData,
                              IN INT32 Timeout);

IMPORT STATUS bus_command009_(IN enum bus_command_rw_e BusOperation, 
                              IN enum bus_command_ms_e BusMstSel, 
                              INOUT struct businput_t* BusInput, 
                              INOUT struct busoutput_t* BusOutput, 
                              INOUT MP_COORD* BusData,
                              IN INT32 Timeout);

IMPORT STATUS bus_command010_(IN enum bus_command_rw_e BusOperation, 
                              IN enum bus_command_ms_e BusMstSel, 
                              INOUT struct businput_t* BusInput, 
                              INOUT struct busoutput_t* BusOutput, 
                              INOUT MP_COORD* BusData,
                              IN INT32 Timeout);


IMPORT STATUS bus_command011_(IN enum bus_command_rw_e BusOperation, 
                              IN enum bus_command_ms_e BusMstSel, 
                              struct businput_t* BusInput, 
                              struct busoutput_t* BusOutput, 
                              MP_COORD* BusData,
                              IN INT32 Timeout);

IMPORT STATUS bus_command012_(IN enum bus_command_rw_e BusOperation, 
                              IN enum bus_command_ms_e BusMstSel, 
                              INOUT struct businput_t* BusInput, 
                              INOUT struct busoutput_t* BusOutput, 
                              INOUT struct cmd_type01_t* BusData,
                              IN INT32 Timeout);

IMPORT STATUS bus_command013_(IN enum bus_command_rw_e BusOperation, 
                              IN enum bus_command_ms_e BusMstSel, 
                              INOUT struct businput_t* BusInput, 
                              INOUT struct busoutput_t* BusOutput, 
                              INOUT struct cmd_type01_t* BusData,
                              IN INT32 Timeout);


IMPORT STATUS bus_command014_(IN enum bus_command_rw_e BusOperation, 
                              IN enum bus_command_ms_e BusMstSel, 
                              INOUT struct businput_t* BusInput, 
                              INOUT struct busoutput_t* BusOutput, 
                              INOUT struct cmd_type01_t* BusData,
                              IN INT32 Timeout);

IMPORT STATUS bus_command017_(IN enum bus_command_rw_e BusOperation, 
                              IN enum bus_command_ms_e BusMstSel, 
                              INOUT struct businput_t* BusInput, 
                              INOUT struct busoutput_t* BusOutput, 
                              INOUT struct cmd_type07_t* BusData,
                              IN INT32 Timeout);

IMPORT STATUS bus_command018_(IN enum bus_command_rw_e BusOperation, 
                              IN enum bus_command_ms_e BusMstSel, 
                              INOUT struct businput_t* BusInput, 
                              INOUT struct busoutput_t* BusOutput, 
                              INOUT struct cmd_type07_t* BusData,
                              IN INT32 Timeout);

IMPORT STATUS bus_command020_(IN enum bus_command_rw_e BusOperation, 
                              IN enum bus_command_ms_e BusMstSel, 
                              INOUT struct businput_t* BusInput, 
                              INOUT struct busoutput_t* BusOutput, 
                              INOUT MP_COORD* BusData,
                              IN INT32 Timeout);


IMPORT STATUS bus_command021_(IN enum bus_command_rw_e BusOperation, 
                              IN enum bus_command_ms_e BusMstSel, 
                              INOUT struct businput_t* BusInput, 
                              INOUT struct busoutput_t* BusOutput, 
                              INOUT struct cmd_type01_t* BusData,
                              IN INT32 Timeout);

IMPORT STATUS bus_command022_(IN enum bus_command_rw_e BusOperation, 
                              IN enum bus_command_ms_e BusMstSel, 
                              INOUT struct businput_t* BusInput, 
                              INOUT struct busoutput_t* BusOutput, 
                              INOUT struct cmd_type01_t* BusData,
                              IN INT32 Timeout);

IMPORT STATUS bus_command026_(IN enum bus_command_rw_e BusOperation, 
                              IN enum bus_command_ms_e BusMstSel, 
                              INOUT struct businput_t* BusInput, 
                              INOUT struct busoutput_t* BusOutput, 
                              INOUT struct cmd_type01_t* BusData,
                              IN INT32 Timeout);

IMPORT STATUS bus_command027_(IN enum bus_command_rw_e BusOperation, 
                              IN enum bus_command_ms_e BusMstSel, 
                              INOUT struct businput_t* BusInput, 
                              INOUT struct busoutput_t* BusOutput, 
                              INOUT struct cmd_type08_t* BusData,
                              IN INT32 Timeout);

IMPORT STATUS bus_command129_(IN enum bus_command_rw_e BusOperation, 
                              IN enum bus_command_ms_e BusMstSel, 
                              INOUT struct businput_t* BusInput, 
                              INOUT struct busoutput_t* BusOutput, 
                              INOUT MP_COORD* BusData,
                              IN INT32 Timeout);

IMPORT STATUS bus_command130_(IN enum bus_command_rw_e BusOperation, 
                              IN enum bus_command_ms_e BusMstSel, 
                              INOUT struct businput_t* BusInput, 
                              INOUT struct busoutput_t* BusOutput, 
                              INOUT MP_JOINT* BusData,
                              IN INT32 Timeout);

IMPORT STATUS bus_command131_(IN enum bus_command_rw_e BusOperation, 
                              IN enum bus_command_ms_e BusMstSel, 
                              INOUT struct businput_t* BusInput, 
                              INOUT struct busoutput_t* BusOutput, 
                              INOUT cmd_type02_t* BusData,
                              IN INT32 Timeout);

IMPORT STATUS bus_command132_(IN enum bus_command_rw_e BusOperation, 
                              IN enum bus_command_ms_e BusMstSel, 
                              INOUT struct businput_t* BusInput, 
                              INOUT struct busoutput_t* BusOutput, 
                              INOUT struct cmd_type07_t* BusData,
                              IN INT32 Timeout);

IMPORT STATUS bus_command133_(IN enum bus_command_rw_e BusOperation, 
                              IN enum bus_command_ms_e BusMstSel, 
                              INOUT struct businput_t* BusInput, 
                              INOUT struct busoutput_t* BusOutput, 
                              INOUT struct cmd_type07_t* BusData,
                              IN INT32 Timeout);

IMPORT STATUS bus_command134_(IN enum bus_command_rw_e BusOperation, 
                              IN enum bus_command_ms_e BusMstSel, 
                              INOUT struct businput_t* BusInput, 
                              INOUT struct busoutput_t* BusOutput, 
                              INOUT struct cmd_type09_t* BusData,
                              IN INT32 Timeout);

IMPORT STATUS bus_command137_(IN enum bus_command_rw_e BusOperation, 
                              IN enum bus_command_ms_e BusMstSel, 
                              INOUT struct businput_t* BusInput, 
                              INOUT struct busoutput_t* BusOutput, 
                              INOUT cmd_type03_t* BusData,
                              IN INT32 Timeout);

IMPORT STATUS bus_command145_(IN enum bus_command_rw_e BusOperation, 
                              IN enum bus_command_ms_e BusMstSel, 
                              INOUT struct businput_t* BusInput, 
                              INOUT struct busoutput_t* BusOutput, 
                              INOUT struct cmd_type01_t* BusData,
                              IN INT32 Timeout);

IMPORT STATUS bus_command148_(IN enum bus_command_rw_e BusOperation, 
                              IN enum bus_command_ms_e BusMstSel, 
                              INOUT struct businput_t* BusInput, 
                              INOUT struct busoutput_t* BusOutput, 
                              INOUT struct cmd_type08_t* BusData,
                              IN INT32 Timeout);

IMPORT STATUS bus_command151_(IN enum bus_command_rw_e BusOperation, 
                              IN enum bus_command_ms_e BusMstSel, 
                              INOUT struct businput_t* BusInput, 
                              INOUT struct busoutput_t* BusOutput, 
                              INOUT struct cmd_type06_t* BusData,
                              IN INT32 Timeout);


IMPORT STATUS bus_command254_(IN enum bus_command_rw_e BusOperation, 
                              IN enum bus_command_ms_e BusMstSel, 
                              INOUT struct businput_t* BusInput, 
                              INOUT struct busoutput_t* BusOutput, 
                              INOUT struct cmd_type07_t* BusData,
                              IN INT32 Timeout);

IMPORT STATUS bus_command255_(IN enum bus_command_rw_e BusOperation, 
                              IN enum bus_command_ms_e BusMstSel, 
                              INOUT struct businput_t* BusInput, 
                              INOUT struct busoutput_t* BusOutput, 
                              INOUT struct cmd_type07_t* BusData,
                              IN INT32 Timeout);

#endif
