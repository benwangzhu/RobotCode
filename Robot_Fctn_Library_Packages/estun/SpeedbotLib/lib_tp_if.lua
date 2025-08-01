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

function delay_(SleepTime)
	local ret = 1
	local timeStart = ins:GetCurSysClk()
	while (ret ~= 0) do
		if (ins:GetCurSysClk() - timeStart) >= SleepTime then	
			ret = 0
		else
			Sleep(1)
	    end
	end
end

function set_mutli_simdo(Type, IoStAddr, Val, IoLen)
	if (IoStAddr < 0 ) then	
		log_error_(1, {"set_mutli_simdo:Invalid start address!", "[SimDoAddr:", IoStAddr, "]"})
	end
	while true do
		mov:SetDO8421(IoStAddr, IoStAddr + IoLen - 1, Val, 1)
		if bit_2val_(Type, get_simio_("BIT", "SIMDO", IoStAddr, IoLen)) == Val then
			break
		else
			Sleep(1)
		end
	end
end

function set_simdo_(Type, IoStAddr, Val, IoLen)
	if (IoStAddr < 0 ) then	
		log_error_(1, {"set_simdo_:Invalid start address!", "[SimDoAddr:", IoStAddr, "]"})
	end

	if Type == "BIT" then
		for i = 1, IoLen do
			if Val[i] < 0 or Val[i] > 1 then
				log_error_(1, {"set_simdo_:Invalid Val!", "[Type:", Type, ",Addr:", IoStAddr, ",Val:", Val[i], "]"})
				return
			end
			set_mutli_simdo("BIT", IoStAddr + i - 1, Val[i], 1)
		end
	elseif Type == "UINT8" then
		if type(Val) ~= "integer" then
			log_error_(1, {"set_simdo_:The input data is not of type number!"})
		end
		if (Val < 0 or Val > 255) then	
			log_error_(1, {"set_simdo_:Invalid Val!", "[Type:", Type, ",Addr:", IoStAddr, ",Val:", Val, "]"})
			return
		end
		set_mutli_simdo("UINT8", IoStAddr, Val, 8)
	elseif Type == "UINT16" then
		if type(Val) ~= "integer" then
			log_error_(1, {"set_simdo_:The input data is not of type integer!"})
		end
		if (Val < 0 or Val > 65535) then	
			log_error_(1, {"set_simdo_:Invalid Val!", "[Type:", Type, ",Addr:", IoStAddr, ",Val:", Val, "]"})
			return
		end
		set_mutli_simdo("UINT16", IoStAddr, Val, 16)
	elseif Type == "INT16" then
		if type(Val) ~= "integer" then
			log_error_(1, {"set_simdo_:The input data is not of type integer!"})
		end
		if (Val < -32768 or Val > 32767) then
			log_error_(1, {"set_simdo_:Invalid Val!", "[Type:", Type, ",Addr:", IoStAddr, ",Val:", Val, "]"})
			return
		end
		set_mutli_simdo("UINT16", IoStAddr, Val < 0 and Val + 65536 or Val, 16)
	elseif Type == "INT32" then
		if type(Val) ~= "integer" then
			log_error_(1, {"set_simdo_:The input data is not of type integer!"})
		end
		local byteVal = {Val % 256, math.floor(Val / 256) % 256, math.floor(Val / (256^2)) % 256, math.floor(Val / (256^3)) % 256}
		set_mutli_simdo("UINT16", IoStAddr + 0,  byteVal[2] * 256 + byteVal[1], 16)
		set_mutli_simdo("UINT16", IoStAddr + 16, byteVal[4] * 256 + byteVal[3], 16)
	else
		log_error_(1, {"set_simdo_:Invalid Type!", "[Type:", Type, "]"})
	end
end 

