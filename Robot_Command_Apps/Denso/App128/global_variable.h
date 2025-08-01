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

'! ָ��ͨѶͨ��
'! �� �趨 - ͨ��������Ȩ - ����ͨ�� - ��̫�� ��·���8-15
#define COMM128_STATE_COMM_ID       8
#define COMM128_MOTION_COMM_ID      9

'! ��Ҫ�޸�������� !!!
#define TYPE_DENSO      5

#if __SCARA_ROBOT__ =  1

    '! SCARA������
    #define NUM_OF_ROBOT_AXIS       4

#else

    #define NUM_OF_ROBOT_AXIS       6

#endif

'! �˰汾��ʹ��
#define NUM_OF_ROT_AXIS         0

'! �洢�˶����ŵ�����ȫ�ּĴ������
#Define VARIABLE_I_MOVE_ID      21

'! �洢ֹͣ�˶�������ȫ�ּĴ������
#Define VARIABLE_I_STOP_ID      22

'! ָ����󻺴������
#define MAX_TRAJ_LENGTH     1024

'! ָ�����ӳ���ַ, ÿ����ַ����8λ, [-1 : ��ӳ��]
#define OUTPUT_INDEX01         -1
#define OUTPUT_INDEX02         -1
#define OUTPUT_INDEX03         -1
#define OUTPUT_INDEX04         -1
#define OUTPUT_INDEX05         -1
#define OUTPUT_INDEX06         -1
#define OUTPUT_INDEX07         -1
#define OUTPUT_INDEX08         -1

'! ָ������ӳ���ַ, ÿ����ַ����8λ, [-1 : ��ӳ��]
#define INPUT_INDEX01           -1
#define INPUT_INDEX02           -1
#define INPUT_INDEX03           -1
#define INPUT_INDEX04           -1
#define INPUT_INDEX05           -1
#define INPUT_INDEX06           -1
#define INPUT_INDEX07           -1
#define INPUT_INDEX08           -1



#Endif '!__GLOBAL_VARIABLE_H__
