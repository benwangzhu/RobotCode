--***********************************************************
--
-- Copyright 2018 - 2025 speedbot All Rights reserved.
--
-- file Name: lib_busio
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

function bus_sbit_(IoStAddr, Val, Bit)
	if IoStAddr < 0 then
		log_error_(1, {"bus_sbit_:Invalid start address!", "[IoStAddr:", IoStAddr, ",Bit:", Bit, ",Val:", Val, "]"})
	end
	if (Bit <= 0) or (Bit > 8) then
		log_error_(1, {"bus_sbit_:Invalid operation bit!", "[IoStAddr:", IoStAddr, ",Bit:", Bit, ",Val:", Val, "]"})
	end
	if (Val < 0) or (Val > 1) then
		log_error_(1, {"bus_sbit_:Invalid value!", "[IoStAddr:", IoStAddr, ",Bit:", Bit, ",Val:", Val, "]"})
	end

	local Bits = byte_2bit_(bus_gbyte_("IO_DOUT", IoStAddr))

	Bits[Bit] = Val
	bus_sbyte_(IoStAddr, bit_2byte_(Bits, 1, 8))
end


function bus_sbyte_(IoStAddr, Val)
	if IoStAddr < 0 then
		log_error_(1, {"bus_sbyte_:Invalid start address!", "[IoStAddr:", IoStAddr, ",Bit:", Bit, ",Val:", Val, "]"})
	end
	if (Val < 0) or (Val > 255) then
		log_error_(1, {"bus_sbyte_:Invalid value!", "[IoStAddr:", IoStAddr, ",Val:", Val, "]"})
	end
	mov:SetSimAO(IoStAddr, Val)
	local doValue = mov:GetSimAO(IoStAddr) --对设置成功与否进行等待，避免后续判断出错。
	while abs(doValue - Val) > 0.0001 do
		doValue = mov:GetSimAO(IoStAddr)
		delay_(1) --这里需要延时等待下，否则死循环出错
	end
end

function bus_ssint_(IoStAddr, Val)
	if IoStAddr < 0 then
		log_error_(1, {"bus_ssint_:Invalid start address!", "[IoStAddr:", IoStAddr, ",Val:", Val, "]"})
	end
	if (Val < -32768) or (Val > 32767) then
		log_error_(1, {"bus_ssint_:Invalid value!", "[IoStAddr:", IoStAddr, ",Val:", Val, "]"})
	end
	bus_sbyte_(IoStAddr + 0, (Val < 0 and Val + 65536 or Val) % 256)
	bus_sbyte_(IoStAddr + 1, math.floor((Val < 0 and Val + 65536 or Val) / 256) % 256)
end

function bus_susint_(IoStAddr, Val)
	if IoStAddr < 0 then
		log_error_(1, {"bus_susint_:Invalid start address!", "[IoStAddr:", IoStAddr, ",Val:", Val, "]"})
	end
	if (Val < 0) or (Val > 65535) then
		log_error_(1, {"bus_susint_:Invalid value!", "[IoStAddr:", IoStAddr, ",Val:", Val, "]"})
	end
	bus_sbyte_(IoStAddr + 0, Val % 256)
	bus_sbyte_(IoStAddr + 1, math.floor(Val / 256) % 256)
end

function bus_sint_(IoStAddr, Val)
	if IoStAddr < 0 then
		log_error_(1, {"bus_sint_:Invalid start address!", "[IoStAddr:", IoStAddr, ",Val:", Val, "]"})
	end
	bus_sbyte_(IoStAddr + 0, Val % 256)
	bus_sbyte_(IoStAddr + 1, math.floor(Val / 256) % 256)
	bus_sbyte_(IoStAddr + 2, math.floor(Val / (256^2)) % 256)
	bus_sbyte_(IoStAddr + 3, math.floor(Val / (256^3)) % 256)
end

function bus_sfloat2_(IoStAddr, Val)
	if IoStAddr < 0 then
		log_error_(1, {"bus_sfloat2_:Invalid start address!", "[IoStAddr:", IoStAddr, ",Val:", Val, "]"})
	end
	local IntVal, _ = math.modf(Val)
	local DecVal, _ = math.modf((Val - IntVal)*10000)
	bus_sbyte_(IoStAddr + 0, ((IntVal < 0) and (IntVal + 65536) or IntVal) % 256)
	bus_sbyte_(IoStAddr + 1, math.floor((IntVal < 0 and IntVal + 65536 or IntVal) / 256) % 256)
	bus_sbyte_(IoStAddr + 2, ((DecVal < 0) and (DecVal + 65536) or DecVal) % 256)
	bus_sbyte_(IoStAddr + 3, math.floor((DecVal < 0 and DecVal + 65536 or DecVal) / 256) % 256)
