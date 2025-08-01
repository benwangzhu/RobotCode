/***********************************************************

Copyright 2018 - 2025 speedbot All Rights reserved.

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
#ifndef __SBT_UNSTACK_H__
#define __SBT_UNSTACK_H__

#include "lib/operating_environment.h"
#include "lib/lib_mppackages.h"


#define UNSTACK_ALARM_CODE      8000

#define UNSTACK_SERVER_PORT     15555 


/* 拆码垛数据结构*/
struct unstack_data_t
{
    INT32 PartId;                   // 工件编号
    INT32 AreaId;                   // 区域编号
    INT32 MagaPip;                  // 抓手气路通道
    FLOAT BoxLength;                // 工件长度
    FLOAT BoxWindth;                // 工件宽度
    FLOAT BoxHig;                   // 工件高度
    MP_COORD PickPos;               // 抓取坐标
    MP_COORD DropPos;               // 码垛坐标
    MP_COORD ObliPos;               // 斜插坐标
};

//
#define UNSTACK_INFORM_SWITCH_CODE_FINISH       5
#define UNSTACK_INFORM_SWITCH_CODE_ERROR        4
#define UNSTACK_INFORM_SWITCH_CODE_WORK         3
#define UNSTACK_INFORM_SWITCH_CODE_INITIALIZED  2

#define UNSTACK_SAVE_VARIABLE_LONG_PART_ID      60      /* D[060] 存储工件编号 */                
#define UNSTACK_SAVE_VARIABLE_LONG_AREA_ID      61      /* D[061] 存储区域编号 */
#define UNSTACK_SAVE_VARIABLE_LONG_MAG_PIP      62      /* D[062] 存储抓手气路通道 */
#define UNSTACK_SAVE_VARIABLE_FLOAT_BOX_LENGTH  61      /* R[060] 存储工件长度 */
#define UNSTACK_SAVE_VARIABLE_FLOAT_BOX_WINDTH  62      /* R[061] 存储工件宽度 */
#define UNSTACK_SAVE_VARIABLE_FLOAT_BOX_HIG     63      /* R[062] 存储工件高度 */
#define UNSTACK_SAVE_VARIABLE_POS_PICK          60      /* P[060] 存储抓取坐标 */
#define UNSTACK_SAVE_VARIABLE_POS_PLACE         61      /* P[061] 存储码垛坐标 */
#define UNSTACK_SAVE_VARIABLE_POS_OBLIPOS       62      /* P[062] 存储斜插坐标 */


#define UNSTACK_ALARM_SUBCODE_FAILED_CONNECT                    1
#define UNSTACK_ALARM_MESSAGE_SKILL_FAILED_CONNECT			    "链接失败[IP:%s, PORT:%d]"


IMPORT STATUS processReceived_sbt_unstack_data_();              /* 接收解析数据 */

IMPORT STATUS processCommand_sbt_unstack_open_();               /* 通讯链接 */

IMPORT STATUS processCommand_sbt_unstack_initialize_();         /* 链接后进行通讯交互初始化 */

IMPORT STATUS processCommand_sbt_unstack_getData_();            /* 获取通讯数据 */

IMPORT STATUS processCommand_sbt_unstack_miss_();               /* 通讯反馈拆垛时掉箱 */

IMPORT STATUS processCommand_sbt_unstack_success_();            /* 通讯反馈拆垛成功 */

IMPORT STATUS processCommand_sbt_unstack_area_();               /* 通讯反馈拆垛后离开区域 */

IMPORT STATUS processCommand_sbt_unstack_reach_();              /* 通讯反馈拆垛坐标信息可达 */

IMPORT STATUS processCommand_sbt_unstack_unreach_();            /* 通讯反馈拆垛坐标信息不可达 */

#endif /* __SBT_UNSTACK_H__ */