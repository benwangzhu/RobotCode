/***********************************************************

Copyright 2018 - 2023 speedbot All Rights reserved.

file Name: lib_socket.c

Description:
  Language             ==   motoplus for Yaskawa ROBOT
  Date                 ==   2021 - 09 - 03
  Modification Data    ==   2021 - 09 - 18

Author: speedbot

Version: 1.0
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
  
2022 - 03 - 01 ++ tcp_connect_() ==> STATUS

2022 - 03 - 01 ++ tcp_accept_() ==> STATUS

2022 - 03 - 01 ++ tcp_disconnect_() ==> STATUS

2022 - 03 - 01 ++ tcp_buffer_() ==> STATUS

2022 - 03 - 01 ++ tcp_send_msg_() ==> STATUS

2022 - 03 - 01 ++ tcp_received_msg() ==> STATUS

2022 - 03 - 01 ++ tcp_received_json_() ==> STATUS

2022 - 03 - 01 ++ udp_create_() ==> STATUS

2022 - 03 - 01 ++ udp_send_msg_() ==> STATUS

2022 - 03 - 01 ++ udp_received_msg_() ==> STATUS

2022 - 03 - 01 ++ udp_close_() ==> STATUS

2022 - 03 - 01 ++ encode_data_to_buffer_() ==> STATUS

2022 - 03 - 01 ++ decode_data_from_buffer_() ==> STATUS

*/

#include "motoPlus.h"
#include "lib_mpsocket.h"
#include "lib_mphelper.h"

STATUS tcp_connect_(INOUT struct sock_cfg_t *TcpSocketConfig)
{
	struct sockaddr_in SockAddr;
	INT32 Status;

	TcpSocketConfig->Connected = FALSE;

	TcpSocketConfig->SockFd = mpSocket(AF_INET, SOCK_STREAM, 0); 

	if (TcpSocketConfig->SockFd <= 0) 
	{
		//#if DEBUG_PRINT == ON
		DEBUG_ERROR("Creat Socket Error, Socket Fd = %d", TcpSocketConfig->SockFd);
		//#endif
		return(TcpSocketConfig->SockFd);
	}

	memset(&SockAddr, 0, sizeof(SockAddr));
	SockAddr.sin_family = AF_INET;
	SockAddr.sin_addr.s_addr = mpInetAddr(TcpSocketConfig->Host);
	SockAddr.sin_port = mpHtons(TcpSocketConfig->Port); 

	Status = mpConnect(TcpSocketConfig->SockFd, (struct sockaddr *)&SockAddr, sizeof(SockAddr));
	if (Status != OK)
	{
		//#if DEBUG_PRINT == ON
    	DEBUG_ERROR("Connect To Server Socket Error, Status = %d", Status);
		//#endif
	}

	TcpSocketConfig->Connected = (Status >= 0);
	
	return(Status);
}

STATUS tcp_accept_(INOUT struct sock_cfg_t *TcpSocketConfig)
{
	struct sockaddr_in SockAddr;
	struct sockaddr_in RemoteAddr;
	BOOL SockOpt = TRUE;
	INT32 Status;

	TcpSocketConfig->Connected = FALSE;

	int Sd = mpSocket(AF_INET, SOCK_STREAM, 0); 

	if (Sd <= 0) 
	{
		//#if DEBUG_PRINT == ON
        DEBUG_ERROR("Creat Socket Error, Socket Fd = %d", Sd);
		//#endif
		return(Sd);
	}

	memset(&SockAddr, 0, sizeof(SockAddr));
	SockAddr.sin_family = AF_INET;
	SockAddr.sin_addr.s_addr = INADDR_ANY;
	SockAddr.sin_port = mpHtons(TcpSocketConfig->Port); 

	mpSetsockopt(Sd, SOL_SOCKET, SO_REUSEADDR, (char*)&SockOpt, sizeof(SockOpt));

	Status = mpBind(Sd, (struct sockaddr *)&SockAddr, sizeof(struct sockaddr_in));
	if (Status != OK) 
	{
		//#if DEBUG_PRINT == ON
    	DEBUG_ERROR("Socket Bind Error, Status = %d", Status);
		//#endif
		return(Status);
	}

	Status = mpListen(Sd, 1);
	if (Status != OK)
	{
		//#if DEBUG_PRINT == ON
    	DEBUG_ERROR("Socket Listen Error, Status = %d", Status);
		//#endif
		return(Status);
	}

	memset(&RemoteAddr, 0, sizeof(RemoteAddr));
	int SizeOfRemoteAddr = sizeof(RemoteAddr);

	TcpSocketConfig->SockFd = mpAccept(Sd, (struct sockaddr *)&RemoteAddr, &SizeOfRemoteAddr);
	
	mpClose(Sd);

	if (TcpSocketConfig->SockFd <= 0) 
	{
		//#if DEBUG_PRINT == ON
    	DEBUG_ERROR("Accept Socket Error, Socket Fd = %d", TcpSocketConfig->SockFd);
		//#endif
		return(TcpSocketConfig->SockFd);
	}

	TcpSocketConfig->Connected = TRUE;
	return 0;
}