end

function bus_scpos_(IoStAddr, Val, NumOfAxis)
	if IoStAddr < 0 then
		log_error_(1, {"bus_scpos_:Invalid start address!", "[IoStAddr:", IoStAddr, "]"})
	end
	local TempNumOfAxis = NumOfAxis or 6
	local PosArray = cpos_2array_(Val)
	for i = 1, TempNumOfAxis do 
		bus_sfloat2_(IoStAddr + (i - 1) * 4, PosArray[i])
	end
end

function bus_sapos_(IoStAddr, Val, NumOfAxis)
	if IoStAddr < 0 then
		log_error_(1, {"bus_sapos_:Invalid start address!", "[IoStAddr:", IoStAddr, "]"})
	end
	local TempNumOfAxis = NumOfAxis or 6
	local PosArray = apos_2array_(Val)
	for i = 1, TempNumOfAxis do 
		bus_sfloat2_(IoStAddr + (i - 1) * 4, PosArray[i])
	end
end

function bus_gbit_(IoType, IoStAddr, Bit)
	if IoStAddr < 0 then
		log_error_(1, {"bus_gbit_:Invalid start address!", "[IoStAddr:", IoStAddr, "]"})
	end
	if (Bit <= 0) or (Bit > 8) then
		log_error_(1, {"bus_gbit_:Invalid operation bit!", "[IoStAddr:", IoStAddr, ",Bit:", Bit, "]"})
	end

	local Bits = byte_2bit_(bus_gbyte_(IoType, IoStAddr))
	return Bits[Bit]
end

function bus_gbyte_(IoType, IoStAddr)
	if IoStAddr < 0 then
		log_error_(1, {"bus_gbyte_:Invalid start address!", "[IoStAddr:", IoStAddr, "]"})
	end
	if IoType == "IO_DIN" then 
		return mov:GetSimAI(IoStAddr)
	elseif IoType == "IO_DOUT" then 
		return mov:GetSimAO(IoStAddr)
	else
		log_error_(1, {"bus_gbyte_:Invalid IO Type![IO_DIN, IO_DOUT]"})
	end
end

function bus_gsint_(IoType, IoStAddr)
	if IoStAddr < 0 then
		log_error_(1, {"bus_gsint_:Invalid start address!", "[IoStAddr:", IoStAddr, "]"})
	end
	
	local TempVal = ins:BitOperation(5, bus_gbyte_(IoType, IoStAddr + 1), 8) + bus_gbyte_(IoType, IoStAddr + 0)
	return TempVal > 32767 and TempVal - 65536 or TempVal
end

function bus_gusint_(IoType, IoStAddr)
	if IoStAddr < 0 then
		log_error_(1, {"bus_gusint_:Invalid start address!", "[IoStAddr:", IoStAddr, "]"})
	end
	
	return ins:BitOperation(5, bus_gbyte_(IoType, IoStAddr + 1), 8) + bus_gbyte_(IoType, IoStAddr + 0)
end

function bus_gint_(IoType, IoStAddr)
	if IoStAddr < 0 then
		log_error_(1, {"bus_gint_:Invalid start address!", "[IoStAddr:", IoStAddr, "]"})
	end
	
	return ins:BitOperation(5, bus_gbyte_(IoType, IoStAddr + 3), 24) + ins:BitOperation(5, bus_gbyte_(IoType, IoStAddr + 2), 16) + ins:BitOperation(5, bus_gbyte_(IoType, IoStAddr + 1), 8) + bus_gbyte_(IoType, IoStAddr + 0)
end

function bus_gfloat2_(IoType, IoStAddr)
	if IoStAddr < 0 then
		log_error_(1, {"bus_gfloat2_:Invalid start address!", "[IoStAddr:", IoStAddr, "]"})
	end
	
	return bus_gsint_(IoType, IoStAddr + 0) + bus_gsint_(IoType, IoStAddr + 2) / 10000.0
end

function bus_gcpos_(IoType, IoStAddr, NumOfAxis)
	if IoStAddr < 0 then
		log_error_(1, {"bus_gcpos_:Invalid start address!", "[IoStAddr:", IoStAddr, "]"})
	end

	local TempNumOfAxis = NumOfAxis or 6
	
	local TempVal = {}
	for i = 1, TempNumOfAxis do 
		table.insert(TempVal, bus_gfloat2_(IoType, IoStAddr + (i - 1) * 4))
	end
	
	return array_2cpos_(TempVal)
end

