--***********************************************************
--
-- Copyright 2018 - 2025 speedbot All Rights reserved.
--
-- file Name: lib_math
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

function bit_2byte_(Bits, StartIndex, Len)
	if (StartIndex <= 0) or (StartIndex > 32) then
		log_error_(1, {"bit_2byte_:Invalid start address!", "[StartIndex:", StartIndex, "]"})
	end
	if (Len <= 0) or (Len > 32) then
		log_error_(1, {"bit_2byte_:Invalid length!", "[Len:", Len, "]"})
	end
	
	local Val = 0
    for i = 1, Len do 
		Val = Val + Bits[StartIndex + i - 1] * (2^(i - 1))
	end

    return Val
end

function bit_2val_(Type, BitArray)
	if (#BitArray == 0) or (BitArray == nil) then
		log_error_(1, {"bit_2val_:Invalid Val!"})	
	end
	if Type == "BIT" then
		return BitArray[1]
	elseif Type == "UINT8" then
		return bit_2byte_(BitArray, 1, 8)
	elseif Type == "UINT16" or Type == "INT16" then
		local Temp = bit_2byte_(BitArray, 9, 8) * 256 + bit_2byte_(BitArray, 1, 8)
		if Type == "INT16" then 
			Temp = Temp > 32767 and Temp - 65536 or Temp
		end
		return Temp
	elseif Type == "INT32" then
		return ins:BitOperation(5, bit_2byte_(BitArray, 25, 8), 24) + ins:BitOperation(5, bit_2byte_(BitArray, 17, 8), 16) + ins:BitOperation(5, bit_2byte_(BitArray, 9, 8), 8) + bit_2byte_(BitArray, 1, 8)	
	elseif Type == "FLOAT2" then
		local Int16 = {0, 0}
		Int16[1] = bit_2byte_(BitArray, 9, 8) * 256 + bit_2byte_(BitArray, 1, 8)
		Int16[2] = bit_2byte_(BitArray, 25, 8) * 256 + bit_2byte_(BitArray, 17, 8)
		Int16[1] = Int16[1] > 32767 and Int16[1] - 65536 or Int16[1]
		Int16[2] = Int16[2] > 32767 and Int16[2] - 65536 or Int16[2]
		return Int16[1] + Int16[2] / 10000.0
	else
		log_error_(1, {"bit_2val_:Invalid Type!", "[Type:", Type, "]"})
	end
end

function byte_2bit_(Val)
	-- if type(Val) ~= "integer" then
	-- 	log_error_(1, {"byte_2bit_:The input data is not of type integer!"})
	-- end

	if (Val < 0) or (Val > 255) then
		log_error_(1, {"byte_2bit_:Invalid Val!", "[Val:", Val, "]"})
	end

	local Bits = {0, 0, 0, 0, 0, 0, 0, 0}
	for i = 0, 7 do
		Bits[i + 1] = ins:BitOperation(1, ins:BitOperation(6, Val, i), 1)
	end
	return Bits
end



















