--***********************************************************
--
-- Copyright 2018 - 2025 speedbot All Rights reserved.
--
-- file Name: lib_buscmd
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

function buscmd_wo_(BusCmdId, BusMstSel, BusIn, BusOut)
	if BusMstSel == "BUSCMD_MST" then
		BusOut.RobMsgType = BusCmdId
		bus_stell_(BusIn, BusOut)
	elseif BusMstSel == "BUSCMD_SLE" then
		BusOut.MsgType = BusCmdId
		bus_ftell_(BusIn, BusOut)
    else
        log_error_(1, {"buscmd_wo_:Invalid BusMstSel!", "[BusMstSel:", BusMstSel, "]"})
	end
end

function buscmd_ro_(BusCmdId, BusMstSel, BusIn, BusOut, BusTimeout)
	local TempBusTimeout = BusTimeout or -1
	local Status
    if BusMstSel == "BUSCMD_MST" then
        Status = bus_rtell_(BusIn, BusOut, TempBusTimeout)
        bus_sbyte_(BusOut.BusIoSt + 7, 0)
        if (Status ~= 0) then
            log_warn_(1, {"buscmd_ro_:Command processing failed!", "[BusCmdId:", BusCmdId, "]", "[Res:", Status, "]"})
            return Status
        end
        if (BusIn.MsgType ~= BusCmdId) then 
            log_error_(1, {"buscmd_ro_:Invalid CmdId received!", "[BusCmdId:", BusCmdId, "]", "[MsgType:", BusIn.MsgType, "]"})
            return(-1)
        end
    elseif BusMstSel == "BUSCMD_SLE" then
        Status = bus_wtell_(BusIn, BusOut, TempBusTimeout)
        if (Status ~= 0) then 
            log_warn_(1, {"buscmd_ro_:Command processing failed!", "[BusCmdId:", BusCmdId, "]", "[Res:", Status, "]"})
            return Status
        end
        if (BusIn.AgentMsgType ~= BusCmdId) then 
            log_error_(1, {"buscmd_ro_:Invalid CmdId received!", "[BusCmdId:", BusCmdId, "]", "[MsgType:", BusIn.AgentMsgType, "]"})
            return -1
        end
    else
        log_error_(1, {"buscmd_wo_:Invalid BusMstSel!", "[BusMstSel:", BusMstSel, "]"})
    end
	return Status
end

function bus_cmd001_(BusOperation, BusMstSel, BusIn, BusOut, BusTimeout)
	local TempBusTimeout = BusTimeout or -1
	if BusOperation == "BUSCMD_WRITE" then
        return buscmd_wo_(1, BusMstSel, BusIn, BusOut)
	elseif BusOperation == "BUSCMD_READ" then
        return buscmd_ro_(1, BusMstSel, BusIn, BusOut, TempBusTimeout)
    else
        log_error_(1, {"bus_cmd001_:Invalid BusOperation!", "[BusOperation:", BusOperation, "]"})
	end
end

function bus_cmd002_(BusOperation, BusMstSel, BusIn, BusOut, BusData, BusTimeout)
	local TempBusTimeout = BusTimeout or -1
	if BusOperation == "BUSCMD_WRITE" then
        bus_sbyte_(BusOut.BusIoSt + 8, BusData.Byte01 or 0)
        bus_sbyte_(BusOut.BusIoSt + 9, BusData.Byte02 or 0)
        bus_susint_(BusOut.BusIoSt + 10, BusData.Short03 or 0)
        bus_susint_(BusOut.BusIoSt + 12, BusData.Short04 or 0)
        bus_sint_(BusOut.BusIoSt + 14, BusData.Int05 or 0)
        bus_sint_(BusOut.BusIoSt + 18, BusData.Int06 or 0)
        bus_sfloat2_(BusOut.BusIoSt + 22, BusData.Float07 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 26, BusData.Float08 or 0.0)
        return buscmd_wo_(2, BusMstSel, BusIn, BusOut)
	elseif BusOperation == "BUSCMD_READ" then
		if buscmd_ro_(2, BusMstSel, BusIn, BusOut, TempBusTimeout) ~= 0 then
			if BusData ~= nil then
				for k in pairs(BusData) do 
                    BusData[k] = nil 
                end
			end
			return -1
		end
        BusData.Byte01 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 8)
        BusData.Byte02 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 9)
        BusData.Short03 = bus_gusint_("IO_DIN", BusIn.BusIoSt + 10)
        BusData.Short04 = bus_gusint_("IO_DIN", BusIn.BusIoSt + 12)
        BusData.Int05 = bus_gint_("IO_DIN", BusIn.BusIoSt + 14)
        BusData.Int06 = bus_gint_("IO_DIN", BusIn.BusIoSt + 18)
        BusData.Float07 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 22)
        BusData.Float08 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 26)
        return 0
    else
        log_error_(1, {"bus_cmd002_:Invalid BusOperation!", "[BusOperation:", BusOperation, "]"})
	end
end

function bus_cmd003_(BusOperation, BusMstSel, BusIn, BusOut, BusData, BusTimeout)
	local TempBusTimeout = BusTimeout or -1
	if BusOperation == "BUSCMD_WRITE" then
        bus_scpos_(BusOut.BusIoSt + 8, BusData, 6)
        return buscmd_wo_(3, BusMstSel, BusIn, BusOut)
	elseif BusOperation == "BUSCMD_READ" then
		if buscmd_ro_(3, BusMstSel, BusIn, BusOut, TempBusTimeout) ~= 0 then
			if BusData ~= nil then
				for k in pairs(BusData) do 
                    BusData[k] = nil 
                end
			end
			return -1
		end
        BusData = bus_gcpos_("IO_DIN", BusIn.BusIoSt + 8, 6)
        return 0
    else
        log_error_(1, {"bus_cmd003_:Invalid BusOperation!", "[BusOperation:", BusOperation, "]"})
	end
end

function bus_cmd009_(BusOperation, BusMstSel, BusIn, BusOut, BusData, BusTimeout)
	local TempBusTimeout = BusTimeout or -1
	if BusOperation == "BUSCMD_WRITE" then
        bus_scpos_(BusOut.BusIoSt + 8, BusData, 6)
        return buscmd_wo_(9, BusMstSel, BusIn, BusOut)
	elseif BusOperation == "BUSCMD_READ" then
		if buscmd_ro_(9, BusMstSel, BusIn, BusOut, TempBusTimeout) ~= 0 then
			if BusData ~= nil then
				for k in pairs(BusData) do 
                    BusData[k] = nil 
                end
			end
			return -1
		end
        BusData = bus_gcpos_("IO_DIN", BusIn.BusIoSt + 8, 6)
        return 0
    else
        log_error_(1, {"bus_cmd009_:Invalid BusOperation!", "[BusOperation:", BusOperation, "]"})
	end
end

function bus_cmd010_(BusOperation, BusMstSel, BusIn, BusOut, BusData, BusTimeout)
	local TempBusTimeout = BusTimeout or -1
	if BusOperation == "BUSCMD_WRITE" then
        bus_scpos_(BusOut.BusIoSt + 8, BusData, 6)
        return buscmd_wo_(10, BusMstSel, BusIn, BusOut)
	elseif BusOperation == "BUSCMD_READ" then
		if buscmd_ro_(10, BusMstSel, BusIn, BusOut, TempBusTimeout) ~= 0 then
			if BusData ~= nil then
				for k in pairs(BusData) do 
                    BusData[k] = nil 
                end
			end
			return -1
		end
        BusData = bus_gcpos_("IO_DIN", BusIn.BusIoSt + 8, 6)
        return 0
    else
        log_error_(1, {"bus_cmd010_:Invalid BusOperation!", "[BusOperation:", BusOperation, "]"})
	end
end

function bus_cmd011_(BusOperation, BusMstSel, BusIn, BusOut, BusData, BusTimeout)
	local TempBusTimeout = BusTimeout or -1
	if BusOperation == "BUSCMD_WRITE" then
        bus_scpos_(BusOut.BusIoSt + 8, BusData, 6)
        return buscmd_wo_(11, BusMstSel, BusIn, BusOut)
	elseif BusOperation == "BUSCMD_READ" then
		if buscmd_ro_(11, BusMstSel, BusIn, BusOut, TempBusTimeout) ~= 0 then
			if BusData ~= nil then
				for k in pairs(BusData) do 
                    BusData[k] = nil 
                end
			end
			return -1
		end
        BusData = bus_gcpos_("IO_DIN", BusIn.BusIoSt + 8, 6)
        return 0
    else
        log_error_(1, {"bus_cmd011_:Invalid BusOperation!", "[BusOperation:", BusOperation, "]"})
	end
end

function bus_cmd012_(BusOperation, BusMstSel, BusIn, BusOut, BusData, BusTimeout)
	local TempBusTimeout = BusTimeout or -1
	if BusOperation == "BUSCMD_WRITE" then
        bus_scpos_(BusOut.BusIoSt + 8, BusData, 6)
        return buscmd_wo_(12, BusMstSel, BusIn, BusOut)
	elseif BusOperation == "BUSCMD_READ" then
		if buscmd_ro_(12, BusMstSel, BusIn, BusOut, TempBusTimeout) ~= 0 then
			if BusData ~= nil then
				for k in pairs(BusData) do 
                    BusData[k] = nil 
                end
			end
			return -1
		end
        BusData = bus_gcpos_("IO_DIN", BusIn.BusIoSt + 8, 6)
        return 0
    else
        log_error_(1, {"bus_cmd012_:Invalid BusOperation!", "[BusOperation:", BusOperation, "]"})
	end
end

function bus_cmd013_(BusOperation, BusMstSel, BusIn, BusOut, BusData, BusTimeout)
	local TempBusTimeout = BusTimeout or -1
	if BusOperation == "BUSCMD_WRITE" then
        bus_sbyte_(BusOut.BusIoSt + 8, BusData.Byte01 or 0)
        bus_sbyte_(BusOut.BusIoSt + 9, BusData.Byte02 or 0)
        bus_susint_(BusOut.BusIoSt + 10, BusData.Short03 or 0)
        bus_susint_(BusOut.BusIoSt + 12, BusData.Short04 or 0)
        bus_sint_(BusOut.BusIoSt + 14, BusData.Int05 or 0)
        bus_sint_(BusOut.BusIoSt + 18, BusData.Int06 or 0)
        bus_sfloat2_(BusOut.BusIoSt + 22, BusData.Float07 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 26, BusData.Float08 or 0.0)
        return buscmd_wo_(13, BusMstSel, BusIn, BusOut)
	elseif BusOperation == "BUSCMD_READ" then
		if buscmd_ro_(13, BusMstSel, BusIn, BusOut, TempBusTimeout) ~= 0 then
			if BusData ~= nil then
				for k in pairs(BusData) do 
                    BusData[k] = nil 
                end
			end
			return -1
		end
        BusData.Byte01 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 8)
        BusData.Byte02 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 9)
        BusData.Short03 = bus_gusint_("IO_DIN", BusIn.BusIoSt + 10)
        BusData.Short04 = bus_gusint_("IO_DIN", BusIn.BusIoSt + 12)
        BusData.Int05 = bus_gint_("IO_DIN", BusIn.BusIoSt + 14)
        BusData.Int06 = bus_gint_("IO_DIN", BusIn.BusIoSt + 18)
        BusData.Float07 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 22)
        BusData.Float08 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 26)
        return 0
    else
        log_error_(1, {"bus_cmd013_:Invalid BusOperation!", "[BusOperation:", BusOperation, "]"})
	end
end

