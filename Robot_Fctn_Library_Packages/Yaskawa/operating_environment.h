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

// 库文件专用错误代码
// 示教器出现此报错代码，说明是库程序报错
#define LIB_ERROR_CODE                              8500

// 日志输出开关
// 可用电脑链接机器人后，用 CMD 输入 -> telnet 机器人 ip， 用户名 MOTOMANrobot 密码 MOTOMANrobot
// 若电脑没有 telnet 功能，进入Windows 控制面板 - 应用与功能 - 程序和功能 - 启用或关闭 Windows 功能 - 开启 Telnet Client
// 即可调试 printf
#define DEBUG_PRINT								                  OFF

// 兼容机器人控制柜版本 DX100 DX200 DN200 YRC1000，防止不同柜子之间不兼容问题导致的编译不通过
#define CONTROL_VER                                 YRC1000

// 函数返回成功或者失败定义
#define OK                                          0
#define SUCCESS                                     1
#define ERROR                                       (-1)

// 简化程序的一个通用宏
#define CHECK_RESULT(status) \
do { \
    if (status == OK) { \
        /* 状态为 OK 时的操作 */ \
    } else { \
        return (status); \
    } \
} while (0)

// 打印 INFO 宏
#define DEBUG_INFO(MsgFormat, ...) \
do \
{  \
    if (DEBUG_PRINT == ON) \
	{ \
        printf("[DEBUG_INFO] : " MsgFormat " [File:%s, Line:%d]\n\n", ##__VA_ARGS__, get_filename(__FILE__), __LINE__); \
    } \
} while (0)

// 打印 WARN 宏
#define DEBUG_WARN(MsgFormat, ...) \
do \
{  \
   printf("[DEBUG_WARN] : " MsgFormat " [File:%s, Line:%d]\n\n", ##__VA_ARGS__, get_filename(__FILE__), __LINE__); \
} while (0)

// 打印 ERROR 宏
#define DEBUG_ERROR(MsgFormat, ...) \
do \
{  \
	printf("[DEBUG_ERROR]: " MsgFormat " [File:%s, Line:%d]\n\n", ##__VA_ARGS__, get_filename(__FILE__), __LINE__); \
} while (0)
#endif
