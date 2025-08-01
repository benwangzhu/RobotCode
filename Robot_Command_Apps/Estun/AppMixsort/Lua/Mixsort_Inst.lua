--***********************************************************
--
-- Copyright 2018 - 2025 speedbot All Rights reserved.
--
-- file Name: Mixsort_Inst
--
-- Description:
--   Language             ==   Lua for ESTUN ROBOT
--   Date                 ==   2025 - 05 - 01
--   Modification Data    ==   2025 - 05 - 01
--
-- Author: speedbot
--
-- Version: 1.0
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

function check_cpos_xyz_(InCpos, E7CoordMode, LimUp, LimDown)
	local CheckPos = { 	confdata = {mode = InCpos.confdata.mode,cf1 = InCpos.confdata.cf1, cf2 = InCpos.confdata.cf2, cf3 = InCpos.confdata.cf3, cf4 = InCpos.confdata.cf4, cf5 = InCpos.confdata.cf5, cf6 = InCpos.confdata.cf6},
						x = InCpos.x,y = InCpos.y,z = InCpos.z,a = InCpos.a,b = InCpos.b,c = InCpos.c,a7 = InCpos.a7,
						a8 = InCpos.a8,a9 = InCpos.a9,a10 = InCpos.a10,a11 = InCpos.a11,a12 = InCpos.a12,a13 = InCpos.a13,a14 = InCpos.a14,a15 = InCpos.a15,a16 = InCpos.a16
					}
	local CoordMode
	if (CheckPos.a7 ~= nil) and (E7CoordMode ~= nil) then  
		if E7CoordMode == 0 then
			CoordMode = nil
		elseif E7CoordMode == 1 then 
			CoordMode = "x"
		elseif E7CoordMode == 2 then 
			CoordMode = "y"
		else
			log_error_(1, {"check_cpos_xyz_:Invalid E7CoordMode!", "[E7CoordMode:", E7CoordMode, "]"})
		end
		CheckPos[CoordMode] = CheckPos[CoordMode] + CheckPos.a7
	end
	local n = {"x", "y", "z"}
	for i = 1, 3 do  
		if CheckPos[n[i]] > LimUp[n[i]] then 
			log_warn_(1, {"check_cpos_xyz_:", "cpos[", n[i], ":", CheckPos[n[i]], "] > LimUp[" , n[i], ":", LimUp[n[i]], "]"})
			return -1
		end
		if CheckPos[n[i]] < LimDown[n[i]] then 
			log_warn_(1, {"check_cpos_xyz_:", "cpos[", n[i], ":", CheckPos[n[i]], "] < LimDown[" , n[i], ":", LimDown[n[i]], "]"})
			return -2
		end
	end
	return 0
end