function bus_cmd014_(BusOperation, BusMstSel, BusIn, BusOut, BusData, BusTimeout)
	local TempBusTimeout = BusTimeout or -1
	if BusOperation == "BUSCMD_WRITE" then
        bus_sbyte_(BusOut.BusIoSt + 8, BusData.Byte01 or 0)
        bus_sbyte_(BusOut.BusIoSt + 9, BusData.Byte02 or 0)
        bus_susint_(BusOut.BusIoSt + 10, BusData.Short03 or 0)
        bus_susint_(BusOut.BusIoSt + 12, BusData.Short04 or 0)
        bus_sint_(BusOut.BusIoSt + 14, BusData.Int05 or 0)
        bus_sint_(BusOut.BusIoSt + 18, BusData.Int06 or 0)
        bus_sfloat2_(BusOut.BusIoSt + 22, BusData.Float07 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 26, BusData.Float08 or 0.0)
        return buscmd_wo_(14, BusMstSel, BusIn, BusOut)
	elseif BusOperation == "BUSCMD_READ" then
		if buscmd_ro_(14, BusMstSel, BusIn, BusOut, TempBusTimeout) ~= 0 then
			if BusData ~= nil then
				for k in pairs(BusData) do 
                    BusData[k] = nil 
                end
			end
			return -1
		end
        BusData.Byte01 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 8)
        BusData.Byte02 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 9)
        BusData.Short03 = bus_gusint_("IO_DIN", BusIn.BusIoSt + 10)
        BusData.Short04 = bus_gusint_("IO_DIN", BusIn.BusIoSt + 12)
        BusData.Int05 = bus_gint_("IO_DIN", BusIn.BusIoSt + 14)
        BusData.Int06 = bus_gint_("IO_DIN", BusIn.BusIoSt + 18)
        BusData.Float07 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 22)
        BusData.Float08 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 26)
        return 0
    else
        log_error_(1, {"bus_cmd014_:Invalid BusOperation!", "[BusOperation:", BusOperation, "]"})
	end
end

function bus_cmd017_(BusOperation, BusMstSel, BusIn, BusOut, BusData, BusTimeout)
	local TempBusTimeout = BusTimeout or -1
	if BusOperation == "BUSCMD_WRITE" then
        bus_sfloat2_(BusOut.BusIoSt + 8, BusData.Float01 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 12, BusData.Float02 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 16, BusData.Float03 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 20, BusData.Float04 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 24, BusData.Float05 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 28, BusData.Float06 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 32, BusData.Float07 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 36, BusData.Float08 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 40, BusData.Float09 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 44, BusData.Float10 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 48, BusData.Float11 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 52, BusData.Float12 or 0.0)
        bus_sint_(BusOut.BusIoSt + 56, BusData.Int13 or 0.0)
        bus_sint_(BusOut.BusIoSt + 60, BusData.Int14 or 0.0)
    return buscmd_wo_(17, BusMstSel, BusIn, BusOut)
	elseif BusOperation == "BUSCMD_READ" then
		if buscmd_ro_(17, BusMstSel, BusIn, BusOut, TempBusTimeout) ~= 0 then
			if BusData ~= nil then
				for k in pairs(BusData) do 
                    BusData[k] = nil 
                end
			end
			return -1
		end
        BusData.Float01 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 8)
        BusData.Float02 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 12)
        BusData.Float03 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 16)
        BusData.Float04 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 20)
        BusData.Float05 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 24)
        BusData.Float06 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 28)
        BusData.Float07 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 32)
        BusData.Float08 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 36)
        BusData.Float09 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 40)
        BusData.Float10 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 44)
        BusData.Float11 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 48)
        BusData.Float12 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 52)
        BusData.Int13 = bus_gint_("IO_DIN", BusIn.BusIoSt + 56)
        BusData.Int14 = bus_gint_("IO_DIN", BusIn.BusIoSt + 60)
    return 0
    else
        log_error_(1, {"bus_cmd017_:Invalid BusOperation!", "[BusOperation:", BusOperation, "]"})
	end
end

function bus_cmd018_(BusOperation, BusMstSel, BusIn, BusOut, BusData, BusTimeout)
	local TempBusTimeout = BusTimeout or -1
	if BusOperation == "BUSCMD_WRITE" then
        bus_sfloat2_(BusOut.BusIoSt + 8, BusData.Float01 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 12, BusData.Float02 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 16, BusData.Float03 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 20, BusData.Float04 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 24, BusData.Float05 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 28, BusData.Float06 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 32, BusData.Float07 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 36, BusData.Float08 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 40, BusData.Float09 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 44, BusData.Float10 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 48, BusData.Float11 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 52, BusData.Float12 or 0.0)
        bus_sint_(BusOut.BusIoSt + 56, BusData.Int13 or 0.0)
        bus_sint_(BusOut.BusIoSt + 60, BusData.Int14 or 0.0)
        return buscmd_wo_(18, BusMstSel, BusIn, BusOut)
	elseif BusOperation == "BUSCMD_READ" then
		if buscmd_ro_(18, BusMstSel, BusIn, BusOut, TempBusTimeout) ~= 0 then
			if BusData ~= nil then
				for k in pairs(BusData) do 
                    BusData[k] = nil 
                end
			end
			return -1
		end
        BusData.Float01 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 8)
        BusData.Float02 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 12)
        BusData.Float03 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 16)
        BusData.Float04 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 20)
        BusData.Float05 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 24)
        BusData.Float06 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 28)
        BusData.Float07 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 32)
        BusData.Float08 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 36)
        BusData.Float09 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 40)
        BusData.Float10 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 44)
        BusData.Float11 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 48)
        BusData.Float12 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 52)
        BusData.Int13 = bus_gint_("IO_DIN", BusIn.BusIoSt + 56)
        BusData.Int14 = bus_gint_("IO_DIN", BusIn.BusIoSt + 60)
        return 0
    else
        log_error_(1, {"bus_cmd018_:Invalid BusOperation!", "[BusOperation:", BusOperation, "]"})
	end
end

function bus_cmd020_(BusOperation, BusMstSel, BusIn, BusOut, BusData, BusTimeout)
	local TempBusTimeout = BusTimeout or -1
	if BusOperation == "BUSCMD_WRITE" then
        bus_scpos_(BusOut.BusIoSt + 8, BusData, 6)
        return buscmd_wo_(20, BusMstSel, BusIn, BusOut)
	elseif BusOperation == "BUSCMD_READ" then
		if buscmd_ro_(20, BusMstSel, BusIn, BusOut, TempBusTimeout) ~= 0 then
			if BusData ~= nil then
				for k in pairs(BusData) do 
                    BusData[k] = nil 
                end
			end
			return -1
		end
        BusData = bus_gcpos_("IO_DIN", BusIn.BusIoSt + 8, 6)
        return 0
    else
        log_error_(1, {"bus_cmd020_:Invalid BusOperation!", "[BusOperation:", BusOperation, "]"})
	end
end

function bus_cmd021_(BusOperation, BusMstSel, BusIn, BusOut, BusData, BusTimeout)
	local TempBusTimeout = BusTimeout or -1
	if BusOperation == "BUSCMD_WRITE" then
        bus_sbyte_(BusOut.BusIoSt + 8, BusData.Byte01 or 0)
        bus_sbyte_(BusOut.BusIoSt + 9, BusData.Byte02 or 0)
        bus_susint_(BusOut.BusIoSt + 10, BusData.Short03 or 0)
        bus_susint_(BusOut.BusIoSt + 12, BusData.Short04 or 0)
        bus_sint_(BusOut.BusIoSt + 14, BusData.Int05 or 0)
        bus_sint_(BusOut.BusIoSt + 18, BusData.Int06 or 0)
        bus_sfloat2_(BusOut.BusIoSt + 22, BusData.Float07 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 26, BusData.Float08 or 0.0)
        return buscmd_wo_(21, BusMstSel, BusIn, BusOut)
	elseif BusOperation == "BUSCMD_READ" then
		if buscmd_ro_(21, BusMstSel, BusIn, BusOut, TempBusTimeout) ~= 0 then
			if BusData ~= nil then
				for k in pairs(BusData) do 
                    BusData[k] = nil 
                end
			end
			return -1
		end
        BusData.Byte01 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 8)
        BusData.Byte02 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 9)
        BusData.Short03 = bus_gusint_("IO_DIN", BusIn.BusIoSt + 10)
        BusData.Short04 = bus_gusint_("IO_DIN", BusIn.BusIoSt + 12)
        BusData.Int05 = bus_gint_("IO_DIN", BusIn.BusIoSt + 14)
        BusData.Int06 = bus_gint_("IO_DIN", BusIn.BusIoSt + 18)
        BusData.Float07 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 22)
        BusData.Float08 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 26)
        return 0
    else
        log_error_(1, {"bus_cmd021_:Invalid BusOperation!", "[BusOperation:", BusOperation, "]"})
	end
end

function bus_cmd022_(BusOperation, BusMstSel, BusIn, BusOut, BusData, BusTimeout)
	local TempBusTimeout = BusTimeout or -1
	if BusOperation == "BUSCMD_WRITE" then
        bus_sbyte_(BusOut.BusIoSt + 8, BusData.Byte01 or 0)
        bus_sbyte_(BusOut.BusIoSt + 9, BusData.Byte02 or 0)
        bus_susint_(BusOut.BusIoSt + 10, BusData.Short03 or 0)
        bus_susint_(BusOut.BusIoSt + 12, BusData.Short04 or 0)
        bus_sint_(BusOut.BusIoSt + 14, BusData.Int05 or 0)
        bus_sint_(BusOut.BusIoSt + 18, BusData.Int06 or 0)
        bus_sfloat2_(BusOut.BusIoSt + 22, BusData.Float07 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 26, BusData.Float08 or 0.0)
        return buscmd_wo_(22, BusMstSel, BusIn, BusOut)
	elseif BusOperation == "BUSCMD_READ" then
		if buscmd_ro_(22, BusMstSel, BusIn, BusOut, TempBusTimeout) ~= 0 then
			if BusData ~= nil then
				for k in pairs(BusData) do 
                    BusData[k] = nil 
                end
			end
			return -1
		end
        BusData.Byte01 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 8)
        BusData.Byte02 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 9)
        BusData.Short03 = bus_gusint_("IO_DIN", BusIn.BusIoSt + 10)
        BusData.Short04 = bus_gusint_("IO_DIN", BusIn.BusIoSt + 12)
        BusData.Int05 = bus_gint_("IO_DIN", BusIn.BusIoSt + 14)
        BusData.Int06 = bus_gint_("IO_DIN", BusIn.BusIoSt + 18)
        BusData.Float07 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 22)
        BusData.Float08 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 26)
        return 0
    else
        log_error_(1, {"bus_cmd022_:Invalid BusOperation!", "[BusOperation:", BusOperation, "]"})
	end
end

function bus_cmd026_(BusOperation, BusMstSel, BusIn, BusOut, BusData, BusTimeout)
	local TempBusTimeout = BusTimeout or -1
	if BusOperation == "BUSCMD_WRITE" then
        bus_sbyte_(BusOut.BusIoSt + 8, BusData.Byte01 or 0)
        bus_sbyte_(BusOut.BusIoSt + 9, BusData.Byte02 or 0)
        bus_susint_(BusOut.BusIoSt + 10, BusData.Short03 or 0)
        bus_susint_(BusOut.BusIoSt + 12, BusData.Short04 or 0)
        bus_sint_(BusOut.BusIoSt + 14, BusData.Int05 or 0)
        bus_sint_(BusOut.BusIoSt + 18, BusData.Int06 or 0)
        bus_sfloat2_(BusOut.BusIoSt + 22, BusData.Float07 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 26, BusData.Float08 or 0.0)
        return buscmd_wo_(26, BusMstSel, BusIn, BusOut)
	elseif BusOperation == "BUSCMD_READ" then
		if buscmd_ro_(26, BusMstSel, BusIn, BusOut, TempBusTimeout) ~= 0 then
			if BusData ~= nil then
				for k in pairs(BusData) do 
                    BusData[k] = nil 
                end
			end
			return -1
		end
        BusData.Byte01 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 8)
        BusData.Byte02 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 9)
        BusData.Short03 = bus_gusint_("IO_DIN", BusIn.BusIoSt + 10)
        BusData.Short04 = bus_gusint_("IO_DIN", BusIn.BusIoSt + 12)
        BusData.Int05 = bus_gint_("IO_DIN", BusIn.BusIoSt + 14)
        BusData.Int06 = bus_gint_("IO_DIN", BusIn.BusIoSt + 18)
        BusData.Float07 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 22)
        BusData.Float08 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 26)
        return 0
    else
        log_error_(1, {"bus_cmd026_:Invalid BusOperation!", "[BusOperation:", BusOperation, "]"})
	end