function bus_gapos_(IoType, IoStAddr, NumOfAxis)
	if IoStAddr < 0 then
		log_error_(1, {"bus_gapos_:Invalid start address!", "[IoStAddr:", IoStAddr, "]"})
	end

	local TempNumOfAxis = NumOfAxis or 6
	
	local TempVal = {}
	for i = 1, TempNumOfAxis do 
		table.insert(TempVal, bus_gfloat2_(IoType, IoStAddr + (i - 1) * 4))
	end
	
	return array_2apos_(TempVal)
end

function bus_uptin_(BusIn)
	BusIn.SysReady = (bus_gbit_("IO_DIN", BusIn.BusIoSt, 1) > 0)
	BusIn.SysInited = (bus_gbit_("IO_DIN", BusIn.BusIoSt, 2) > 0)
	BusIn.StopMov = (bus_gbit_("IO_DIN", BusIn.BusIoSt, 3) > 0)
	BusIn.OnMeasure = (bus_gbit_("IO_DIN", BusIn.BusIoSt, 4) > 0)
	BusIn.MeasuerOver = (bus_gbit_("IO_DIN", BusIn.BusIoSt, 5) > 0)
	BusIn.ResultOk = (bus_gbit_("IO_DIN", BusIn.BusIoSt, 6) > 0)
	BusIn.ResultNG = (bus_gbit_("IO_DIN", BusIn.BusIoSt, 7) > 0)
	BusIn.Finished = (bus_gbit_("IO_DIN", BusIn.BusIoSt, 8) > 0)

	BusIn.DeviceId = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 1)
	BusIn.JobId = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 2)
	BusIn.ErrorId = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 3)
	BusIn.AgentTellId = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 4)
	BusIn.AgentMsgType = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 5)
	BusIn.TellId = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 6)
	BusIn.MsgType = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 7)
end

function bus_uptout_(BusOut)
	bus_sbit_(BusOut.BusIoSt + 0, BusOut.SysEnable and 1 or 0, 1)
	bus_sbit_(BusOut.BusIoSt + 0, BusOut.SysInit and 1 or 0, 2)
	bus_sbit_(BusOut.BusIoSt + 0, BusOut.RobMoving and 1 or 0, 3)
	bus_sbit_(BusOut.BusIoSt + 0, BusOut.MeasuerSt and 1 or 0, 4)
	bus_sbit_(BusOut.BusIoSt + 0, BusOut.MeasuerEd and 1 or 0, 5)
	bus_sbit_(BusOut.BusIoSt + 0, BusOut.Reserverd1 and 1 or 0, 6)
	bus_sbit_(BusOut.BusIoSt + 0, BusOut.Reserverd2 and 1 or 0, 7)
	bus_sbit_(BusOut.BusIoSt + 0, BusOut.CycleEnd and 1 or 0, 8)
	
	bus_sbyte_(BusOut.BusIoSt + 1, BusOut.RobotId)
	bus_sbyte_(BusOut.BusIoSt + 2, BusOut.JobId)
	bus_sbyte_(BusOut.BusIoSt + 3, BusOut.ProtocolId)
	bus_sbyte_(BusOut.BusIoSt + 4, BusOut.TellId)
	bus_sbyte_(BusOut.BusIoSt + 5, BusOut.MsgType)
	bus_sbyte_(BusOut.BusIoSt + 6, BusOut.RobTellId)
	bus_sbyte_(BusOut.BusIoSt + 7, BusOut.RobMsgType)
end

function bus_init_(BusIn, BusOut, RonId, ProtId)
	local SysInit = bus_gbit_("IO_DOUT", BusOut.BusIoSt, 2)
	if SysInit > 0 then
		SysInit = 0
		bus_sbit_(BusOut.BusIoSt, SysInit, 2)
		delay_(200)
	end
    BusOut.SysEnable        = true
    BusOut.SysInit          = true
    BusOut.RobMoving        = false
    BusOut.MeasuerSt        = false
    BusOut.MeasuerEd        = false
    BusOut.Reserverd1       = false
    BusOut.Reserverd2       = false
    BusOut.CycleEnd         = false
    BusOut.RobotId          = RonId
    BusOut.JobId            = 0
    BusOut.ProtocolId       = ProtId
    BusOut.RobTellId        = 0
    -- BusOut.RobMsgType       = 0
	bus_uptout_(BusOut)
	delay_(100)
	repeat
		bus_uptin_(BusIn)
		if (BusIn.TellId == 0) and (BusIn.SysInited == true) then
			break
		end
		delay_(100)
	until false
    bus_uptin_(BusIn)
    BusOut.TellId	= BusIn.AgentTellId
    BusOut.MsgType	= BusIn.AgentMsgType
    BusOut.SysInit	= false
    bus_uptout_(BusOut)
