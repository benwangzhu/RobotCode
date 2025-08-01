/***********************************************************

Copyright 2018 - 2023 speedbot All Rights reserved.

 file Name: lib_tp_if.h

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
#ifndef __OPERATING_ENVIRONMENT_H__
#define __OPERATING_ENVIRONMENT_H__

#include <stdio.h>

extern const char *get_filename(const char *path);

#define IN
#define OUT
#define INOUT

#define DX200           2
#define YRC1000         4

// ���ļ�ר�ô������
// ʾ�������ִ˱�����룬˵���ǿ���򱨴�
#define LIB_ERROR_CODE                              8500

// ��־�������
// ���õ������ӻ����˺��� CMD ���� -> telnet ������ ip�� �û��� MOTOMANrobot ���� MOTOMANrobot
// ������û�� telnet ���ܣ�����Windows ������� - Ӧ���빦�� - ����͹��� - ���û�ر� Windows ���� - ���� Telnet Client
// ���ɵ��� printf
#define DEBUG_PRINT								                  OFF

// ���ݻ����˿��ƹ�汾 DX100 DX200 DN200 YRC1000����ֹ��ͬ����֮�䲻�������⵼�µı��벻ͨ��
#define CONTROL_VER                                 YRC1000

// �������سɹ�����ʧ�ܶ���
#define OK                                          0
#define SUCCESS                                     1
#define ERROR                                       (-1)

// �򻯳����һ��ͨ�ú�
#define CHECK_RESULT(status) \
do { \
    if (status == OK) { \
        /* ״̬Ϊ OK ʱ�Ĳ��� */ \
    } else { \
        return (status); \
    } \
} while (0)

// ��ӡ INFO ��
#define DEBUG_INFO(MsgFormat, ...) \
do \
{  \
    if (DEBUG_PRINT == ON) \
	{ \
        printf("[DEBUG_INFO] : " MsgFormat " [File:%s, Line:%d]\n\n", ##__VA_ARGS__, get_filename(__FILE__), __LINE__); \
    } \
} while (0)

// ��ӡ WARN ��
#define DEBUG_WARN(MsgFormat, ...) \
do \
{  \
   printf("[DEBUG_WARN] : " MsgFormat " [File:%s, Line:%d]\n\n", ##__VA_ARGS__, get_filename(__FILE__), __LINE__); \
} while (0)

// ��ӡ ERROR ��
#define DEBUG_ERROR(MsgFormat, ...) \
do \
{  \
	printf("[DEBUG_ERROR]: " MsgFormat " [File:%s, Line:%d]\n\n", ##__VA_ARGS__, get_filename(__FILE__), __LINE__); \
} while (0)
#endif