STATUS tcp_disconnect_(INOUT struct sock_cfg_t *TcpSocketConfig)
{
	mpClose(TcpSocketConfig->SockFd);
	TcpSocketConfig->Connected = FALSE;

    return(OK);
}

STATUS tcp_buffer_(INOUT struct sock_cfg_t *TcpSocketConfig)
{
	char RecvMsg[512];
	fd_set RecvFd;
	struct timeval Timeout = {0, 0};

	if (!TcpSocketConfig->Connected) return(ERROR);

	FD_ZERO(&RecvFd);
	FD_SET(TcpSocketConfig->SockFd, &RecvFd);

	TcpSocketConfig->NByte = mpSelect(TcpSocketConfig->SockFd + 1 , &RecvFd, NULL, NULL, &Timeout);
	if (TcpSocketConfig->NByte > 0)
    {
		TcpSocketConfig->NByte = mpRecv(TcpSocketConfig->SockFd, RecvMsg, sizeof(RecvMsg), 2);
		if (TcpSocketConfig->NByte <= 0) return(ERROR);
	}
	return(TcpSocketConfig->NByte);
}

STATUS tcp_send_msg_(INOUT struct sock_cfg_t *TcpSocketConfig, IN const CHAR* Message, IN USHORT Lenght)
{
	return(mpSend(TcpSocketConfig->SockFd, Message, Lenght, 0));
}

STATUS tcp_received_msg_(INOUT struct sock_cfg_t *TcpSocketConfig, OUT char* MessageBuffer, IN USHORT Lenght)
{
	fd_set	RecvFd;
	struct timeval Timeout = {(int)(TcpSocketConfig->RecvTimeout/1000), (int)((TcpSocketConfig->RecvTimeout - (TcpSocketConfig->RecvTimeout / 1000 % 10) * 1000) * 1000)};

	FD_ZERO(&RecvFd);
	FD_SET(TcpSocketConfig->SockFd, &RecvFd);

	if (TcpSocketConfig->RecvTimeout > 0 && TcpSocketConfig->NByte <= 0)
    {
		if (mpSelect(TcpSocketConfig->SockFd + 1 , &RecvFd, NULL, NULL, &Timeout) <= 0) return(ERROR);
        
    }

	return(mpRecv(TcpSocketConfig->SockFd, MessageBuffer, Lenght, 0));
}

