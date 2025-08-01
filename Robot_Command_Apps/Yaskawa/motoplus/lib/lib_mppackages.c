/***********************************************************

Copyright 2018 - 2023 speedbot All Rights reserved.

file Name: lib_mppackages.c

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
  
*/

#include "motoPlus.h"
#include "lib_mphelper.h"
#include "lib_mppackages.h"


STATUS encodedataframe_char_(INOUT UCHAR* Buffer, INOUT INT32* Offset, IN CHAR Value)
{
	if (Buffer == NULL || Offset == NULL)
	{
		DEBUG_INFO("Arguments are invalid!");
		
		return ERROR;
	}
	
	memcpy(Buffer + (*Offset), &Value, sizeof(CHAR));
	*Offset += sizeof(CHAR);
	
	return OK;
}

STATUS encodedataframe_str_(INOUT UCHAR* Buffer, INOUT INT32* Offset, IN const CHAR* Value, IN INT32 Len)
{
	if ((Buffer == NULL) || (Offset == NULL) || (Value == NULL))
	{
		DEBUG_INFO("Arguments are invalid!");
		
		return ERROR;
	}
	
	memcpy(Buffer + (*Offset), Value, sizeof(CHAR) * Len);
	*Offset += sizeof(CHAR) * Len;
	
	return OK;
}

STATUS encodedataframe_int32_(INOUT UCHAR* Buffer, INOUT INT32* Offset, IN INT32 Value)
{
	if (Buffer == NULL || Offset == NULL)
	{
		DEBUG_INFO("Arguments are invalid!");
		
		return ERROR;
	}
	
	INT32 tmp = mpHtonl(Value);		// ?????
	
	memcpy(Buffer + (*Offset), &tmp, sizeof(INT32));
	*Offset += sizeof(INT32);
	
	return OK;
}

STATUS encodedataframe_int64_(INOUT UCHAR* Buffer, INOUT INT32* Offset, IN INT64 Value)
{
	if (Buffer == NULL || Offset == NULL)
	{
		DEBUG_INFO("Arguments are invalid!");
		
		return ERROR;
	}
	
	INT64 tmp = htonll_(Value);		// ?????
	memcpy(Buffer + (*Offset), &tmp, sizeof(INT64));
	
	*Offset += sizeof(INT64);
	
	return OK;
}

STATUS encodedataframe_float_(INOUT UCHAR* Buffer, INOUT INT32* Offset, IN FLOAT Value)
{
	if (Buffer == NULL || Offset == NULL)
	{
		DEBUG_INFO("Arguments are invalid!");
		
		return ERROR;
	}
	
	memcpy(Buffer + (*Offset), &Value, sizeof(FLOAT));
	*Offset += sizeof(FLOAT);
	
	return OK;
}

STATUS encodedataframe_tooldata_(INOUT UCHAR* Buffer, INOUT INT32* Offset, IN const MP_TOOL_RSP_DATA* Value)
{
	if (Buffer == NULL || Offset == NULL || Value == NULL)
	{
		DEBUG_INFO("Arguments are invalid!");
		
		return ERROR;
	}
	
	FLOAT tmp = 0.0;
	
	// X
	tmp = (FLOAT)Value->x / 1000.0;
	memcpy(Buffer + (*Offset), &tmp, sizeof(FLOAT));
	*Offset += sizeof(FLOAT);
	
	// Y
	tmp = (FLOAT)Value->y / 1000.0;
	memcpy(Buffer + (*Offset), &tmp, sizeof(FLOAT));
	*Offset += sizeof(FLOAT);
	
	// Z
	tmp = (FLOAT)Value->z / 1000.0;
	memcpy(Buffer + (*Offset), &tmp, sizeof(FLOAT));
	*Offset += sizeof(FLOAT);
	
	// Rx
	tmp = (FLOAT)Value->rx / 10000.0;
	memcpy(Buffer + (*Offset), &tmp, sizeof(FLOAT));
	*Offset += sizeof(FLOAT);
	
	// Ry
	tmp = (FLOAT)Value->ry / 10000.0;
	memcpy(Buffer + (*Offset), &tmp, sizeof(FLOAT));
	*Offset += sizeof(FLOAT);
	
	// Rz
	tmp = (FLOAT)Value->rz / 10000.0;
	memcpy(Buffer + (*Offset), &tmp, sizeof(FLOAT));
	*Offset += sizeof(FLOAT);
	
	return OK;
}