function cnv_cpos_2cpos_(E7CoordMode, MaxExt, MinExt, MinDist, RlE7Pos, InCpos, OutCpos)
	local TempMaxExt = MaxExt - 20
	local TempMinExt = MinExt + 20
    local TempRlE7Pos = RlE7Pos or (TempMaxExt + TempMinExt) / 2.0
	local CoordMode
	local Trans = { confdata = {mode = InCpos.confdata.mode,cf1 = InCpos.confdata.cf1, cf2 = InCpos.confdata.cf2, cf3 = InCpos.confdata.cf3,
					cf4 = InCpos.confdata.cf4, cf5 = InCpos.confdata.cf5, cf6 = InCpos.confdata.cf6},
					x = InCpos.x,y = InCpos.y,z = InCpos.z,a = InCpos.a,b = InCpos.b,c = InCpos.c,a7 = InCpos.a7,
					a8 = InCpos.a8,a9 = InCpos.a9,a10 = InCpos.a10,a11 = InCpos.a11,a12 = InCpos.a12,a13 = InCpos.a13,a14 = InCpos.a14,a15 = InCpos.a15,a16 = InCpos.a16
				}
	if E7CoordMode == 0 then
		CoordMode = nil
	elseif E7CoordMode == 1 then 
		CoordMode = "x"
	elseif E7CoordMode == 2 then 
		CoordMode = "y"
	else
		log_error_(1, {"cnv_cpos_2cpos_:Invalid E7CoordMode!", "[E7CoordMode:", E7CoordMode, "]"})
	end
	if CoordMode ~= nil then
		Trans["a7"] = Trans["a7"] + Trans[CoordMode]
		Trans[CoordMode] = 0
		local Temp = CoordMode == "x" and "y" or "x"
		if (math.abs(Trans[Temp]) < math.abs(MinDist)) and (Trans["a7"] < TempRlE7Pos) then  
			Trans[CoordMode] = math.sqrt(MinDist * MinDist - Trans[Temp] * Trans[Temp]) * (-1)
			Trans["a7"] = Trans["a7"] + math.sqrt(MinDist * MinDist - Trans[Temp] * Trans[Temp])
		elseif (math.abs(Trans[Temp]) < math.abs(MinDist)) and (Trans["a7"] >= TempRlE7Pos) then
			Trans[CoordMode] = math.sqrt(MinDist * MinDist - Trans[Temp] * Trans[Temp])
			Trans["a7"] = Trans["a7"] - math.sqrt(MinDist * MinDist - Trans[Temp] * Trans[Temp])
		end
		if Trans["a7"] <= TempMinExt then
			Trans[CoordMode] = Trans[CoordMode] + Trans["a7"] - TempMinExt
			Trans["a7"] = TempMinExt
		end
		if Trans["a7"] >= TempMaxExt then
			Trans[CoordMode] = Trans[CoordMode] + Trans["a7"] - TempMaxExt
			Trans["a7"] = TempMaxExt
		end
		OutCpos.a7 = Trans.a7
	end
	OutCpos.confdata.mode = Trans.confdata.mode
	OutCpos.confdata.cf1 = Trans.confdata.cf1
	OutCpos.confdata.cf2 = Trans.confdata.cf2
	OutCpos.confdata.cf3 = Trans.confdata.cf3
	OutCpos.confdata.cf4 = Trans.confdata.cf4
	OutCpos.confdata.cf5 = Trans.confdata.cf5
	OutCpos.confdata.cf6 = Trans.confdata.cf6
	OutCpos.x = Trans.x
	OutCpos.y = Trans.y
	OutCpos.z = Trans.z
	OutCpos.a = Trans.a
	OutCpos.b = Trans.b
	OutCpos.c = Trans.c
end

