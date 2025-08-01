--***********************************************************
--
-- Copyright 2018 - 2025 speedbot All Rights reserved.
--
-- file Name: lib_logs
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

function log_info_(Id, ErrorMsg)
	local Msg = ""
	for i = 1, #ErrorMsg do 
		Msg = Msg..tostring(ErrorMsg[i]) 
	end
	ins:setRobotInfo(Msg, 70001 + (Id % 10000))
end

function log_warn_(Id, ErrorMsg)
	local Msg = ""
	for i = 1, #ErrorMsg do 
		Msg = Msg..tostring(ErrorMsg[i]) 
	end
	ins:setRobotWarning(Msg, 70001 + (Id % 10000))
end

function log_error_(Id, ErrorMsg)
	local Msg = ""
	for i = 1, #ErrorMsg do 
		Msg = Msg..tostring(ErrorMsg[i]) 
	end
	while true do
		ins:setRobotToError(Msg, 90001 + (Id % 10000))
		ins:LuaPauseRun()
		delay_(1)
	end
end




















