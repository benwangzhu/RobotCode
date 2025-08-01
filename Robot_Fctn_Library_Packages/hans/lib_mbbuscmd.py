# -*- coding: utf-8 -*-
#
#***********************************************************
#
# Copyright 2018 - 2025 speedbot All Rights reserved.
#
# file Name: lib_mbbuscmd
#
# Description:
#   Language             ==   python Script for HANS ROBOT
#   Date                 ==   2023 - 03 - 31
#   Modification Data    ==   2025 - 03 - 31
#
# Author: speedbot
#
# Version: 1.1
#*********************************************************************************************************
import time         #??time?  
from CCClient import CCClient
from enum import Enum
from lib_mbbusio import MBBusComm
from lib_mbbusio import HIGHLOW
from lib_logs import Logs

class BUSCMD_RW(Enum):
    BUSCMD_WRITE = 1
    BUSCMD_READ = 2


class BUSCMD_MS(Enum):
    BUSCMD_MST = -1
    BUSCMD_SLE = -2


class MBBusCmd(object):

    RobClient           = CCClient()

    def __init__(self, MBBusComm : MBBusComm):
        self.MBBusComm = MBBusComm               
        self.Status = Logs.OK
        # self.MBBusComm.mbbus_init_(0, self.MBBusComm.PTC_GEN_CMD)
    @staticmethod
    def _mbbuscmd_wo__(MBBusComm : MBBusComm, BusCmdId : int, BusMstSel : BUSCMD_MS):
        if (BusMstSel == BUSCMD_MS.BUSCMD_MST):
            MBBusComm.BusOut['RobMsgType'] = BusCmdId
            MBBusComm.mbbus_stell_()
        else:
            MBBusComm.BusOut['MsgType'] = BusCmdId
            MBBusComm.mbbus_ftell_()
        return Logs.OK
    @staticmethod
    def _mbbuscmd_ro__(MBBusComm : MBBusComm, BusCmdId : int, BusMstSel : BUSCMD_MS, BusTimeout : float = -1.0):
        if (BusMstSel == BUSCMD_MS.BUSCMD_MST):
            MBBusComm.BusTimeout = BusTimeout
            Status = MBBusComm.mbbus_rtell_()
            MBBusComm.mbbus_sbyte_((MBBusComm.BusOutputAddr + 3), MBBusComm.BusOut['RobMsgType'], HIGHLOW.HIGH)   
            if (Status != Logs.OK):
                return Status
            if (MBBusComm.BusIn['MsgType'] != BusCmdId):
                return Logs.ERROR
        else:
            MBBusComm.BusTimeout = BusTimeout
            Status = MBBusComm.mbbus_wtell_()
            if (Status != Logs.OK):
                return Status
            if (MBBusComm.BusIn['AgentMsgType'] != BusCmdId):
                return Logs.ERROR

        return Status
    def mbbus_cmd001_(self, BusOperation : BUSCMD_RW, BusMstSel : BUSCMD_MS, BusTimeout : float = -1.0):
        if (BusOperation == BUSCMD_RW.BUSCMD_WRITE):
            return(MBBusCmd._mbbuscmd_wo__(self.MBBusComm, 1, BusMstSel))
        else:
            return(MBBusCmd._mbbuscmd_ro__(self.MBBusComm, 1, BusMstSel, BusTimeout))

    def mbbus_cmd002_(self, BusOperation : BUSCMD_RW, BusMstSel : BUSCMD_MS, BusData : dict, BusTimeout : float = -1.0):
        if (BusOperation == BUSCMD_RW.BUSCMD_WRITE):
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 4, BusData['Byte01'], HIGHLOW.LOW)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 4, BusData['Byte02'],HIGHLOW.HIGH)
            self.MBBusComm.mbbus_ssint_(self.MBBusComm.BusOutputAddr + 5, BusData['Short03'])
            self.MBBusComm.mbbus_ssint_(self.MBBusComm.BusOutputAddr + 6, BusData['Short04'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 7, BusData['Int05'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 9, BusData['Int06'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 11, BusData['Float07'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 13, BusData['Float08'])

            self.RobClient.sendVarValue('WriteCmdType01', BusData)
            
            return(MBBusCmd._mbbuscmd_wo__(self.MBBusComm, 2, BusMstSel))
        else:
            BusData = {'Byte01' : 0, 'Byte02' : 0, 'Short03' : 0, 'Short04' : 0, 'Int05' : 0, 'Int06' : 0, 'Float07' : 0.0, 'Float08' : 0.0}
            if (MBBusCmd._mbbuscmd_ro__(self.MBBusComm, 2, BusMstSel, BusTimeout) == Logs.OK):
                BusData['Byte01'] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 4, HIGHLOW.LOW)
                BusData['Byte02'] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 4, HIGHLOW.HIGH)
                BusData['Short03'] = self.MBBusComm.mbbus_gsint_(self.MBBusComm.BusInputAddr + 5)
                BusData['Short04'] = self.MBBusComm.mbbus_gsint_(self.MBBusComm.BusInputAddr + 6)
                BusData['Int05'] = self.MBBusComm.mbbus_gint_(self.MBBusComm.BusInputAddr + 7)
                BusData['Int06'] = self.MBBusComm.mbbus_gint_(self.MBBusComm.BusInputAddr + 9)
                BusData['Float07'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 11)
                BusData['Float08'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 13)

                self.RobClient.sendVarValue('ReadCmdType01', BusData)

                return(Logs.OK)
            return(Logs.ERROR)

    def mbbus_cmd003_(self, BusOperation : BUSCMD_RW, BusMstSel : BUSCMD_MS, BusData : dict, BusTimeout : float = -1.0):
        if (BusOperation == BUSCMD_RW.BUSCMD_WRITE):
            self.MBBusComm.mbbus_scart_(self.MBBusComm.BusOutputAddr + 4, BusData)
            self.RobClient.sendVarValue('WriteCartPos', BusData)
            return(MBBusCmd._mbbuscmd_wo__(self.MBBusComm, 3, BusMstSel))
        else:
            BusData = {'x' : 0, 'y' : 0, 'z' : 0, 'rx' : 0, 'ry' : 0, 'rz' : 0}
            if (MBBusCmd._mbbuscmd_ro__(self.MBBusComm, 3, BusMstSel, BusTimeout) == Logs.OK):
                BusData = self.MBBusComm.mbbus_gcart_(self.MBBusComm.BusInputAddr + 4)
                self.RobClient.sendVarValue('ReadCartPos', BusData)
                return(Logs.OK)
            return(Logs.ERROR)

    def mbbus_cmd009_(self, BusOperation : BUSCMD_RW, BusMstSel : BUSCMD_MS, BusData : dict, BusTimeout : float = -1.0):
        if (BusOperation == BUSCMD_RW.BUSCMD_WRITE):
            self.MBBusComm.mbbus_scart_(self.MBBusComm.BusOutputAddr + 4, BusData)
            self.RobClient.sendVarValue('WriteCartPos', BusData)
            return(MBBusCmd._mbbuscmd_wo__(self.MBBusComm, 9, BusMstSel))
        else:
            BusData = {'x' : 0, 'y' : 0, 'z' : 0, 'rx' : 0, 'ry' : 0, 'rz' : 0}
            if (MBBusCmd._mbbuscmd_ro__(self.MBBusComm, 9, BusMstSel, BusTimeout) == Logs.OK):
                BusData = self.MBBusComm.mbbus_gcart_(self.MBBusComm.BusInputAddr + 4)
                self.RobClient.sendVarValue('ReadCartPos', BusData)
                return(Logs.OK)
            return(Logs.ERROR)

    def mbbus_cmd010_(self, BusOperation : BUSCMD_RW, BusMstSel : BUSCMD_MS, BusData : dict, BusTimeout : float = -1.0):
        if (BusOperation == BUSCMD_RW.BUSCMD_WRITE):
            self.MBBusComm.mbbus_scart_(self.MBBusComm.BusOutputAddr + 4, BusData)
            self.RobClient.sendVarValue('WriteCartPos', BusData)
            return(MBBusCmd._mbbuscmd_wo__(self.MBBusComm, 10, BusMstSel))
        else:
            BusData = {'x' : 0, 'y' : 0, 'z' : 0, 'rx' : 0, 'ry' : 0, 'rz' : 0}
            if (MBBusCmd._mbbuscmd_ro__(self.MBBusComm, 10, BusMstSel, BusTimeout) == Logs.OK):
                BusData = self.MBBusComm.mbbus_gcart_(self.MBBusComm.BusInputAddr + 4)
                self.RobClient.sendVarValue('ReadCartPos', BusData)
                return(Logs.OK)
            return(Logs.ERROR)
        
    def mbbus_cmd011_(self, BusOperation : BUSCMD_RW, BusMstSel : BUSCMD_MS, BusData : dict, BusTimeout : float = -1.0):
        if (BusOperation == BUSCMD_RW.BUSCMD_WRITE):
            self.MBBusComm.mbbus_scart_(self.MBBusComm.BusOutputAddr + 4, BusData)
            self.RobClient.sendVarValue('WriteCartPos', BusData)
            return(MBBusCmd._mbbuscmd_wo__(self.MBBusComm, 11, BusMstSel))
        else:
            BusData = {'x' : 0, 'y' : 0, 'z' : 0, 'rx' : 0, 'ry' : 0, 'rz' : 0}
            if (MBBusCmd._mbbuscmd_ro__(self.MBBusComm, 11, BusMstSel, BusTimeout) == Logs.OK):
                BusData = self.MBBusComm.mbbus_gcart_(self.MBBusComm.BusInputAddr + 4)
                self.RobClient.sendVarValue('ReadCartPos', BusData)
                return(Logs.OK)
            return(Logs.ERROR)

    def mbbus_cmd012_(self, BusOperation : BUSCMD_RW, BusMstSel : BUSCMD_MS, BusData : dict, BusTimeout : float = -1.0):
        if (BusOperation == BUSCMD_RW.BUSCMD_WRITE):
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 4, BusData['Byte01'], HIGHLOW.LOW)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 4, BusData['Byte02'],HIGHLOW.HIGH)
            self.MBBusComm.mbbus_ssint_(self.MBBusComm.BusOutputAddr + 5, BusData['Short03'])
            self.MBBusComm.mbbus_ssint_(self.MBBusComm.BusOutputAddr + 6, BusData['Short04'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 7, BusData['Int05'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 9, BusData['Int06'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 11, BusData['Float07'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 13, BusData['Float08'])

            self.RobClient.sendVarValue('WriteCmdType01', BusData)
            
            return(MBBusCmd._mbbuscmd_wo__(self.MBBusComm, 12, BusMstSel))
        else:
            BusData = {'Byte01' : 0, 'Byte02' : 0, 'Short03' : 0, 'Short04' : 0, 'Int05' : 0, 'Int06' : 0, 'Float07' : 0.0, 'Float08' : 0.0}
            if (MBBusCmd._mbbuscmd_ro__(self.MBBusComm, 12, BusMstSel, BusTimeout) == Logs.OK):
                BusData['Byte01'] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 4, HIGHLOW.LOW)
                BusData['Byte02'] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 4, HIGHLOW.HIGH)
                BusData['Short03'] = self.MBBusComm.mbbus_gsint_(self.MBBusComm.BusInputAddr + 5)
                BusData['Short04'] = self.MBBusComm.mbbus_gsint_(self.MBBusComm.BusInputAddr + 6)
                BusData['Int05'] = self.MBBusComm.mbbus_gint_(self.MBBusComm.BusInputAddr + 7)
                BusData['Int06'] = self.MBBusComm.mbbus_gint_(self.MBBusComm.BusInputAddr + 9)
                BusData['Float07'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 11)
                BusData['Float08'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 13)

                self.RobClient.sendVarValue('ReadCmdType01', BusData)

                return(Logs.OK)
            return(Logs.ERROR)

    def mbbus_cmd013_(self, BusOperation : BUSCMD_RW, BusMstSel : BUSCMD_MS, BusData : dict, BusTimeout : float = -1.0):
        if (BusOperation == BUSCMD_RW.BUSCMD_WRITE):
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 4, BusData['Byte01'], HIGHLOW.LOW)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 4, BusData['Byte02'],HIGHLOW.HIGH)
            self.MBBusComm.mbbus_ssint_(self.MBBusComm.BusOutputAddr + 5, BusData['Short03'])
            self.MBBusComm.mbbus_ssint_(self.MBBusComm.BusOutputAddr + 6, BusData['Short04'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 7, BusData['Int05'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 9, BusData['Int06'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 11, BusData['Float07'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 13, BusData['Float08'])

            self.RobClient.sendVarValue('WriteCmdType01', BusData)
            
            return(MBBusCmd._mbbuscmd_wo__(self.MBBusComm, 13, BusMstSel))
        else:
            BusData = {'Byte01' : 0, 'Byte02' : 0, 'Short03' : 0, 'Short04' : 0, 'Int05' : 0, 'Int06' : 0, 'Float07' : 0.0, 'Float08' : 0.0}
            if (MBBusCmd._mbbuscmd_ro__(self.MBBusComm, 13, BusMstSel, BusTimeout) == Logs.OK):
                BusData['Byte01'] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 4, HIGHLOW.LOW)
                BusData['Byte02'] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 4, HIGHLOW.HIGH)
                BusData['Short03'] = self.MBBusComm.mbbus_gsint_(self.MBBusComm.BusInputAddr + 5)
                BusData['Short04'] = self.MBBusComm.mbbus_gsint_(self.MBBusComm.BusInputAddr + 6)
                BusData['Int05'] = self.MBBusComm.mbbus_gint_(self.MBBusComm.BusInputAddr + 7)
                BusData['Int06'] = self.MBBusComm.mbbus_gint_(self.MBBusComm.BusInputAddr + 9)
                BusData['Float07'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 11)
                BusData['Float08'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 13)

                self.RobClient.sendVarValue('ReadCmdType01', BusData)

                return(Logs.OK)
            return(Logs.ERROR)

    def mbbus_cmd014_(self, BusOperation : BUSCMD_RW, BusMstSel : BUSCMD_MS, BusData : dict, BusTimeout : float = -1.0):
        if (BusOperation == BUSCMD_RW.BUSCMD_WRITE):
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 4, BusData['Byte01'], HIGHLOW.LOW)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 4, BusData['Byte02'],HIGHLOW.HIGH)
            self.MBBusComm.mbbus_ssint_(self.MBBusComm.BusOutputAddr + 5, BusData['Short03'])
            self.MBBusComm.mbbus_ssint_(self.MBBusComm.BusOutputAddr + 6, BusData['Short04'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 7, BusData['Int05'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 9, BusData['Int06'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 11, BusData['Float07'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 13, BusData['Float08'])

            self.RobClient.sendVarValue('WriteCmdType01', BusData)
            
            return(MBBusCmd._mbbuscmd_wo__(self.MBBusComm, 14, BusMstSel))
        else:
            BusData = {'Byte01' : 0, 'Byte02' : 0, 'Short03' : 0, 'Short04' : 0, 'Int05' : 0, 'Int06' : 0, 'Float07' : 0.0, 'Float08' : 0.0}
            if (MBBusCmd._mbbuscmd_ro__(self.MBBusComm, 14, BusMstSel, BusTimeout) == Logs.OK):
                BusData['Byte01'] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 4, HIGHLOW.LOW)
                BusData['Byte02'] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 4, HIGHLOW.HIGH)
                BusData['Short03'] = self.MBBusComm.mbbus_gsint_(self.MBBusComm.BusInputAddr + 5)
                BusData['Short04'] = self.MBBusComm.mbbus_gsint_(self.MBBusComm.BusInputAddr + 6)
                BusData['Int05'] = self.MBBusComm.mbbus_gint_(self.MBBusComm.BusInputAddr + 7)
                BusData['Int06'] = self.MBBusComm.mbbus_gint_(self.MBBusComm.BusInputAddr + 9)
                BusData['Float07'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 11)
                BusData['Float08'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 13)

                self.RobClient.sendVarValue('ReadCmdType01', BusData)

                return(Logs.OK)
            return(Logs.ERROR)

    def mbbus_cmd017_(self, BusOperation : BUSCMD_RW, BusMstSel : BUSCMD_MS, BusData : dict, BusTimeout : float = -1.0):
        if (BusOperation == BUSCMD_RW.BUSCMD_WRITE):
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 4, BusData['Float01'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 6, BusData['Float02'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 8, BusData['Float03'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 10, BusData['Float04'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 12, BusData['Float05'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 14, BusData['Float06'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 16, BusData['Float07'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 18, BusData['Float08'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 20, BusData['Float09'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 22, BusData['Float10'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 24, BusData['Float11'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 26, BusData['Float12'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 28, BusData['Int13'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 30, BusData['Int14'])

            self.RobClient.sendVarValue('WriteCmdType07', BusData)
            
            return(MBBusCmd._mbbuscmd_wo__(self.MBBusComm, 17, BusMstSel))
        else:
            BusData = {'Float01' : 0, 'Float02' : 0, 'Float03' : 0, 'Float04' : 0, 'Float05' : 0, 'Float06' : 0, 
                       'Float07' : 0, 'Float08' : 0, 'Float09' : 0, 'Float10' : 0, 'Float11' : 0, 'Float12' : 0, 
                       'Int13' : 0, 'Int14' : 0}
            if (MBBusCmd._mbbuscmd_ro__(self.MBBusComm, 17, BusMstSel, BusTimeout) == Logs.OK):
                BusData['Float01'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 4)
                BusData['Float02'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 6)
                BusData['Float03'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 8)
                BusData['Float04'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 10)
                BusData['Float05'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 12)
                BusData['Float06'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 14)
                BusData['Float07'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 16)
                BusData['Float08'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 18)
                BusData['Float09'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 20)
                BusData['Float10'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 22)
                BusData['Float11'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 24)
                BusData['Float12'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 26)
                BusData['Int13'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 28)
                BusData['Int14'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 30)

                self.RobClient.sendVarValue('ReadCmdType07', BusData)

                return(Logs.OK)
            return(Logs.ERROR)

    def mbbus_cmd018_(self, BusOperation : BUSCMD_RW, BusMstSel : BUSCMD_MS, BusData : dict, BusTimeout : float = -1.0):
        if (BusOperation == BUSCMD_RW.BUSCMD_WRITE):
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 4, BusData['Float01'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 6, BusData['Float02'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 8, BusData['Float03'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 10, BusData['Float04'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 12, BusData['Float05'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 14, BusData['Float06'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 16, BusData['Float07'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 18, BusData['Float08'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 20, BusData['Float09'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 22, BusData['Float10'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 24, BusData['Float11'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 26, BusData['Float12'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 28, BusData['Int13'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 30, BusData['Int14'])

            self.RobClient.sendVarValue('WriteCmdType07', BusData)
            
            return(MBBusCmd._mbbuscmd_wo__(self.MBBusComm, 18, BusMstSel))
        else:
            BusData = {'Float01' : 0, 'Float02' : 0, 'Float03' : 0, 'Float04' : 0, 'Float05' : 0, 'Float06' : 0, 
                       'Float07' : 0, 'Float08' : 0, 'Float09' : 0, 'Float10' : 0, 'Float11' : 0, 'Float12' : 0, 
                       'Int13' : 0, 'Int14' : 0}
            if (MBBusCmd._mbbuscmd_ro__(self.MBBusComm, 18, BusMstSel, BusTimeout) == Logs.OK):
                BusData['Float01'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 4)
                BusData['Float02'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 6)
                BusData['Float03'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 8)
                BusData['Float04'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 10)
                BusData['Float05'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 12)
                BusData['Float06'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 14)
                BusData['Float07'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 16)
                BusData['Float08'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 18)
                BusData['Float09'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 20)
                BusData['Float10'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 22)
                BusData['Float11'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 24)
                BusData['Float12'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 26)
                BusData['Int13'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 28)
                BusData['Int14'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 30)

                self.RobClient.sendVarValue('ReadCmdType07', BusData)

                return(Logs.OK)
            return(Logs.ERROR)

    def mbbus_cmd020_(self, BusOperation : BUSCMD_RW, BusMstSel : BUSCMD_MS, BusData : dict, BusTimeout : float = -1.0):
        if (BusOperation == BUSCMD_RW.BUSCMD_WRITE):
            self.MBBusComm.mbbus_scart_(self.MBBusComm.BusOutputAddr + 4, BusData)
            self.RobClient.sendVarValue('WriteCartPos', BusData)
            return(MBBusCmd._mbbuscmd_wo__(self.MBBusComm, 20, BusMstSel))
        else:
            BusData = {'x' : 0, 'y' : 0, 'z' : 0, 'rx' : 0, 'ry' : 0, 'rz' : 0}
            if (MBBusCmd._mbbuscmd_ro__(self.MBBusComm, 20, BusMstSel, BusTimeout) == Logs.OK):
                BusData = self.MBBusComm.mbbus_gcart_(self.MBBusComm.BusInputAddr + 4)
                self.RobClient.sendVarValue('ReadCartPos', BusData)
                return(Logs.OK)
            return(Logs.ERROR)

    def mbbus_cmd021_(self, BusOperation : BUSCMD_RW, BusMstSel : BUSCMD_MS, BusData : dict, BusTimeout : float = -1.0):
        if (BusOperation == BUSCMD_RW.BUSCMD_WRITE):
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 4, BusData['Byte01'], HIGHLOW.LOW)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 4, BusData['Byte02'],HIGHLOW.HIGH)
            self.MBBusComm.mbbus_ssint_(self.MBBusComm.BusOutputAddr + 5, BusData['Short03'])
            self.MBBusComm.mbbus_ssint_(self.MBBusComm.BusOutputAddr + 6, BusData['Short04'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 7, BusData['Int05'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 9, BusData['Int06'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 11, BusData['Float07'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 13, BusData['Float08'])

            self.RobClient.sendVarValue('WriteCmdType01', BusData)
            
            return(MBBusCmd._mbbuscmd_wo__(self.MBBusComm, 21, BusMstSel))
        else:
            BusData = {'Byte01' : 0, 'Byte02' : 0, 'Short03' : 0, 'Short04' : 0, 'Int05' : 0, 'Int06' : 0, 'Float07' : 0.0, 'Float08' : 0.0}
            if (MBBusCmd._mbbuscmd_ro__(self.MBBusComm, 21, BusMstSel, BusTimeout) == Logs.OK):
                BusData['Byte01'] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 4, HIGHLOW.LOW)
                BusData['Byte02'] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 4, HIGHLOW.HIGH)
                BusData['Short03'] = self.MBBusComm.mbbus_gsint_(self.MBBusComm.BusInputAddr + 5)
                BusData['Short04'] = self.MBBusComm.mbbus_gsint_(self.MBBusComm.BusInputAddr + 6)
                BusData['Int05'] = self.MBBusComm.mbbus_gint_(self.MBBusComm.BusInputAddr + 7)
                BusData['Int06'] = self.MBBusComm.mbbus_gint_(self.MBBusComm.BusInputAddr + 9)
                BusData['Float07'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 11)
                BusData['Float08'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 13)

                self.RobClient.sendVarValue('ReadCmdType01', BusData)

                return(Logs.OK)
            return(Logs.ERROR)

    def mbbus_cmd022_(self, BusOperation : BUSCMD_RW, BusMstSel : BUSCMD_MS, BusData : dict, BusTimeout : float = -1.0):
        if (BusOperation == BUSCMD_RW.BUSCMD_WRITE):
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 4, BusData['Byte01'], HIGHLOW.LOW)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 4, BusData['Byte02'],HIGHLOW.HIGH)
            self.MBBusComm.mbbus_ssint_(self.MBBusComm.BusOutputAddr + 5, BusData['Short03'])
            self.MBBusComm.mbbus_ssint_(self.MBBusComm.BusOutputAddr + 6, BusData['Short04'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 7, BusData['Int05'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 9, BusData['Int06'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 11, BusData['Float07'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 13, BusData['Float08'])

            self.RobClient.sendVarValue('WriteCmdType01', BusData)
            
            return(MBBusCmd._mbbuscmd_wo__(self.MBBusComm, 22, BusMstSel))
        else:
            BusData = {'Byte01' : 0, 'Byte02' : 0, 'Short03' : 0, 'Short04' : 0, 'Int05' : 0, 'Int06' : 0, 'Float07' : 0.0, 'Float08' : 0.0}
            if (MBBusCmd._mbbuscmd_ro__(self.MBBusComm, 22, BusMstSel, BusTimeout) == Logs.OK):
                BusData['Byte01'] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 4, HIGHLOW.LOW)
                BusData['Byte02'] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 4, HIGHLOW.HIGH)
                BusData['Short03'] = self.MBBusComm.mbbus_gsint_(self.MBBusComm.BusInputAddr + 5)
                BusData['Short04'] = self.MBBusComm.mbbus_gsint_(self.MBBusComm.BusInputAddr + 6)
                BusData['Int05'] = self.MBBusComm.mbbus_gint_(self.MBBusComm.BusInputAddr + 7)
                BusData['Int06'] = self.MBBusComm.mbbus_gint_(self.MBBusComm.BusInputAddr + 9)
                BusData['Float07'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 11)
                BusData['Float08'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 13)

                self.RobClient.sendVarValue('ReadCmdType01', BusData)

                return(Logs.OK)
            return(Logs.ERROR)
        
    def mbbus_cmd026_(self, BusOperation : BUSCMD_RW, BusMstSel : BUSCMD_MS, BusData : dict, BusTimeout : float = -1.0):
        if (BusOperation == BUSCMD_RW.BUSCMD_WRITE):
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 4, BusData['Byte01'], HIGHLOW.LOW)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 4, BusData['Byte02'],HIGHLOW.HIGH)
            self.MBBusComm.mbbus_ssint_(self.MBBusComm.BusOutputAddr + 5, BusData['Short03'])
            self.MBBusComm.mbbus_ssint_(self.MBBusComm.BusOutputAddr + 6, BusData['Short04'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 7, BusData['Int05'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 9, BusData['Int06'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 11, BusData['Float07'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 13, BusData['Float08'])

            self.RobClient.sendVarValue('WriteCmdType01', BusData)
            
            return(MBBusCmd._mbbuscmd_wo__(self.MBBusComm, 26, BusMstSel))
        else:
            BusData = {'Byte01' : 0, 'Byte02' : 0, 'Short03' : 0, 'Short04' : 0, 'Int05' : 0, 'Int06' : 0, 'Float07' : 0.0, 'Float08' : 0.0}
            if (MBBusCmd._mbbuscmd_ro__(self.MBBusComm, 26, BusMstSel, BusTimeout) == Logs.OK):
                BusData['Byte01'] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 4, HIGHLOW.LOW)
                BusData['Byte02'] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 4, HIGHLOW.HIGH)
                BusData['Short03'] = self.MBBusComm.mbbus_gsint_(self.MBBusComm.BusInputAddr + 5)
                BusData['Short04'] = self.MBBusComm.mbbus_gsint_(self.MBBusComm.BusInputAddr + 6)
                BusData['Int05'] = self.MBBusComm.mbbus_gint_(self.MBBusComm.BusInputAddr + 7)
                BusData['Int06'] = self.MBBusComm.mbbus_gint_(self.MBBusComm.BusInputAddr + 9)
                BusData['Float07'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 11)
                BusData['Float08'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 13)

                self.RobClient.sendVarValue('ReadCmdType01', BusData)

                return(Logs.OK)
            return(Logs.ERROR)

    def mbbus_cmd027_(self, BusOperation : BUSCMD_RW, BusMstSel : BUSCMD_MS, BusData : dict, BusTimeout : float = -1.0):
        if (BusOperation == BUSCMD_RW.BUSCMD_WRITE):
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 4, BusData['Byte01'], HIGHLOW.LOW)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 4, BusData['Byte02'],HIGHLOW.HIGH)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 5, BusData['Byte03'], HIGHLOW.LOW)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 5, BusData['Byte04'],HIGHLOW.HIGH)
            self.MBBusComm.mbbus_ssint_(self.MBBusComm.BusOutputAddr + 6, BusData['Short05'])
            self.MBBusComm.mbbus_ssint_(self.MBBusComm.BusOutputAddr + 7, BusData['Short06'])
            self.MBBusComm.mbbus_ssint_(self.MBBusComm.BusOutputAddr + 8, BusData['Short07'])
            self.MBBusComm.mbbus_ssint_(self.MBBusComm.BusOutputAddr + 9, BusData['Short08'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 10, BusData['Int09'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 12, BusData['Int10'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 14, BusData['Int11'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 16, BusData['Int12'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 18, BusData['Float13'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 20, BusData['Float14'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 22, BusData['Float15'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 24, BusData['Float16'])

            self.RobClient.sendVarValue('WriteCmdType08', BusData)
            
            return(MBBusCmd._mbbuscmd_wo__(self.MBBusComm, 27, BusMstSel))
        else:
            BusData = {'Byte01' : 0, 'Byte02' : 0, 'Byte03' : 0, 'Byte04' : 0, 
                       'Short05' : 0, 'Short06' : 0, 'Short07' : 0, 'Short08' : 0,
                       'Int09' : 0, 'Int10' : 0, 'Int11' : 0, 'Int12' : 0,
                       'Float13' : 0.0, 'Float14' : 0.0, 'Float15' : 0.0, 'Float16' : 0.0}
            if (MBBusCmd._mbbuscmd_ro__(self.MBBusComm, 27, BusMstSel, BusTimeout) == Logs.OK):
                BusData['Byte01'] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 4, HIGHLOW.LOW)
                BusData['Byte02'] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 4, HIGHLOW.HIGH)
                BusData['Byte01'] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 5, HIGHLOW.LOW)
                BusData['Byte02'] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 5, HIGHLOW.HIGH)
                BusData['Short03'] = self.MBBusComm.mbbus_gsint_(self.MBBusComm.BusInputAddr + 6)
                BusData['Short04'] = self.MBBusComm.mbbus_gsint_(self.MBBusComm.BusInputAddr + 7)
                BusData['Short03'] = self.MBBusComm.mbbus_gsint_(self.MBBusComm.BusInputAddr + 8)
                BusData['Short04'] = self.MBBusComm.mbbus_gsint_(self.MBBusComm.BusInputAddr + 9)
                BusData['Int05'] = self.MBBusComm.mbbus_gint_(self.MBBusComm.BusInputAddr + 10)
                BusData['Int06'] = self.MBBusComm.mbbus_gint_(self.MBBusComm.BusInputAddr + 12)
                BusData['Int05'] = self.MBBusComm.mbbus_gint_(self.MBBusComm.BusInputAddr + 14)
                BusData['Int06'] = self.MBBusComm.mbbus_gint_(self.MBBusComm.BusInputAddr + 16)
                BusData['Float07'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 18)
                BusData['Float08'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 20)
                BusData['Float07'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 22)
                BusData['Float08'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 24)

                self.RobClient.sendVarValue('ReadCmdType08', BusData)

                return(Logs.OK)
            return(Logs.ERROR)

    def mbbus_cmd0129_(self, BusOperation : BUSCMD_RW, BusMstSel : BUSCMD_MS, BusData : dict, BusTimeout : float = -1.0):
        if (BusOperation == BUSCMD_RW.BUSCMD_WRITE):
            self.MBBusComm.mbbus_scart_(self.MBBusComm.BusOutputAddr + 4, BusData)
            self.RobClient.sendVarValue('WriteCartPos', BusData)
            return(MBBusCmd._mbbuscmd_wo__(self.MBBusComm, 129, BusMstSel))
        else:
            BusData = {'x' : 0, 'y' : 0, 'z' : 0, 'rx' : 0, 'ry' : 0, 'rz' : 0}
            if (MBBusCmd._mbbuscmd_ro__(self.MBBusComm, 129, BusMstSel, BusTimeout) == Logs.OK):
                BusData = self.MBBusComm.mbbus_gcart_(self.MBBusComm.BusInputAddr + 4)
                self.RobClient.sendVarValue('ReadCartPos', BusData)
                return(Logs.OK)
            return(Logs.ERROR)

    def mbbus_cmd0130_(self, BusOperation : BUSCMD_RW, BusMstSel : BUSCMD_MS, BusData : dict, BusTimeout : float = -1.0):
        if (BusOperation == BUSCMD_RW.BUSCMD_WRITE):
            self.MBBusComm.mbbus_sjoint_(self.MBBusComm.BusOutputAddr + 4, BusData)
            self.RobClient.sendVarValue('WriteJointPos', BusData)
            return(MBBusCmd._mbbuscmd_wo__(self.MBBusComm, 130, BusMstSel))
        else:
            BusData = {'j1' : 0, 'j2' : 0, 'j3' : 0, 'j4' : 0, 'j5' : 0, 'j6' : 0}
            if (MBBusCmd._mbbuscmd_ro__(self.MBBusComm, 130, BusMstSel, BusTimeout) == Logs.OK):
                BusData = self.MBBusComm.mbbus_gjoint_(self.MBBusComm.BusInputAddr + 4)
                self.RobClient.sendVarValue('WriteJointPos', BusData)
                return(Logs.OK)
            return(Logs.ERROR)

    def mbbus_cmd131_(self, BusOperation : BUSCMD_RW, BusMstSel : BUSCMD_MS, BusData : list, BusTimeout : float = -1.0):
        if (BusOperation == BUSCMD_RW.BUSCMD_WRITE):
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 4, BusData[0])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 6, BusData[1])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 8, BusData[2])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 10, BusData[3])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 12, BusData[4])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 14, BusData[5])
            self.RobClient.sendVarValue('WriteCmdType02', BusData)
            
            return(MBBusCmd._mbbuscmd_wo__(self.MBBusComm, 131, BusMstSel))
        else:
            BusData = [0, 0, 0, 0, 0, 0]
            if (MBBusCmd._mbbuscmd_ro__(self.MBBusComm, 131, BusMstSel, BusTimeout) == Logs.OK):
                BusData[0] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 4)
                BusData[1] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 6)
                BusData[2] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 8)
                BusData[3] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 10)
                BusData[4] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 12)
                BusData[5] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 14)
                self.RobClient.sendVarValue('ReadCmdType02', BusData)

                return(Logs.OK)
            return(Logs.ERROR)

    def mbbus_cmd132_(self, BusOperation : BUSCMD_RW, BusMstSel : BUSCMD_MS, BusData : dict, BusTimeout : float = -1.0):
        if (BusOperation == BUSCMD_RW.BUSCMD_WRITE):
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 4, BusData['Float01'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 6, BusData['Float02'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 8, BusData['Float03'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 10, BusData['Float04'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 12, BusData['Float05'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 14, BusData['Float06'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 16, BusData['Float07'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 18, BusData['Float08'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 20, BusData['Float09'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 22, BusData['Float10'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 24, BusData['Float11'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 26, BusData['Float12'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 28, BusData['Int13'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 30, BusData['Int14'])

            self.RobClient.sendVarValue('WriteCmdType07', BusData)
            
            return(MBBusCmd._mbbuscmd_wo__(self.MBBusComm, 132, BusMstSel))
        else:
            BusData = {'Float01' : 0, 'Float02' : 0, 'Float03' : 0, 'Float04' : 0, 'Float05' : 0, 'Float06' : 0, 
                       'Float07' : 0, 'Float08' : 0, 'Float09' : 0, 'Float10' : 0, 'Float11' : 0, 'Float12' : 0, 
                       'Int13' : 0, 'Int14' : 0}
            if (MBBusCmd._mbbuscmd_ro__(self.MBBusComm, 132, BusMstSel, BusTimeout) == Logs.OK):
                BusData['Float01'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 4)
                BusData['Float02'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 6)
                BusData['Float03'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 8)
                BusData['Float04'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 10)
                BusData['Float05'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 12)
                BusData['Float06'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 14)
                BusData['Float07'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 16)
                BusData['Float08'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 18)
                BusData['Float09'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 20)
                BusData['Float10'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 22)
                BusData['Float11'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 24)
                BusData['Float12'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 26)
                BusData['Int13'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 28)
                BusData['Int14'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 30)

                self.RobClient.sendVarValue('ReadCmdType07', BusData)

                return(Logs.OK)
            return(Logs.ERROR)

    def mbbus_cmd133_(self, BusOperation : BUSCMD_RW, BusMstSel : BUSCMD_MS, BusData : dict, BusTimeout : float = -1.0):
        if (BusOperation == BUSCMD_RW.BUSCMD_WRITE):
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 4, BusData['Float01'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 6, BusData['Float02'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 8, BusData['Float03'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 10, BusData['Float04'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 12, BusData['Float05'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 14, BusData['Float06'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 16, BusData['Float07'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 18, BusData['Float08'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 20, BusData['Float09'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 22, BusData['Float10'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 24, BusData['Float11'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 26, BusData['Float12'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 28, BusData['Int13'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 30, BusData['Int14'])

            self.RobClient.sendVarValue('WriteCmdType07', BusData)
            
            return(MBBusCmd._mbbuscmd_wo__(self.MBBusComm, 133, BusMstSel))
        else:
            BusData = {'Float01' : 0, 'Float02' : 0, 'Float03' : 0, 'Float04' : 0, 'Float05' : 0, 'Float06' : 0, 
                       'Float07' : 0, 'Float08' : 0, 'Float09' : 0, 'Float10' : 0, 'Float11' : 0, 'Float12' : 0, 
                       'Int13' : 0, 'Int14' : 0}
            if (MBBusCmd._mbbuscmd_ro__(self.MBBusComm, 133, BusMstSel, BusTimeout) == Logs.OK):
                BusData['Float01'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 4)
                BusData['Float02'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 6)
                BusData['Float03'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 8)
                BusData['Float04'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 10)
                BusData['Float05'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 12)
                BusData['Float06'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 14)
                BusData['Float07'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 16)
                BusData['Float08'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 18)
                BusData['Float09'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 20)
                BusData['Float10'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 22)
                BusData['Float11'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 24)
                BusData['Float12'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 26)
                BusData['Int13'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 28)
                BusData['Int14'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 30)

                self.RobClient.sendVarValue('ReadCmdType07', BusData)

                return(Logs.OK)
            return(Logs.ERROR)

    def mbbus_cmd134_(self, BusOperation : BUSCMD_RW, BusMstSel : BUSCMD_MS, BusData : dict, BusTimeout : float = -1.0):
        if (BusOperation == BUSCMD_RW.BUSCMD_WRITE):
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 4, BusData['Int01'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 6, BusData['Int02'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 8, BusData['Float03'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 10, BusData['Float04'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 12, BusData['Float05'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 14, BusData['Float06'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 16, BusData['Float07'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 18, BusData['Float08'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 20, BusData['Float09'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 22, BusData['Float10'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 24, BusData['Float11'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 26, BusData['Float12'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 28, BusData['Float13'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 30, BusData['Float14'])

            self.RobClient.sendVarValue('WriteCmdType09', BusData)
            
            return(MBBusCmd._mbbuscmd_wo__(self.MBBusComm, 134, BusMstSel))
        else:
            BusData = {'Int01' : 0, 'Int02' : 0, 'Float03' : 0, 'Float04' : 0, 'Float05' : 0, 'Float06' : 0, 
                       'Float07' : 0, 'Float08' : 0, 'Float09' : 0, 'Float10' : 0, 'Float11' : 0, 'Float12' : 0, 
                       'Float13' : 0, 'Float14' : 0}
            if (MBBusCmd._mbbuscmd_ro__(self.MBBusComm, 134, BusMstSel, BusTimeout) == Logs.OK):
                BusData['Int01'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 4)
                BusData['Int02'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 6)
                BusData['Float03'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 8)
                BusData['Float04'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 10)
                BusData['Float05'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 12)
                BusData['Float06'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 14)
                BusData['Float07'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 16)
                BusData['Float08'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 18)
                BusData['Float09'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 20)
                BusData['Float10'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 22)
                BusData['Float11'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 24)
                BusData['Float12'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 26)
                BusData['Float13'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 28)
                BusData['Float14'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 30)

                self.RobClient.sendVarValue('ReadCmdType09', BusData)

                return(Logs.OK)
            return(Logs.ERROR)

    def mbbus_cmd137_(self, BusOperation : BUSCMD_RW, BusMstSel : BUSCMD_MS, BusData : list, BusTimeout : float = -1.0):
        if (BusOperation == BUSCMD_RW.BUSCMD_WRITE):

            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 4, BusData[0], HIGHLOW.LOW)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 4, BusData[1],HIGHLOW.HIGH)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 5, BusData[2], HIGHLOW.LOW)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 5, BusData[3],HIGHLOW.HIGH)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 6, BusData[4], HIGHLOW.LOW)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 6, BusData[5],HIGHLOW.HIGH)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 7, BusData[6], HIGHLOW.LOW)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 7, BusData[7],HIGHLOW.HIGH)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 8, BusData[8], HIGHLOW.LOW)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 8, BusData[9],HIGHLOW.HIGH)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 9, BusData[10], HIGHLOW.LOW)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 9, BusData[11],HIGHLOW.HIGH)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 10, BusData[12], HIGHLOW.LOW)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 10, BusData[13],HIGHLOW.HIGH)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 11, BusData[14], HIGHLOW.LOW)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 11, BusData[15],HIGHLOW.HIGH)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 12, BusData[16], HIGHLOW.LOW)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 12, BusData[17],HIGHLOW.HIGH)
            
            return(MBBusCmd._mbbuscmd_wo__(self.MBBusComm, 137, BusMstSel))
        else:
            BusData =[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            if (MBBusCmd._mbbuscmd_ro__(self.MBBusComm, 137, BusMstSel, BusTimeout) == Logs.OK):

                BusData[0] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 4, HIGHLOW.LOW)
                BusData[1] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 4, HIGHLOW.HIGH)
                BusData[2] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 5, HIGHLOW.LOW)
                BusData[3] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 5, HIGHLOW.HIGH)
                BusData[4] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 6, HIGHLOW.LOW)
                BusData[5] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 6, HIGHLOW.HIGH)
                BusData[6] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 7, HIGHLOW.LOW)
                BusData[7] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 7, HIGHLOW.HIGH)
                BusData[8] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 8, HIGHLOW.LOW)
                BusData[9] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 8, HIGHLOW.HIGH)
                BusData[10] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 9, HIGHLOW.LOW)
                BusData[11] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 9, HIGHLOW.HIGH)
                BusData[12] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 10, HIGHLOW.LOW)
                BusData[13] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 10, HIGHLOW.HIGH)
                BusData[14] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 11, HIGHLOW.LOW)
                BusData[15] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 11, HIGHLOW.HIGH)
                BusData[16] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 12, HIGHLOW.LOW)
                BusData[17] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 12, HIGHLOW.HIGH)

                self.RobClient.sendVarValue('ReadCmdType03', BusData)

                return(Logs.OK)
            return(Logs.ERROR)

    def mbbus_cmd145_(self, BusOperation : BUSCMD_RW, BusMstSel : BUSCMD_MS, BusData : dict, BusTimeout : float = -1.0):
        if (BusOperation == BUSCMD_RW.BUSCMD_WRITE):
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 4, BusData['Byte01'], HIGHLOW.LOW)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 4, BusData['Byte02'],HIGHLOW.HIGH)
            self.MBBusComm.mbbus_ssint_(self.MBBusComm.BusOutputAddr + 5, BusData['Short03'])
            self.MBBusComm.mbbus_ssint_(self.MBBusComm.BusOutputAddr + 6, BusData['Short04'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 7, BusData['Int05'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 9, BusData['Int06'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 11, BusData['Float07'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 13, BusData['Float08'])

            self.RobClient.sendVarValue('WriteCmdType01', BusData)
            
            return(MBBusCmd._mbbuscmd_wo__(self.MBBusComm, 145, BusMstSel))
        else:
            BusData = {'Byte01' : 0, 'Byte02' : 0, 'Short03' : 0, 'Short04' : 0, 'Int05' : 0, 'Int06' : 0, 'Float07' : 0.0, 'Float08' : 0.0}
            if (MBBusCmd._mbbuscmd_ro__(self.MBBusComm, 145, BusMstSel, BusTimeout) == Logs.OK):
                BusData['Byte01'] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 4, HIGHLOW.LOW)
                BusData['Byte02'] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 4, HIGHLOW.HIGH)
                BusData['Short03'] = self.MBBusComm.mbbus_gsint_(self.MBBusComm.BusInputAddr + 5)
                BusData['Short04'] = self.MBBusComm.mbbus_gsint_(self.MBBusComm.BusInputAddr + 6)
                BusData['Int05'] = self.MBBusComm.mbbus_gint_(self.MBBusComm.BusInputAddr + 7)
                BusData['Int06'] = self.MBBusComm.mbbus_gint_(self.MBBusComm.BusInputAddr + 9)
                BusData['Float07'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 11)
                BusData['Float08'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 13)

                self.RobClient.sendVarValue('ReadCmdType01', BusData)

                return(Logs.OK)
            return(Logs.ERROR)

    def mbbus_cmd148_(self, BusOperation : BUSCMD_RW, BusMstSel : BUSCMD_MS, BusData : dict, BusTimeout : float = -1.0):
        if (BusOperation == BUSCMD_RW.BUSCMD_WRITE):
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 4, BusData['Byte01'], HIGHLOW.LOW)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 4, BusData['Byte02'],HIGHLOW.HIGH)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 5, BusData['Byte03'], HIGHLOW.LOW)
            self.MBBusComm.mbbus_sbyte_(self.MBBusComm.BusOutputAddr + 5, BusData['Byte04'],HIGHLOW.HIGH)
            self.MBBusComm.mbbus_ssint_(self.MBBusComm.BusOutputAddr + 6, BusData['Short05'])
            self.MBBusComm.mbbus_ssint_(self.MBBusComm.BusOutputAddr + 7, BusData['Short06'])
            self.MBBusComm.mbbus_ssint_(self.MBBusComm.BusOutputAddr + 8, BusData['Short07'])
            self.MBBusComm.mbbus_ssint_(self.MBBusComm.BusOutputAddr + 9, BusData['Short08'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 10, BusData['Int09'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 12, BusData['Int10'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 14, BusData['Int11'])
            self.MBBusComm.mbbus_sint_(self.MBBusComm.BusOutputAddr + 16, BusData['Int12'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 18, BusData['Float13'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 20, BusData['Float14'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 22, BusData['Float15'])
            self.MBBusComm.mbbus_sfloat2_(self.MBBusComm.BusOutputAddr + 24, BusData['Float16'])

            self.RobClient.sendVarValue('WriteCmdType08', BusData)
            
            return(MBBusCmd._mbbuscmd_wo__(self.MBBusComm, 148, BusMstSel))
        else:
            BusData = {'Byte01' : 0, 'Byte02' : 0, 'Byte03' : 0, 'Byte04' : 0, 
                       'Short05' : 0, 'Short06' : 0, 'Short07' : 0, 'Short08' : 0,
                       'Int09' : 0, 'Int10' : 0, 'Int11' : 0, 'Int12' : 0,
                       'Float13' : 0.0, 'Float14' : 0.0, 'Float15' : 0.0, 'Float16' : 0.0}
            if (MBBusCmd._mbbuscmd_ro__(self.MBBusComm, 148, BusMstSel, BusTimeout) == Logs.OK):
                BusData['Byte01'] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 4, HIGHLOW.LOW)
                BusData['Byte02'] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 4, HIGHLOW.HIGH)
                BusData['Byte01'] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 5, HIGHLOW.LOW)
                BusData['Byte02'] = self.MBBusComm.mbbus_gbyte_(self.MBBusComm.BusInputAddr + 5, HIGHLOW.HIGH)
                BusData['Short03'] = self.MBBusComm.mbbus_gsint_(self.MBBusComm.BusInputAddr + 6)
                BusData['Short04'] = self.MBBusComm.mbbus_gsint_(self.MBBusComm.BusInputAddr + 7)
                BusData['Short03'] = self.MBBusComm.mbbus_gsint_(self.MBBusComm.BusInputAddr + 8)
                BusData['Short04'] = self.MBBusComm.mbbus_gsint_(self.MBBusComm.BusInputAddr + 9)
                BusData['Int05'] = self.MBBusComm.mbbus_gint_(self.MBBusComm.BusInputAddr + 10)
                BusData['Int06'] = self.MBBusComm.mbbus_gint_(self.MBBusComm.BusInputAddr + 12)
                BusData['Int05'] = self.MBBusComm.mbbus_gint_(self.MBBusComm.BusInputAddr + 14)
                BusData['Int06'] = self.MBBusComm.mbbus_gint_(self.MBBusComm.BusInputAddr + 16)
                BusData['Float07'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 18)
                BusData['Float08'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 20)
                BusData['Float07'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 22)
                BusData['Float08'] = self.MBBusComm.mbbus_gfloat2_(self.MBBusComm.BusInputAddr + 24)

                self.RobClient.sendVarValue('ReadCmdType08', BusData)

                return(Logs.OK)
            return(Logs.ERROR)
