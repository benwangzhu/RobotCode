--***********************************************************
--
-- Copyright 2018 - 2025 speedbot All Rights reserved.
--
-- file Name: lib_tp_if
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

-- PLC 交互指令实现
ZoneCtrl_Para={
	{_name="Mode",    _desc ="<CH>操作类型</CH><EN>Mode</EN>",_type="enum",_init="I_ENTER",_enum={"I_ENTER","I_EXIT"}},
	{_name="ZoneNo",	_desc ="<CH>干涉区编号</CH><EN>ValInt</EN>",_type="INTC",_max=12,_min=1,_init=1},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="ZoneCtrl",_comm ="<CH>干涉区操作指令.</CH><EN>ZoneCtrl.</EN>"},
}
function ZoneCtrl(ZoneCtrl_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempZoneNo = (type(ZoneCtrl_Para.ZoneNo) == "integer" or type(ZoneCtrl_Para.ZoneNo) == "number" or ZoneCtrl_Para.ZoneNo.value == nil) and ZoneCtrl_Para.ZoneNo or ZoneCtrl_Para.ZoneNo.value
	if ZoneCtrl_Para.Mode == "I_EXIT" then
		set_simdo_("BIT", TempZoneNo + 20, {1}, 1)
		set_simdo_("BIT", TempZoneNo + 240, {0}, 1)
	else
		set_simdo_("BIT", TempZoneNo + 20, {0}, 1)
		wait_simio_("SIMDI", TempZoneNo + 20, 1, 0)
		set_simdo_("BIT", TempZoneNo + 240, {1}, 1)
	end
end

PathSegment_Para={
	{_name="SegmentNo",	_desc ="<CH>路径编号</CH><EN>SegmentNo</EN>",_type="INTC",_max=255,_min=0,_init=1},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="PathSegment",_comm ="<CH>路径段反馈指令.</CH><EN>PathSegment.</EN>"},
}
function PathSegment(PathSegment_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempSegment = (type(PathSegment_Para.SegmentNo) == "integer" or type(PathSegment_Para.SegmentNo) == "number" or PathSegment_Para.SegmentNo.value == nil) and PathSegment_Para.SegmentNo or PathSegment_Para.SegmentNo.value
	set_simdo_("UINT8", 33, TempSegment)
	set_simdo_("BIT", 41, {0}, 1)
end

RequestToContinue_Para={
	-- {_name="Continue",	_desc ="<CH>返回值</CH><EN>Continue</EN>",_type="INT"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="RequestToContinue",_comm ="<CH>路径段请求指令.</CH><EN>RequestToContinue.</EN>"},
}
function RequestToContinue(RequestToContinue_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	set_simdo_("BIT", 41, {0}, 1)
	wait_simio_("SIMDI", 41, 0, 0)
	set_simdo_("BIT", 41, {1}, 1)
	wait_simio_("SIMDI", 41, 1, 0)
	if t_g["DicisionCode"] == nil then
		t_g["DicisionCode"] = {_type = "INT", value = 0, saveflag = true, note = "Dicision Code"}
	end
	t_g["DicisionCode"].value = get_simio_("UINT8", "SIMDI", 33)
end

WaitForSimIo_Para={
	{_name="IoType",    _desc ="<CH>IO 类型</CH><EN>IoType</EN>",_type="enum",_init="SIMDI",_enum={"SIMDI","SIMDO"}},
	{_name="StAddrInt",	_desc ="<CH>SIM IO 地址</CH><EN>StAddrInt</EN>",_type="INTC",_max=2048,_min=1,_init=1},
	{_name="Val",	_desc ="<CH>等待状态</CH><EN>StAddrInt</EN>",_type="INTC",_max=1,_min=0,_init=1},
	{_name="T",           _desc ="<CH>时长(ms)</CH><EN>Time(ms)</EN>",_type="INTC",_max=1000000,_min=0,_init=0,_comm ="<CH>0表示无限等待，非0值为正常等待时间</CH><EN>0: infinite wait;  Non-zero: normal wait time</EN>"},
	{_name="Ret",         _desc ="<CH>超时判断值</CH><EN>IsOvertime</EN>",_type="INT"},
	{_name="Goto",       _desc ="<CH>超时跳转的标签名</CH><EN>LabelName</EN>",_type="label"},	
	{_name="Secondname",_desc ="Secondname",_type="str",_init="WaitForSimIo",_comm ="<CH>等待 SIMIO 满足条件.</CH><EN>WaitForSimIo.</EN>"},
}
function WaitForSimIo(WaitForSimIo_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempStAddr, TempVal, TempT
	TempStAddr = (type(WaitForSimIo_Para.StAddrInt) == "integer" or type(WaitForSimIo_Para.StAddrInt) == "number" or WaitForSimIo_Para.StAddrInt.value == nil) and WaitForSimIo_Para.StAddrInt or WaitForSimIo_Para.StAddrInt.value 
	TempVal = (type(WaitForSimIo_Para.Val) == "integer" or type(WaitForSimIo_Para.Val) == "number" or WaitForSimIo_Para.Val.value == nil) and WaitForSimIo_Para.Val or WaitForSimIo_Para.Val.value
	TempT = (type(WaitForSimIo_Para.T) == "integer" or type(WaitForSimIo_Para.T) == "number" or WaitForSimIo_Para.T.value == nil) and WaitForSimIo_Para.T or WaitForSimIo_Para.T.value 
	WaitForSimIo_Para.Ret.value = wait_simio_(WaitForSimIo_Para.IoType, TempStAddr, TempVal, TempT)
	if WaitForSimIo_Para.Ret.value == -1 and WaitForSimIo_Para.Goto ~= nil then WaitGotoLabel(WaitForSimIo_Para.Goto) end
end

--PulseSimOut脉冲指令
PulseSimDo_Para={
	{_name="StAddrInt",	_desc ="<CH>SIM DO 地址</CH><EN>StAddrInt</EN>",_type="INTC",_max=2048,_min=1,_init=1},
	{_name="Val",        _desc ="<CH>端口值</CH><EN>Value</EN>",_type="int",_max=1,_min=0,_init=0},
	{_name="Time",       _desc ="<CH>持续时间(ms)</CH><EN>Time(ms)</EN>",_type="int",_max=10000,_min=0,_init=0},
	{_name="InterEnable",_desc ="<CH>中断使能</CH><EN>IsInterrupt</EN>",_type="int",_max=1,_min=0,_init=0,_comm ="<CH>暂停后是否打断脉冲的输出(0:继续输出1：打断输出)</CH><EN>Judge whether interrupt pulse output(0:no 1:yes) after pause</EN>"},
	{_name="Secondname", _desc ="Secondname",_type="str",_init="PulSOut",_comm ="<CH>设置虚拟脉冲输出指令.</CH><EN>Set a simulation port output the special pulse.</EN>"},
}

function PulseSimDo(PulseSimDo_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempStAddr = (type(PulseSimDo_Para.StAddrInt) == "integer" or type(PulseSimDo_Para.StAddrInt) == "number" or PulseSimDo_Para.StAddrInt.value == nil) and PulseSimDo_Para.StAddrInt or PulseSimDo_Para.StAddrInt.value 
	local ret = ins:PulseOutput(2, TempStAddr, PulseSimDo_Para.Val, PulseSimDo_Para.Time, PulseSimDo_Para.InterEnable)
	if ret == 1 then
	  ins:setSysError(977)
	  ExecStsIsFailed(1)
	end	
end

EchoChannel_Para={
	{_name="Channecll",	_desc ="<CH>通道1</CH><EN>Channecll</EN>",_type="INTC",_max=255,_min=0,_init=0},	
	{_name="Channecl2",	_desc ="<CH>通道2</CH><EN>Channecl2</EN>",_type="INTC",_max=255,_min=0,_init=0},	
	{_name="Channecl3",	_desc ="<CH>通道3</CH><EN>Channecl3</EN>",_type="INTC",_max=255,_min=0,_init=0},	
	{_name="Channecl4",	_desc ="<CH>通道4</CH><EN>Channecl4</EN>",_type="INTC",_max=255,_min=0,_init=0},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="EchoChannel",_comm ="<CH>通道反馈指令.</CH><EN>Echo Channel.</EN>"},
}
function EchoChannel(EchoChannel_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempChannecll = (type(EchoChannel_Para.Channecll) == "integer" or type(EchoChannel_Para.Channecll) == "number" or EchoChannel_Para.Channecll.value == nil) and EchoChannel_Para.Channecll or EchoChannel_Para.Channecll.value
	local TempChannecl2 = (type(EchoChannel_Para.Channecl2) == "integer" or type(EchoChannel_Para.Channecl2) == "number" or EchoChannel_Para.Channecl2.value == nil) and EchoChannel_Para.Channecl2 or EchoChannel_Para.Channecl2.value
	local TempChannecl3 = (type(EchoChannel_Para.Channecl3) == "integer" or type(EchoChannel_Para.Channecl3) == "number" or EchoChannel_Para.Channecl3.value == nil) and EchoChannel_Para.Channecl3 or EchoChannel_Para.Channecl3.value
	local TempChannecl4 = (type(EchoChannel_Para.Channecl4) == "integer" or type(EchoChannel_Para.Channecl4) == "number" or EchoChannel_Para.Channecl4.value == nil) and EchoChannel_Para.Channecl4 or EchoChannel_Para.Channecl4.value
	set_simdo_("UINT8", 129,  TempChannecll)
	set_simdo_("UINT8", 137, TempChannecl2)
	set_simdo_("UINT8", 145, TempChannecl3)
	set_simdo_("UINT8", 153, TempChannecl4)
end

EchoJobInfo_Para={
	{_name="Info1",	_desc ="<CH>信息1</CH><EN>Info1</EN>",_type="INTC",_max=255,_min=0,_init=0},	
	{_name="Info2",	_desc ="<CH>信息2</CH><EN>Info2</EN>",_type="INTC",_max=255,_min=0,_init=0},	
	{_name="Info3",	_desc ="<CH>信息3</CH><EN>Info3</EN>",_type="INTC",_max=255,_min=0,_init=0},	
	{_name="Info4",	_desc ="<CH>信息4</CH><EN>Info4</EN>",_type="INTC",_max=255,_min=0,_init=0},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="EchoJobInfo",_comm ="<CH>通道反馈指令.</CH><EN>Echo Job Info.</EN>"},
}
function EchoJobInfo(EchoJobInfo_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempJobInfol = (type(EchoJobInfo_Para.Info1) == "integer" or type(EchoJobInfo_Para.Info1) == "number" or EchoJobInfo_Para.Info1.value == nil) and EchoJobInfo_Para.Info1 or EchoJobInfo_Para.Info1.value
	local TempJobInfo2 = (type(EchoJobInfo_Para.Info2) == "integer" or type(EchoJobInfo_Para.Info2) == "number" or EchoJobInfo_Para.Info2.value == nil) and EchoJobInfo_Para.Info2 or EchoJobInfo_Para.Info2.value
	local TempJobInfo3 = (type(EchoJobInfo_Para.Info3) == "integer" or type(EchoJobInfo_Para.Info3) == "number" or EchoJobInfo_Para.Info3.value == nil) and EchoJobInfo_Para.Info3 or EchoJobInfo_Para.Info3.value
	local TempJobInfo4 = (type(EchoJobInfo_Para.Info4) == "integer" or type(EchoJobInfo_Para.Info4) == "number" or EchoJobInfo_Para.Info4.value == nil) and EchoJobInfo_Para.Info4 or EchoJobInfo_Para.Info4.value
	set_simdo_("UINT8", 97,  TempJobInfol)
	set_simdo_("UINT8", 105, TempJobInfo2)
	set_simdo_("UINT8", 113, TempJobInfo3)
	set_simdo_("UINT8", 121, TempJobInfo4)
end

Servo01Ctrl_Para={
	{_name="CtrlMode", _desc ="<CH>控制类型</CH><EN>CtrlMode</EN>",_type="enum",_init="MOVING",_enum={"MOVING","WAITING"},_depends={"Dist=10"}},
	{_name="Dist",	_desc ="<CH>控制距离</CH><EN>Dist</EN>",_type="INTC",_max=32767,_min=-32768,_init=0},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="Servo01Ctrl",_comm ="<CH>外部伺服控制指令.</CH><EN>Servo01 Ctrl.</EN>"},
}
function Servo01Ctrl(Servo01Ctrl_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	if Servo01Ctrl_Para.CtrlMode == "MOVING" then
		local TempDist = (type(Servo01Ctrl_Para.Dist) == "integer" or type(Servo01Ctrl_Para.Dist) == "number" or Servo01Ctrl_Para.Dist.value == nil) and Servo01Ctrl_Para.Dist or Servo01Ctrl_Para.Dist.value
		set_simdo_("INT16", 161, TempDist)
		local ret = ins:PulseOutput(2, 57, 1, 1000, 1)
		if ret == 1 then
		  ins:setSysError(977)
		  ExecStsIsFailed(1)
		end	
	else
		local OutDist = get_simio_("INT16", "SIMDO", 161)
		local n = {}
		while true do
			n = get_simio_("BIT", "SIMDI", 57, 1)
			if (math.abs(get_simio_("INT16", "SIMDI", 161) - OutDist) <= 2) and (n[1] == 1) then
				break
			end
			Sleep(1)
		end
	end
end