--HELPER 指令实现
CheckCposXYZ_Para={
	{_name="P",    _desc ="<CH>需要检查的直角坐标</CH><EN>P</EN>",_type="CPOS"},
	{_name="E7CoordMode",	_desc ="<CH>地轨轴协调模式</CH><EN>E7CoordMode</EN>",_type="INTC",_max=2,_min=0,_init=0},	
	{_name="LimUp",	_desc ="<CH>上极限</CH><EN>LimUp</EN>",_type="CPOS"},	
	{_name="LimDown",	_desc ="<CH>下极限</CH><EN>LimDown</EN>",_type="CPOS"},	
	{_name="Res",	_desc ="<CH>状态输出</CH><EN>Output Val</EN>",_type="INT"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="CheckCposXYZ",_comm ="<CH>检查直角坐标是否超出指定的上下限.</CH><EN>CheckCposXYZ.</EN>"},
}
function CheckCposXYZ(CheckCposXYZ_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempE7CoordMode = (type(CheckCposXYZ_Para.E7CoordMode) == "integer" or type(CheckCposXYZ_Para.E7CoordMode) == "number" or CheckCposXYZ_Para.E7CoordMode.value == nil) and CheckCposXYZ_Para.E7CoordMode or CheckCposXYZ_Para.E7CoordMode.value
	CheckCposXYZ_Para.Res.value = check_cpos_xyz_(CheckCposXYZ_Para.P, TempE7CoordMode, CheckCposXYZ_Para.LimUp, CheckCposXYZ_Para.LimDown)
end

CnvCpos2Cpos_Para={
	{_name="E7CoordMode",	_desc ="<CH>地轨轴协调模式</CH><EN>E7CoordMode</EN>",_type="INTC",_max=2,_min=0,_init=0},	
	{_name="MaxExt",	_desc ="<CH>地轨轴上限位</CH><EN>MaxExt</EN>",_type="REALC", _max=3.4e+38, _min=-3.4e+38,_init=0.0},	
	{_name="MinExt",	_desc ="<CH>地轨轴下限位</CH><EN>MinExt</EN>",_type="REALC", _max=3.4e+38, _min=-3.4e+38,_init=0.0},	
	{_name="MixDist",	_desc ="<CH>TCP位置距离本体最小距离</CH><EN>MixDist</EN>",_type="REALC"},	
	{_name="RlE7Pos",	_desc ="<CH>左右偏置的地轨分界线</CH><EN>RlE7Pos</EN>",_type="REALC",_init="DEFAULT"},	
	{_name="InCpos",	_desc ="<CH>输入基准位置</CH><EN>InCpos</EN>",_type="CPOS"},	
	{_name="OutCpos",	_desc ="<CH>输出位置</CH><EN>OutCpos</EN>",_type="CPOS"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="CnvCpos2Cpos",_comm ="<CH>将输入带地轨的坐标转化成指定偏置的安全坐标.</CH><EN>CnvCpos2Cpos.</EN>"},
}
function CnvCpos2Cpos(CnvCpos2Cpos_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempE7CoordMode, TempMaxExt, TempMinExt, TempMinDist, TempRlE7Pos
	TempE7CoordMode = (type(CnvCpos2Cpos_Para.E7CoordMode) == "integer" or type(CnvCpos2Cpos_Para.E7CoordMode) == "number" or CnvCpos2Cpos_Para.E7CoordMode.value == nil) and CnvCpos2Cpos_Para.E7CoordMode or CnvCpos2Cpos_Para.E7CoordMode.value
	TempMaxExt = type(CnvCpos2Cpos_Para.MaxExt) == "float" or type(CnvCpos2Cpos_Para.MaxExt) == "integer" and CnvCpos2Cpos_Para.MaxExt or CnvCpos2Cpos_Para.MaxExt.value
	TempMinExt = type(CnvCpos2Cpos_Para.MinExt) == "float" or type(CnvCpos2Cpos_Para.MinExt) == "integer" and CnvCpos2Cpos_Para.MinExt or CnvCpos2Cpos_Para.MinExt.value
	TempMinDist = type(CnvCpos2Cpos_Para.MixDist) == "float" or type(CnvCpos2Cpos_Para.MixDist) == "integer" and CnvCpos2Cpos_Para.MixDist or CnvCpos2Cpos_Para.MixDist.value
	if type(CnvCpos2Cpos_Para.RlE7Pos) == "float" or type(CnvCpos2Cpos_Para.RlE7Pos) == "integer" then
		TempRlE7Pos = CnvCpos2Cpos_Para.RlE7Pos
	elseif CnvCpos2Cpos_Para.RlE7Pos == "DEFAULT" then
		TempRlE7Pos = nil
	else
	    TempRlE7Pos = CnvCpos2Cpos_Para.RlE7Pos.value
	end
	cnv_cpos_2cpos_(TempE7CoordMode, TempMaxExt, TempMinExt, TempMinDist, TempRlE7Pos, CnvCpos2Cpos_Para.InCpos, CnvCpos2Cpos_Para.OutCpos)
end

MixsortAck_Para={
	{_name="Mode",    _desc ="<CH>模式</CH><EN>Mode</EN>",_type="enum",_init="GET_TACK",_enum={"EDG_PICTURE","GET_PICTURE","LTN_PICTURE","GET_DATA","GET_TACK"}},
    {_name="Secondname",_desc ="Secondname",_type="str",_init="MixsortAck",_comm ="<CH>任务触发模式选择.</CH><EN>MixsortAck.</EN>"},
}
function MixsortAck(MixsortAck_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）

	if t_p["GlobalToSensorCmd"] == nil then
		log_error_(1, {"MixsortAck:Undefined variable In Mixsort Project![GlobalToSensorCmd]"})
	end

	while true do
		if t_p["GlobalToSensorCmd"].value == 0 then
			break
		end
		Sleep(1)
	end

	if MixsortAck_Para.Mode == "EDG_PICTURE" then
		t_p["GlobalToSensorCmd"].value = 1
	elseif MixsortAck_Para.Mode == "GET_PICTURE" then
		t_p["GlobalToSensorCmd"].value = 2
	elseif MixsortAck_Para.Mode == "LTN_PICTURE" then
		t_p["GlobalToSensorCmd"].value = 3
	elseif MixsortAck_Para.Mode == "GET_DATA" then
		t_p["GlobalToSensorCmd"].value = 4
	elseif MixsortAck_Para.Mode == "GET_TACK" then
		t_p["GlobalToSensorCmd"].value = 255
	else
		log_error_(1, {"MixsortAck:Invalid Mode![Mode:", MixsortAck_Para.Mode, "]"})
	end
end



