STATUS tcp_received_json_(INOUT struct sock_cfg_t *TcpSocketConfig, OUT INT32 IntData[], OUT FLOAT FloatData[], OUT CHAR StringData[][JSON_MAX_STR], OUT FLOAT PosData[][JSON_MAX_AXS])
{
	char BuffStr[STR_BAFFER_MAX + 1];
	int Count = 1;
	char TmpStr[255];
	char JsonName[JSON_MAX_DAT][24];
	char JsonType[JSON_MAX_DAT][8];
	int NumOfKey = 0;
	int NumOfVal = 0;
	int NumOfInt = 0;
	int NumOfFloat = 0;
	int NumOfStr = 0;
	int NumOfPos = 0;
	int I, J;

	memset(BuffStr, '\0', sizeof(BuffStr));

	if (tcp_received_msg_(TcpSocketConfig, BuffStr, 1024) <= 0) return(ERROR);
	
	memset(TmpStr, '\0', sizeof(TmpStr));

	while((strcmp(sub_string_(&BuffStr[0], Count, 1), JSON_DEC_EL1) != 0))
    {	
		if(strcmp(sub_string_(&BuffStr[0], Count, 1), JSON_DEC_NUL) != 0) strcat(&TmpStr[0], sub_string_(&BuffStr[0], Count, 1));
		Count++;
	}

	if (strcmp(&TmpStr[0], JSON_DEC_KEY) != 0) return(ERROR);
	
	while((strcmp(sub_string_(&BuffStr[0], Count, 1), JSON_DEC_EL2) != 0))
    {
		NumOfKey++;
		memset(TmpStr, '\0', sizeof(TmpStr));
		Count++;
		FOREVER
        {
			strcat(&TmpStr[0], sub_string_(&BuffStr[0], Count, 1));
			Count++;
			if ((strcmp(sub_string_(&BuffStr[0], Count, 1), JSON_DEC_EL4) == 0) || (strcmp(sub_string_(&BuffStr[0], Count, 1), JSON_DEC_EL2) == 0)) break;
		}
		strcpy(JsonName[NumOfKey], sub_string_(TmpStr, 1, find_string_(TmpStr, JSON_DEC_EL3)));
		strcpy(JsonType[NumOfKey], sub_string_(TmpStr, find_string_(TmpStr, JSON_DEC_EL3) + 1, strlen(TmpStr) - find_string_(TmpStr, JSON_DEC_EL3)));
	}

	Count++;
	memset(TmpStr, '\0', sizeof(TmpStr));
	while((strcmp(sub_string_(&BuffStr[0], Count, 1), JSON_DEC_EL1) != 0))
    {	
		strcat(&TmpStr[0], sub_string_(&BuffStr[0], Count, 1));
		Count++;
	}

	if (strcmp(&TmpStr[0], JSON_DEC_VAL) != 0) return(ERROR);

	while((strcmp(sub_string_(&BuffStr[0], Count, 1), JSON_DEC_EL2) != 0))
    {
		NumOfVal++;
		memset(TmpStr, '\0', sizeof(TmpStr));
		Count++;
		FOREVER
        {
			strcat(&TmpStr[0], sub_string_(&BuffStr[0], Count, 1));
			Count++;
			if ((strcmp(sub_string_(&BuffStr[0], Count, 1), JSON_DEC_EL4) == 0) || (strcmp(sub_string_(&BuffStr[0], Count, 1), JSON_DEC_EL2) == 0)) break;
		}

		for(J = 1;J <= NumOfKey;J++)
        {
			if (strcmp(JsonName[J], sub_string_(TmpStr, 1, find_string_(TmpStr, JSON_DEC_EL3))) == 0)
            {
				if ((strcmp(JsonType[J], JSON_INT_TYP)) == 0)
                {
					NumOfInt++;
					IntData[NumOfInt - 1] = atoi(sub_string_(TmpStr, find_string_(TmpStr, JSON_DEC_EL3) + 1, strlen(TmpStr) - find_string_(TmpStr, JSON_DEC_EL3)));
					break;
				}
				else if ((strcmp(JsonType[J], JSON_FLT_TYP)) == 0)
                {
					NumOfFloat++;
					FloatData[NumOfFloat - 1] = atof(sub_string_(TmpStr, find_string_(TmpStr, JSON_DEC_EL3) + 1, strlen(TmpStr) - find_string_(TmpStr, JSON_DEC_EL3)));
					break;
				}
				else if ((strcmp(JsonType[J], JSON_STR_TYP)) == 0)
                {
					NumOfStr++;
					strcpy(StringData[NumOfStr - 1], sub_string_(TmpStr, find_string_(TmpStr, JSON_DEC_EL3) + 1, strlen(TmpStr) - find_string_(TmpStr, JSON_DEC_EL3)));
					break;
				}
				else if ((strcmp(JsonType[J], JSON_POS_TYP)) == 0)
                {
					NumOfPos++;
					strcpy(TmpStr, sub_string_(TmpStr, find_string_(TmpStr, JSON_DEC_EL3)+1, strlen(TmpStr) - find_string_(TmpStr, JSON_DEC_EL3)));
					strcat(TmpStr, JSON_DEC_EL5);
					for(I = 0;I < 6;I++)
                    {
						PosData[NumOfPos - 1][I] = atof(sub_string_(TmpStr, 1, find_string_(TmpStr, JSON_DEC_EL5) - 1));
						strcpy(TmpStr, sub_string_(TmpStr, find_string_(TmpStr, JSON_DEC_EL5) + 1, strlen(TmpStr) - find_string_(TmpStr, JSON_DEC_EL5)));
					}
					break;
				}
				
			}
		}
			
	}

	return(OK);

}

