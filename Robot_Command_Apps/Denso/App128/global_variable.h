'!TITLE "global_variable.h"

'!***********************************************************
'!
'! Copyright 2018 - 2025 speedbot All Rights reserved.
'!
'! File Name: global_variable.h
'!
'! Description:
'!   Language             ==   PacScipt for DENSO ROBOT
'!   Date                 ==   2025 - 02 - 24
'!   Modification Data    ==   2025 - 02 - 24
'!
'! Author: speedbot
'!
'! Version: 1.0
'!*********************************************************************************************************;

#ifndef __GLOBAL_VARIABLE_H__
#Define __GLOBAL_VARIABLE_H__

'! 指定通讯通道
'! 在 设定 - 通信与启动权 - 数据通信 - 以太网 线路编号8-15
#define COMM128_STATE_COMM_ID       8
#define COMM128_MOTION_COMM_ID      9

'! 不要修改这个定义 !!!
#define TYPE_DENSO      5

#if __SCARA_ROBOT__ =  1

    '! SCARA机器人
    #define NUM_OF_ROBOT_AXIS       4

#else

    #define NUM_OF_ROBOT_AXIS       6

#endif

'! 此版本不使用
#define NUM_OF_ROT_AXIS         0

'! 存储运动点编号的整形全局寄存器编号
#Define VARIABLE_I_MOVE_ID      21

'! 存储停止运动的整形全局寄存器编号
#Define VARIABLE_I_STOP_ID      22

'! 指定最大缓存点数量
#define MAX_TRAJ_LENGTH     1024

'! 指定输出映射地址, 每个地址定义8位, [-1 : 不映射]
#define OUTPUT_INDEX01         -1
#define OUTPUT_INDEX02         -1
#define OUTPUT_INDEX03         -1
#define OUTPUT_INDEX04         -1
#define OUTPUT_INDEX05         -1
#define OUTPUT_INDEX06         -1
#define OUTPUT_INDEX07         -1
#define OUTPUT_INDEX08         -1

'! 指定输入映射地址, 每个地址定义8位, [-1 : 不映射]
#define INPUT_INDEX01           -1
#define INPUT_INDEX02           -1
#define INPUT_INDEX03           -1
#define INPUT_INDEX04           -1
#define INPUT_INDEX05           -1
#define INPUT_INDEX06           -1
#define INPUT_INDEX07           -1
#define INPUT_INDEX08           -1



#Endif '!__GLOBAL_VARIABLE_H__