STATUS encodedataframe_cartposition_(INOUT UCHAR* Buffer, INOUT INT32* Offset, IN const MP_CART_POS_RSP_DATA* Value)
{
	if (Buffer == NULL || Offset == NULL || Value == NULL)
	{
		DEBUG_INFO("Arguments are invalid!");
		
		return ERROR;
	}
	
	FLOAT tmp = 0.0;
	
	// X
	tmp = (FLOAT)Value->lPos[0] / 1000.0;
	memcpy(Buffer + (*Offset), &tmp, sizeof(FLOAT));
	*Offset += sizeof(FLOAT);
	
	// Y
	tmp = (FLOAT)Value->lPos[1] / 1000.0;
	memcpy(Buffer + (*Offset), &tmp, sizeof(FLOAT));
	*Offset += sizeof(FLOAT);
	
	// Z
	tmp = (FLOAT)Value->lPos[2] / 1000.0;
	memcpy(Buffer + (*Offset), &tmp, sizeof(FLOAT));
	*Offset += sizeof(FLOAT);
	
	// Rx
	tmp = (FLOAT)Value->lPos[3] / 10000.0;
	memcpy(Buffer + (*Offset), &tmp, sizeof(FLOAT));
	*Offset += sizeof(FLOAT);
	
	// Ry
	tmp = (FLOAT)Value->lPos[4] / 10000.0;
	memcpy(Buffer + (*Offset), &tmp, sizeof(FLOAT));
	*Offset += sizeof(FLOAT);
	
	// Rz
	tmp = (FLOAT)Value->lPos[5] / 10000.0;
	memcpy(Buffer + (*Offset), &tmp, sizeof(FLOAT));
	*Offset += sizeof(FLOAT);
	
	return OK;
}

STATUS encodedataframe_coord_(INOUT UCHAR* Buffer, INT32* INOUT Offset, IN const MP_COORD* Value)
{
	if (Buffer == NULL || Offset == NULL || Value == NULL)
	{
		DEBUG_INFO("Arguments are invalid!");
		
		return ERROR;
	}
	
	FLOAT tmp = 0.0;
	
	// X
	tmp = (FLOAT)Value->x / 1000.0;
	memcpy(Buffer + (*Offset), &tmp, sizeof(FLOAT));
	*Offset += sizeof(FLOAT);
	
	// Y
	tmp = (FLOAT)Value->y / 1000.0;
	memcpy(Buffer + (*Offset), &tmp, sizeof(FLOAT));
	*Offset += sizeof(FLOAT);
	
	// Z
	tmp = (FLOAT)Value->z / 1000.0;
	memcpy(Buffer + (*Offset), &tmp, sizeof(FLOAT));
	*Offset += sizeof(FLOAT);
	
	// Rx
	tmp = (FLOAT)Value->rx / 10000.0;
	memcpy(Buffer + (*Offset), &tmp, sizeof(FLOAT));
	*Offset += sizeof(FLOAT);
	
	// Ry
	tmp = (FLOAT)Value->ry / 10000.0;
	memcpy(Buffer + (*Offset), &tmp, sizeof(FLOAT));
	*Offset += sizeof(FLOAT);
	
	// Rz
	tmp = (FLOAT)Value->rz / 10000.0;
	memcpy(Buffer + (*Offset), &tmp, sizeof(FLOAT));
	*Offset += sizeof(FLOAT);
	
	return OK;
}

