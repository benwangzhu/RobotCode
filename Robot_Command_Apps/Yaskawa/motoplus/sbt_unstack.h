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


/* ��������ݽṹ*/
struct unstack_data_t
{
    INT32 PartId;                   // �������
    INT32 AreaId;                   // ������
    INT32 MagaPip;                  // ץ����·ͨ��
    FLOAT BoxLength;                // ��������
    FLOAT BoxWindth;                // �������
    FLOAT BoxHig;                   // �����߶�
    MP_COORD PickPos;               // ץȡ����
    MP_COORD DropPos;               // �������
    MP_COORD ObliPos;               // б������
};

//
#define UNSTACK_INFORM_SWITCH_CODE_FINISH       5
#define UNSTACK_INFORM_SWITCH_CODE_ERROR        4
#define UNSTACK_INFORM_SWITCH_CODE_WORK         3
#define UNSTACK_INFORM_SWITCH_CODE_INITIALIZED  2

#define UNSTACK_SAVE_VARIABLE_LONG_PART_ID      60      /* D[060] �洢������� */                
#define UNSTACK_SAVE_VARIABLE_LONG_AREA_ID      61      /* D[061] �洢������ */
#define UNSTACK_SAVE_VARIABLE_LONG_MAG_PIP      62      /* D[062] �洢ץ����·ͨ�� */
#define UNSTACK_SAVE_VARIABLE_FLOAT_BOX_LENGTH  61      /* R[060] �洢�������� */
#define UNSTACK_SAVE_VARIABLE_FLOAT_BOX_WINDTH  62      /* R[061] �洢������� */
#define UNSTACK_SAVE_VARIABLE_FLOAT_BOX_HIG     63      /* R[062] �洢�����߶� */
#define UNSTACK_SAVE_VARIABLE_POS_PICK          60      /* P[060] �洢ץȡ���� */
#define UNSTACK_SAVE_VARIABLE_POS_PLACE         61      /* P[061] �洢������� */
#define UNSTACK_SAVE_VARIABLE_POS_OBLIPOS       62      /* P[062] �洢б������ */


#define UNSTACK_ALARM_SUBCODE_FAILED_CONNECT                    1
#define UNSTACK_ALARM_MESSAGE_SKILL_FAILED_CONNECT			    "����ʧ��[IP:%s, PORT:%d]"


IMPORT STATUS processReceived_sbt_unstack_data_();              /* ���ս������� */

IMPORT STATUS processCommand_sbt_unstack_open_();               /* ͨѶ���� */

IMPORT STATUS processCommand_sbt_unstack_initialize_();         /* ���Ӻ����ͨѶ������ʼ�� */

IMPORT STATUS processCommand_sbt_unstack_getData_();            /* ��ȡͨѶ���� */

IMPORT STATUS processCommand_sbt_unstack_miss_();               /* ͨѶ�������ʱ���� */

IMPORT STATUS processCommand_sbt_unstack_success_();            /* ͨѶ�������ɹ� */

IMPORT STATUS processCommand_sbt_unstack_area_();               /* ͨѶ���������뿪���� */

IMPORT STATUS processCommand_sbt_unstack_reach_();              /* ͨѶ�������������Ϣ�ɴ� */

IMPORT STATUS processCommand_sbt_unstack_unreach_();            /* ͨѶ�������������Ϣ���ɴ� */

#endif /* __SBT_UNSTACK_H__ */