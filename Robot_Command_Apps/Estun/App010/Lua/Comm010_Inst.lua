--***********************************************************
--
-- Copyright 2018 - 2025 speedbot All Rights reserved.
--
-- file Name: Comm010_Inst
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

SbtComm010Mode_Para={
	{_name="Mode",    _desc ="<CH>模式</CH><EN>Mode</EN>",_type="enum",_init="STACK",_enum={"STACK","UNSTACK"}},
    {_name="Secondname",_desc ="Secondname",_type="str",_init="SbtComm010Mode",_comm ="<CH>工作触发模式选择.</CH><EN>SbtComm010Mode.</EN>"},
}
function SbtComm010Mode(SbtComm010Mode_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）

	if t_p["RobDataTableWorkMode"] == nil then
		log_error_(1, {"SbtComm010Mode:Undefined variable In Comm010 Project![RobDataTableWorkMode]"})
	end

	if SbtComm010Mode_Para.Mode == "STACK" then
		t_p["RobDataTableWorkMode"].value = 1
	elseif SbtComm010Mode_Para.Mode == "UNSTACK" then
		t_p["RobDataTableWorkMode"].value = 2
	else
		log_error_(1, {"SbtComm010Mode:Invalid Mode![Mode:", SbtComm010Mode_Para.Mode, "]"})
	end
end

SbtComm010Skill_Para={
	{_name="Mode",    _desc ="<CH>模式</CH><EN>Mode</EN>",_type="enum",_init="DATA1",_enum={"DATA1","DATA2","SUCCESS","MISS","PRESS", "FAILED", "AREA"},_depends={"AreaId=0000001"}},
	{_name="AreaId",	_desc ="<CH>区域编号</CH><EN>AreaId</EN>",_type="INTC",_max=255,_min=0,_init=0},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="SbtComm010Skill",_comm ="<CH>任务触发模式选择.</CH><EN>SbtComm010Skill.</EN>"},
}
function SbtComm010Skill(SbtComm010Skill_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）

	if t_p["GlobalCommandId"] == nil then
		log_error_(1, {"SbtComm010Skill:Undefined variable In Comm010 Project![GlobalCommandId]"})
	end
	if t_p["RobDataTableArea"] == nil then
		log_error_(1, {"SbtComm010Skill:Undefined variable In Comm010 Project![RobDataTableArea]"})
	end

	while true do
		if t_p["GlobalCommandId"].value == 0 then
			break
		end
		Sleep(1)
	end

	if SbtComm010Skill_Para.Mode == "DATA1" then
		t_p["GlobalCommandId"].value = 1
	elseif SbtComm010Skill_Para.Mode == "DATA2" then
		t_p["GlobalCommandId"].value = 2
	elseif SbtComm010Skill_Para.Mode == "SUCCESS" then
		t_p["GlobalCommandId"].value = 4
	elseif SbtComm010Skill_Para.Mode == "MISS" then
		t_p["GlobalCommandId"].value = 5
	elseif SbtComm010Skill_Para.Mode == "PRESS" then
		t_p["GlobalCommandId"].value = 6
	elseif SbtComm010Skill_Para.Mode == "FAILED" then
		t_p["GlobalCommandId"].value = 7
	elseif SbtComm010Skill_Para.Mode == "AREA" then
		t_p["RobDataTableArea"].value = (type(SbtComm010Skill_Para.AreaId) == "integer" or type(SbtComm010Skill_Para.AreaId) == "number" or SbtComm010Skill_Para.AreaId.value == nil) and SbtComm010Skill_Para.AreaId or SbtComm010Skill_Para.AreaId.value
		t_p["GlobalCommandId"].value = 8
	else
		log_error_(1, {"SbtComm010Skill:Invalid Mode![Mode:", SbtComm010Skill_Para.Mode, "]"})
	end
end



























