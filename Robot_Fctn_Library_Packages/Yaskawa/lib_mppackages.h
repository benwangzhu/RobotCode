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
* 功  能：编码一个CHAR值															*
* 参  数：[INOUT] Buffer	缓存指针												*
*		  [INOUT] Offset	相对于buffer的偏移量的指针，从buffer + *offset处开始写入*
*							编码数据，当编码完成时，更新*offset。					*
*		  [IN] Value 		一个CHAR值												*
* 返回值：编码结果																	*
************************************************************************************/
extern STATUS encodedataframe_char_(INOUT UCHAR* Buffer, INOUT INT32* Offset, IN CHAR Value);

/************************************************************************************
* 功  能：编码一个指定长度的CHAR数组												*
* 参  数：[INOUT] Buffer	缓存指针												*
*		  [INOUT] Offset	相对于buffer的偏移量的指针，从buffer + *offset处开始写入*
*							编码数据，当编码完成时，更新*offset。					*
*		  [IN] Value 		一个CHAR数组											*
*		  [IN] Len			CHAR数组长度											*
* 返回值：编码结果																	*
************************************************************************************/
extern STATUS encodedataframe_str_(INOUT UCHAR* Buffer, INOUT INT32* Offset, IN const CHAR* Value, IN INT32 Len);

/************************************************************************************
* 功  能：编码一个INT32值															*
* 参  数：[INOUT] Buffer	缓存指针												*
*		  [INOUT] Offset	相对于buffer的偏移量的指针，从buffer + *offset处开始写入*
*							编码数据，当编码完成时，更新*offset。					*
*		  [IN] Value 		一个INT32值												*
* 返回值：编码结果																	*
************************************************************************************/
extern STATUS encodedataframe_int32_(INOUT UCHAR* Buffer, INOUT INT32* Offset, IN INT32 Value);

/************************************************************************************
* 功  能：编码一个INT64值															*
* 参  数：[INOUT] Buffer	缓存指针												*
*		  [INOUT] Offset	相对于buffer的偏移量的指针，从buffer + *offset处开始写入*
*							编码数据，当编码完成时，更新*offset。					*
*		  [IN] Value 		一个INT64值												*
* 返回值：编码结果																	*
************************************************************************************/
extern STATUS encodedataframe_int64_(INOUT UCHAR* Buffer, INOUT INT32* Offset, IN INT64 Value);

/************************************************************************************
* 功  能：编码一个FLOAT值															*
* 参  数：[INOUT] Buffer	缓存指针												*
*		  [INOUT] Offset	相对于buffer的偏移量的指针，从buffer + *offset处开始写入*
*							编码数据，当编码完成时，更新*offset。					*
*		  [IN] Value 		一个FLOAT值												*
* 返回值：编码结果																	*
************************************************************************************/
extern STATUS encodedataframe_float_(INOUT UCHAR* Buffer, INOUT INT32* Offset, IN FLOAT Value);

/************************************************************************************
* 功  能：编码工具数据																*
* 参  数：[INOUT] Buffer	缓存指针												*
*		  [INOUT] Offset	相对于buffer的偏移量的指针，从buffer + *offset处开始写入*
*							编码数据，当编码完成时，更新*offset。					*
*		  [IN] Value		工具数据指针											*
* 返回值：编码结果																	*
************************************************************************************/
extern STATUS encodedataframe_tooldata_(INOUT UCHAR* Buffer, INOUT INT32* Offset, IN const MP_TOOL_RSP_DATA* Value);

/************************************************************************************
* 功  能：编码笛卡尔坐标位置数据													*
* 参  数：[INOUT] Buffer	缓存指针												*
*		  [INOUT] Offset	相对于buffer的偏移量的指针，从buffer + *offset处开始写入*
*							编码数据，当编码完成时，更新*offset。					*
*		  [IN] Value		笛卡尔坐标位置指针										*
* 返回值：编码结果																	*
************************************************************************************/
extern STATUS encodedataframe_cartposition_(INOUT UCHAR* Buffer, INOUT INT32* Offset, IN const MP_CART_POS_RSP_DATA* Value);

/************************************************************************************
* 功  能：编码MP_COORD数据															*
* 参  数：[INOUT] Buffer	缓存指针												*
*		  [INOUT] Offset	相对于buffer的偏移量的指针，从buffer + *offset处开始写入*
*							编码数据，当编码完成时，更新*offset。					*
*		  [IN] Value		MP_COORD指针											*
* 返回值：编码结果																	*
************************************************************************************/
extern STATUS encodedataframe_coord_(INOUT UCHAR* Buffer, INOUT INT32* Offset, IN const MP_COORD* Value);

extern STATUS encodedataframe_header_(INOUT UCHAR *Buffer, INOUT INT32 *Offset, IN struct packages_head_t Header);