end

function bus_cmd027_(BusOperation, BusMstSel, BusIn, BusOut, BusData, BusTimeout)
	local TempBusTimeout = BusTimeout or -1
	if BusOperation == "BUSCMD_WRITE" then
        bus_sbyte_(BusOut.BusIoSt + 8, BusData.Byte01 or 0)
        bus_sbyte_(BusOut.BusIoSt + 9, BusData.Byte02 or 0)
        bus_sbyte_(BusOut.BusIoSt + 10, BusData.Byte03 or 0)
        bus_sbyte_(BusOut.BusIoSt + 11, BusData.Byte04 or 0)
        bus_susint_(BusOut.BusIoSt + 12, BusData.Short05 or 0)
        bus_susint_(BusOut.BusIoSt + 14, BusData.Short06 or 0)
        bus_susint_(BusOut.BusIoSt + 16, BusData.Short07 or 0)
        bus_susint_(BusOut.BusIoSt + 18, BusData.Short08 or 0)
        bus_sint_(BusOut.BusIoSt + 20, BusData.Int09 or 0)
        bus_sint_(BusOut.BusIoSt + 24, BusData.Int10 or 0)
        bus_sint_(BusOut.BusIoSt + 28, BusData.Int11 or 0)
        bus_sint_(BusOut.BusIoSt + 32, BusData.Int12 or 0)
        bus_sfloat2_(BusOut.BusIoSt + 36, BusData.Float13 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 40, BusData.Float14 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 44, BusData.Float15 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 48, BusData.Float16 or 0.0)
        return buscmd_wo_(27, BusMstSel, BusIn, BusOut)
	elseif BusOperation == "BUSCMD_READ" then
		if buscmd_ro_(27, BusMstSel, BusIn, BusOut, TempBusTimeout) ~= 0 then
			if BusData ~= nil then
				for k in pairs(BusData) do 
                    BusData[k] = nil 
                end
			end
			return -1
		end
        BusData.Byte01 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 8)
        BusData.Byte02 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 9)
        BusData.Byte03 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 10)
        BusData.Byte04 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 11)
        BusData.Short05 = bus_gusint_("IO_DIN", BusIn.BusIoSt + 12)
        BusData.Short06 = bus_gusint_("IO_DIN", BusIn.BusIoSt + 14)
        BusData.Short07 = bus_gusint_("IO_DIN", BusIn.BusIoSt + 16)
        BusData.Short08 = bus_gusint_("IO_DIN", BusIn.BusIoSt + 18)
        BusData.Int09 = bus_gint_("IO_DIN", BusIn.BusIoSt + 20)
        BusData.Int10 = bus_gint_("IO_DIN", BusIn.BusIoSt + 24)
        BusData.Int11 = bus_gint_("IO_DIN", BusIn.BusIoSt + 28)
        BusData.Int12 = bus_gint_("IO_DIN", BusIn.BusIoSt + 32)
        BusData.Float13 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 36)
        BusData.Float14 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 40)
        BusData.Float15 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 44)
        BusData.Float16 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 48)
    return 0
    else
        log_error_(1, {"bus_cmd027_:Invalid BusOperation!", "[BusOperation:", BusOperation, "]"})
	end
end

function bus_cmd129_(BusOperation, BusMstSel, BusIn, BusOut, BusData, BusTimeout)
	local TempBusTimeout = BusTimeout or -1
	if BusOperation == "BUSCMD_WRITE" then
        bus_scpos_(BusOut.BusIoSt + 8, BusData, 6)
        return buscmd_wo_(129, BusMstSel, BusIn, BusOut)
	elseif BusOperation == "BUSCMD_READ" then
		if buscmd_ro_(129, BusMstSel, BusIn, BusOut, TempBusTimeout) ~= 0 then
			if BusData ~= nil then
				for k in pairs(BusData) do 
                    BusData[k] = nil 
                end
			end
			return -1
		end
        BusData = bus_gcpos_("IO_DIN", BusIn.BusIoSt + 8, 6)
        return 0
    else
        log_error_(1, {"bus_cmd129_:Invalid BusOperation!", "[BusOperation:", BusOperation, "]"})
	end
end

function bus_cmd130_(BusOperation, BusMstSel, BusIn, BusOut, BusData, BusTimeout)
	local TempBusTimeout = BusTimeout or -1
	if BusOperation == "BUSCMD_WRITE" then
        bus_sapos_(BusOut.BusIoSt + 8, BusData, 6)
        return buscmd_wo_(130, BusMstSel, BusIn, BusOut)
	elseif BusOperation == "BUSCMD_READ" then
		if buscmd_ro_(130, BusMstSel, BusIn, BusOut, TempBusTimeout) ~= 0 then
			if BusData ~= nil then
				for k in pairs(BusData) do 
                    BusData[k] = nil 
                end
			end
			return -1
		end
        BusData = bus_gapos_("IO_DIN", BusIn.BusIoSt + 8, 6)
        return 0
    else
        log_error_(1, {"bus_cmd130_:Invalid BusOperation!", "[BusOperation:", BusOperation, "]"})
	end
end

function bus_cmd131_(BusOperation, BusMstSel, BusIn, BusOut, BusData, BusTimeout)
	local TempBusTimeout = BusTimeout or -1
	if BusOperation == "BUSCMD_WRITE" then
        bus_sfloat2_(BusOut.BusIoSt + 8, BusData.Float01 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 12, BusData.Float02 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 16, BusData.Float03 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 20, BusData.Float04 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 24, BusData.Float05 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 28, BusData.Float06 or 0.0)
        return buscmd_wo_(131, BusMstSel, BusIn, BusOut)
	elseif BusOperation == "BUSCMD_READ" then
		if buscmd_ro_(131, BusMstSel, BusIn, BusOut, TempBusTimeout) ~= 0 then
			if BusData ~= nil then
				for k in pairs(BusData) do 
                    BusData[k] = nil 
                end
			end
			return -1
		end
        BusData.Float01 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 8)
        BusData.Float02 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 12)
        BusData.Float03 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 16)
        BusData.Float04 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 20)
        BusData.Float05 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 24)
        BusData.Float06 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 28)
        return 0
    else
        log_error_(1, {"bus_cmd131_:Invalid BusOperation!", "[BusOperation:", BusOperation, "]"})
	end
end

function bus_cmd132_(BusOperation, BusMstSel, BusIn, BusOut, BusData, BusTimeout)
	local TempBusTimeout = BusTimeout or -1
	if BusOperation == "BUSCMD_WRITE" then
        bus_sfloat2_(BusOut.BusIoSt + 8, BusData.Float01 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 12, BusData.Float02 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 16, BusData.Float03 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 20, BusData.Float04 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 24, BusData.Float05 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 28, BusData.Float06 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 32, BusData.Float07 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 36, BusData.Float08 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 40, BusData.Float09 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 44, BusData.Float10 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 48, BusData.Float11 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 52, BusData.Float12 or 0.0)
        bus_sint_(BusOut.BusIoSt + 56, BusData.Int13 or 0.0)
        bus_sint_(BusOut.BusIoSt + 60, BusData.Int14 or 0.0)
        return buscmd_wo_(132, BusMstSel, BusIn, BusOut)
	elseif BusOperation == "BUSCMD_READ" then
		if buscmd_ro_(132, BusMstSel, BusIn, BusOut, TempBusTimeout) ~= 0 then
			if BusData ~= nil then
				for k in pairs(BusData) do 
                    BusData[k] = nil 
                end
			end
			return -1
		end
        BusData.Float01 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 8)
        BusData.Float02 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 12)
        BusData.Float03 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 16)
        BusData.Float04 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 20)
        BusData.Float05 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 24)
        BusData.Float06 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 28)
        BusData.Float07 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 32)
        BusData.Float08 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 36)
        BusData.Float09 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 40)
        BusData.Float10 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 44)
        BusData.Float11 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 48)
        BusData.Float12 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 52)
        BusData.Int13 = bus_gint_("IO_DIN", BusIn.BusIoSt + 56)
        BusData.Int14 = bus_gint_("IO_DIN", BusIn.BusIoSt + 60)
        return 0
    else
        log_error_(1, {"bus_cmd132_:Invalid BusOperation!", "[BusOperation:", BusOperation, "]"})
	end
end

function bus_cmd133_(BusOperation, BusMstSel, BusIn, BusOut, BusData, BusTimeout)
	local TempBusTimeout = BusTimeout or -1
	if BusOperation == "BUSCMD_WRITE" then
        bus_sfloat2_(BusOut.BusIoSt + 8, BusData.Float01 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 12, BusData.Float02 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 16, BusData.Float03 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 20, BusData.Float04 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 24, BusData.Float05 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 28, BusData.Float06 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 32, BusData.Float07 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 36, BusData.Float08 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 40, BusData.Float09 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 44, BusData.Float10 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 48, BusData.Float11 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 52, BusData.Float12 or 0.0)
        bus_sint_(BusOut.BusIoSt + 56, BusData.Int13 or 0.0)
        bus_sint_(BusOut.BusIoSt + 60, BusData.Int14 or 0.0)
        return buscmd_wo_(133, BusMstSel, BusIn, BusOut)
	elseif BusOperation == "BUSCMD_READ" then
		if buscmd_ro_(133, BusMstSel, BusIn, BusOut, TempBusTimeout) ~= 0 then
			if BusData ~= nil then
				for k in pairs(BusData) do 
                    BusData[k] = nil 
                end
			end
			return -1
		end
        BusData.Float01 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 8)
        BusData.Float02 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 12)
        BusData.Float03 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 16)
        BusData.Float04 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 20)
        BusData.Float05 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 24)
        BusData.Float06 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 28)
        BusData.Float07 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 32)
        BusData.Float08 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 36)
        BusData.Float09 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 40)
        BusData.Float10 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 44)
        BusData.Float11 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 48)
        BusData.Float12 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 52)
        BusData.Int13 = bus_gint_("IO_DIN", BusIn.BusIoSt + 56)
        BusData.Int14 = bus_gint_("IO_DIN", BusIn.BusIoSt + 60)
        return 0
    else
        log_error_(1, {"bus_cmd133_:Invalid BusOperation!", "[BusOperation:", BusOperation, "]"})
	end
end

function bus_cmd134_(BusOperation, BusMstSel, BusIn, BusOut, BusData, BusTimeout)
	local TempBusTimeout = BusTimeout or -1
	if BusOperation == "BUSCMD_WRITE" then
        bus_sint_(BusOut.BusIoSt + 8, BusData.Int13 or 0.0)
        bus_sint_(BusOut.BusIoSt + 12, BusData.Int14 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 16, BusData.Float03 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 20, BusData.Float04 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 24, BusData.Float05 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 28, BusData.Float06 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 32, BusData.Float07 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 36, BusData.Float08 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 40, BusData.Float09 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 44, BusData.Float10 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 48, BusData.Float11 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 52, BusData.Float12 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 56, BusData.Float13 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 60, BusData.Float14 or 0.0)
        return buscmd_wo_(134, BusMstSel, BusIn, BusOut)
	elseif BusOperation == "BUSCMD_READ" then
		if buscmd_ro_(134, BusMstSel, BusIn, BusOut, TempBusTimeout) ~= 0 then
			if BusData ~= nil then
				for k in pairs(BusData) do 
                    BusData[k] = nil 
                end
			end
			return -1
		end
        BusData.Int13 = bus_gint_("IO_DIN", BusIn.BusIoSt + 8)
        BusData.Int14 = bus_gint_("IO_DIN", BusIn.BusIoSt + 12)
        BusData.Float03 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 16)
        BusData.Float04 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 20)
        BusData.Float05 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 24)
        BusData.Float06 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 28)
        BusData.Float07 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 32)
        BusData.Float08 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 36)
        BusData.Float09 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 40)
        BusData.Float10 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 44)
        BusData.Float11 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 48)
        BusData.Float12 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 52)
        BusData.Float13 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 56)
        BusData.Float14 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 60)
        return 0
    else
        log_error_(1, {"bus_cmd134_:Invalid BusOperation!", "[BusOperation:", BusOperation, "]"})
	end