STATUS decodedataframe_char_(IN const UCHAR* Buffer, INOUT INT32* Offset, OUT CHAR* Value)
{
	if (Buffer == NULL || Offset == NULL || Value == NULL)
	{
		DEBUG_INFO("Arguments are invalid!");
		
		return ERROR;
	}
	
	memcpy(Value, Buffer + (*Offset), sizeof(CHAR));
	*Offset += sizeof(CHAR);
	
	return OK;
}

STATUS decodedataframe_str_(IN const UCHAR* Buffer, INOUT INT32* Offset, OUT CHAR* Value, IN INT32 Len)
{
	if (Buffer == NULL || Offset == NULL || Value == NULL)
	{
		DEBUG_INFO("Arguments are invalid!");
		
		return ERROR;
	}
	
	memcpy(Value, Buffer + (*Offset), sizeof(CHAR) * Len);
	*Offset += sizeof(CHAR) * Len;
	
	return OK;
}

STATUS  decodedataframe_int32_(IN const UCHAR* Buffer, INOUT INT32* Offset, OUT INT32* Value)
{
	if (Buffer == NULL || Offset == NULL || Value == NULL)
	{
		DEBUG_INFO("Arguments are invalid!");
		
		return ERROR;
	}
	
	memcpy(Value, Buffer + (*Offset), sizeof(INT32));
	*Value = mpNtohl(*Value);
	*Offset += sizeof(INT32);
	
	return OK;
}

STATUS decodedataframe_int64_(IN const UCHAR* Buffer, INOUT INT32* Offset, OUT INT64* Value)
{
	if (Buffer == NULL || Offset == NULL || Value == NULL)
	{
		DEBUG_INFO("Arguments are invalid!");
		
		return ERROR;
	}
	
	memcpy(Value, Buffer + (*Offset), sizeof(INT64));
	*Value = ntohll_(*Value);
	*Offset += sizeof(INT64);
	
	return OK;
}

STATUS decodedataframe_float_(IN const UCHAR* Buffer, INOUT INT32* Offset, OUT FLOAT* Value)
{
	if (Buffer == NULL || Offset == NULL || Value == NULL)
	{
		DEBUG_INFO("Arguments are invalid!");
		
		return ERROR;
	}
	
	memcpy(Value, Buffer + (*Offset), sizeof(FLOAT));
	*Offset += sizeof(FLOAT);
	
	return OK;
}

STATUS decodedataframe_cartposition_(IN const UCHAR* Buffer, INOUT INT32* Offset, OUT MP_CART_POS_RSP_DATA* Value)
{
	if (Buffer == NULL || Offset == NULL || Value == NULL)
	{
		DEBUG_INFO("Arguments are invalid!");
		
		return ERROR;
	}
	
	FLOAT tmp = 0;
	
	// X
	memcpy(&tmp, Buffer + (*Offset), sizeof(FLOAT));
	Value->lPos[0] = (LONG)(tmp * 1000);
	*Offset += sizeof(FLOAT);
	
	// Y
	memcpy(&tmp, Buffer + (*Offset), sizeof(FLOAT));
	Value->lPos[1] = (LONG)(tmp * 1000);
	*Offset += sizeof(FLOAT);
	
	// Z
	memcpy(&tmp, Buffer + (*Offset), sizeof(FLOAT));
	Value->lPos[2] = (LONG)(tmp * 1000);
	*Offset += sizeof(FLOAT);
	
	// Rx
	memcpy(&tmp, Buffer + (*Offset), sizeof(FLOAT));
	Value->lPos[3] = (LONG)(tmp * 10000);
	*Offset += sizeof(FLOAT);
	
	// Ry
	memcpy(&tmp, Buffer + (*Offset), sizeof(FLOAT));
	Value->lPos[4] = (LONG)(tmp * 10000);
	*Offset += sizeof(FLOAT);
	
	// Rz
	memcpy(&tmp, Buffer + (*Offset), sizeof(FLOAT));
	Value->lPos[5] = (LONG)(tmp * 10000);
	*Offset += sizeof(FLOAT);
	
	return OK;
}

