/***********************************************************

Copyright 2018 - 2023 speedbot All Rights reserved.

file Name: lib_mphelper.c

Description:
  Language             ==   motoplus for Yaskawa ROBOT
  Date                 ==   2023 - 09 - 14
  Modification Data    ==   2023 - 09 - 14

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

/************************************************************************************
* 功  能：将主机字节序的UDLONG值转换为网络字节序的UDLONG值							*
* 参  数：[IN] HostLongLong 主机字节序的UDLONG值									*
* 返回值：网络字节序的UDLONG值														*
************************************************************************************/
UDLONG htonll_(IN UDLONG HostLongLong)
{
	ULONG Hi32 = (HostLongLong >> 32) & 0x00000000ffffffff;
	ULONG Lo32 = HostLongLong & 0x00000000ffffffff;
	
	Hi32 = mpHtonl(Hi32);
	Lo32 = mpHtonl(Lo32);
	
	return (((UDLONG)Lo32) << 32) | ((UDLONG)Hi32);
}

/************************************************************************************
* 功  能：将网络字节序的UDLONG值转换为主机字节序的UDLONG值							*
* 参  数：[IN] NetLongLong 网络字节序的UDLONG值										*
* 返回值：主机字节序的UDLONG值														*
************************************************************************************/
UDLONG ntohll_(IN UDLONG NetLongLong)
{
	ULONG Hi32 = (NetLongLong >> 32) & 0x00000000ffffffff;
	ULONG Lo32 = NetLongLong & 0x00000000ffffffff;
	
	Hi32 = mpNtohl(Hi32);
	Lo32 = mpNtohl(Lo32);
	
	return (((UDLONG)Lo32) << 32) | ((UDLONG)Hi32);
}

/************************************************************************************
* 功  能：计算空间两点的距离														*
* 参  数：[IN] x1 第一个点的X坐标													*
*		  [IN] y1 第一个点的Y坐标													*
*		  [IN] z1 第一个点的Z坐标													*
*		  [IN] x2 第二个点的X坐标													*
*		  [IN] y2 第二个点的Y坐标													*
*		  [IN] z2 第二个点的Z坐标													*
* 返回值：两点之间的距离															*
************************************************************************************/
FLOAT calculate_distance_(IN FLOAT x1, IN FLOAT y1, IN FLOAT z1, IN FLOAT x2, IN FLOAT y2, IN FLOAT z2)
{
	return sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1) + (z2 - z1) * (z2 - z1)); 
}

// 查表法计算Modbus CRC16校验值的数据表
static UCHAR auchCRCHi[] =
{
	0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81,
	0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0,
	0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01,
	0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41,
	0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81,
	0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0,
	0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01,
	0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
	0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81,
	0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0,
	0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01,
	0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
	0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81,
	0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0,
	0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01,
	0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
	0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81,
	0x40
};

static UCHAR auchCRCLo[] =
{
	0x00, 0xC0, 0xC1, 0x01, 0xC3, 0x03, 0x02, 0xC2, 0xC6, 0x06, 0x07, 0xC7, 0x05, 0xC5, 0xC4,
	0x04, 0xCC, 0x0C, 0x0D, 0xCD, 0x0F, 0xCF, 0xCE, 0x0E, 0x0A, 0xCA, 0xCB, 0x0B, 0xC9, 0x09,
	0x08, 0xC8, 0xD8, 0x18, 0x19, 0xD9, 0x1B, 0xDB, 0xDA, 0x1A, 0x1E, 0xDE, 0xDF, 0x1F, 0xDD,
	0x1D, 0x1C, 0xDC, 0x14, 0xD4, 0xD5, 0x15, 0xD7, 0x17, 0x16, 0xD6, 0xD2, 0x12, 0x13, 0xD3,
	0x11, 0xD1, 0xD0, 0x10, 0xF0, 0x30, 0x31, 0xF1, 0x33, 0xF3, 0xF2, 0x32, 0x36, 0xF6, 0xF7,
	0x37, 0xF5, 0x35, 0x34, 0xF4, 0x3C, 0xFC, 0xFD, 0x3D, 0xFF, 0x3F, 0x3E, 0xFE, 0xFA, 0x3A,
	0x3B, 0xFB, 0x39, 0xF9, 0xF8, 0x38, 0x28, 0xE8, 0xE9, 0x29, 0xEB, 0x2B, 0x2A, 0xEA, 0xEE,
	0x2E, 0x2F, 0xEF, 0x2D, 0xED, 0xEC, 0x2C, 0xE4, 0x24, 0x25, 0xE5, 0x27, 0xE7, 0xE6, 0x26,
	0x22, 0xE2, 0xE3, 0x23, 0xE1, 0x21, 0x20, 0xE0, 0xA0, 0x60, 0x61, 0xA1, 0x63, 0xA3, 0xA2,
	0x62, 0x66, 0xA6, 0xA7, 0x67, 0xA5, 0x65, 0x64, 0xA4, 0x6C, 0xAC, 0xAD, 0x6D, 0xAF, 0x6F,
	0x6E, 0xAE, 0xAA, 0x6A, 0x6B, 0xAB, 0x69, 0xA9, 0xA8, 0x68, 0x78, 0xB8, 0xB9, 0x79, 0xBB,
	0x7B, 0x7A, 0xBA, 0xBE, 0x7E, 0x7F, 0xBF, 0x7D, 0xBD, 0xBC, 0x7C, 0xB4, 0x74, 0x75, 0xB5,
	0x77, 0xB7, 0xB6, 0x76, 0x72, 0xB2, 0xB3, 0x73, 0xB1, 0x71, 0x70, 0xB0, 0x50, 0x90, 0x91,
	0x51, 0x93, 0x53, 0x52, 0x92, 0x96, 0x56, 0x57, 0x97, 0x55, 0x95, 0x94, 0x54, 0x9C, 0x5C,
	0x5D, 0x9D, 0x5F, 0x9F, 0x9E, 0x5E, 0x5A, 0x9A, 0x9B, 0x5B, 0x99, 0x59, 0x58, 0x98, 0x88,
	0x48, 0x49, 0x89, 0x4B, 0x8B, 0x8A, 0x4A, 0x4E, 0x8E, 0x8F, 0x4F, 0x8D, 0x4D, 0x4C, 0x8C,
	0x44, 0x84, 0x85, 0x45, 0x87, 0x47, 0x46, 0x86, 0x82, 0x42, 0x43, 0x83, 0x41, 0x81, 0x80,
	0x40
};

