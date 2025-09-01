/***********************************************************

Copyright 2018 - 2023 speedbot All Rights reserved.

file Name: lib_mppackages.h

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
#ifndef __SBT_MPPACKAGES_H__
#define __SBT_MPPACKAGES_H__

#include "operating_environment.h"
#include "lib_mpsocket.h"

#define PACKAGE_HEADER      232425
#define PACKAGE_TAIL        485868

struct packages_head_t
{
    INT32 Header;
    INT32 Length;
    INT32 PacketCount;
    UINT8 Cmd;
    UINT8 Type;
    UINT8 Seq;
    UINT8 VirtualRob;
};

typedef	int	packages_tail_t;


/************************************************************************************
* ��  �ܣ�����һ��CHARֵ															*
* ��  ����[INOUT] Buffer	����ָ��												*
*		  [INOUT] Offset	�����buffer��ƫ������ָ�룬��buffer + *offset����ʼд��*
*							�������ݣ����������ʱ������*offset��					*
*		  [IN] Value 		һ��CHARֵ												*
* ����ֵ��������																	*
************************************************************************************/
extern STATUS encodedataframe_char_(INOUT UCHAR* Buffer, INOUT INT32* Offset, IN CHAR Value);

/************************************************************************************
* ��  �ܣ�����һ��ָ�����ȵ�CHAR����												*
* ��  ����[INOUT] Buffer	����ָ��												*
*		  [INOUT] Offset	�����buffer��ƫ������ָ�룬��buffer + *offset����ʼд��*
*							�������ݣ����������ʱ������*offset��					*
*		  [IN] Value 		һ��CHAR����											*
*		  [IN] Len			CHAR���鳤��											*
* ����ֵ��������																	*
************************************************************************************/
extern STATUS encodedataframe_str_(INOUT UCHAR* Buffer, INOUT INT32* Offset, IN const CHAR* Value, IN INT32 Len);

/************************************************************************************
* ��  �ܣ�����һ��INT32ֵ															*
* ��  ����[INOUT] Buffer	����ָ��												*
*		  [INOUT] Offset	�����buffer��ƫ������ָ�룬��buffer + *offset����ʼд��*
*							�������ݣ����������ʱ������*offset��					*
*		  [IN] Value 		һ��INT32ֵ												*
* ����ֵ��������																	*
************************************************************************************/
extern STATUS encodedataframe_int32_(INOUT UCHAR* Buffer, INOUT INT32* Offset, IN INT32 Value);

/************************************************************************************
* ��  �ܣ�����һ��INT64ֵ															*
* ��  ����[INOUT] Buffer	����ָ��												*
*		  [INOUT] Offset	�����buffer��ƫ������ָ�룬��buffer + *offset����ʼд��*
*							�������ݣ����������ʱ������*offset��					*
*		  [IN] Value 		һ��INT64ֵ												*
* ����ֵ��������																	*
************************************************************************************/
extern STATUS encodedataframe_int64_(INOUT UCHAR* Buffer, INOUT INT32* Offset, IN INT64 Value);

/************************************************************************************
* ��  �ܣ�����һ��FLOATֵ															*
* ��  ����[INOUT] Buffer	����ָ��												*
*		  [INOUT] Offset	�����buffer��ƫ������ָ�룬��buffer + *offset����ʼд��*
*							�������ݣ����������ʱ������*offset��					*
*		  [IN] Value 		һ��FLOATֵ												*
* ����ֵ��������																	*
************************************************************************************/
extern STATUS encodedataframe_float_(INOUT UCHAR* Buffer, INOUT INT32* Offset, IN FLOAT Value);

/************************************************************************************
* ��  �ܣ����빤������																*
* ��  ����[INOUT] Buffer	����ָ��												*
*		  [INOUT] Offset	�����buffer��ƫ������ָ�룬��buffer + *offset����ʼд��*
*							�������ݣ����������ʱ������*offset��					*
*		  [IN] Value		��������ָ��											*
* ����ֵ��������																	*
************************************************************************************/
extern STATUS encodedataframe_tooldata_(INOUT UCHAR* Buffer, INOUT INT32* Offset, IN const MP_TOOL_RSP_DATA* Value);

/************************************************************************************
* ��  �ܣ�����ѿ�������λ������													*
* ��  ����[INOUT] Buffer	����ָ��												*
*		  [INOUT] Offset	�����buffer��ƫ������ָ�룬��buffer + *offset����ʼд��*
*							�������ݣ����������ʱ������*offset��					*
*		  [IN] Value		�ѿ�������λ��ָ��										*
* ����ֵ��������																	*
************************************************************************************/
extern STATUS encodedataframe_cartposition_(INOUT UCHAR* Buffer, INOUT INT32* Offset, IN const MP_CART_POS_RSP_DATA* Value);

/************************************************************************************
* ��  �ܣ�����MP_COORD����															*
* ��  ����[INOUT] Buffer	����ָ��												*
*		  [INOUT] Offset	�����buffer��ƫ������ָ�룬��buffer + *offset����ʼд��*
*							�������ݣ����������ʱ������*offset��					*
*		  [IN] Value		MP_COORDָ��											*
* ����ֵ��������																	*
************************************************************************************/
extern STATUS encodedataframe_coord_(INOUT UCHAR* Buffer, INOUT INT32* Offset, IN const MP_COORD* Value);