end

function bus_cmd137_(BusOperation, BusMstSel, BusIn, BusOut, BusData, BusTimeout)
	local TempBusTimeout = BusTimeout or -1
	if BusOperation == "BUSCMD_WRITE" then
        bus_sbyte_(BusOut.BusIoSt + 8, BusData.Byte01 or 0)
        bus_sbyte_(BusOut.BusIoSt + 9, BusData.Byte02 or 0)
        bus_sbyte_(BusOut.BusIoSt + 10, BusData.Byte03 or 0)
        bus_sbyte_(BusOut.BusIoSt + 11, BusData.Byte04 or 0)
        bus_sbyte_(BusOut.BusIoSt + 12, BusData.Byte05 or 0)
        bus_sbyte_(BusOut.BusIoSt + 13, BusData.Byte06 or 0)
        bus_sbyte_(BusOut.BusIoSt + 14, BusData.Byte07 or 0)
        bus_sbyte_(BusOut.BusIoSt + 15, BusData.Byte08 or 0)
        bus_sbyte_(BusOut.BusIoSt + 16, BusData.Byte09 or 0)
        bus_sbyte_(BusOut.BusIoSt + 17, BusData.Byte10 or 0)
        bus_sbyte_(BusOut.BusIoSt + 18, BusData.Byte11 or 0)
        bus_sbyte_(BusOut.BusIoSt + 19, BusData.Byte12 or 0)
        bus_sbyte_(BusOut.BusIoSt + 20, BusData.Byte13 or 0)
        bus_sbyte_(BusOut.BusIoSt + 21, BusData.Byte14 or 0)
        bus_sbyte_(BusOut.BusIoSt + 22, BusData.Byte15 or 0)
        bus_sbyte_(BusOut.BusIoSt + 23, BusData.Byte16 or 0)
        bus_sbyte_(BusOut.BusIoSt + 24, BusData.Byte17 or 0)
        bus_sbyte_(BusOut.BusIoSt + 25, BusData.Byte18 or 0)
        return buscmd_wo_(137, BusMstSel, BusIn, BusOut)
	elseif BusOperation == "BUSCMD_READ" then
		if buscmd_ro_(137, BusMstSel, BusIn, BusOut, TempBusTimeout) ~= 0 then
			if BusData ~= nil then
				for k in pairs(BusData) do 
                    BusData[k] = nil 
                end
			end
			return -1
		end
        BusData.Byte01 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 8)
        BusData.Byte02 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 9)
        BusData.Byte03 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 10)
        BusData.Byte04 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 11)
        BusData.Byte05 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 12)
        BusData.Byte06 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 13)
        BusData.Byte07 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 14)
        BusData.Byte08 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 15)
        BusData.Byte09 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 16)
        BusData.Byte10 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 17)
        BusData.Byte11 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 18)
        BusData.Byte12 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 19)
        BusData.Byte13 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 20)
        BusData.Byte14 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 21)
        BusData.Byte15 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 22)
        BusData.Byte16 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 23)
        BusData.Byte17 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 24)
        BusData.Byte18 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 25)
        return 0
    else
        log_error_(1, {"bus_cmd137_:Invalid BusOperation!", "[BusOperation:", BusOperation, "]"})
	end
end

function bus_cmd145_(BusOperation, BusMstSel, BusIn, BusOut, BusData, BusTimeout)
	local TempBusTimeout = BusTimeout or -1
	if BusOperation == "BUSCMD_WRITE" then
        bus_sbyte_(BusOut.BusIoSt + 8, BusData.Byte01 or 0)
        bus_sbyte_(BusOut.BusIoSt + 9, BusData.Byte02 or 0)
        bus_susint_(BusOut.BusIoSt + 10, BusData.Short03 or 0)
        bus_susint_(BusOut.BusIoSt + 12, BusData.Short04 or 0)
        bus_sint_(BusOut.BusIoSt + 14, BusData.Int05 or 0)
        bus_sint_(BusOut.BusIoSt + 18, BusData.Int06 or 0)
        bus_sfloat2_(BusOut.BusIoSt + 22, BusData.Float07 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 26, BusData.Float08 or 0.0)
        return buscmd_wo_(145, BusMstSel, BusIn, BusOut)
	elseif BusOperation == "BUSCMD_READ" then
		if buscmd_ro_(145, BusMstSel, BusIn, BusOut, TempBusTimeout) ~= 0 then
			if BusData ~= nil then
				for k in pairs(BusData) do 
                    BusData[k] = nil 
                end
			end
			return -1
		end
        BusData.Byte01 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 8)
        BusData.Byte02 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 9)
        BusData.Short03 = bus_gusint_("IO_DIN", BusIn.BusIoSt + 10)
        BusData.Short04 = bus_gusint_("IO_DIN", BusIn.BusIoSt + 12)
        BusData.Int05 = bus_gint_("IO_DIN", BusIn.BusIoSt + 14)
        BusData.Int06 = bus_gint_("IO_DIN", BusIn.BusIoSt + 18)
        BusData.Float07 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 22)
        BusData.Float08 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 26)
        return 0
    else
        log_error_(1, {"bus_cmd145_:Invalid BusOperation!", "[BusOperation:", BusOperation, "]"})
	end
end

function bus_cmd148_(BusOperation, BusMstSel, BusIn, BusOut, BusData, BusTimeout)
	local TempBusTimeout = BusTimeout or -1
	if BusOperation == "BUSCMD_WRITE" then
        bus_sbyte_(BusOut.BusIoSt + 8, BusData.Byte01 or 0)
        bus_sbyte_(BusOut.BusIoSt + 9, BusData.Byte02 or 0)
        bus_sbyte_(BusOut.BusIoSt + 10, BusData.Byte03 or 0)
        bus_sbyte_(BusOut.BusIoSt + 11, BusData.Byte04 or 0)
        bus_susint_(BusOut.BusIoSt + 12, BusData.Short05 or 0)
        bus_susint_(BusOut.BusIoSt + 14, BusData.Short06 or 0)
        bus_susint_(BusOut.BusIoSt + 16, BusData.Short07 or 0)
        bus_susint_(BusOut.BusIoSt + 18, BusData.Short08 or 0)
        bus_sint_(BusOut.BusIoSt + 20, BusData.Int09 or 0)
        bus_sint_(BusOut.BusIoSt + 24, BusData.Int10 or 0)
        bus_sint_(BusOut.BusIoSt + 28, BusData.Int11 or 0)
        bus_sint_(BusOut.BusIoSt + 32, BusData.Int12 or 0)
        bus_sfloat2_(BusOut.BusIoSt + 36, BusData.Float13 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 40, BusData.Float14 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 44, BusData.Float15 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 48, BusData.Float16 or 0.0)
        return buscmd_wo_(148, BusMstSel, BusIn, BusOut)
	elseif BusOperation == "BUSCMD_READ" then
		if buscmd_ro_(148, BusMstSel, BusIn, BusOut, TempBusTimeout) ~= 0 then
			if BusData ~= nil then
				for k in pairs(BusData) do 
                    BusData[k] = nil 
                end
			end
			return -1
		end
        BusData.Byte01 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 8)
        BusData.Byte02 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 9)
        BusData.Byte03 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 10)
        BusData.Byte04 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 11)
        BusData.Short05 = bus_gusint_("IO_DIN", BusIn.BusIoSt + 12)
        BusData.Short06 = bus_gusint_("IO_DIN", BusIn.BusIoSt + 14)
        BusData.Short07 = bus_gusint_("IO_DIN", BusIn.BusIoSt + 16)
        BusData.Short08 = bus_gusint_("IO_DIN", BusIn.BusIoSt + 18)
        BusData.Int09 = bus_gint_("IO_DIN", BusIn.BusIoSt + 20)
        BusData.Int10 = bus_gint_("IO_DIN", BusIn.BusIoSt + 24)
        BusData.Int11 = bus_gint_("IO_DIN", BusIn.BusIoSt + 28)
        BusData.Int12 = bus_gint_("IO_DIN", BusIn.BusIoSt + 32)
        BusData.Float13 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 36)
        BusData.Float14 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 40)
        BusData.Float15 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 44)
        BusData.Float16 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 48)
        return 0
    else
        log_error_(1, {"bus_cmd148_:Invalid BusOperation!", "[BusOperation:", BusOperation, "]"})
	end
end

function bus_cmd151_(BusOperation, BusMstSel, BusIn, BusOut, BusData, BusTimeout)
	local TempBusTimeout = BusTimeout or -1
	if BusOperation == "BUSCMD_WRITE" then
        bus_sbyte_(BusOut.BusIoSt + 8, BusData.Byte01 or 0)
        bus_susint_(BusOut.BusIoSt + 9, BusData.Short02 or 0)
        bus_susint_(BusOut.BusIoSt + 11, BusData.Short03 or 0)
        bus_susint_(BusOut.BusIoSt + 13, BusData.Short04 or 0)
        bus_sfloat2_(BusOut.BusIoSt + 15, BusData.Float05 or 0.0)
        bus_sfloat2_(BusOut.BusIoSt + 19, BusData.Float06 or 0.0)
        return buscmd_wo_(151, BusMstSel, BusIn, BusOut)
	elseif BusOperation == "BUSCMD_READ" then
		if buscmd_ro_(151, BusMstSel, BusIn, BusOut, TempBusTimeout) ~= 0 then
			if BusData ~= nil then
				for k in pairs(BusData) do 
                    BusData[k] = nil 
                end
			end
			return -1
		end
        BusData.Byte01 = bus_gbyte_("IO_DIN", BusIn.BusIoSt + 8)
        BusData.Short02 = bus_gusint_("IO_DIN", BusIn.BusIoSt + 9)
        BusData.Short03 = bus_gusint_("IO_DIN", BusIn.BusIoSt + 11)
        BusData.Short04 = bus_gusint_("IO_DIN", BusIn.BusIoSt + 13)
        BusData.Float05 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 15)
        BusData.Float06 = bus_gfloat2_("IO_DIN", BusIn.BusIoSt + 19)
        return 0
    else
        log_error_(1, {"bus_cmd151_:Invalid BusOperation!", "[BusOperation:", BusOperation, "]"})
	end
end


