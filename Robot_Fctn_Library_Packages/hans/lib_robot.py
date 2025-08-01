# -*- coding: utf-8 -*-
#
#***********************************************************
#
# Copyright 2018 - 2025 speedbot All Rights reserved.
#
# file Name: lib_robot
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
class Robot(object):
    
    __HANS_ROBOT_E05_AXIS_LIMIT = [ [-360.0, 360.0], 
                                    [-135.0, 135.0], 
                                    [-153.0, 153.0],
                                    [-360.0, 360.0], 
                                    [-180.0, 180.0], 
                                    [-360.0, 360.0]]


    def __init__(self):
        self.NumOfRobAxis = 6
        self.MaxSmoot = 200.0               # mm
        self.MaxMovJointSpeed = 100.0       # deg/s  
        self.MaxMovLinSpeed = 1000.0        # mm/s 
        self.MaxMovJointAcc = 360.0         # deg/s^2
        self.MaxMovLinAcc = 2500.0          # mm/s^2
        self.AxisLim = self.__HANS_ROBOT_E05_AXIS_LIMIT         # Hans E05 Robot Axis Limit Config
