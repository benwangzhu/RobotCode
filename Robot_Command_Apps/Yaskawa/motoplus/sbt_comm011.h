/***********************************************************

Copyright 2018 - 2023 speedbot All Rights reserved.

file Name: lib_mpmotion.h

Description:
  Language             ==   motoplus for Yaskawa ROBOT
  Date                 ==   2021 - 09 - 03
  Modification Data    ==   2021 - 09 - 18

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
#ifndef __SBT_COMM011_H__
#define __SBT_COMM011_H__

#include "lib\operating_environment.h"
#include "lib\lib_mppackages.h"

#define COMM011_ALARM_CODE 8011

struct package_realtime_t
{
  struct packages_head_t Header;
  MP_COORD Pos;
  FLOAT ProcessPrm01;
  FLOAT ProcessPrm02;
  FLOAT ProcessPrm03;
  FLOAT ProcessPrm04;
  UINT8 Reversed[8];
  packages_tail_t Tail;
};

struct package_traje_t
{
  struct packages_head_t Header;
  MP_COORD Pos;
  FLOAT ProcessPrm01;
  FLOAT ProcessPrm02;
  FLOAT ProcessPrm03;
  FLOAT ProcessPrm04;
  UINT8 Reversed[8];
  packages_tail_t Tail;
};

#define COMM011_SERVER_PORT     11002   

#define COMM011_ALARM_CODE      8011

#define COMM011_ALARM_SUBCODE_FAILED_CONNECT                    1
#define COMM011_ALARM_MESSAGE_SKILL_FAILED_CONNECT						  "链接失败[IP:%s, PORT:%d]"


#define INST_UNKNOWN        0
#define INST_PATH           1
#define INST_2D_ST          2
#define INST_2D_ED          3
#define INST_3D_ST          4
#define INST_3D_ED          5
#define INST_LS_ST          6
#define INST_LS_ED          7
#define INST_PRM_ST         8
#define INST_PRM_ED         9

IMPORT struct package_realtime_t PackageRealtime;
IMPORT struct package_traje_t PackageTraje;

IMPORT STATUS ProcessReceivedSbtComm011Data();

IMPORT STATUS processCommand_sbt_comm011_init_();   // 初始化

IMPORT STATUS ProcessCommandSbtComm011Realtime();   // 实时数据传输

IMPORT STATUS ProcessCommandSbtComm011Close();      // 链接通讯

IMPORT STATUS processCommand_sbt_comm011_close_();   // 关闭通讯

IMPORT STATUS ProcessCommandSbtComm011ScanStart();   // 2D扫描开始

IMPORT STATUS ProcessCommandSbtComm011ScanStop();   // 2D扫描结束

IMPORT STATUS ProcessCommandSbtComm011GetPath();    // 获取焊接位置

#endif  /* __SBT_COMM011_H__ */