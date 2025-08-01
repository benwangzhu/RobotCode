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
#ifndef __SBT_COMM004_H__
#define __SBT_COMM004_H__

#include "lib/operating_environment.h"

#define COMM004_ALARM_CODE 8004

#define COMM004_ALARM_SUBCODE_SOFTWARE_NOT_READY                    101
#define COMM004_ALARM_MESSAGE_SKILL_SOFTWARE_NOT_READY						  "软件未就绪"
#define COMM004_ALARM_SUBCODE_SOFTWARE_TIMEOUT                      102
#define COMM004_ALARM_MESSAGE_SKILL_SOFTWARE_TIMEOUT								"软件处理超时"
#define COMM004_ALARM_SUBCODE_UNKNOWN                               103
#define COMM004_ALARM_MESSAGE_SKILL_UNKNOWN								          "未知错误"
#define COMM004_ALARM_SUBCODE_CAMERA_CONN_FAIL                      1
#define COMM004_ALARM_MESSAGE_SKILL_CAMERA_CONN_FAIL					      "相机连接失败"
#define COMM004_ALARM_SUBCODE_CAMERA_PHOTO_FAIL                     2
#define COMM004_ALARM_MESSAGE_SKILL_CAMERA_PHOTO_FAIL					      "相机拍照失败"
#define COMM004_ALARM_SUBCODE_CAMERA_MATER_LOAD_FAIL                3
#define COMM004_ALARM_MESSAGE_SKILL_MATER_LOAD_FAIL					        "上料算法识别失败"
#define COMM004_ALARM_SUBCODE_HINGE_FIT_ALGO_FAIL                   4
#define COMM004_ALARM_MESSAGE_SKILL_HINGE_FIT_ALGO_FAIL					    "铰链贴合算法计算失败"
#define COMM004_ALARM_SUBCODE_HINGE_ALGO_FAIL                       5
#define COMM004_ALARM_MESSAGE_SKILL_HINGE_ALGO_FAIL					        "铰链调整算法计算失败"
#define COMM004_ALARM_SUBCODE_GAP_CALC_FAIL                         6
#define COMM004_ALARM_MESSAGE_SKILL_GAP_CALC_FAIL				            "间隙面差计算失败"
#define COMM004_ALARM_SUBCODE_ASSEMBLY_ALGO_FAIL                    7
#define COMM004_ALARM_MESSAGE_SKILL_ASSEMBLY_ALGO_FAIL					    "装调算法调用失败"
#define COMM004_ALARM_SUBCODE_TIGHT_INVO_FAIL                       8
#define COMM004_ALARM_MESSAGE_SKILL_TIGHT_INVO_FAIL					        "拧紧算法调用失败"
#define COMM004_ALARM_SUBCODE_LEVEL_INVO_FAIL                       9
#define COMM004_ALARM_MESSAGE_SKILL_LEVEL_INVO_FAIL					        "车门吸平算法调用失败"
#define COMM004_ALARM_SUBCODE_CORR_RANGE                            10
#define COMM004_ALARM_MESSAGE_SKILL_CORR_RANGE					            "超出纠偏阈值范围"

#define SAVE_ROBOT_ASMB_POS_VARIABLE            100             // P[100]
#define SAVE_ROBOT_ASMB_STATUS_VARIABLE         100             // B[100]


IMPORT STATUS processCommand_sbt_comm004_initialize_();   // 初始化

IMPORT STATUS ProcessCommand_sbt_comm004_param_();        // 参数

IMPORT STATUS ProcessCommand_sbt_comm004_guide_();        // 引导

IMPORT STATUS ProcessCommand_sbt_comm004_send_pos_();     // 发送位置

IMPORT STATUS ProcessCommand_sbt_comm004_camera_();       // 选择相机

IMPORT STATUS ProcessCommand_sbt_comm004_vasmb_();        // 装调

IMPORT STATUS ProcessCommand_sbt_comm004_dqmoni_();       // 质量监控

#endif