end


function bus_wtell_(BusIn, BusOut, Timeout)
	local TempTimeout = Timeout or -1
	local timeStart = ins:GetCurSysClk()
	repeat
		BusOut.TellId = bus_gbyte_("IO_DOUT", BusOut.BusIoSt + 4)
		BusIn.AgentTellId = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 4)
		if (BusIn.AgentTellId == 0) or (BusOut.TellId == BusIn.AgentTellId) then
			if TempTimeout == 0 then 
				log_warn_(3, {"bus_wtell_:Wtell Bus Null Data!"})
				return -3 
			end
			delay_(8)
		else
			BusIn.JobId = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 2)
			BusIn.ErrorId = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 3)
			BusIn.AgentMsgType = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 5)
			return BusIn.ErrorId
		end
		BusIn.SysReady = (bus_gbit_("IO_DIN", BusIn.BusIoSt, 1) > 0)
		BusOut.SysEnable = (bus_gbit_("IO_DOUT", BusOut.BusIoSt, 1) > 0)
		BusOut.SysInit = (bus_gbit_("IO_DOUT", BusOut.BusIoSt, 2) > 0)
		if (ins:GetCurSysClk() - timeStart) > TempTimeout then
			BusOut.TellId = bus_gbyte_("IO_DOUT", BusOut.BusIoSt + 4)
			BusIn.AgentTellId = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 4)
		end
		if (((ins:GetCurSysClk() - timeStart) > TempTimeout) and (TempTimeout > 0) and (BusOut.TellId == BusIn.AgentTellId)) then 
			break 
		end
	until ((not BusIn.SysReady) or (not BusOut.SysEnable) or (BusOut.SysInit))
	if (not BusIn.SysReady) or (not BusOut.SysEnable) or (BusOut.SysInit) then
		log_warn_(2, {"bus_wtell_:bus_wtell_ Not Enb!", "[SysReady:", BusIn.SysReady, "]", "[SysEnable:", BusOut.SysEnable, "]"})
		delay_(100)
		return -2
	end

	log_warn_(1, {"bus_wtell_:Wtell Bus Timeout"})
	return -1
end

function bus_ftell_(BusIn, BusOut)
    BusIn.AgentTellId   = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 4)
    BusIn.AgentMsgType  = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 5) 
    BusOut.TellId       = BusIn.AgentTellId
    BusOut.MsgType      = BusIn.AgentMsgType
	bus_sbyte_(BusOut.BusIoSt + 5, BusOut.MsgType)
	bus_sbyte_(BusOut.BusIoSt + 4, BusOut.TellId)
end

function bus_ntell_(BusIn, BusOut, Timeout)
	local TempTimeout = Timeout or -1
	local timeStart = ins:GetCurSysClk()
    BusIn.TellId        = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 6) 
    BusOut.RobTellId    = BusIn.TellId + 1
    if BusOut.RobTellId > 255 then BusOut.RobTellId = 1 end
    bus_sbyte_(BusOut.BusIoSt + 1, BusOut.RobotId)
    bus_sbyte_(BusOut.BusIoSt + 2, BusOut.JobId)
    bus_sbyte_(BusOut.BusIoSt + 7, BusOut.RobMsgType)
    bus_sbyte_(BusOut.BusIoSt + 6, BusOut.RobTellId)
    repeat 
        BusIn.TellId = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 6) 
        if (BusOut.RobTellId == BusIn.TellId) then 
            BusIn.JobId         = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 2)
            BusIn.ErrorId       = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 3)
            BusIn.MsgType       = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 7) 
            return BusIn.ErrorId
        else 
            if TempTimeout == 0 then
				log_warn_(2, {"bus_ntell_:Ntell Bus Null Data!"})
				return -3
			end
            delay_(8)
        end
		BusIn.SysReady = (bus_gbit_("IO_DIN", BusIn.BusIoSt, 1) > 0)
		BusOut.SysEnable = (bus_gbit_("IO_DOUT", BusOut.BusIoSt, 1) > 0)
		BusOut.SysInit = (bus_gbit_("IO_DOUT", BusOut.BusIoSt, 2) > 0)
		if (((ins:GetCurSysClk() - timeStart) > TempTimeout) and (TempTimeout > 0) and (BusOut.RobTellId ~= BusIn.TellId)) then 
			break 
		end
    until ((not BusIn.SysReady) or (not BusOut.SysEnable) or (BusOut.SysInit))
    BusIn.TellId = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 6) 
    if (BusOut.RobTellId == BusIn.TellId) then 
        BusIn.JobId         = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 2)
        BusIn.ErrorId       = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 3)
        BusIn.MsgType       = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 7) 
        return BusIn.ErrorId
    end
	if (not BusIn.SysReady) or (not BusOut.SysEnable) or (BusOut.SysInit) then
		log_warn_(2, {"bus_ntell_:Ntell Bus Not Enb!"})
		delay_(100)
		return -2
	end
	log_warn_(1, {"bus_ntell_:Ntell Bus Timeout!"})
	return -1