STATUS decodedataframe_coord_(IN const UCHAR* Buffer, INOUT INT32* Offset, OUT MP_COORD* Value)
{
	if (Buffer == NULL || Offset == NULL || Value == NULL)
	{
		DEBUG_INFO("Arguments are invalid!");
		
		return ERROR;
	}
	
	FLOAT tmp = 0;
	
	// X
	memcpy(&tmp, Buffer + (*Offset), sizeof(FLOAT));
	Value->x = (LONG)(tmp * 1000);
	*Offset += sizeof(FLOAT);
	
	// Y
	memcpy(&tmp, Buffer + (*Offset), sizeof(FLOAT));
	Value->y = (LONG)(tmp * 1000);
	*Offset += sizeof(FLOAT);
	
	// Z
	memcpy(&tmp, Buffer + (*Offset), sizeof(FLOAT));
	Value->z = (LONG)(tmp * 1000);
	*Offset += sizeof(FLOAT);
	
	// Rx
	memcpy(&tmp, Buffer + (*Offset), sizeof(FLOAT));
	Value->rx = (LONG)(tmp * 10000);
	*Offset += sizeof(FLOAT);
	
	// Ry
	memcpy(&tmp, Buffer + (*Offset), sizeof(FLOAT));
	Value->ry = (LONG)(tmp * 10000);
	*Offset += sizeof(FLOAT);
	
	// Rz
	memcpy(&tmp, Buffer + (*Offset), sizeof(FLOAT));
	Value->rz = (LONG)(tmp * 10000);
	*Offset += sizeof(FLOAT);
	
	return OK;
}

STATUS encodedataframe_header_(INOUT UCHAR *Buffer, INOUT INT32 *Offset, IN struct packages_head_t Header)
{
	INT32 Status = ERROR;
	*Offset = 0;

	Status = encodedataframe_int32_(Buffer, Offset, Header.Header);
	CHECK_RESULT(Status);
	Status = encodedataframe_int32_(Buffer, Offset, Header.Length);
	CHECK_RESULT(Status);
	Status = encodedataframe_int32_(Buffer, Offset, Header.PacketCount);
	CHECK_RESULT(Status);
	Buffer[12] = (UCHAR)Header.Cmd;
	Buffer[13] = (UCHAR)Header.Type;
	Buffer[14] = (UCHAR)Header.Seq;
	Buffer[15] = (UCHAR)Header.VirtualRob;

	*Offset += 4;

	return(OK);
}

STATUS encodedataframe_tail_(INOUT UCHAR *Buffer, INOUT INT32 *Offset, IN packages_tail_t Tail)
{
	INT32 Status = ERROR;

	Status = encodedataframe_int32_(Buffer, Offset, Tail);
	CHECK_RESULT(Status);

	return(OK);
}

STATUS decodedataframe_header_(IN const UCHAR* Buffer, INOUT INT32* Offset, OUT struct packages_head_t* Header)
{
	INT32 Status = ERROR;
	*Offset = 0;

	Status = decodedataframe_int32_(Buffer, Offset, &Header->Header);
	CHECK_RESULT(Status);
	Status = decodedataframe_int32_(Buffer, Offset, &Header->Length);
	CHECK_RESULT(Status);
	Status = decodedataframe_int32_(Buffer, Offset, &Header->PacketCount);
	CHECK_RESULT(Status);
	Header->Cmd = (UINT8)Buffer[12];
	Header->Cmd = (UINT8)Buffer[13];
	Header->Cmd = (UINT8)Buffer[14];
	Header->Cmd = (UINT8)Buffer[15];

	if (Header->Header != PACKAGE_HEADER)
	{
        DEBUG_ERROR("Package Header != 232425[Header:%d]", Header->Header);
		
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Package Header != 232425[Header:%d]", Header->Header);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);

		return(ERROR);
	}
	

	return(OK);
}