STATUS udp_create_(INOUT struct udp_cfg_t *UdpSocketConfig)
{
	struct sockaddr_in SockAddr;
	BOOL SockOpt = TRUE;

	UdpSocketConfig->SockFd = mpSocket(AF_INET, SOCK_DGRAM, 0); 

	if (UdpSocketConfig->SockFd < 0) return(ERROR);

	memset(&SockAddr, 0, sizeof(SockAddr));
	SockAddr.sin_family = AF_INET;
	SockAddr.sin_addr.s_addr = INADDR_ANY;
	SockAddr.sin_port = mpHtons(UdpSocketConfig->InternalPort); 

	mpSetsockopt(UdpSocketConfig->SockFd, SOL_SOCKET, SO_REUSEADDR, (char*)&SockOpt, sizeof(SockOpt));

	return(mpBind(UdpSocketConfig->SockFd, (struct sockaddr *)&SockAddr, sizeof(struct sockaddr_in)));
}

STATUS udp_send_msg_(INOUT struct udp_cfg_t *UdpSocketConfig, IN CHAR* Message, IN USHORT Lenght)
{
	struct sockaddr_in RemoteAddr;

    RemoteAddr.sin_family = AF_INET;
    RemoteAddr.sin_port = mpHtons(UdpSocketConfig->ExternalPort);
    RemoteAddr.sin_addr.s_addr = mpInetAddr(UdpSocketConfig->ExternalHost);
    return(mpSendTo(UdpSocketConfig->SockFd, Message, Lenght, 0, (struct sockaddr *)&RemoteAddr, sizeof(RemoteAddr)));
}

STATUS udp_received_msg_(INOUT struct udp_cfg_t *UdpSocketConfig, OUT CHAR* MessageBuffer, IN USHORT Lenght)
{
	fd_set	RecvFd;
	struct sockaddr_in RemoteAddr;
	struct timeval Timeout = {(int)(UdpSocketConfig->RecvTimeout/1000), (int)((UdpSocketConfig->RecvTimeout - (UdpSocketConfig->RecvTimeout / 1000 % 10) * 1000) * 1000)};
    int AddrLen = sizeof(RemoteAddr);
    int Ret;

	FD_ZERO(&RecvFd);
	FD_SET(UdpSocketConfig->SockFd, &RecvFd);
	if (UdpSocketConfig->RecvTimeout > 0)
    {
		if (mpSelect(UdpSocketConfig->SockFd + 1 , &RecvFd, NULL, NULL, &Timeout) <= 0) return(ERROR);
    }
    
    Ret = mpRecvFrom(UdpSocketConfig->SockFd, MessageBuffer, Lenght, 0, (struct sockaddr *)&RemoteAddr, &AddrLen);
    if(Ret > 0)
    {

        memcpy(UdpSocketConfig->ExternalHost, mpInetNtoa(RemoteAddr.sin_addr), strlen(mpInetNtoa(RemoteAddr.sin_addr)));
        UdpSocketConfig->ExternalPort = mpNtohs(RemoteAddr.sin_port);
    }

    return(Ret);
}

STATUS udp_close_(INOUT struct udp_cfg_t *UdpSocketConfig)
{
	mpClose(UdpSocketConfig->SockFd);
    UdpSocketConfig->SockFd = -1;
    return(OK);
}

STATUS encode_data_to_buffer_(INOUT UCHAR *Buffer, IN const VOID *DataVal, INOUT UINT *Offset, IN UINT Size)
{
	memcpy(Buffer + (*Offset), DataVal, Size);
	*Offset += Size;

    return(OK);
}

STATUS decode_data_from_buffer_(IN const UCHAR *Buffer, OUT VOID *DataVal, INOUT UINT *Offset, IN UINT Size)
{
	memcpy(DataVal, Buffer + (*Offset), Size);
	*Offset += Size;

    return(OK);
}