end

function bus_stell_(BusIn, BusOut)
    BusIn.TellId        = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 6) 
    BusOut.RobTellId    = bus_gbyte_("IO_DOUT", BusOut.BusIoSt + 6) 
	BusOut.SysEnable 	= (bus_gbit_("IO_DOUT", BusOut.BusIoSt, 1) > 0)
	
    if (BusIn.TellId ~= BusOut.RobTellId) or (not BusOut.SysEnable) then
        bus_init_(BusIn, BusOut, BusOut.RobotId, 64)
    end

    BusOut.RobTellId    = BusIn.TellId + 1
    if BusOut.RobTellId > 255 then 
		BusOut.RobTellId = 1
	end

    bus_sbyte_(BusOut.BusIoSt + 1, BusOut.RobotId)
    bus_sbyte_(BusOut.BusIoSt + 2, BusOut.JobId)
    bus_sbyte_(BusOut.BusIoSt + 7, BusOut.RobMsgType)
    bus_sbyte_(BusOut.BusIoSt + 6, BusOut.RobTellId)
end

function bus_rtell_(BusIn, BusOut, Timeout)
	local TempTimeout = Timeout or -1
	local timeStart = ins:GetCurSysClk()
	BusOut.RobTellId = bus_gbyte_("IO_DOUT", BusOut.BusIoSt + 6) 
    repeat 
        BusIn.TellId = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 6) 
        if (BusOut.RobTellId == BusIn.TellId) then 
            BusIn.JobId         = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 2)
            BusIn.ErrorId       = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 3)
            BusIn.MsgType       = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 7) 
            return BusIn.ErrorId
        else 
            if TempTimeout == 0 then
				log_warn_(2, {"bus_rtell_:Ntell Bus Null Data!"})
				return -3
			end
            delay_(8)
        end
		BusIn.SysReady = (bus_gbit_("IO_DIN", BusIn.BusIoSt, 1) > 0)
		BusOut.SysEnable = (bus_gbit_("IO_DOUT", BusOut.BusIoSt, 1) > 0)
		BusOut.SysInit = (bus_gbit_("IO_DOUT", BusOut.BusIoSt, 2) > 0)
		if (((ins:GetCurSysClk() - timeStart) > TempTimeout) and (TempTimeout > 0) and (BusOut.RobTellId ~= BusIn.TellId)) then
			break 
		end
    until ((not BusIn.SysReady) or (not BusOut.SysEnable) or (BusOut.SysInit))
    BusIn.TellId = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 6) 
    if (BusOut.RobTellId == BusIn.TellId) then 
        BusIn.JobId         = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 2)
        BusIn.ErrorId       = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 3)
        BusIn.MsgType       = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 7) 
        return BusIn.ErrorId
    end
	if (not BusIn.SysReady) or (not BusOut.SysEnable) or (BusOut.SysInit) then
		log_warn_(2, {"bus_rtell_:Ntell Bus Not Enb!"})
		delay_(100)
		return -2
	end
	log_warn_(1, {"bus_rtell_:Ntell Bus Timeout!"})
	return -1
end