/************************************************************************************
* 功  能：计算Modbus CRC16校验值													*
* 参  数：[IN] Buffer 缓存字节数组													*
*		  [IN] Len 缓存长度															*
* 返回值：Modbus CRC16校验值														*
************************************************************************************/
USHORT crc16_(IN UCHAR* Buffer, IN INT32 Len)
{
	if ((Buffer == NULL) || (Len == 0))
	{
		DEBUG_ERROR("Arguments are invalid!");
		
		return 0;
	}
	
	UCHAR uchCRCHi = 0xff;
	UCHAR uchCRCLo = 0xff;
	USHORT  uindex = 0;
	
	while (Len--)
	{
		uindex = uchCRCLo^*Buffer++;
		uchCRCLo = uchCRCHi^auchCRCHi[uindex];
		uchCRCHi = auchCRCLo[uindex];
	}
	
	return (uchCRCHi << 8 | uchCRCLo);
}

// Bessel Filter Coefficient

#define BESSEL_FILTER_B1				(0.015381832265239)
#define BESSEL_FILTER_B2				(0.061527329060959)
#define BESSEL_FILTER_B3				(0.092290993591432)
#define BESSEL_FILTER_B4				(0.061527329060956)
#define BESSEL_FILTER_B5				(0.015381832265239)

#define BESSEL_FILTER_A2				(-1.463075423924117)
#define BESSEL_FILTER_A3				(1.003289284487628)
#define BESSEL_FILTER_A4				(-0.341477548318651)
#define BESSEL_FILTER_A5				(0.047373003998963)

/************************************************************************************
* 功  能：计算BesselFilter滤波值													*
* 参  数：[IN] X 输入信号															*
*		  [IN] Y 输出信号															*
* 返回值：滤波输出信号																*
************************************************************************************/
DOUBLE bessel_filter_(IN const DOUBLE X[7], IN const DOUBLE Y[6])
{
	DOUBLE val1 = BESSEL_FILTER_B1 * X[4] + 
				 BESSEL_FILTER_B2 * X[3] + 
				 BESSEL_FILTER_B3 * X[2] + 
				 BESSEL_FILTER_B4 * X[1] + 
				 BESSEL_FILTER_B5 * X[0];
				 
	DOUBLE val2 = BESSEL_FILTER_A2 * Y[3] + 
				 BESSEL_FILTER_A3 * Y[2] + 
				 BESSEL_FILTER_A4 * Y[1] + 
				 BESSEL_FILTER_A5 * Y[0];
	
	return val1 - val2;
}

/************************************************************************************
* 功  能：计算均值滤波器的输出值													*
* 参  数：[IN] X 输入信号															*
*		  [IN] Len 输入信号个数														*
* 返回值：滤波输出值																*
************************************************************************************/
DOUBLE mean_filter_(IN const DOUBLE X[], IN const INT32 Len)
{
	DOUBLE sum = 0.0;
	INT32 i = 0;
	for (i = 0; i < Len; ++i)
	{
		sum += X[i];
	}
	
	return sum / (DOUBLE)Len;
}

