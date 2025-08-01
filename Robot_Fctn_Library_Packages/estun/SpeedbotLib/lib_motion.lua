--***********************************************************
--
-- Copyright 2018 - 2025 speedbot All Rights reserved.
--
-- file Name: lib_motion
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



function cpos_2array_(PosVal)
    return  {	PosVal.x or 0.0,
				PosVal.y or 0.0, 
 				PosVal.z or 0.0, 
				PosVal.a or 0.0, 
				PosVal.b or 0.0, 
				PosVal.c or 0.0,
				PosVal.a7 or 0.0,
				PosVal.a8 or 0.0,
				PosVal.a9 or 0.0,
				PosVal.a10 or 0.0,
				PosVal.a11 or 0.0,
				PosVal.a12 or 0.0
			}
end

function apos_2array_(PosVal)
    return  {	PosVal.a1 or 0.0,
				PosVal.a2 or 0.0, 
 				PosVal.a3 or 0.0, 
				PosVal.a4 or 0.0, 
				PosVal.a5 or 0.0, 
				PosVal.a6 or 0.0,
				PosVal.a7 or 0.0,
				PosVal.a8 or 0.0,
				PosVal.a9 or 0.0,
				PosVal.a10 or 0.0,
				PosVal.a11 or 0.0,
				PosVal.a12 or 0.0
			}
end

function array_2cpos_(ArrayVal)
	local TempCpos={
		_type="CPOS",
		confdata={_type="POSCFG",mode=mov:GetCurCM(1),cf1=mov:GetCurCM(2),cf2=mov:GetCurCM(3),cf3=mov:GetCurCM(4),cf4=mov:GetCurCM(5),cf5=mov:GetCurCM(6),cf6=mov:GetCurCM(7)},
		x=mov:GetSelectCurW(1),
		y=mov:GetSelectCurW(2),
		z=mov:GetSelectCurW(3),
		a=mov:GetSelectCurW(4),
		b=mov:GetSelectCurW(5),
		c=mov:GetSelectCurW(6),
		a7=mov:GetSelectCurJ(7),
		a8=mov:GetSelectCurJ(8),
		a9=mov:GetSelectCurJ(9),
		a10=mov:GetSelectCurJ(10),
		a11=mov:GetSelectCurJ(11),
		a12=mov:GetSelectCurJ(12),
		a13=mov:GetSelectCurJ(13),
		a14=mov:GetSelectCurJ(14),
		a15=mov:GetSelectCurJ(15),
		a16=mov:GetSelectCurJ(16)
	}

	if #ArrayVal >= 1 then
		TempCpos.x = ArrayVal[1]
	end
	if #ArrayVal >= 2 then
		TempCpos.y = ArrayVal[2]
	end
	if #ArrayVal >= 3 then
		TempCpos.z = ArrayVal[3]
	end
	if #ArrayVal >= 4 then
		TempCpos.a = ArrayVal[4]
	end
	if #ArrayVal >= 5 then
		TempCpos.b = ArrayVal[5]
	end
	if #ArrayVal >= 6 then
		TempCpos.c = ArrayVal[6]
	end
	if #ArrayVal >= 7 then
		TempCpos.a7 = ArrayVal[7]
	end
	if #ArrayVal >= 8 then
		TempCpos.a8 = ArrayVal[8]
	end
	if #ArrayVal >= 9 then
		TempCpos.a9 = ArrayVal[9]
	end
	if #ArrayVal >= 10 then
		TempCpos.a10 = ArrayVal[10]
	end
	if #ArrayVal >= 11 then
		TempCpos.a11 = ArrayVal[11]
	end
	if #ArrayVal >= 12 then
		TempCpos.a12 = ArrayVal[12]
	end
	if #ArrayVal >= 13 then
		TempCpos.a13 = ArrayVal[13]
	end
	if #ArrayVal >= 14 then
		TempCpos.a14 = ArrayVal[14]
	end
	if #ArrayVal >= 15 then
		TempCpos.a15 = ArrayVal[15]
	end
	if #ArrayVal >= 16 then
		TempCpos.a16 = ArrayVal[16]
	end

	return TempCpos
end

function array_2apos_(ArrayVal)
	local TempApos={
		_type="APOS",
		a1=mov:GetSelectCurJ(1),
		a2=mov:GetSelectCurJ(2),
		a3=mov:GetSelectCurJ(3),
		a4=mov:GetSelectCurJ(4),
		a5=mov:GetSelectCurJ(5),
		a6=mov:GetSelectCurJ(6),
		a7=mov:GetSelectCurJ(7),
		a8=mov:GetSelectCurJ(8),
		a9=mov:GetSelectCurJ(9),
		a10=mov:GetSelectCurJ(10),
		a11=mov:GetSelectCurJ(11),
		a12=mov:GetSelectCurJ(12),
		a13=mov:GetSelectCurJ(13),
		a14=mov:GetSelectCurJ(14),
		a15=mov:GetSelectCurJ(15),
		a16=mov:GetSelectCurJ(16)
	}
	
	if #ArrayVal >= 1 then
		TempApos.a1 = ArrayVal[1]
	end
	if #ArrayVal >= 2 then
		TempApos.a2 = ArrayVal[2]
	end
	if #ArrayVal >= 3 then
		TempApos.a3 = ArrayVal[3]
	end
	if #ArrayVal >= 4 then
		TempApos.a4 = ArrayVal[4]
	end
	if #ArrayVal >= 5 then
		TempApos.a5 = ArrayVal[5]
	end
	if #ArrayVal >= 6 then
		TempApos.a6 = ArrayVal[6]
	end
	if #ArrayVal >= 7 then
		TempApos.a7 = ArrayVal[7]
	end
	if #ArrayVal >= 8 then
		TempApos.a8 = ArrayVal[8]
	end
	if #ArrayVal >= 9 then
		TempApos.a9 = ArrayVal[9]
	end
	if #ArrayVal >= 10 then
		TempApos.a10 = ArrayVal[10]
	end
	if #ArrayVal >= 11 then
		TempApos.a11 = ArrayVal[11]
	end
	if #ArrayVal >= 12 then
		TempApos.a12 = ArrayVal[12]
	end
	if #ArrayVal >= 13 then
		TempApos.a13 = ArrayVal[13]
	end
	if #ArrayVal >= 14 then
		TempApos.a14 = ArrayVal[14]
	end
	if #ArrayVal >= 15 then
		TempApos.a15 = ArrayVal[15]
	end
	if #ArrayVal >= 16 then
		TempApos.a16 = ArrayVal[16]
	end

	return TempApos
end














