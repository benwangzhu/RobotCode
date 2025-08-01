# -*- coding: utf-8 -*-
#
#***********************************************************
#
# Copyright 2018 - 2025 speedbot All Rights reserved.
#
# file Name: lib_typecast
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

class TypeCast:

    @staticmethod
    def list_2cart_(DataList : list):
        if len(DataList) < 6:
            raise ValueError(f"Input list must have exactly 6 elements, but got {len(DataList)} elements.")
        
        return {
            "x": DataList[0],
            "y": DataList[1],
            "z": DataList[2],
            "rx": DataList[3],
            "ry": DataList[4],
            "rz": DataList[5]
        }

    @staticmethod
    def cart_2list_(DataDict : dict):
        required_keys = ["x", "y", "z", "rx", "ry", "rz"]
        for key in required_keys:
            if key not in DataDict:
                raise KeyError(f"Missing key '{key}' in input dictionary.")
        
        return [
            DataDict["x"],
            DataDict["y"],
            DataDict["z"],
            DataDict["rx"],
            DataDict["ry"],
            DataDict["rz"]
        ]
    
    @staticmethod
    def list_2joint_(DataList : list):
        if len(DataList) < 6:
            raise ValueError(f"Input list must have exactly 6 elements, but got {len(DataList)} elements.")
        
        return {
            "j1": DataList[0],
            "j2": DataList[1],
            "j3": DataList[2],
            "j4": DataList[3],
            "j5": DataList[4],
            "j6": DataList[5]
        }
    
    @staticmethod
    def joint_2list_(DataDict : dict):
        required_keys = ["j1", "j2", "j3", "j4", "j5", "j6"]
        for key in required_keys:
            if key not in DataDict:
                raise KeyError(f"Missing key '{key}' in input dictionary.")
        
        return [
            DataDict["j1"],
            DataDict["j2"],
            DataDict["j3"],
            DataDict["j4"],
            DataDict["j5"],
            DataDict["j6"]
        ]