extern STATUS encodedataframe_header_(INOUT UCHAR *Buffer, INOUT INT32 *Offset, IN struct packages_head_t Header);

extern STATUS encodedataframe_tail_(INOUT UCHAR *Buffer, INOUT INT32 *Offset, IN packages_tail_t Tail);

/***********************************������صĺ���**********************************/

/************************************************************************************
* ��  �ܣ�����һ��CHARֵ															*
* ��  ����[INOUT] Buffer	����ָ��												*
*		  [INOUT] Offset	�����buffer��ƫ������ָ�룬��buffer + *offset����ʼ��ȡ*
*							�������ݣ����������ʱ������*offset��					*
*		  [OUT] Value 		һ��CHARֵ��ָ��										*
* ����ֵ��������																	*
************************************************************************************/
extern STATUS decodedataframe_char_(IN const UCHAR* Buffer, INOUT INT32* Offset, OUT CHAR* Value);

/************************************************************************************
* ��  �ܣ�����һ��CHAR����															*
* ��  ����[INOUT] Buffer	����ָ��												*
*		  [INOUT] Offset	�����buffer��ƫ������ָ�룬��buffer + *offset����ʼ��ȡ*
*							�������ݣ����������ʱ������*offset��					*
*		  [OUT] Value 		һ��CHAR�����ָ��										*
*		  [IN]	Len			Ҫ�����CHAR����ĳ���									*
* ����ֵ��������																	*
************************************************************************************/
extern STATUS decodedataframe_str_(IN const UCHAR* Buffer, INOUT INT32* Offset, OUT CHAR* Value, IN INT32 Len);

/************************************************************************************
* ��  �ܣ�����һ��INT32ֵ															*
* ��  ����[INOUT] Buffer	����ָ��												*
*		  [INOUT] Offset	�����buffer��ƫ������ָ�룬��buffer + *offset����ʼ��ȡ*
*							�������ݣ����������ʱ������*offset��					*
*		  [OUT] Value 		һ��INT32ֵ��ָ��										*
* ����ֵ��������																	*
************************************************************************************/
extern STATUS decodedataframe_int32_(IN const UCHAR* Buffer, INOUT INT32* Offset, OUT INT32* Value);

/************************************************************************************
* ��  �ܣ�����һ��INT64ֵ															*
* ��  ����[INOUT] Buffer	����ָ��												*
*		  [INOUT] Offset	�����buffer��ƫ������ָ�룬��buffer + *offset����ʼ��ȡ*
*							�������ݣ����������ʱ������*offset��					*
*		  [OUT] Value 		һ��INT64ֵ��ָ��										*
* ����ֵ��������																	*
************************************************************************************/
extern STATUS decodedataframe_int64_(IN const UCHAR* Buffer, INOUT INT32* Offset, OUT INT64* Value);

/************************************************************************************
* ��  �ܣ�����һ��FLOATֵ															*
* ��  ����[INOUT] Buffer	����ָ��												*
*		  [INOUT] Offset	�����buffer��ƫ������ָ�룬��buffer + *offset����ʼ��ȡ*
*							�������ݣ����������ʱ������*offset��					*
*		  [OUT] Value 		һ��FLOATֵ��ָ��										*
* ����ֵ��������																	*
************************************************************************************/
extern STATUS decodedataframe_float_(IN const UCHAR* Buffer, INOUT INT32* Offset, OUT FLOAT* Value);

/************************************************************************************
* ��  �ܣ�����һ���ѿ�������λ��ֵ													*
* ��  ����[INOUT] Buffer	����ָ��												*
*		  [INOUT] Offset	�����buffer��ƫ������ָ�룬��buffer + *offset����ʼ��ȡ*
*							�������ݣ����������ʱ������*offset��					*
*		  [OUT] Value 		һ��MP_CART_POS_RSP_DATAֵ��ָ��						*
* ����ֵ��������																	*
************************************************************************************/
extern STATUS decodedataframe_cartposition_(IN const UCHAR* Buffer, INOUT INT32* Offset, OUT MP_CART_POS_RSP_DATA* Value);

/************************************************************************************
* ��  �ܣ�����һ��MP_COORD����														*
* ��  ����[INOUT] Buffer	����ָ��												*
*		  [INOUT] Offset	�����buffer��ƫ������ָ�룬��buffer + *offset����ʼ��ȡ*
*							�������ݣ����������ʱ������*offset��					*
*		  [OUT] Value		һ��MP_COORDֵ��ָ��									*
* ����ֵ��������																	*
************************************************************************************/
extern STATUS decodedataframe_coord_(IN const UCHAR* Buffer, INOUT INT32* Offset, OUT MP_COORD* Value);

extern STATUS decodedataframe_header_(IN const UCHAR* Buffer, INOUT INT32* Offset, OUT struct packages_head_t* Header);

extern STATUS decodedataframe_tail_(IN const UCHAR* Buffer, INOUT INT32* Offset, OUT packages_tail_t* Tail);

extern STATUS decodedataframe_json_(IN const UCHAR* Buffer, OUT INT32 IntData[], OUT FLOAT FloatData[], OUT CHAR StringData[][JSON_MAX_STR], OUT FLOAT PosData[][JSON_MAX_AXS]);

#endif