function get_simio_(Type, IoType, IoStAddr, IoLen)
	local TempVal

	if (IoStAddr < 0 ) then	
		log_error_(1, {"set_simdo_:Invalid start address!", "[SimDoAddr:", IoStAddr, "]"})
	end

	if Type == "BIT" then
		local Bit = {}
		if IoType == "SIMDO" then
			for i = 1, IoLen do
				table.insert(Bit, mov:GetSimDO(IoStAddr + i - 1))
			end
		elseif IoType == "SIMDI" then
			for i = 1, IoLen do
				table.insert(Bit, mov:GetSimDI(IoStAddr + i - 1))
			end
		else
			log_error_(1, {"get_simio_:Invalid IoType!", "[IoType:", IoType, "]"})
		end
		return Bit
	elseif Type == "UINT8" then
		if IoType == "SIMDO" then
			return bit_2val_("UINT8",get_simio_("BIT", "SIMDO", IoStAddr, 8))
		elseif IoType == "SIMDI" then
			return mov:GetDI8421(IoStAddr, IoStAddr + 7, 1)
		else
			log_error_(1, {"get_simio_:Invalid IoType!", "[IoType:", IoType, "]"})
		end
	elseif Type == "UINT16" then
		if IoType == "SIMDO" then
			return bit_2val_("UINT16",get_simio_("BIT", "SIMDO", IoStAddr, 16))
		elseif IoType == "SIMDI" then
			return mov:GetDI8421(IoStAddr, IoStAddr + 15, 1)
		else
			log_error_(1, {"get_simio_:Invalid IoType!", "[IoType:", IoType, "]"})
		end
	elseif Type == "INT16" then
		if IoType == "SIMDO" then
			TempVal = bit_2val_("UINT16",get_simio_("BIT", "SIMDO", IoStAddr, 16))
		elseif IoType == "SIMDI" then
			TempVal = mov:GetDI8421(IoStAddr, IoStAddr + 15, 1)
		else
			log_error_(1, {"get_simio_:Invalid IoType!", "[IoType:", IoType, "]"})
		end
		return TempVal > 32767 and TempVal - 65536 or TempVal
	elseif Type == "INT32" then
		if IoType == "SIMDO" then
			TempVal,_ = bit_2val_("INT32",get_simio_("BIT", "SIMDO", IoStAddr, 32))
		elseif IoType == "SIMDI" then
			local byteValue = {mov:GetDI8421(IoStAddr + 0, IoStAddr + 7,1), mov:GetDI8421(IoStAddr + 8, IoStAddr + 15,1), mov:GetDI8421(IoStAddr + 16, IoStAddr + 23,1), mov:GetDI8421(IoStAddr + 24, IoStAddr + 31,1)}
			TempVal = ins:BitOperation(5, byteValue[4], 24) + ins:BitOperation(5, byteValue[3], 16) + ins:BitOperation(5, byteValue[2], 8) + byteValue[1]
		else
			log_error_(1, {"get_simio_:Invalid IoType!", "[IoType:", IoType, "]"})
		end
		return TempVal
	else
		log_error_(1, {"get_simio_:Invalid Type!", "[Type:", Type, "]"})
	end
end

function wait_simio_(IoType, IoStAddr, Val, TimeParam)
    local n
	local TimeCount = ins:GetCurSysClk()
	local Res = 0
	local CopyTimeParam = TimeParam == nil and 0 or TimeParam

	if (IoStAddr < 0 ) then	
		log_error_(1, {"wait_simio_:Invalid start address!", "[IoStAddr:", IoStAddr, "]"})
	end
	if Val < 0 or Val > 1 then
		log_error_(1, {"set_simdo_:Invalid Val!", "[Val:", Val, "]"})
		return
	end
	repeat
		n = get_simio_("BIT", IoType, IoStAddr, 1)
		if n[1] == Val then 
			break
		else
			Sleep(1)
		end
	    if CopyTimeParam ~= 0 then
		  if (ins:GetCurSysClk() - TimeCount) >= CopyTimeParam then  -----判断条件为超时退出
		      Res = -1
			  break
	       end
		end
	until false
	return Res
end