-- BUS COMMAND 通讯指令实现
BusCmd001_Para={
	{_name="BusOperation",    _desc ="<CH>读写类型</CH><EN>BusOperation</EN>",_type="enum",_init="BUSCMD_WRITE",_enum={"BUSCMD_WRITE","BUSCMD_READ"},_depends={"BusTimeout=01","BusResult=01"}},
	{_name="BusMstSel",    _desc ="<CH>操作类型</CH><EN>IoType</EN>",_type="enum",_init="BUSCMD_MST",_enum={"BUSCMD_MST","BUSCMD_SLE"}},
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="BusTimeout",	_desc ="<CH>超时时间 (ms)</CH><EN>BusTimeout (ms)</EN>",_type="INTC",_max=2147483647,_min=-1,_init=0},
	{_name="BusResult",	_desc ="<CH>状态输出</CH><EN>Output Val</EN>",_type="INT"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusCmd001",_comm ="<CH>Bus Cmd 001 通讯指令.</CH><EN>Bus Command 001.</EN>"},
}
function BusCmd001(BusCmd001_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempTimeout = nil
	if BusCmd001_Para.BusTimeout ~= nil then
		TempTimeout = (type(BusCmd001_Para.BusTimeout) == "integer" or type(BusCmd001_Para.BusTimeout) == "number" or BusCmd001_Para.BusTimeout.value == nil) and BusCmd001_Para.BusTimeout or BusCmd001_Para.BusTimeout.value
	end
	local Res = bus_cmd001_(BusCmd001_Para.BusOperation, BusCmd001_Para.BusMstSel, BusCmd001_Para.BusIn, BusCmd001_Para.BusOut, TempTimeout)
	if BusCmd001_Para.BusResult ~= nil  then BusCmd001_Para.BusResult.value = Res end
end

BusCmd002_Para={
	{_name="BusOperation",    _desc ="<CH>读写类型</CH><EN>BusOperation</EN>",_type="enum",_init="BUSCMD_WRITE",_enum={"BUSCMD_WRITE","BUSCMD_READ"},_depends={"BusTimeout=01","BusResult=01"}},
	{_name="BusMstSel",    _desc ="<CH>操作类型</CH><EN>IoType</EN>",_type="enum",_init="BUSCMD_MST",_enum={"BUSCMD_MST","BUSCMD_SLE"}},
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="BusData",	_desc ="<CH>数据</CH><EN>BusData</EN>",_type="cmd_typ01_t"},	
	{_name="BusTimeout",	_desc ="<CH>超时时间 (ms)</CH><EN>BusTimeout (ms)</EN>",_type="INTC",_max=2147483647,_min=-1,_init=0},
	{_name="BusResult",	_desc ="<CH>状态输出</CH><EN>Output Val</EN>",_type="INT"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusCmd002",_comm ="<CH>Bus Cmd 002 通讯指令.</CH><EN>Bus Command 009.</EN>"},
}
function BusCmd002(BusCmd002_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempTimeout = nil
	if BusCmd002_Para.BusTimeout ~= nil then
		TempTimeout = (type(BusCmd002_Para.BusTimeout) == "integer" or type(BusCmd002_Para.BusTimeout) == "number" or BusCmd002_Para.BusTimeout.value == nil) and BusCmd002_Para.BusTimeout or BusCmd002_Para.BusTimeout.value
	end
	local Res = bus_cmd002_(BusCmd002_Para.BusOperation, BusCmd002_Para.BusMstSel, BusCmd002_Para.BusIn, BusCmd002_Para.BusOut, BusCmd002_Para.BusData, TempTimeout)
	if BusCmd002_Para.BusResult ~= nil  then BusCmd002_Para.BusResult.value = Res end
end

BusCmd003_Para={
	{_name="BusOperation",    _desc ="<CH>读写类型</CH><EN>BusOperation</EN>",_type="enum",_init="BUSCMD_WRITE",_enum={"BUSCMD_WRITE","BUSCMD_READ"},_depends={"BusTimeout=01","BusResult=01"}},
	{_name="BusMstSel",    _desc ="<CH>操作类型</CH><EN>IoType</EN>",_type="enum",_init="BUSCMD_MST",_enum={"BUSCMD_MST","BUSCMD_SLE"}},
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="BusData",	_desc ="<CH>数据</CH><EN>BusData</EN>",_type="CPOS"},	
	{_name="BusTimeout",	_desc ="<CH>超时时间 (ms)</CH><EN>BusTimeout (ms)</EN>",_type="INTC",_max=2147483647,_min=-1,_init=0},
	{_name="BusResult",	_desc ="<CH>状态输出</CH><EN>Output Val</EN>",_type="INT"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusCmd003",_comm ="<CH>Bus Cmd 003 通讯指令.</CH><EN>Bus Command 003.</EN>"},
}
function BusCmd003(BusCmd003_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempTimeout = nil
	if BusCmd003_Para.BusTimeout ~= nil then
		TempTimeout = (type(BusCmd003_Para.BusTimeout) == "integer" or type(BusCmd003_Para.BusTimeout) == "number" or BusCmd003_Para.BusTimeout.value == nil) and BusCmd003_Para.BusTimeout or BusCmd003_Para.BusTimeout.value
	end
	local Res = bus_cmd003_(BusCmd003_Para.BusOperation, BusCmd003_Para.BusMstSel, BusCmd003_Para.BusIn, BusCmd003_Para.BusOut, BusCmd003_Para.BusData, TempTimeout)
	if BusCmd003_Para.BusResult ~= nil  then BusCmd003_Para.BusResult.value = Res end
end

BusCmd009_Para={
	{_name="BusOperation",    _desc ="<CH>读写类型</CH><EN>BusOperation</EN>",_type="enum",_init="BUSCMD_WRITE",_enum={"BUSCMD_WRITE","BUSCMD_READ"},_depends={"BusTimeout=01","BusResult=01"}},
	{_name="BusMstSel",    _desc ="<CH>操作类型</CH><EN>IoType</EN>",_type="enum",_init="BUSCMD_MST",_enum={"BUSCMD_MST","BUSCMD_SLE"}},
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="BusData",	_desc ="<CH>数据</CH><EN>BusData</EN>",_type="CPOS"},	
	{_name="BusTimeout",	_desc ="<CH>超时时间 (ms)</CH><EN>BusTimeout (ms)</EN>",_type="INTC",_max=2147483647,_min=-1,_init=0},
	{_name="BusResult",	_desc ="<CH>状态输出</CH><EN>Output Val</EN>",_type="INT"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusCmd009",_comm ="<CH>Bus Cmd 009 通讯指令.</CH><EN>Bus Command 009.</EN>"},
}
function BusCmd009(BusCmd009_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempTimeout = nil
	if BusCmd009_Para.BusTimeout ~= nil then
		TempTimeout = (type(BusCmd009_Para.BusTimeout) == "integer" or type(BusCmd009_Para.BusTimeout) == "number" or BusCmd009_Para.BusTimeout.value == nil) and BusCmd009_Para.BusTimeout or BusCmd009_Para.BusTimeout.value
	end
	local Res = bus_cmd009_(BusCmd009_Para.BusOperation, BusCmd009_Para.BusMstSel, BusCmd009_Para.BusIn, BusCmd009_Para.BusOut, BusCmd009_Para.BusData, TempTimeout)
	if BusCmd009_Para.BusResult ~= nil  then BusCmd009_Para.BusResult.value = Res end
end

BusCmd010_Para={
	{_name="BusOperation",    _desc ="<CH>读写类型</CH><EN>BusOperation</EN>",_type="enum",_init="BUSCMD_WRITE",_enum={"BUSCMD_WRITE","BUSCMD_READ"},_depends={"BusTimeout=01","BusResult=01"}},
	{_name="BusMstSel",    _desc ="<CH>操作类型</CH><EN>IoType</EN>",_type="enum",_init="BUSCMD_MST",_enum={"BUSCMD_MST","BUSCMD_SLE"}},
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="BusData",	_desc ="<CH>数据</CH><EN>BusData</EN>",_type="CPOS"},	
	{_name="BusTimeout",	_desc ="<CH>超时时间 (ms)</CH><EN>BusTimeout (ms)</EN>",_type="INTC",_max=2147483647,_min=-1,_init=0},
	{_name="BusResult",	_desc ="<CH>状态输出</CH><EN>Output Val</EN>",_type="INT"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusCmd010",_comm ="<CH>Bus Cmd 010 通讯指令.</CH><EN>Bus Command 010.</EN>"},
}
function BusCmd010(BusCmd010_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempTimeout = nil
	if BusCmd010_Para.BusTimeout ~= nil then
		TempTimeout = (type(BusCmd010_Para.BusTimeout) == "integer" or type(BusCmd010_Para.BusTimeout) == "number" or BusCmd010_Para.BusTimeout.value == nil) and BusCmd010_Para.BusTimeout or BusCmd010_Para.BusTimeout.value
	end
	local Res = bus_cmd010_(BusCmd010_Para.BusOperation, BusCmd010_Para.BusMstSel, BusCmd010_Para.BusIn, BusCmd010_Para.BusOut, BusCmd010_Para.BusData, TempTimeout)
	if BusCmd010_Para.BusResult ~= nil  then BusCmd010_Para.BusResult.value = Res end
end

BusCmd011_Para={
	{_name="BusOperation",    _desc ="<CH>读写类型</CH><EN>BusOperation</EN>",_type="enum",_init="BUSCMD_WRITE",_enum={"BUSCMD_WRITE","BUSCMD_READ"},_depends={"BusTimeout=01","BusResult=01"}},
	{_name="BusMstSel",    _desc ="<CH>操作类型</CH><EN>IoType</EN>",_type="enum",_init="BUSCMD_MST",_enum={"BUSCMD_MST","BUSCMD_SLE"}},
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="BusData",	_desc ="<CH>数据</CH><EN>BusData</EN>",_type="CPOS"},	
	{_name="BusTimeout",	_desc ="<CH>超时时间 (ms)</CH><EN>BusTimeout (ms)</EN>",_type="INTC",_max=2147483647,_min=-1,_init=0},
	{_name="BusResult",	_desc ="<CH>状态输出</CH><EN>Output Val</EN>",_type="INT"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusCmd011",_comm ="<CH>Bus Cmd 011 通讯指令.</CH><EN>Bus Command 011.</EN>"},
}
function BusCmd011(BusCmd011_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempTimeout = nil
	if BusCmd011_Para.BusTimeout ~= nil then
		TempTimeout = (type(BusCmd011_Para.BusTimeout) == "integer" or type(BusCmd011_Para.BusTimeout) == "number" or BusCmd011_Para.BusTimeout.value == nil) and BusCmd011_Para.BusTimeout or BusCmd011_Para.BusTimeout.value
	end
	local Res = bus_cmd011_(BusCmd011_Para.BusOperation, BusCmd011_Para.BusMstSel, BusCmd011_Para.BusIn, BusCmd011_Para.BusOut, BusCmd011_Para.BusData, TempTimeout)
	if BusCmd011_Para.BusResult ~= nil  then BusCmd011_Para.BusResult.value = Res end
end

BusCmd012_Para={
	{_name="BusOperation",    _desc ="<CH>读写类型</CH><EN>BusOperation</EN>",_type="enum",_init="BUSCMD_WRITE",_enum={"BUSCMD_WRITE","BUSCMD_READ"},_depends={"BusTimeout=01","BusResult=01"}},
	{_name="BusMstSel",    _desc ="<CH>操作类型</CH><EN>IoType</EN>",_type="enum",_init="BUSCMD_MST",_enum={"BUSCMD_MST","BUSCMD_SLE"}},
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="BusData",	_desc ="<CH>数据</CH><EN>BusData</EN>",_type="cmd_typ01_t"},	
	{_name="BusTimeout",	_desc ="<CH>超时时间 (ms)</CH><EN>BusTimeout (ms)</EN>",_type="INTC",_max=2147483647,_min=-1,_init=0},
	{_name="BusResult",	_desc ="<CH>状态输出</CH><EN>Output Val</EN>",_type="INT"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusCmd012",_comm ="<CH>Bus Cmd 012 通讯指令.</CH><EN>Bus Command 012.</EN>"},
}
function BusCmd012(BusCmd012_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempTimeout = nil
	if BusCmd012_Para.BusTimeout ~= nil then
		TempTimeout = (type(BusCmd012_Para.BusTimeout) == "integer" or type(BusCmd012_Para.BusTimeout) == "number" or BusCmd012_Para.BusTimeout.value == nil) and BusCmd012_Para.BusTimeout or BusCmd012_Para.BusTimeout.value
	end
	local Res = bus_cmd012_(BusCmd012_Para.BusOperation, BusCmd012_Para.BusMstSel, BusCmd012_Para.BusIn, BusCmd012_Para.BusOut, BusCmd012_Para.BusData, TempTimeout)
	if BusCmd012_Para.BusResult ~= nil  then BusCmd012_Para.BusResult.value = Res end
end

BusCmd013_Para={
	{_name="BusOperation",    _desc ="<CH>读写类型</CH><EN>BusOperation</EN>",_type="enum",_init="BUSCMD_WRITE",_enum={"BUSCMD_WRITE","BUSCMD_READ"},_depends={"BusTimeout=01","BusResult=01"}},
	{_name="BusMstSel",    _desc ="<CH>操作类型</CH><EN>IoType</EN>",_type="enum",_init="BUSCMD_MST",_enum={"BUSCMD_MST","BUSCMD_SLE"}},
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="BusData",	_desc ="<CH>数据</CH><EN>BusData</EN>",_type="cmd_typ01_t"},	
	{_name="BusTimeout",	_desc ="<CH>超时时间 (ms)</CH><EN>BusTimeout (ms)</EN>",_type="INTC",_max=2147483647,_min=-1,_init=0},
	{_name="BusResult",	_desc ="<CH>状态输出</CH><EN>Output Val</EN>",_type="INT"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusCmd013",_comm ="<CH>Bus Cmd 013 通讯指令.</CH><EN>Bus Command 013.</EN>"},
}
function BusCmd013(BusCmd013_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempTimeout = nil
	if BusCmd013_Para.BusTimeout ~= nil then
		TempTimeout = (type(BusCmd013_Para.BusTimeout) == "integer" or type(BusCmd013_Para.BusTimeout) == "number" or BusCmd013_Para.BusTimeout.value == nil) and BusCmd013_Para.BusTimeout or BusCmd013_Para.BusTimeout.value
	end
	local Res = bus_cmd013_(BusCmd013_Para.BusOperation, BusCmd013_Para.BusMstSel, BusCmd013_Para.BusIn, BusCmd013_Para.BusOut, BusCmd013_Para.BusData, TempTimeout)
	if BusCmd013_Para.BusResult ~= nil  then BusCmd013_Para.BusResult.value = Res end
end

BusCmd014_Para={
	{_name="BusOperation",    _desc ="<CH>读写类型</CH><EN>BusOperation</EN>",_type="enum",_init="BUSCMD_WRITE",_enum={"BUSCMD_WRITE","BUSCMD_READ"},_depends={"BusTimeout=01","BusResult=01"}},
	{_name="BusMstSel",    _desc ="<CH>操作类型</CH><EN>IoType</EN>",_type="enum",_init="BUSCMD_MST",_enum={"BUSCMD_MST","BUSCMD_SLE"}},
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="BusData",	_desc ="<CH>数据</CH><EN>BusData</EN>",_type="cmd_typ01_t"},	
	{_name="BusTimeout",	_desc ="<CH>超时时间 (ms)</CH><EN>BusTimeout (ms)</EN>",_type="INTC",_max=2147483647,_min=-1,_init=0},
	{_name="BusResult",	_desc ="<CH>状态输出</CH><EN>Output Val</EN>",_type="INT"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusCmd014",_comm ="<CH>Bus Cmd 014 通讯指令.</CH><EN>Bus Command 014.</EN>"},
}
function BusCmd014(BusCmd014_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempTimeout = nil
	if BusCmd014_Para.BusTimeout ~= nil then
		TempTimeout = (type(BusCmd014_Para.BusTimeout) == "integer" or type(BusCmd014_Para.BusTimeout) == "number" or BusCmd014_Para.BusTimeout.value == nil) and BusCmd014_Para.BusTimeout or BusCmd014_Para.BusTimeout.value
	end
	local Res = bus_cmd014_(BusCmd014_Para.BusOperation, BusCmd014_Para.BusMstSel, BusCmd014_Para.BusIn, BusCmd014_Para.BusOut, BusCmd014_Para.BusData, TempTimeout)
	if BusCmd014_Para.BusResult ~= nil  then BusCmd014_Para.BusResult.value = Res end
end

BusCmd017_Para={
	{_name="BusOperation",    _desc ="<CH>读写类型</CH><EN>BusOperation</EN>",_type="enum",_init="BUSCMD_WRITE",_enum={"BUSCMD_WRITE","BUSCMD_READ"},_depends={"BusTimeout=01","BusResult=01"}},
	{_name="BusMstSel",    _desc ="<CH>操作类型</CH><EN>IoType</EN>",_type="enum",_init="BUSCMD_MST",_enum={"BUSCMD_MST","BUSCMD_SLE"}},
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="BusData",	_desc ="<CH>数据</CH><EN>BusData</EN>",_type="cmd_typ07_t"},	
	{_name="BusTimeout",	_desc ="<CH>超时时间 (ms)</CH><EN>BusTimeout (ms)</EN>",_type="INTC",_max=2147483647,_min=-1,_init=0},
	{_name="BusResult",	_desc ="<CH>状态输出</CH><EN>Output Val</EN>",_type="INT"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusCmd017",_comm ="<CH>Bus Cmd 017 通讯指令.</CH><EN>Bus Command 017.</EN>"},
}
function BusCmd017(BusCmd017_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempTimeout = nil
	if BusCmd017_Para.BusTimeout ~= nil then
		TempTimeout = (type(BusCmd017_Para.BusTimeout) == "integer" or type(BusCmd017_Para.BusTimeout) == "number" or BusCmd017_Para.BusTimeout.value == nil) and BusCmd017_Para.BusTimeout or BusCmd017_Para.BusTimeout.value
	end
	local Res = bus_cmd017_(BusCmd017_Para.BusOperation, BusCmd017_Para.BusMstSel, BusCmd017_Para.BusIn, BusCmd017_Para.BusOut, BusCmd017_Para.BusData, TempTimeout)
	if BusCmd017_Para.BusResult ~= nil  then BusCmd017_Para.BusResult.value = Res end
end

BusCmd018_Para={
	{_name="BusOperation",    _desc ="<CH>读写类型</CH><EN>BusOperation</EN>",_type="enum",_init="BUSCMD_WRITE",_enum={"BUSCMD_WRITE","BUSCMD_READ"},_depends={"BusTimeout=01","BusResult=01"}},
	{_name="BusMstSel",    _desc ="<CH>操作类型</CH><EN>IoType</EN>",_type="enum",_init="BUSCMD_MST",_enum={"BUSCMD_MST","BUSCMD_SLE"}},
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="BusData",	_desc ="<CH>数据</CH><EN>BusData</EN>",_type="cmd_typ07_t"},	
	{_name="BusTimeout",	_desc ="<CH>超时时间 (ms)</CH><EN>BusTimeout (ms)</EN>",_type="INTC",_max=2147483647,_min=-1,_init=0},
	{_name="BusResult",	_desc ="<CH>状态输出</CH><EN>Output Val</EN>",_type="INT"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusCmd018",_comm ="<CH>Bus Cmd 018 通讯指令.</CH><EN>Bus Command 018.</EN>"},
}
function BusCmd018(BusCmd018_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempTimeout = nil
	if BusCmd018_Para.BusTimeout ~= nil then
		TempTimeout = (type(BusCmd018_Para.BusTimeout) == "integer" or type(BusCmd018_Para.BusTimeout) == "number" or BusCmd018_Para.BusTimeout.value == nil) and BusCmd018_Para.BusTimeout or BusCmd018_Para.BusTimeout.value
	end
	local Res = bus_cmd018_(BusCmd018_Para.BusOperation, BusCmd018_Para.BusMstSel, BusCmd018_Para.BusIn, BusCmd018_Para.BusOut, BusCmd018_Para.BusData, TempTimeout)
	if BusCmd018_Para.BusResult ~= nil  then BusCmd018_Para.BusResult.value = Res end
end

BusCmd020_Para={
	{_name="BusOperation",    _desc ="<CH>读写类型</CH><EN>BusOperation</EN>",_type="enum",_init="BUSCMD_WRITE",_enum={"BUSCMD_WRITE","BUSCMD_READ"},_depends={"BusTimeout=01","BusResult=01"}},
	{_name="BusMstSel",    _desc ="<CH>操作类型</CH><EN>IoType</EN>",_type="enum",_init="BUSCMD_MST",_enum={"BUSCMD_MST","BUSCMD_SLE"}},
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="BusData",	_desc ="<CH>数据</CH><EN>BusData</EN>",_type="CPOS"},	
	{_name="BusTimeout",	_desc ="<CH>超时时间 (ms)</CH><EN>BusTimeout (ms)</EN>",_type="INTC",_max=2147483647,_min=-1,_init=0},
	{_name="BusResult",	_desc ="<CH>状态输出</CH><EN>Output Val</EN>",_type="INT"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusCmd020",_comm ="<CH>Bus Cmd 020 通讯指令.</CH><EN>Bus Command 020.</EN>"},
}
function BusCmd020(BusCmd020_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempTimeout = nil
	if BusCmd020_Para.BusTimeout ~= nil then
		TempTimeout = (type(BusCmd020_Para.BusTimeout) == "integer" or type(BusCmd020_Para.BusTimeout) == "number" or BusCmd020_Para.BusTimeout.value == nil) and BusCmd020_Para.BusTimeout or BusCmd020_Para.BusTimeout.value
	end
	local Res = bus_cmd020_(BusCmd020_Para.BusOperation, BusCmd020_Para.BusMstSel, BusCmd020_Para.BusIn, BusCmd020_Para.BusOut, BusCmd020_Para.BusData, TempTimeout)
	if BusCmd020_Para.BusResult ~= nil  then BusCmd020_Para.BusResult.value = Res end
end

BusCmd021_Para={
	{_name="BusOperation",    _desc ="<CH>读写类型</CH><EN>BusOperation</EN>",_type="enum",_init="BUSCMD_WRITE",_enum={"BUSCMD_WRITE","BUSCMD_READ"},_depends={"BusTimeout=01","BusResult=01"}},
	{_name="BusMstSel",    _desc ="<CH>操作类型</CH><EN>IoType</EN>",_type="enum",_init="BUSCMD_MST",_enum={"BUSCMD_MST","BUSCMD_SLE"}},
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="BusData",	_desc ="<CH>数据</CH><EN>BusData</EN>",_type="cmd_typ01_t"},	
	{_name="BusTimeout",	_desc ="<CH>超时时间 (ms)</CH><EN>BusTimeout (ms)</EN>",_type="INTC",_max=2147483647,_min=-1,_init=0},
	{_name="BusResult",	_desc ="<CH>状态输出</CH><EN>Output Val</EN>",_type="INT"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusCmd021",_comm ="<CH>Bus Cmd 021 通讯指令.</CH><EN>Bus Command 021.</EN>"},
}
function BusCmd021(BusCmd021_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempTimeout = nil
	if BusCmd021_Para.BusTimeout ~= nil then
		TempTimeout = (type(BusCmd021_Para.BusTimeout) == "integer" or type(BusCmd021_Para.BusTimeout) == "number" or BusCmd021_Para.BusTimeout.value == nil) and BusCmd021_Para.BusTimeout or BusCmd021_Para.BusTimeout.value
	end
	local Res = bus_cmd021_(BusCmd021_Para.BusOperation, BusCmd021_Para.BusMstSel, BusCmd021_Para.BusIn, BusCmd021_Para.BusOut, BusCmd021_Para.BusData, TempTimeout)
	if BusCmd021_Para.BusResult ~= nil  then BusCmd021_Para.BusResult.value = Res end
end

BusCmd022_Para={
	{_name="BusOperation",    _desc ="<CH>读写类型</CH><EN>BusOperation</EN>",_type="enum",_init="BUSCMD_WRITE",_enum={"BUSCMD_WRITE","BUSCMD_READ"},_depends={"BusTimeout=01","BusResult=01"}},
	{_name="BusMstSel",    _desc ="<CH>操作类型</CH><EN>IoType</EN>",_type="enum",_init="BUSCMD_MST",_enum={"BUSCMD_MST","BUSCMD_SLE"}},
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="BusData",	_desc ="<CH>数据</CH><EN>BusData</EN>",_type="cmd_typ01_t"},	
	{_name="BusTimeout",	_desc ="<CH>超时时间 (ms)</CH><EN>BusTimeout (ms)</EN>",_type="INTC",_max=2147483647,_min=-1,_init=0},
	{_name="BusResult",	_desc ="<CH>状态输出</CH><EN>Output Val</EN>",_type="INT"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusCmd022",_comm ="<CH>Bus Cmd 022 通讯指令.</CH><EN>Bus Command 022.</EN>"},
}
function BusCmd022(BusCmd022_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempTimeout = nil
	if BusCmd022_Para.BusTimeout ~= nil then
		TempTimeout = (type(BusCmd022_Para.BusTimeout) == "integer" or type(BusCmd022_Para.BusTimeout) == "number" or BusCmd022_Para.BusTimeout.value == nil) and BusCmd022_Para.BusTimeout or BusCmd022_Para.BusTimeout.value
	end
	local Res = bus_cmd022_(BusCmd022_Para.BusOperation, BusCmd022_Para.BusMstSel, BusCmd022_Para.BusIn, BusCmd022_Para.BusOut, BusCmd022_Para.BusData, TempTimeout)
	if BusCmd022_Para.BusResult ~= nil  then BusCmd022_Para.BusResult.value = Res end
end

BusCmd026_Para={
	{_name="BusOperation",    _desc ="<CH>读写类型</CH><EN>BusOperation</EN>",_type="enum",_init="BUSCMD_WRITE",_enum={"BUSCMD_WRITE","BUSCMD_READ"},_depends={"BusTimeout=01","BusResult=01"}},
	{_name="BusMstSel",    _desc ="<CH>操作类型</CH><EN>IoType</EN>",_type="enum",_init="BUSCMD_MST",_enum={"BUSCMD_MST","BUSCMD_SLE"}},
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="BusData",	_desc ="<CH>数据</CH><EN>BusData</EN>",_type="cmd_typ01_t"},	
	{_name="BusTimeout",	_desc ="<CH>超时时间 (ms)</CH><EN>BusTimeout (ms)</EN>",_type="INTC",_max=2147483647,_min=-1,_init=0},
	{_name="BusResult",	_desc ="<CH>状态输出</CH><EN>Output Val</EN>",_type="INT"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusCmd026",_comm ="<CH>Bus Cmd 026 通讯指令.</CH><EN>Bus Command 026.</EN>"},
}
function BusCmd026(BusCmd026_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempTimeout = nil
	if BusCmd026_Para.BusTimeout ~= nil then
		TempTimeout = (type(BusCmd026_Para.BusTimeout) == "integer" or type(BusCmd026_Para.BusTimeout) == "number" or BusCmd026_Para.BusTimeout.value == nil) and BusCmd026_Para.BusTimeout or BusCmd026_Para.BusTimeout.value
	end
	local Res = bus_cmd026_(BusCmd026_Para.BusOperation, BusCmd026_Para.BusMstSel, BusCmd026_Para.BusIn, BusCmd026_Para.BusOut, BusCmd026_Para.BusData, TempTimeout)
	if BusCmd026_Para.BusResult ~= nil  then BusCmd026_Para.BusResult.value = Res end
end

BusCmd027_Para={
	{_name="BusOperation",    _desc ="<CH>读写类型</CH><EN>BusOperation</EN>",_type="enum",_init="BUSCMD_WRITE",_enum={"BUSCMD_WRITE","BUSCMD_READ"},_depends={"BusTimeout=01","BusResult=01"}},
	{_name="BusMstSel",    _desc ="<CH>操作类型</CH><EN>IoType</EN>",_type="enum",_init="BUSCMD_MST",_enum={"BUSCMD_MST","BUSCMD_SLE"}},
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="BusData",	_desc ="<CH>数据</CH><EN>BusData</EN>",_type="cmd_typ08_t"},	
	{_name="BusTimeout",	_desc ="<CH>超时时间 (ms)</CH><EN>BusTimeout (ms)</EN>",_type="INTC",_max=2147483647,_min=-1,_init=0},
	{_name="BusResult",	_desc ="<CH>状态输出</CH><EN>Output Val</EN>",_type="INT"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusCmd027",_comm ="<CH>Bus Cmd 027 通讯指令.</CH><EN>Bus Command 027.</EN>"},
}
function BusCmd027(BusCmd027_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempTimeout = nil
	if BusCmd027_Para.BusTimeout ~= nil then
		TempTimeout = (type(BusCmd027_Para.BusTimeout) == "integer" or type(BusCmd027_Para.BusTimeout) == "number" or BusCmd027_Para.BusTimeout.value == nil) and BusCmd027_Para.BusTimeout or BusCmd027_Para.BusTimeout.value
	end
	local Res = bus_cmd027_(BusCmd027_Para.BusOperation, BusCmd027_Para.BusMstSel, BusCmd027_Para.BusIn, BusCmd027_Para.BusOut, BusCmd027_Para.BusData, TempTimeout)
	if BusCmd027_Para.BusResult ~= nil  then BusCmd027_Para.BusResult.value = Res end
end

BusCmd129_Para={
	{_name="BusOperation",    _desc ="<CH>读写类型</CH><EN>BusOperation</EN>",_type="enum",_init="BUSCMD_WRITE",_enum={"BUSCMD_WRITE","BUSCMD_READ"},_depends={"BusTimeout=01","BusResult=01"}},
	{_name="BusMstSel",    _desc ="<CH>操作类型</CH><EN>IoType</EN>",_type="enum",_init="BUSCMD_MST",_enum={"BUSCMD_MST","BUSCMD_SLE"}},
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="BusData",	_desc ="<CH>数据</CH><EN>BusData</EN>",_type="CPOS"},	
	{_name="BusTimeout",	_desc ="<CH>超时时间 (ms)</CH><EN>BusTimeout (ms)</EN>",_type="INTC",_max=2147483647,_min=-1,_init=0},
	{_name="BusResult",	_desc ="<CH>状态输出</CH><EN>Output Val</EN>",_type="INT"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusCmd129",_comm ="<CH>Bus Cmd 129 通讯指令.</CH><EN>Bus Command 129.</EN>"},
}
function BusCmd129(BusCmd129_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempTimeout = nil
	if BusCmd129_Para.BusTimeout ~= nil then
		TempTimeout = (type(BusCmd129_Para.BusTimeout) == "integer" or type(BusCmd129_Para.BusTimeout) == "number" or BusCmd129_Para.BusTimeout.value == nil) and BusCmd129_Para.BusTimeout or BusCmd129_Para.BusTimeout.value
	end
	local Res = bus_cmd129_(BusCmd129_Para.BusOperation, BusCmd129_Para.BusMstSel, BusCmd129_Para.BusIn, BusCmd129_Para.BusOut, BusCmd129_Para.BusData, TempTimeout)
	if BusCmd129_Para.BusResult ~= nil  then BusCmd129_Para.BusResult.value = Res end
end

BusCmd130_Para={
	{_name="BusOperation",    _desc ="<CH>读写类型</CH><EN>BusOperation</EN>",_type="enum",_init="BUSCMD_WRITE",_enum={"BUSCMD_WRITE","BUSCMD_READ"},_depends={"BusTimeout=01","BusResult=01"}},
	{_name="BusMstSel",    _desc ="<CH>操作类型</CH><EN>IoType</EN>",_type="enum",_init="BUSCMD_MST",_enum={"BUSCMD_MST","BUSCMD_SLE"}},
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="BusData",	_desc ="<CH>数据</CH><EN>BusData</EN>",_type="APOS"},	
	{_name="BusTimeout",	_desc ="<CH>超时时间 (ms)</CH><EN>BusTimeout (ms)</EN>",_type="INTC",_max=2147483647,_min=-1,_init=0},
	{_name="BusResult",	_desc ="<CH>状态输出</CH><EN>Output Val</EN>",_type="INT"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusCmd130",_comm ="<CH>Bus Cmd 130 通讯指令.</CH><EN>Bus Command 130.</EN>"},
}
function BusCmd130(BusCmd130_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempTimeout = nil
	if BusCmd130_Para.BusTimeout ~= nil then
		TempTimeout = (type(BusCmd130_Para.BusTimeout) == "integer" or type(BusCmd130_Para.BusTimeout) == "number" or BusCmd130_Para.BusTimeout.value == nil) and BusCmd130_Para.BusTimeout or BusCmd130_Para.BusTimeout.value
	end
	local Res = bus_cmd130_(BusCmd130_Para.BusOperation, BusCmd130_Para.BusMstSel, BusCmd130_Para.BusIn, BusCmd130_Para.BusOut, BusCmd130_Para.BusData, TempTimeout)
	if BusCmd130_Para.BusResult ~= nil  then BusCmd130_Para.BusResult.value = Res end
end

BusCmd131_Para={
	{_name="BusOperation",    _desc ="<CH>读写类型</CH><EN>BusOperation</EN>",_type="enum",_init="BUSCMD_WRITE",_enum={"BUSCMD_WRITE","BUSCMD_READ"},_depends={"BusTimeout=01","BusResult=01"}},
	{_name="BusMstSel",    _desc ="<CH>操作类型</CH><EN>IoType</EN>",_type="enum",_init="BUSCMD_MST",_enum={"BUSCMD_MST","BUSCMD_SLE"}},
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="BusData",	_desc ="<CH>数据</CH><EN>BusData</EN>",_type="cmd_typ02_t"},	
	{_name="BusTimeout",	_desc ="<CH>超时时间 (ms)</CH><EN>BusTimeout (ms)</EN>",_type="INTC",_max=2147483647,_min=-1,_init=0},
	{_name="BusResult",	_desc ="<CH>状态输出</CH><EN>Output Val</EN>",_type="INT"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusCmd131",_comm ="<CH>Bus Cmd 131 通讯指令.</CH><EN>Bus Command 131.</EN>"},
}
function BusCmd131(BusCmd131_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempTimeout = nil
	if BusCmd131_Para.BusTimeout ~= nil then
		TempTimeout = (type(BusCmd131_Para.BusTimeout) == "integer" or type(BusCmd131_Para.BusTimeout) == "number" or BusCmd131_Para.BusTimeout.value == nil) and BusCmd131_Para.BusTimeout or BusCmd131_Para.BusTimeout.value
	end
	local Res = bus_cmd131_(BusCmd131_Para.BusOperation, BusCmd131_Para.BusMstSel, BusCmd131_Para.BusIn, BusCmd131_Para.BusOut, BusCmd131_Para.BusData, TempTimeout)
	if BusCmd131_Para.BusResult ~= nil  then BusCmd131_Para.BusResult.value = Res end
end

BusCmd132_Para={
	{_name="BusOperation",    _desc ="<CH>读写类型</CH><EN>BusOperation</EN>",_type="enum",_init="BUSCMD_WRITE",_enum={"BUSCMD_WRITE","BUSCMD_READ"},_depends={"BusTimeout=01","BusResult=01"}},
	{_name="BusMstSel",    _desc ="<CH>操作类型</CH><EN>IoType</EN>",_type="enum",_init="BUSCMD_MST",_enum={"BUSCMD_MST","BUSCMD_SLE"}},
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="BusData",	_desc ="<CH>数据</CH><EN>BusData</EN>",_type="cmd_typ07_t"},	
	{_name="BusTimeout",	_desc ="<CH>超时时间 (ms)</CH><EN>BusTimeout (ms)</EN>",_type="INTC",_max=2147483647,_min=-1,_init=0},
	{_name="BusResult",	_desc ="<CH>状态输出</CH><EN>Output Val</EN>",_type="INT"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusCmd132",_comm ="<CH>Bus Cmd 132 通讯指令.</CH><EN>Bus Command 132.</EN>"},
}
function BusCmd132(BusCmd132_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempTimeout = nil
	if BusCmd132_Para.BusTimeout ~= nil then
		TempTimeout = (type(BusCmd132_Para.BusTimeout) == "integer" or type(BusCmd132_Para.BusTimeout) == "number" or BusCmd132_Para.BusTimeout.value == nil) and BusCmd132_Para.BusTimeout or BusCmd132_Para.BusTimeout.value
	end
	local Res = bus_cmd132_(BusCmd132_Para.BusOperation, BusCmd132_Para.BusMstSel, BusCmd132_Para.BusIn, BusCmd132_Para.BusOut, BusCmd132_Para.BusData, TempTimeout)
	if BusCmd132_Para.BusResult ~= nil  then BusCmd132_Para.BusResult.value = Res end
end

BusCmd133_Para={
	{_name="BusOperation",    _desc ="<CH>读写类型</CH><EN>BusOperation</EN>",_type="enum",_init="BUSCMD_WRITE",_enum={"BUSCMD_WRITE","BUSCMD_READ"},_depends={"BusTimeout=01","BusResult=01"}},
	{_name="BusMstSel",    _desc ="<CH>操作类型</CH><EN>IoType</EN>",_type="enum",_init="BUSCMD_MST",_enum={"BUSCMD_MST","BUSCMD_SLE"}},
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="BusData",	_desc ="<CH>数据</CH><EN>BusData</EN>",_type="cmd_typ07_t"},	
	{_name="BusTimeout",	_desc ="<CH>超时时间 (ms)</CH><EN>BusTimeout (ms)</EN>",_type="INTC",_max=2147483647,_min=-1,_init=0},
	{_name="BusResult",	_desc ="<CH>状态输出</CH><EN>Output Val</EN>",_type="INT"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusCmd133",_comm ="<CH>Bus Cmd 133 通讯指令.</CH><EN>Bus Command 133.</EN>"},
}
function BusCmd133(BusCmd133_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempTimeout = nil
	if BusCmd133_Para.BusTimeout ~= nil then
		TempTimeout = (type(BusCmd133_Para.BusTimeout) == "integer" or type(BusCmd133_Para.BusTimeout) == "number" or BusCmd133_Para.BusTimeout.value == nil) and BusCmd133_Para.BusTimeout or BusCmd133_Para.BusTimeout.value
	end
	local Res = bus_cmd133_(BusCmd133_Para.BusOperation, BusCmd133_Para.BusMstSel, BusCmd133_Para.BusIn, BusCmd133_Para.BusOut, BusCmd133_Para.BusData, TempTimeout)
	if BusCmd133_Para.BusResult ~= nil  then BusCmd133_Para.BusResult.value = Res end
end

BusCmd134_Para={
	{_name="BusOperation",    _desc ="<CH>读写类型</CH><EN>BusOperation</EN>",_type="enum",_init="BUSCMD_WRITE",_enum={"BUSCMD_WRITE","BUSCMD_READ"},_depends={"BusTimeout=01","BusResult=01"}},
	{_name="BusMstSel",    _desc ="<CH>操作类型</CH><EN>IoType</EN>",_type="enum",_init="BUSCMD_MST",_enum={"BUSCMD_MST","BUSCMD_SLE"}},
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="BusData",	_desc ="<CH>数据</CH><EN>BusData</EN>",_type="cmd_typ09_t"},	
	{_name="BusTimeout",	_desc ="<CH>超时时间 (ms)</CH><EN>BusTimeout (ms)</EN>",_type="INTC",_max=2147483647,_min=-1,_init=0},
	{_name="BusResult",	_desc ="<CH>状态输出</CH><EN>Output Val</EN>",_type="INT"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusCmd134",_comm ="<CH>Bus Cmd 134 通讯指令.</CH><EN>Bus Command 134.</EN>"},
}
function BusCmd134(BusCmd134_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempTimeout = nil
	if BusCmd134_Para.BusTimeout ~= nil then
		TempTimeout = (type(BusCmd134_Para.BusTimeout) == "integer" or type(BusCmd134_Para.BusTimeout) == "number" or BusCmd134_Para.BusTimeout.value == nil) and BusCmd134_Para.BusTimeout or BusCmd134_Para.BusTimeout.value
	end
	local Res = bus_cmd134_(BusCmd134_Para.BusOperation, BusCmd134_Para.BusMstSel, BusCmd134_Para.BusIn, BusCmd134_Para.BusOut, BusCmd134_Para.BusData, TempTimeout)
	if BusCmd134_Para.BusResult ~= nil  then BusCmd134_Para.BusResult.value = Res end
end

BusCmd137_Para={
	{_name="BusOperation",    _desc ="<CH>读写类型</CH><EN>BusOperation</EN>",_type="enum",_init="BUSCMD_WRITE",_enum={"BUSCMD_WRITE","BUSCMD_READ"},_depends={"BusTimeout=01","BusResult=01"}},
	{_name="BusMstSel",    _desc ="<CH>操作类型</CH><EN>IoType</EN>",_type="enum",_init="BUSCMD_MST",_enum={"BUSCMD_MST","BUSCMD_SLE"}},
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="BusData",	_desc ="<CH>数据</CH><EN>BusData</EN>",_type="cmd_typ03_t"},	
	{_name="BusTimeout",	_desc ="<CH>超时时间 (ms)</CH><EN>BusTimeout (ms)</EN>",_type="INTC",_max=2147483647,_min=-1,_init=0},
	{_name="BusResult",	_desc ="<CH>状态输出</CH><EN>Output Val</EN>",_type="INT"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusCmd137",_comm ="<CH>Bus Cmd 137 通讯指令.</CH><EN>Bus Command 137.</EN>"},
}
function BusCmd137(BusCmd137_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempTimeout = nil
	if BusCmd137_Para.BusTimeout ~= nil then
		TempTimeout = (type(BusCmd137_Para.BusTimeout) == "integer" or type(BusCmd137_Para.BusTimeout) == "number" or BusCmd137_Para.BusTimeout.value == nil) and BusCmd137_Para.BusTimeout or BusCmd137_Para.BusTimeout.value
	end
	local Res = bus_cmd137_(BusCmd137_Para.BusOperation, BusCmd137_Para.BusMstSel, BusCmd137_Para.BusIn, BusCmd137_Para.BusOut, BusCmd137_Para.BusData, TempTimeout)
	if BusCmd137_Para.BusResult ~= nil  then BusCmd137_Para.BusResult.value = Res end
end

BusCmd145_Para={
	{_name="BusOperation",    _desc ="<CH>读写类型</CH><EN>BusOperation</EN>",_type="enum",_init="BUSCMD_WRITE",_enum={"BUSCMD_WRITE","BUSCMD_READ"},_depends={"BusTimeout=01","BusResult=01"}},
	{_name="BusMstSel",    _desc ="<CH>操作类型</CH><EN>IoType</EN>",_type="enum",_init="BUSCMD_MST",_enum={"BUSCMD_MST","BUSCMD_SLE"}},
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="BusData",	_desc ="<CH>数据</CH><EN>BusData</EN>",_type="cmd_typ01_t"},	
	{_name="BusTimeout",	_desc ="<CH>超时时间 (ms)</CH><EN>BusTimeout (ms)</EN>",_type="INTC",_max=2147483647,_min=-1,_init=0},
	{_name="BusResult",	_desc ="<CH>状态输出</CH><EN>Output Val</EN>",_type="INT"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusCmd145",_comm ="<CH>Bus Cmd 145 通讯指令.</CH><EN>Bus Command 145.</EN>"},
}
function BusCmd145(BusCmd145_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempTimeout = nil
	if BusCmd145_Para.BusTimeout ~= nil then
		TempTimeout = (type(BusCmd145_Para.BusTimeout) == "integer" or type(BusCmd145_Para.BusTimeout) == "number" or BusCmd145_Para.BusTimeout.value == nil) and BusCmd145_Para.BusTimeout or BusCmd145_Para.BusTimeout.value
	end
	local Res = bus_cmd145_(BusCmd145_Para.BusOperation, BusCmd145_Para.BusMstSel, BusCmd145_Para.BusIn, BusCmd145_Para.BusOut, BusCmd145_Para.BusData, TempTimeout)
	if BusCmd145_Para.BusResult ~= nil  then BusCmd145_Para.BusResult.value = Res end
end

BusCmd148_Para={
	{_name="BusOperation",    _desc ="<CH>读写类型</CH><EN>BusOperation</EN>",_type="enum",_init="BUSCMD_WRITE",_enum={"BUSCMD_WRITE","BUSCMD_READ"},_depends={"BusTimeout=01","BusResult=01"}},
	{_name="BusMstSel",    _desc ="<CH>操作类型</CH><EN>IoType</EN>",_type="enum",_init="BUSCMD_MST",_enum={"BUSCMD_MST","BUSCMD_SLE"}},
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="BusData",	_desc ="<CH>数据</CH><EN>BusData</EN>",_type="cmd_typ08_t"},	
	{_name="BusTimeout",	_desc ="<CH>超时时间 (ms)</CH><EN>BusTimeout (ms)</EN>",_type="INTC",_max=2147483647,_min=-1,_init=0},
	{_name="BusResult",	_desc ="<CH>状态输出</CH><EN>Output Val</EN>",_type="INT"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusCmd148",_comm ="<CH>Bus Cmd 148 通讯指令.</CH><EN>Bus Command 148.</EN>"},
}
function BusCmd148(BusCmd148_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempTimeout = nil
	if BusCmd148_Para.BusTimeout ~= nil then
		TempTimeout = (type(BusCmd148_Para.BusTimeout) == "integer" or type(BusCmd148_Para.BusTimeout) == "number" or BusCmd148_Para.BusTimeout.value == nil) and BusCmd148_Para.BusTimeout or BusCmd148_Para.BusTimeout.value
	end
	local Res = bus_cmd148_(BusCmd148_Para.BusOperation, BusCmd148_Para.BusMstSel, BusCmd148_Para.BusIn, BusCmd148_Para.BusOut, BusCmd148_Para.BusData, TempTimeout)
	if BusCmd148_Para.BusResult ~= nil  then BusCmd148_Para.BusResult.value = Res end
end

BusCmd151_Para={
	{_name="BusOperation",    _desc ="<CH>读写类型</CH><EN>BusOperation</EN>",_type="enum",_init="BUSCMD_WRITE",_enum={"BUSCMD_WRITE","BUSCMD_READ"},_depends={"BusTimeout=01","BusResult=01"}},
	{_name="BusMstSel",    _desc ="<CH>操作类型</CH><EN>IoType</EN>",_type="enum",_init="BUSCMD_MST",_enum={"BUSCMD_MST","BUSCMD_SLE"}},
	{_name="BusIn",	_desc ="<CH>总线输入接口参数</CH><EN>BusIn</EN>",_type="busin_t"},	
	{_name="BusOut",	_desc ="<CH>总线输出接口参数</CH><EN>BusOut</EN>",_type="busout_t"},	
	{_name="BusData",	_desc ="<CH>数据</CH><EN>BusData</EN>",_type="cmd_typ06_t"},	
	{_name="BusTimeout",	_desc ="<CH>超时时间 (ms)</CH><EN>BusTimeout (ms)</EN>",_type="INTC",_max=2147483647,_min=-1,_init=0},
	{_name="BusResult",	_desc ="<CH>状态输出</CH><EN>Output Val</EN>",_type="INT"},	
    {_name="Secondname",_desc ="Secondname",_type="str",_init="BusCmd151",_comm ="<CH>Bus Cmd 151 通讯指令.</CH><EN>Bus Command 151.</EN>"},
}
function BusCmd151(BusCmd151_Para)
	WaitIsParseAllowed(2,1)  -----参数1：打断方式（1=强制打断，2=可控打断）；参数2：等待到位方式（1=给定到位，2=实际到位）
	local TempTimeout = nil
	if BusCmd151_Para.BusTimeout ~= nil then
		TempTimeout = (type(BusCmd151_Para.BusTimeout) == "integer" or type(BusCmd151_Para.BusTimeout) == "number" or BusCmd151_Para.BusTimeout.value == nil) and BusCmd151_Para.BusTimeout or BusCmd151_Para.BusTimeout.value
	end
	local Res = bus_cmd151_(BusCmd151_Para.BusOperation, BusCmd151_Para.BusMstSel, BusCmd151_Para.BusIn, BusCmd151_Para.BusOut, BusCmd151_Para.BusData, TempTimeout)
	if BusCmd151_Para.BusResult ~= nil  then BusCmd151_Para.BusResult.value = Res end
end

