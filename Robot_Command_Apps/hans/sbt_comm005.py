# -*- coding: utf-8 -*-
#
#***********************************************************
#
# Copyright 2018 - 2025 speedbot All Rights reserved.
#
# file Name: sbt_comm005
#
# Description:
#   Language             ==   python Script for HANS ROBOT
#   Date                 ==   2023 - 04 - 07
#   Modification Data    ==   2025 - 04 - 07
#
# Author: speedbot
#
# Version: 1.1
#*********************************************************************************************************
from lib_motion import RobMotion
from lib_mbbusio import MBBusComm
from lib_mbbuscmd import MBBusCmd
from lib_mbbuscmd import BUSCMD_RW
from lib_mbbuscmd import BUSCMD_MS
from lib_tp_if import RobotInterface
from lib_logs import Logs
from lib_helper import Helper
import inspect

MBBusComm = MBBusComm(0, 100)
MBBusCmd = MBBusCmd(MBBusComm)

BusTimeout = 5

ErrorMessages = {
    1 : ("001 VIN code read failed!", "warn"),
    2 : ("002 Failed to capture photo!", "warn")
}

def parse_param_(parsed : any):
    """
    根据 parsed 的值，动态地从全局变量或直接返回值。
    
    参数:
        parsed: 输入值，可以是字符串（表示全局变量名）或其他类型。
    
    返回:
        全局变量的值（如果 parsed 是字符串且存在于 globals() 中），否则直接返回 parsed。
    """
    try:
        # 如果是字符串类型，尝试从全局变量中获取值
        if isinstance(parsed, str):
            if parsed in globals():
                return globals()[parsed]
            else:
                Logs.error_write_(f"Global variable '{parsed}' is not defined!")
                return None  # 或者抛出异常，视需求而定
        else:
            # 如果不是字符串类型，直接返回值
            return parsed
    except Exception as e:
        return None 

def ErrorDisplay():
    if (not MBBusComm.BusIn['SysReady']):
        Logs.logs_error_(f"{901} Software not ready!")
        return
    if (MBBusComm.BusIn['TellId'] != MBBusComm.BusOut['RobTellId']):
        Logs.logs_error_(f"{902} Software processing timeout!")
        return
    
    Message, Leavel = ErrorMessages.get(MBBusComm.BusIn['ErrorId'], ("Unknown error code", "error"))
    if (Leavel == "warn"):
        Logs.logs_warn_(f"{Message}[ErrorCode:{MBBusComm.BusIn['ErrorId']}]")
    elif (Leavel == "error"):
        Logs.logs_error_(f"{Message}[ErrorCode:{MBBusComm.BusIn['ErrorId']}]")
    elif (Leavel == "stop"):
        Logs.error_write_(f"{Message}[ErrorCode:{MBBusComm.BusIn['ErrorId']}]")

# 定义功能函数
def SbtComm005Initialize(Param : list):
    MBBusComm.mbbus_init_(0, MBBusComm.PTC_GEN_CMD)
    Data =[]
    for i in range(1, 19):  # 从索引 1 到 18（包括 18）
        Data.append(parse_param_(Param[i]) or 0)    
    Status = MBBusCmd.mbbus_cmd137_(BUSCMD_RW.BUSCMD_WRITE, BUSCMD_MS.BUSCMD_MST, Data)
    Status = MBBusCmd.mbbus_cmd001_(BUSCMD_RW.BUSCMD_READ, BUSCMD_MS.BUSCMD_MST, 5)
    if (Status == Logs.OK):
        pass
    else:
        ErrorDisplay()

def SbtComm005Picture(Param : list):
    PictureId = parse_param_(Param[1])
    if PictureId is None:
        Logs.error_write_(f"PictureId is None!")
    MBBusComm.BusOut['RobotId'] = PictureId
    CurPos = RobMotion.cur_pos_()
    Status = MBBusCmd.mbbus_cmd009_(BUSCMD_RW.BUSCMD_WRITE, BUSCMD_MS.BUSCMD_MST, CurPos)
    Status = MBBusCmd.mbbus_cmd001_(BUSCMD_RW.BUSCMD_READ, BUSCMD_MS.BUSCMD_MST, BusTimeout)
    if (Status == Logs.OK):
        pass
    else:
        ErrorDisplay()
def SbtComm005Result(Param : list):
    CommType01 = {'Byte01' : 0, 'Byte02' : 0, 'Short03' : 0, 'Short04' : 0, 'Int05' : 0, 'Int06' : 0, 'Float07' : 0.0, 'Float08' : 0.0}
    Status = MBBusCmd.mbbus_cmd012_(BUSCMD_RW.BUSCMD_WRITE, BUSCMD_MS.BUSCMD_MST, CommType01)
    Status = MBBusCmd.mbbus_cmd001_(BUSCMD_RW.BUSCMD_READ, BUSCMD_MS.BUSCMD_MST, BusTimeout)
    if (Status == Logs.OK):
        pass
    else:
        ErrorDisplay()

def SbtComm005Unknown(Param : list):
    Logs.error_write_(f"Command Skill Error![Command:{Param[0]}]")

# 定义命令字符对应的功能函数名称
CommandHandlers = {
    "Comm005Initialize": SbtComm005Initialize,
    "Comm005Picture": SbtComm005Picture,
    "Comm005Result": SbtComm005Result,
}

# 定义主任务
def SbtComm005Main(Param : list):
    # 获取对应处理函数，如果不存在则使用默认处理函数
    Handler = CommandHandlers.get(Param[0], SbtComm005Unknown)
    Handler(Param)

# =========================================== main program =============================================

# 检查 'SpeedbotCommSkill' 是否在全局变量中定义
if 'SpeedbotCommSkill' in globals():
    pass
else:
    Logs.error_write_(f"globals variable 'SpeedbotCommSkill' is not defined!")

# 取出字符串中描述的功能码和参数
ParsedList = Helper.parse_command_(SpeedbotCommSkill)
SbtComm005Main(ParsedList)