extern STATUS encodedataframe_tail_(INOUT UCHAR *Buffer, INOUT INT32 *Offset, IN packages_tail_t Tail);

/***********************************解码相关的函数**********************************/

/************************************************************************************
* 功  能：解码一个CHAR值															*
* 参  数：[INOUT] Buffer	缓存指针												*
*		  [INOUT] Offset	相对于buffer的偏移量的指针，从buffer + *offset处开始读取*
*							解码数据，当解码完成时，更新*offset。					*
*		  [OUT] Value 		一个CHAR值的指针										*
* 返回值：解码结果																	*
************************************************************************************/
extern STATUS decodedataframe_char_(IN const UCHAR* Buffer, INOUT INT32* Offset, OUT CHAR* Value);

/************************************************************************************
* 功  能：解码一个CHAR数组															*
* 参  数：[INOUT] Buffer	缓存指针												*
*		  [INOUT] Offset	相对于buffer的偏移量的指针，从buffer + *offset处开始读取*
*							解码数据，当解码完成时，更新*offset。					*
*		  [OUT] Value 		一个CHAR数组的指针										*
*		  [IN]	Len			要解码的CHAR数组的长度									*
* 返回值：解码结果																	*
************************************************************************************/
extern STATUS decodedataframe_str_(IN const UCHAR* Buffer, INOUT INT32* Offset, OUT CHAR* Value, IN INT32 Len);

/************************************************************************************
* 功  能：解码一个INT32值															*
* 参  数：[INOUT] Buffer	缓存指针												*
*		  [INOUT] Offset	相对于buffer的偏移量的指针，从buffer + *offset处开始读取*
*							解码数据，当解码完成时，更新*offset。					*
*		  [OUT] Value 		一个INT32值的指针										*
* 返回值：解码结果																	*
************************************************************************************/
extern STATUS decodedataframe_int32_(IN const UCHAR* Buffer, INOUT INT32* Offset, OUT INT32* Value);

/************************************************************************************
* 功  能：解码一个INT64值															*
* 参  数：[INOUT] Buffer	缓存指针												*
*		  [INOUT] Offset	相对于buffer的偏移量的指针，从buffer + *offset处开始读取*
*							解码数据，当解码完成时，更新*offset。					*
*		  [OUT] Value 		一个INT64值的指针										*
* 返回值：解码结果																	*
************************************************************************************/
extern STATUS decodedataframe_int64_(IN const UCHAR* Buffer, INOUT INT32* Offset, OUT INT64* Value);

/************************************************************************************
* 功  能：解码一个FLOAT值															*
* 参  数：[INOUT] Buffer	缓存指针												*
*		  [INOUT] Offset	相对于buffer的偏移量的指针，从buffer + *offset处开始读取*
*							解码数据，当解码完成时，更新*offset。					*
*		  [OUT] Value 		一个FLOAT值的指针										*
* 返回值：解码结果																	*
************************************************************************************/
extern STATUS decodedataframe_float_(IN const UCHAR* Buffer, INOUT INT32* Offset, OUT FLOAT* Value);

/************************************************************************************
* 功  能：解码一个笛卡尔坐标位置值													*
* 参  数：[INOUT] Buffer	缓存指针												*
*		  [INOUT] Offset	相对于buffer的偏移量的指针，从buffer + *offset处开始读取*
*							解码数据，当解码完成时，更新*offset。					*
*		  [OUT] Value 		一个MP_CART_POS_RSP_DATA值的指针						*
* 返回值：解码结果																	*
************************************************************************************/
extern STATUS decodedataframe_cartposition_(IN const UCHAR* Buffer, INOUT INT32* Offset, OUT MP_CART_POS_RSP_DATA* Value);

/************************************************************************************
* 功  能：解码一个MP_COORD数据														*
* 参  数：[INOUT] Buffer	缓存指针												*
*		  [INOUT] Offset	相对于buffer的偏移量的指针，从buffer + *offset处开始读取*
*							解码数据，当解码完成时，更新*offset。					*
*		  [OUT] Value		一个MP_COORD值的指针									*
* 返回值：编码结果																	*
************************************************************************************/
extern STATUS decodedataframe_coord_(IN const UCHAR* Buffer, INOUT INT32* Offset, OUT MP_COORD* Value);

extern STATUS decodedataframe_header_(IN const UCHAR* Buffer, INOUT INT32* Offset, OUT struct packages_head_t* Header);

extern STATUS decodedataframe_tail_(IN const UCHAR* Buffer, INOUT INT32* Offset, OUT packages_tail_t* Tail);

extern STATUS decodedataframe_json_(IN const UCHAR* Buffer, OUT INT32 IntData[], OUT FLOAT FloatData[], OUT CHAR StringData[][JSON_MAX_STR], OUT FLOAT PosData[][JSON_MAX_AXS]);

#endif