STATUS decodedataframe_tail_(IN const UCHAR* Buffer, INOUT INT32* Offset, OUT packages_tail_t* Tail)
{

	INT32 Status = ERROR;

	Status = decodedataframe_int32_(Buffer, Offset, Tail);
	CHECK_RESULT(Status);

	if (*Tail != PACKAGE_TAIL)
	{
        DEBUG_ERROR("Package Tail != 485868[Tail:%d]", *Tail);
        // 产生报警
        CHAR AlarmMsg[128] = {0};
        sprintf(AlarmMsg, "Package Tail != 485868[Tail:%d]", *Tail);        
        mpSetAlarm(LIB_ERROR_CODE, AlarmMsg, 2);

		return(ERROR);
	}

	return(OK);
}

STATUS decodedataframe_json_(IN const UCHAR* Buffer, OUT INT32 IntData[], OUT FLOAT FloatData[], OUT CHAR StringData[][JSON_MAX_STR], OUT FLOAT PosData[][JSON_MAX_AXS])
{
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
	
	memset(TmpStr, '\0', sizeof(TmpStr));

	while((strcmp(sub_string_((CHAR *)Buffer, Count, 1), JSON_DEC_EL1) != 0))
    {	
		if(strcmp(sub_string_((CHAR *)Buffer, Count, 1), JSON_DEC_NUL) != 0) strcat(&TmpStr[0], sub_string_((CHAR *)Buffer, Count, 1));
		Count++;
	}

	if (strcmp(&TmpStr[0], JSON_DEC_KEY) != 0) return(ERROR);
	
	while((strcmp(sub_string_((CHAR *)Buffer, Count, 1), JSON_DEC_EL2) != 0))
    {
		NumOfKey++;
		memset(TmpStr, '\0', sizeof(TmpStr));
		Count++;
		FOREVER
        {
			strcat(&TmpStr[0], sub_string_((CHAR *)Buffer, Count, 1));
			Count++;
			if ((strcmp(sub_string_((CHAR *)Buffer, Count, 1), JSON_DEC_EL4) == 0) || (strcmp(sub_string_((CHAR *)Buffer, Count, 1), JSON_DEC_EL2) == 0)) break;
		}
		strcpy(JsonName[NumOfKey], sub_string_(TmpStr, 1, find_string_(TmpStr, JSON_DEC_EL3)));
		strcpy(JsonType[NumOfKey], sub_string_(TmpStr, find_string_(TmpStr, JSON_DEC_EL3) + 1, strlen(TmpStr) - find_string_(TmpStr, JSON_DEC_EL3)));
	}

	Count++;
	memset(TmpStr, '\0', sizeof(TmpStr));
	while((strcmp(sub_string_((CHAR *)Buffer, Count, 1), JSON_DEC_EL1) != 0))
    {	
		strcat(&TmpStr[0], sub_string_((CHAR *)Buffer, Count, 1));
		Count++;
	}

	if (strcmp(&TmpStr[0], JSON_DEC_VAL) != 0) return(ERROR);

	while((strcmp(sub_string_((CHAR *)Buffer, Count, 1), JSON_DEC_EL2) != 0))
    {
		NumOfVal++;
		memset(TmpStr, '\0', sizeof(TmpStr));
		Count++;
		FOREVER
        {
			strcat(&TmpStr[0], sub_string_((CHAR *)Buffer, Count, 1));
			Count++;
			if ((strcmp(sub_string_((CHAR *)Buffer, Count, 1), JSON_DEC_EL4) == 0) || (strcmp(sub_string_((CHAR *)Buffer, Count, 1), JSON_DEC_EL2) == 0)) break;
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

	return(OK);
}