/************************************************************************************
* 功  能：将字符全部转换为大写														*
* 参  数：[INOUT] src 字符串														*
* 返回值：输出大写字符串															*
************************************************************************************/
CHAR* str_upr_(IN CHAR* src)
{
	if (src == NULL)
	{
		return NULL;
	}
	
	while (*src != '\0')
	{
		if ((*src >= 'a') && (*src <= 'z'))
		{
			*src -= 32;
		}
		
		src++;
	}
	
	return src;
}

/************************************************************************************
* 功  能：从一个字符串中解析坐标系数据												*
* 参  数：[IN] 	StringCoord	包含坐标系数据的字符串									*
*		  [OUT] UfData		用户坐标系数据											*
* 返回值：函数执行是否成功。														*
************************************************************************************/
STATUS parse_coord_(IN CHAR* StringCoord, OUT MP_COORD* UfData)
{
	// 检查参数
	if ((StringCoord == NULL) || (UfData == NULL))
	{
		DEBUG_ERROR("Arguments are incorrect.");
	
		return(ERROR);
	}

	float x = 0.0;
	float y = 0.0;
	float z = 0.0;
	float rx = 0.0;
	float ry = 0.0;
	float rz = 0.0;
	int num = sscanf(StringCoord, "%f,%f,%f,%f,%f,%f", 
		&x, &y, &z, &rx, &ry, &rz);
	
	if (num != 6)
	{
		return(ERROR);
	}
	else
	{
		UfData->x = round(x * 1000);
		UfData->y = round(y * 1000);
		UfData->z = round(z * 1000);
		UfData->rx = round(rx * 10000);
		UfData->ry = round(ry * 10000);
		UfData->rz = round(rz * 10000);
	}

	return(OK);
}

/************************************************************************************
* 功  能：实现坐标变换的功能														*
* 参  数：[IN] TransMat	变换矩阵												*
*		  [IN] ScrCoord	变换前的坐标值											*
*		  [IN] DstCoord	变换后的坐标值											*
* 返回值：函数执行是否成功。														*
************************************************************************************/
STATUS trans_from_coord_(IN MP_FRAME* TransMat, IN MP_XYZ* ScrCoord, OUT MP_XYZ* DstCoord)
{
	// 检查参数
	if ((TransMat == NULL) || (ScrCoord == NULL) || (DstCoord == NULL))
	{
		DEBUG_ERROR("Arguments are incorrect.");
	
		return(ERROR);
	}
	
	DstCoord->x = TransMat->nx * ScrCoord->x + TransMat->ox * ScrCoord->y + TransMat->ax * ScrCoord->z + TransMat->px;
	DstCoord->y = TransMat->ny * ScrCoord->x + TransMat->oy * ScrCoord->y + TransMat->ay * ScrCoord->z + TransMat->py;
	DstCoord->z = TransMat->nz * ScrCoord->x + TransMat->oz * ScrCoord->y + TransMat->az * ScrCoord->z + TransMat->pz;
	
	return(OK);
}

/************************************************************************************
* 功  能：初始化MP_FRAME															*
* 参  数：[IN] Mat	矩阵指针														*
* 返回值：函数执行是否成功。														*
************************************************************************************/
STATUS init_frame_(INOUT MP_FRAME* Mat)
{
	// 检查参数
	if (Mat == NULL)
	{
		DEBUG_ERROR("Argument Mat is NULL.");
	
		return(ERROR);
	}
	
	memset(Mat, CLEAR, sizeof(MP_FRAME));
	
	Mat->nx = 1.0;
	Mat->oy = 1.0;
	Mat->az = 1.0;
	
	return(OK);
}

CHAR* sub_string_(IN CHAR* Ch, IN INT32 Pos, IN INT32 Length) 
{  
	int I;
	char SubCh[1024]; 

	memset(SubCh, '\0', sizeof(SubCh));
	for(I = 0; I < Length; I++) 
    {
        SubCh[I] = Ch[Pos + I - 1];    
    }

	SubCh[Length] = '\0'; 

	char* SubString =  SubCh;
	return SubString;         
} 

INT32 find_string_(IN const CHAR *String, IN const CHAR *Dest)
{
    int I = 0;
    int J = 0;
	
    if (String == NULL || Dest == NULL) return(ERROR);
    while (String[I] != '\0')
    {
        if (String[I] != Dest[0])
        {
            I++;
            continue;
        }
        J = 0;
        while (String[I + J] != '\0' && Dest[J] != '\0')
        {
			if (String[I + J] != Dest[J]) break;
            J++;
        }
        if (Dest[J] == '\0') return(I + 1);
        I++;
    }
    return(ERROR);
}

const char *get_filename(const char *path) {
    const char *filename = strrchr(path, '\\');
    if (filename == NULL)
        filename = path;
    else
        filename = filename + 1;
    return filename;
}