-- BUS 通讯指令实现
BusSetNUM_Para={
	{_name="Type",    _desc ="<CH>操作数据类型</CH><EN>Type</EN>",_type="enum",_init="BIT",_enum={"BIT","UINT8", "INT16", "UINT16", "INT32", "FLOAT2"}, _depends={"Int=111110","Float2=000001","Bit=100000"}},
	{_name="StAddrInt",	_desc ="<CH>SIM DO 地址</CH><EN>StAddrInt</EN>",_type="INTC",_max=2048,_min=1,_init=1},
	{_name="Bit",	_desc ="<CH>需要写入的位</CH><EN>Bit</EN>",_type="INTC", _max=8, _min=1,_init=1},	
	{_name="Int",	_desc ="<CH>需要 写入INT 值</CH><EN>Int</EN>",_type="INTC",_max=2147483647,_min=-2147483648,_init=0},	
	{_name="Float2",	_desc ="<CH>需要 FLOAT 值</CH><EN>Float2</EN>",_type="REALC", _max=3.4e+38, _min=-3.4e+38,_init=0.0},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusSetNUM",_comm ="<CH>基础数据写入指令.</CH><EN>Bus Set Val.</EN>"},
}
function BusSetNUM(BusSetNUM_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempStAddr, TempVal, TempBit
	TempStAddr = (type(BusSetNUM_Para.StAddrInt) == "integer" or type(BusSetNUM_Para.StAddrInt) == "number") and BusSetNUM_Para.StAddrInt or BusSetNUM_Para.StAddrInt.value
	if BusSetNUM_Para.Type == "BIT" then
		TempVal = (type(BusSetNUM_Para.Int) == "integer" or type(BusSetNUM_Para.Int) == "number") and BusSetNUM_Para.Int or BusSetNUM_Para.Int.value
		TempBit = (type(BusSetNUM_Para.Bit) == "integer" or type(BusSetNUM_Para.Bit) == "number") and BusSetNUM_Para.Bit or BusSetNUM_Para.Bit.value
		bus_sbit_(TempStAddr, TempVal, TempBit)
	elseif BusSetNUM_Para.Type == "UINT8" then
		TempVal = (type(BusSetNUM_Para.Int) == "integer" or type(BusSetNUM_Para.Int) == "number") and BusSetNUM_Para.Int or BusSetNUM_Para.Int.value
		bus_sbyte_(TempStAddr, TempVal)
	elseif BusSetNUM_Para.Type == "INT16" then
		TempVal = (type(BusSetNUM_Para.Int) == "integer" or type(BusSetNUM_Para.Int) == "number") and BusSetNUM_Para.Int or BusSetNUM_Para.Int.value
		bus_ssint_(TempStAddr, TempVal)
	elseif BusSetNUM_Para.Type == "UINT16" then
		TempVal = (type(BusSetNUM_Para.Int) == "integer" or type(BusSetNUM_Para.Int) == "number") and BusSetNUM_Para.Int or BusSetNUM_Para.Int.value
		bus_susint_(TempStAddr, TempVal)
	elseif BusSetNUM_Para.Type == "INT32" then
		TempVal = (type(BusSetNUM_Para.Int) == "integer" or type(BusSetNUM_Para.Int) == "number") and BusSetNUM_Para.Int or BusSetNUM_Para.Int.value
		bus_sint_(TempStAddr, TempVal)
	elseif BusSetNUM_Para.Type == "FLOAT2" then
		TempVal = (type(BusSetNUM_Para.Float2) == "float" or type(BusSetNUM_Para.Float2) == "integer") and BusSetNUM_Para.Float2 or BusSetNUM_Para.Float2.value
		bus_sfloat2_(TempStAddr, TempVal)
	end
end

BusSetPOS_Para={
	{_name="Type",    _desc ="<CH>操作数据类型</CH><EN>Type</EN>",_type="enum",_init="CPOS",_enum={"CPOS","APOS"}, _depends={"Cpos=10","Apos=01"}},
	{_name="StAddrInt",	_desc ="<CH>SIM DO 地址</CH><EN>StAddrInt</EN>",_type="INTC",_max=2048,_min=1,_init=1},
	{_name="NumOfAxis",	_desc ="<CH>需要写入轴数量</CH><EN>NumOfAxis</EN>",_type="INTC",_max=16,_min=0,_init=6},	
	{_name="Cpos",	_desc ="<CH>需要写入的 CPOS 值</CH><EN>Cpos</EN>",_type="CPOS"},	
	{_name="Apos",	_desc ="<CH>需要写入的 APOS 值</CH><EN>Apos</EN>",_type="APOS"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusSetPOS",_comm ="<CH>位置数据写入指令指令.</CH><EN>Bus Set Pos.</EN>"},
}
function BusSetPOS(BusSetPOS_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempStAddr, TempVal, TempNumOfAxis
	TempStAddr = (type(BusSetPOS_Para.StAddrInt) == "integer" or type(BusSetPOS_Para.StAddrInt) == "number") and BusSetPOS_Para.StAddrInt or BusSetPOS_Para.StAddrInt.value
	TempNumOfAxis = (type(BusSetPOS_Para.NumOfAxis) == "integer" or type(BusSetPOS_Para.NumOfAxis) == "number") and BusSetPOS_Para.NumOfAxis or BusSetPOS_Para.NumOfAxis.value
	if BusSetPOS_Para.Type == "CPOS" then
		TempVal = BusSetPOS_Para.Cpos
		bus_scpos_(TempStAddr, TempVal, TempNumOfAxis)
	elseif BusSetPOS_Para.Type == "APOS" then
		TempVal = BusSetPOS_Para.Apos
		bus_sapos_(TempStAddr, TempVal, TempNumOfAxis)
	end
end

BusGetNUM_Para={
	{_name="Type",    _desc ="<CH>操作数据类型</CH><EN>Type</EN>",_type="enum",_init="BIT",_enum={"BIT","UINT8", "INT16", "UINT16", "INT32", "FLOAT2"}, _depends={"Int=111110","Float2=000001","Bit=100000"}},
	{_name="IoType",    _desc ="<CH>IO 类型</CH><EN>IoType</EN>",_type="enum",_init="IO_DIN",_enum={"IO_DIN","IO_DOUT"}},
	{_name="StAddrInt",	_desc ="<CH>SIM AIO 地址</CH><EN>StAddrInt</EN>",_type="INTC",_max=2048,_min=1,_init=1},
	{_name="Bit",	_desc ="<CH>需要读取的位</CH><EN>Bit</EN>",_type="INTC", _max=8, _min=1,_init=1},	
	{_name="Int",	_desc ="<CH>存储读出的 Int 值</CH><EN>Int</EN>",_type="INTC"},	
	{_name="Float2",	_desc ="<CH>存储读出的 Float 值</CH><EN>Float2</EN>",_type="REALC"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusGetNUM",_comm ="<CH>基础数据读出指令.</CH><EN>Bus Get Int.</EN>"},
}
function BusGetNUM(BusGetNUM_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempStAddr, TempVal, TempBit
	TempStAddr = (type(BusGetNUM_Para.StAddrInt) == "integer" or type(BusGetNUM_Para.StAddrInt) == "number") and BusGetNUM_Para.StAddrInt or BusGetNUM_Para.StAddrInt.value
	if BusGetNUM_Para.Type == "BIT" then
		TempBit = (type(BusGetNUM_Para.Bit) == "integer" or type(BusGetNUM_Para.Bit) == "number") and BusGetNUM_Para.Bit or BusGetNUM_Para.Bit.value
		BusGetNUM_Para.Int.value = bus_gbit_(BusGetNUM_Para.IoType, TempStAddr, TempBit)
	elseif BusGetNUM_Para.Type == "UINT8" then
		BusGetNUM_Para.Int.value = bus_gbyte_(BusGetNUM_Para.IoType, TempStAddr)
	elseif BusGetNUM_Para.Type == "INT16" then
		BusGetNUM_Para.Int.value = bus_gsint_(BusGetNUM_Para.IoType, TempStAddr)
	elseif BusGetNUM_Para.Type == "UINT16" then
		BusGetNUM_Para.Int.value = bus_gusint_(BusGetNUM_Para.IoType, TempStAddr)
	elseif BusGetNUM_Para.Type == "INT32" then
		BusGetNUM_Para.Int.value = bus_gint_(BusGetNUM_Para.IoType, TempStAddr)
	elseif BusGetNUM_Para.Type == "FLOAT2" then
		BusGetNUM_Para.Float2.value = bus_gfloat2_(BusGetNUM_Para.IoType, TempStAddr)
	end
end

BusGetPOS_Para={
	{_name="Type",    _desc ="<CH>操作数据类型</CH><EN>Type</EN>",_type="enum",_init="CPOS",_enum={"CPOS","APOS"}, _depends={"Cpos=10","Apos=01"}},
	{_name="IoType",    _desc ="<CH>IO 类型</CH><EN>IoType</EN>",_type="enum",_init="IO_DIN",_enum={"IO_DIN","IO_DOUT"}},
	{_name="StAddrInt",	_desc ="<CH>SIM AO 地址</CH><EN>StAddrInt</EN>",_type="INTC",_max=2048,_min=1,_init=1},
	{_name="NumOfAxis",	_desc ="<CH>需要写入轴数量</CH><EN>NumOfAxis</EN>",_type="INTC",_max=16,_min=0,_init=6},	
	{_name="Cpos",	_desc ="<CH>输出值</CH><EN>Cpos</EN>",_type="CPOS"},	
	{_name="Apos",	_desc ="<CH>输出值</CH><EN>Apos</EN>",_type="APOS"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusGetPOS",_comm ="<CH>位置数据读出指令.</CH><EN>Bus Get Pos.</EN>"},
}
function BusGetPOS(BusGetPOS_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempStAddr = (type(BusGetPOS_Para.StAddrInt) == "integer" or type(BusGetPOS_Para.StAddrInt) == "number") and BusGetPOS_Para.StAddrInt or BusGetPOS_Para.StAddrInt.value
	local TempNumOfAxis = (type(BusGetPOS_Para.NumOfAxis) == "integer" or type(BusGetPOS_Para.NumOfAxis) == "number") and BusGetPOS_Para.NumOfAxis or BusGetPOS_Para.NumOfAxis.value
	if BusGetPOS_Para.Type == "CPOS" then
		BusGetPOS_Para.Cpos = bus_gcpos_(BusGetPOS_Para.IoType, TempStAddr, TempNumOfAxis)
	elseif BusGetPOS_Para.Type == "APOS" then
		BusGetPOS_Para.Apos = bus_gapos_(BusGetPOS_Para.IoType, TempStAddr, TempNumOfAxis)
	end
end

BusUpdateIN_Para={
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusUpdateIN",_comm ="<CH>更新总线输入头数据.</CH><EN>Bus Update Input.</EN>"},
}
function BusUpdateIN(BusUpdateIN_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	bus_uptin_(BusUpdateIN_Para.BusIn)
end

BusUpdateOUT_Para={
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusUpdateOUT",_comm ="<CH>更新总线输出头数据.</CH><EN>Bus Update Output.</EN>"},
}
function BusUpdateOUT(BusUpdateOUT_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	bus_uptout_(BusUpdateOUT_Para.BusOut)
end

BusInitialize_Para={
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="RonId",	_desc ="<CH>(可定制参数) ID </CH><EN>RonId</EN>",_type="INTC",_max=255,_min=0,_init=0},
	{_name="ProtocolId",	_desc ="<CH>协议 ID</CH><EN>ProtocolId</EN>",_type="INTC",_max=255,_min=0,_init=64},
	{_name="Secondname",_desc ="Secondname",_type="str",_init="BusInitialize",_comm ="<CH>总线初始化.</CH><EN>Bus Initialize.</EN>"},
}
function BusInitialize(BusInitialize_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempRonId = (type(BusInitialize_Para.RonId) == "integer" or type(BusInitialize_Para.RonId) == "number" or BusInitialize_Para.RonId.value == nil) and BusInitialize_Para.RonId or BusInitialize_Para.RonId.value
	local TempProtocolId = (type(BusInitialize_Para.ProtocolId) == "integer" or type(BusInitialize_Para.ProtocolId) == "number" or BusInitialize_Para.ProtocolId.value == nil) and BusInitialize_Para.ProtocolId or BusInitialize_Para.ProtocolId.value
	bus_init_(BusInitialize_Para.BusIn, BusInitialize_Para.BusOut, TempRonId, TempProtocolId)
end

BusWaitTell_Para={
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="Timeout",	_desc ="<CH>超时时间 (ms)</CH><EN>Timeout (ms)</EN>",_type="INTC",_max=2147483647,_min=-1,_init=0},
	{_name="Result",	_desc ="<CH>输出值</CH><EN>Output Result</EN>",_type="INT"},	
	{_name="Secondname",_desc ="Secondname",_type="str",_init="BusWaitTell",_comm ="<CH>等待主控新数据输入.</CH><EN>Bus Wait Tell.</EN>"},
}
function BusWaitTell(BusWaitTell_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempTimeout = (type(BusWaitTell_Para.Timeout) == "integer" or type(BusWaitTell_Para.Timeout) == "number" or BusWaitTell_Para.Timeout.value == nil) and BusWaitTell_Para.Timeout or BusWaitTell_Para.Timeout.value
	BusWaitTell_Para.Result.value = bus_wtell_(BusWaitTell_Para.BusIn, BusWaitTell_Para.BusOut, TempTimeout)
end

BusFeekTell_Para={
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="Secondname",_desc ="Secondname",_type="str",_init="BusFeekTell",_comm ="<CH>数据反馈给主控.</CH><EN>Bus Feek Tell.</EN>"},
}
function BusFeekTell(BusFeekTell_Para)
	bus_ftell_(BusFeekTell_Para.BusIn, BusFeekTell_Para.BusOut)
end

BusNewTell_Para={
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="Timeout",	_desc ="<CH>超时时间 (ms)</CH><EN>Timeout (ms)</EN>",_type="INTC",_max=2147483647,_min=-1,_init=0},
	{_name="Result",	_desc ="<CH>输出值</CH><EN>Output Result</EN>",_type="INT"},	
	{_name="Secondname",_desc ="Secondname",_type="str",_init="BusNewTell",_comm ="<CH>更新数据给从控.</CH><EN>Bus New Tell.</EN>"},
}
function BusNewTell(BusNewTell_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempTimeout = (type(BusNewTell_Para.Timeout) == "integer" or type(BusNewTell_Para.Timeout) == "number" or BusNewTell_Para.Timeout.value == nil) and BusNewTell_Para.Timeout or BusNewTell_Para.Timeout.value
	BusNewTell_Para.Result.value = bus_ntell_(BusNewTell_Para.BusIn, BusNewTell_Para.BusOut, TempTimeout)
end


















































