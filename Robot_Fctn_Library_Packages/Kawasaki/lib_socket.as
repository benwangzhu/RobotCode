;***********************************************************
;
; Copyright 2018 - 2023 speedbot All Rights reserved.
;
; File Name: lib_socket
;
; Description:
;   Language             ==   As for KAWASAKI ROBOT
;   Date                 ==   2021 - 08 - 17
;   Modification Data    ==   2021 - 09 - 17
;
; Author: speedbot
;
; Version: 1.0
;*********************************************************************************************************;
;                                                                                                         ;
;                                                      .^^^                                               ;
;                                               .,~<c+{{{{{{t,                                            ; 
;                                       `^,"!t{{{{{{{{{{{{{{{{+,                                          ;
;                                 .:"c+{{{{{{{{{{{{{{{{{{{{{{{{{+,                                        ;
;                                "{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{~                                       ;
;                               ^{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{!.  `^                                    ;
;                               c{{{{{{{{{{{{{c~,^`  `.^:<+{{{!.  `<{{+,                                  ;
;                              ^{{{{{{{{{{{!^              `,.  `<{{{{{{+:                                ;
;                              t{{{{{{{{{!`                    ~{{{{{{{{{{+,                              ;
;                             ,{{{{{{{{{:      ,uDWMMH^        `c{{{{{{{{{{{~                             ;
;                             +{{{{{{{{:     ,XMMMMMMw           t{{{{{{{{{{t                             ;
;                            ,{{{{{{{{t     :MMMMMMMMM"          ^{{{{{{{{{{~                             ;
;                            +{{{{{{{{~     8MMMMMMMMMMWD8##      {{{{{{{{{+                              ;
;                           :{{{{{{{{{~     8MMMMMMMMMMMMMMH      {{{{{{{{{~                              ;
;                           +{{{{{{{{{c     :MMMMMMMMMMMMMMc     ^{{{{{{{{+                               ;
;                          ^{{{{{{{{{{{,     ,%MMMMMMMMMMH"      c{{{{{{{{:                               ;
;                          `+{{{{{{{{{{{^      :uDWMMMX0"       !{{{{{{{{+                                ;
;                           `c{{{{{{{{{{{"                    ^t{{{{{{{{{,                                ;
;                             ^c{{{{{{{{{{{".               ,c{{{{{{{{{{t                                 ;
;                               ^c{{{{{{{{{{{+<,^`     .^~c{{{{{{{{{{{{{,                                 ;
;                                 ^c{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{t                                  ;
;                                   ^c{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{t`                                  ;
;                                     ^c{{{{{{{{{{{{{{{{{{{{{{{{{{+c"^                                    ;                         
;                                       ^c{{{{{{{{{{{{{{{{{+!":^.                                         ;
;                                         ^!{{{{{{{{t!",^`                                                ;
;                                                                                                         ;
;*********************************************************************************************************;
;

; Load ==> lib_socket_t.AS
; 用此文件的接口库之前必须调用 libsock_cfg_ 程序

;***********************************************************

; 2021 - 08 - 17 ++ lib.tcp_accept_()

; 2021 - 08 - 17 ++ lib.tcp_conn_()

; 2021 - 08 - 17 ++ lib.tcp_dconn_()

; 2021 - 10 - 25 ++ lib.tcp_err_()

; 2021 - 08 - 17 ++ lib.tcp_write_() 

; 2021 - 08 - 17 ++ lib.tcp_rjson_() 

;***********************************************************
; func lib.tcp_accept_()
;***********************************************************
;	OUT : .ServerId			* INT *		* socket Id *
;***********************************************************
; socket监听, 返回一个提供Socket服务的Id号
;***********************************************************
.program lib.tcp_accept_(.ServerId)

    if existinteger("@SOCK_DEFED") == 0 then 

        call lib.def_socket_
    end

	do
		tcp_listen .RetListen, SSockPort
		if .RetListen < SOCK_SUCCESS then
			twait 0.1
		end
	until .RetListen >= SOCK_SUCCESS
	do
		tcp_accept .ServerId, SSockPort, 1
	until .ServerId > SOCK_SUCCESS
	;
	tcp_end_listen .RetListen, SSockPort

	tcp_status .SockCnt, .AryPortNo[1], .ArySockId[1], .AryErrCd[1], .ArySubSd[1], .$AryIp[1]
	
	if .SockCnt > 0 then 
		for .Count = 1 to .SockCnt
			if .ArySockId[.Count] == .ServerId then
				$SSockIp = .$AryIp[.Count]
			end
		end
	end
.end 
	
;***********************************************************
; func lib.tcp_conn_()
;***********************************************************
;	OUT : .ClientId			* INT *		* socket Id *
;***********************************************************
; socket连接, 返回一个提供Socket服务的Id号
;***********************************************************
.program lib.tcp_conn_(.ClientId)
    if existinteger("@SOCK_DEFED") == 0 then 

        call lib.def_socket_
    end

	.Timeout = 3
	.$ProcStr = $CSockIp + "."
	for .I = 1 to 4
		.$IpStr = $decode(.$ProcStr, ".", 0)
		.$TmpStr = $decode(.$ProcStr, ".", 1)
		.Ip[.I] = val(.$Ipstr)
	end
	tcp_status .SockCnt, .AryPortNo[1], .ArySockId[1], .AryErrCd[1], .ArySubSd[1], .$AryIp[1]
	if .SockCnt > 0 then
		for .Count = 1 to .SockCnt
			if .AryPortNo[.Count] == CSockPort then
				tcp_close .Ret, .ArySockId[.Count]
				if .Ret < SOCK_SUCCESS then
					tcp_close .Ret, .ArySockId[.Count]
				end
			end
		end
	end
	tcp_connect .ClientId, CSockPort, .Ip[1], .Timeout
.end 

;***********************************************************
; func lib.tcp_dconn_()
;***********************************************************
;	IN : .SockId			* INT *		* socket Id *
;***********************************************************
; 关闭指定Socket Id的服务
;***********************************************************
.program lib.tcp_dconn_(.SockId)
    if existinteger("@SOCK_DEFED") == 0 then 

        call lib.def_socket_
    end

	tcp_status .SockCnt, .AryPortNo[1], .ArySockId[1], .AryErrCd[1], .ArySubSd[1], .$AryIp[1]
	if .SockCnt > 0 then
		for .Count = 1 to .SockCnt
			if .SockId == .ArySockId[.Count] then
				tcp_close .Ret, .SockId
				if .Ret < SOCK_SUCCESS then
					tcp_close .Ret, .SockId
				end
			end
		end
	end
.end 

;***********************************************************
; func lib.tcp_err_()
;***********************************************************
;	IN : .SockId			* INT *		* socket Id *
;  OUT : .Errno			* INT *     	* 错误编号 *
;***********************************************************
; 返回指定的Socket Id号最后一次发生的错误
;***********************************************************
.program lib.tcp_err_(.SockId, .Errno)
    if existinteger("@SOCK_DEFED") == 0 then 

        call lib.def_socket_
    end

	.Status = -1
	tcp_status .SockCnt, .AryPortNo[1], .ArySockId[1], .AryErrCd[1], .ArySubSd[1], .$AryIp[1]
	for .Count = 1 to .SockCnt
		if .SockId == .ArySockId[.Count] then
			.Errno = .AryErrCd[.Count]
			return
		end
	end
.end 

;***********************************************************
; func lib.tcp_write_() 
;***********************************************************
;	IN : .SockId			* INT *		* socket接口 *
;	IN : .$Msg				* STRING *	* 要发送的字符串 *
;  OUT : .Status			* INT *		* 为0表示发送成功 *
;***********************************************************
; socket数据发送
;***********************************************************
.program lib.tcp_write_(.SockId, .$Msg, .Status) 
    if existinteger("@SOCK_DEFED") == 0 then 

        call lib.def_socket_
    end

	.BufN = 1
	.Timeout = 3
	.$SBuf[1] = .$Msg
	.Status = SOCK_SUCCESS
	.Online = false
	;
	tcp_status .SockCnt, .AryPortNo[1], .ArySockId[1], .AryErrCd[1], .ArySubSd[1], .$AryIp[1]
	if .SockCnt > 0 then 
		for .Count = 1 to .SockCnt
			if .ArySockId[.Count] == .SockId then
				.Online = true
			end
		end
	else
		.Status = SOCK_COM_ERR * (-1)
		return
	end
	;
	if .Online == true then
		tcp_send .Ret, .SockId, .$SBuf[1], .BufN, .Timeout
		if .Ret < SOCK_SUCCESS then
			.Status = SOCK_COM_ERR * (-1)
			return
		end
	else
		.Status = SOCK_COM_ERR * (-1)
		return	
	end
.end

;***********************************************************
; func lib.tcp_rjson_()
;***********************************************************
;	IN : .SockId			* INT *		* socket接口 *
;  OUT : .IntData[]			* INT *		* 返回的整型数组 *
;  OUT : .FloatData[]		* REAL *	* 返回的浮点型数组 *
;  OUT : .$StringData[]     * STRING *	* 返回的字符串数组 *
;  OUT : .PosData[ , ]		* REAL *	* 返回坐标数组 *
;  OUT : .Status			* INT *		* 不为0表示失败 *  
;***********************************************************
; 以json格式从缓冲区读取数据
;***********************************************************
.program lib.tcp_rjson_(.SockId, .IntData[], .FloatData[], .$StringData[], .PosData[, ], .Status)
    if existinteger("@SOCK_DEFED") == 0 then 

        call lib.def_socket_
    end

	.Num = 0
	.MaxLen = 1
	.Status = SOCK_SUCCESS
	.ClientFlg = false
	.ServerFlg = false
	; Reading Bits
	;
	tcp_status .SockCnt, .AryPortNo[1], .ArySockId[1], .AryErrCd[1], .ArySubSd[1], .$AryIp[1]
	if .SockCnt > 0 then 
		for .Count = 1 to .SockCnt
			if .ArySockId[.Count] == .SockId then
				if .AryPortNo[.Count] == 0 then
					.ServerFlg = true
				else
					.ClientFlg = true
				end
			end
		end
	else
		.Status = SOCK_COM_ERR * (-1)
		return
	end
	
	if .ClientFlg == true then
		.Timeout = CSockRecvTimeout
	else
		if .ServerFlg == true then
			.Timeout = SSockRecvTimeout
		else
			if (.ClientFlg == false) AND (.ServerFlg == false) then
				.Status = SOCK_COM_ERR * (-1)
				return
			end
		end
	end
	
	if .Timeout == 0 then
		do
			tcp_recv .Ret, .SockId, .$RBuf[1], .Num, 2, .MaxLen
			call lib.tcp_err_(.SockId, .LastErrno)
		until (.LastErrno <> SOCK_TIMEOUT) or (.Num > 0)
	else
        do
            if .Timeout > 60 then
                .CurTimeout = 60
            else
                .CurTimeout = .Timeout
            end
		    tcp_recv .Ret, .SockId, .$RBuf[1], .Num, .CurTimeout, .MaxLen
            .Timeout = .Timeout - .CurTimeout
        until (.Timeout <= 0) or (.Num > 0)
	end

	if (.Ret < SOCK_SUCCESS) OR (.Num <= 0) then
		.Status = SOCK_COM_ERR * (-1)
		return
	end
	; Conver 'key{********************}'
	;
	.NumOfKey = 0
	.NumOfValue = 0
	.NumOfInt = 0
	.NumOfRel = 0
	.NumOfStr = 0
	.NumOfPos = 0
	
	.Count = 1
	.$TmpStr = ""
	while .$RBuf[.Count] <> $JSON_DEC_EL1 do

		if .$RBuf[.Count] <> $JSON_DEC_NUL then
			.$TmpStr = .$TmpStr + .$RBuf[.Count]
		end

		.Count = .Count + 1
	end
	
	if .$TmpStr <> $JSON_DEC_KEY then
		.Status = SOCK_HED_NAM * (-1)
		return
	end
	
	while .$RBuf[.Count] <> $JSON_DEC_EL2 do
		.NumOfKey = .NumOfKey + 1
		if .NumOfKey > JSON_MAX_DATA then
		  .Status = SOCK_NUM_DAT * (-1)
		  return
		end
		.$TmpStr = ""
		.Count = .Count + 1
		do
		  .$TmpStr = .$TmpStr + .$RBuf[.Count]
		  .Count = .Count + 1
		until (.$RBuf[.Count] == $JSON_DEC_EL4) OR (.$RBuf[.Count] == $JSON_DEC_EL2)
		.$JsonName[.NumOfKey] = $decode(.$TmpStr, $JSON_DEC_EL3, 0)
		.$ProcStr = $decode(.$TmpStr, $JSON_DEC_EL3, 1)
		.$JsonType[.NumOfKey] = .$TmpStr

	end
	
	; Conver 'value{********************}'
	;
	.$TmpStr = ""
	.Count = .Count + 1
	while .$RBuf[.Count] <> $JSON_DEC_EL1 do
		if .$RBuf[.Count] <> $JSON_DEC_NUL then
			.$TmpStr = .$TmpStr + .$RBuf[.Count]
		end
		.Count = .Count + 1
	end
	
	if .$TmpStr <> $JSON_DEC_VAL then
		.Status = SOCK_HED_DAT * (-1)
		return
	end
	
	while .$RBuf[.Count] <> $JSON_DEC_EL2 do
		.NumOfValue = .NumOfValue + 1
		if .NumOfValue > .NumOfKey then
			.Status = SOCK_NUM_DAT * (-1)
			return
		end
		.$TmpStr = ""
		.Count = .Count + 1
		do
		  .$TmpStr = .$TmpStr+.$RBuf[.Count]
		  .Count = .Count + 1
		until (.$RBuf[.Count] == $JSON_DEC_EL4) OR (.$RBuf[.Count] == $JSON_DEC_EL2)
		.$ProcStr = $decode(.$TmpStr, $JSON_DEC_EL3, 0)
		.$Proc2Str = $decode(.$TmpStr, $JSON_DEC_EL3, 1)
		for .I = 1 to .NumOfKey
			if .$ProcStr == .$JsonName[.I] then
				if .$JsonType[.I] == $JSON_INT_TYP then
					.IntData[.NumOfInt] = val(.$TmpStr)
					.NumOfInt = .NumOfInt + 1
				else
					if .$JsonType[.I] == $JSON_FLT_TYP then
						.FloatData[.NumOfRel] = val(.$TmpStr)
						.NumOfRel = .NumOfRel + 1
					else
						if .$JsonType[.I] == $JSON_STR_TYP then
							.$StringData[.NumOfStr] = .$TmpStr
							.NumOfStr = .NumOfStr + 1
						else
							if .$JsonType[.I] == $JSON_POS_TYP then
								.$Proc2Str = .$TmpStr + $JSON_DEC_EL5
								for .J = 0 to JSON_MAX_AXS
									.$PosStr = $decode(.$Proc2Str, $JSON_DEC_EL5, 0)
									.PosData[.NumOfPos, .J] = val(.$PosStr)
									.$PosStr = $decode(.$Proc2Str, $JSON_DEC_EL5, 1)
								end
								.NumOfPos = .NumOfPos + 1
							else
								.Status = SOCK_TYP_DAT * (-1)
								return
							end
						end
					end
				end
			end
		end
	end
	.Status = SOCK_SUCCESS
	return
.end


;***********************************************************
; func lib.release_tcp_()
;***********************************************************
;
;***********************************************************
; 释放所有套接字
;***********************************************************
.program lib.release_tcp_()

    if existinteger("@SOCK_DEFED") == 0 then 

        call lib.def_socket_
    end

	tcp_status .SockCnt, .AryPortNo[1], .ArySockId[1], .AryErrCd[1], .ArySubSd[1], .$AryIp[1]
    for .Count = 1 to .SockCnt
        tcp_close .Ret, .ArySockId[.Count]
        if .Ret < 0 then 
            tcp_close .Ret, .ArySockId[.Count]
        end
    end
.end

.program lib.def_socket_()
	; Decode String 
	;
	$JSON_POS_TYP                 	= "xyzabc"
	$JSON_INT_TYP                 	= "int"
	$JSON_FLT_TYP                	= "float"
	$JSON_STR_TYP                 	= "str"
	$JSON_DEC_EL1                	= "{"
	$JSON_DEC_EL2                	= "}"
	$JSON_DEC_EL3                	= ":"
	$JSON_DEC_EL4               	= ";"
	$JSON_DEC_EL5                	= ","
	$JSON_DEC_KEY                	= "key"
	$JSON_DEC_VAL                	= "value"
	$JSON_DEC_NUL                	= " "
	
	;
	JSON_MAX_DATA					= 30
    ;JSON_MAX_INT	    			= 10
    ;JSON_MAX_POS	    			= 10
    ;JSON_MAX_FLT	    			= 10
    ;JSON_MAX_STR	    			= 10
	
	;
	JSON_MAX_AXS					= (6 - 1)
	
	; Error Code
	;
	SOCK_SUCCESS                   	= 0
	SOCK_TIMEOUT					= -34024
	SOCK_NUM_DAT               	 	= 800001
	SOCK_TYP_DAT                  	= 800002
	SOCK_HED_NAM                  	= 800003
	SOCK_HED_DAT                  	= 800004
	SOCK_COM_ERR					= 800005
	

	SOCK_DEFED						= 0
	; 需要使用Socket模块之前，必须对以下变量自定义赋值
	; Socket Config 
	;
	;SSockConnected					= false
	;$SSockIp						= "0.0.0.0"
	;SSockPort						= 0
	;SSockRecvTimeout				= 0
	
	;CSockConnected					= false
	;$CSockIp						= "0.0.0.0"
	;CSockPort						= 0
	;CSockRecvTimeout				= 0
.end

















































