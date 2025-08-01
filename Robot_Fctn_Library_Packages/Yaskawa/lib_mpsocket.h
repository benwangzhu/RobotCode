/***********************************************************

Copyright 2018 - 2023 speedbot All Rights reserved.

file Name: lib_socket.h

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
#ifndef __SBT_MPSOCKET_H__
#define __SBT_MPSOCKET_H__

#include "operating_environment.h"


#define JSON_POS_TYP        "xyzabc"
#define JSON_INT_TYP        "int"
#define JSON_FLT_TYP        "float"
#define JSON_STR_TYP        "str"
#define JSON_DEC_EL1        "{"
#define JSON_DEC_EL2        "}"
#define JSON_DEC_EL3        ":"
#define JSON_DEC_EL4        ";"
#define JSON_DEC_EL5        ","
#define JSON_DEC_KEY        "key"
#define JSON_DEC_VAL        "value"
#define JSON_DEC_NUL        " "

#define JSON_MAX_DAT        30

#define JSON_MAX_STR        128
#define JSON_MAX_AXS        6

#define STR_BAFFER_MAX      1023

struct sock_cfg_t
{
    BOOL Connected;
    INT32 SockFd;
    CHAR Host[16];
    USHORT Port;
    INT32 NByte;
    UINT32 RecvTimeout;
    
};

struct udp_cfg_t
{
    INT32 SockFd;
    CHAR InternalHost[16];
    USHORT InternalPort;
    CHAR ExternalHost[16];
    USHORT ExternalPort;
    INT32 NByte;
    UINT32 RecvTimeout;

};


//***********************************************************
// func tcp_connect_()
//***********************************************************
//     in/out : *TcpSocketConfig    * sock_cfg_t * 	    * SOCKET 配置变量 * 
//     return : 			* STATUS * 		    * [0 == 连接成功] / [!0 == 连接失败] *
//***********************************************************
//  机器人作为客户端，和服务端进行网络链接
//  服务端的 IP 需提前设置到 TcpSocketConfig.Host 
//  服务端的 PORT 需提前设置到 TcpSocketConfig.Port
//  成功连接会得到一个 SOCKET ID 并且赋值到 TcpSocketConfig.SockFd , 并且 TcpSocketConfig.Connected 会置 TRUE
//***********************************************************	
IMPORT STATUS tcp_connect_(INOUT struct sock_cfg_t *TcpSocketConfig);

//***********************************************************
// func tcp_accept_()
//***********************************************************
//     in/out : *TcpSocketConfig    * sock_cfg_t * 	    * SOCKET 配置变量 * 
//     return : 			* STATUS * 		    * [0 == 连接成功] / [!0 == 连接失败] *
//***********************************************************
//  机器人作为服务端，监听客户端的链接
//  服务端的 IP 指定 TcpSocketConfig.Host = "0.0.0.0"
//  服务端的 PORT 需提前设置到 TcpSocketConfig.Port
//  成功连接会得到一个 SOCKET ID 并且赋值到 TcpSocketConfig.SockFd , 并且 TcpSocketConfig.Connected 会置 TRUE
//***********************************************************	
IMPORT STATUS tcp_accept_(INOUT struct sock_cfg_t *TcpSocketConfig);

//***********************************************************
// func tcp_disconnect_()
//***********************************************************
//     in/out : *TcpSocketConfig    * sock_cfg_t * 	    * SOCKET 配置变量 * 
//     return : 			* STATUS * 		    * 始终返回 0 *
//***********************************************************
//  断开机器人和外部的网络链接
//  无论是机器人作为服务端还是客户端都可以使用 ，并且 TcpSocketConfig.Connected 会置 FALSE
//***********************************************************	
IMPORT STATUS tcp_disconnect_(INOUT struct sock_cfg_t *TcpSocketConfig);

//***********************************************************
// func tcp_buffer_()
//***********************************************************
//     in/out : *TcpSocketConfig    * sock_cfg_t * 	    * SOCKET 配置变量 * 
//     return : 			* STATUS * 		    * [>0 == 有数据] / [=0 == 无数据] / [<0 == 链接异常] *
//***********************************************************
//  检测 SOCKET 缓存区的字节数量
//  还可以用来检查链接对象是否异常断开，貌似拔网线的那种检查不出来
//  检查出来的结果也会存储到 TcpSocketConfig.NByte 
//***********************************************************	
IMPORT STATUS tcp_buffer_(INOUT struct sock_cfg_t *TcpSocketConfig);

//***********************************************************
// func tcp_send_msg_()
//***********************************************************
//     in/out : *TcpSocketConfig    * sock_cfg_t * 	    * SOCKET 配置变量 * 
//         in : *Message        * CHAR *            * 需要发送的消息指针 *
//         in : Lenght         * USHORT *          * 需要发送的消息字节大小 *
//     return : 			* STATUS * 		    * [>0 == 成功发送] *
//***********************************************************
//  向链接对象发送数据
//***********************************************************	
IMPORT STATUS tcp_send_msg_(INOUT struct sock_cfg_t *TcpSocketConfig, IN const CHAR* Message, IN USHORT Lenght);

//***********************************************************
// func tcp_received_msg()
//***********************************************************
//     in/out : *TcpSocketConfig    * sock_cfg_t * 	    * SOCKET 配置变量 * 
//        out : *MessageBuffer    * char *            * 接收存储消息的指针 *
//         in : Lenght         * USHORT *          * 需要接收的消息字节大小 *
//     return : 			* STATUS * 		    * [>0 == 成功接收] *
//***********************************************************
//  从链接对象读取数据
//  读取的数据存储到 *MessageBuffer 中
//***********************************************************	
IMPORT STATUS tcp_received_msg_(INOUT struct sock_cfg_t *TcpSocketConfig, OUT char* MessageBuffer, IN USHORT Lenght);

//***********************************************************
// func tcp_received_json_()
//***********************************************************
//     in/out : *TcpSocketConfig                        * sock_cfg_t * 	    * SOCKET 配置变量 * 
//        out : IntData[]                       * int *             * 接收整型存储变量 *
//        out : FloatData[]                     * float *           * 接收浮点型存储变量 *
//        out : StringfData[][JSON_MAX_STR]     * char *            * 接收字符型存储变量 *
//        out : PosData[][JSON_MAX_AXS]         * float *           * 接收坐标型存储变量 *
//     return : 			                    * STATUS * 		    * [=0 == 成功接收] *
//***********************************************************
//  以 JSON 格式从链接对象中读取数据，读取的数据根据数据类型分别存储在后面的变量中
//  解析格式例 : key{a:int;b:float;c:str;d:xyzabc}value{a:10;b:20.0;c:hello;d:15.1,16.2,18.2,180.0,90.0,0.0}
//***********************************************************	
IMPORT STATUS tcp_received_json_(INOUT struct sock_cfg_t *TcpSocketConfig, OUT INT32 IntData[], OUT FLOAT FloatData[], OUT CHAR StringData[][JSON_MAX_STR], OUT FLOAT PosData[][JSON_MAX_AXS]);

//***********************************************************
// func udp_create_()
//***********************************************************
//     in/out : *UdpSocketConfig    * udp_cfg_t * 	    * UDP 配置变量 * 
//     return : 			* STATUS * 		    * [0 == 成功] / [!0 == 失败] *
//***********************************************************
//  创建一个 UDP 通讯
//  内部和外部 ID PORT 在 UdpSocketConfig 中定义
IMPORT STATUS udp_create_(INOUT struct udp_cfg_t *UdpSocketConfig);

//***********************************************************
// func udp_send_msg_()
//***********************************************************
//     in/out : *UdpSocketConfig    * udp_cfg_t * 	    * UDP 配置变量 * 
//         in : *Message        * CHAR *            * 需要发送的消息指针 *
//         in : Lenght         * USHORT *          * 需要发送的消息字节大小 *
//     return : 			* STATUS * 		    * [>0 == 成功发送] *
//***********************************************************
//  基于 UDP 通讯 发送数据
//***********************************************************	
IMPORT STATUS udp_send_msg_(INOUT struct udp_cfg_t *UdpSocketConfig, IN CHAR* Message, IN USHORT Lenght);

//***********************************************************
// func udp_received_msg_()
//***********************************************************
//     in/out : *UdpSocketConfig    * udp_cfg_t * 	    * SOCKET 配置变量 * 
//        out : *MessageBuffer    * CHAR *            * 接收存储消息的指针 *
//         in : Lenght         * USHORT *          * 需要接收的消息字节大小 *
//     return : 			* STATUS * 		    * [>0 == 成功接收] *
//***********************************************************
//  基于 UDP 通讯 接收数据
//***********************************************************	
IMPORT STATUS udp_received_msg_(INOUT struct udp_cfg_t *UdpSocketConfig, OUT CHAR* MessageBuffer, IN USHORT Lenght);

//***********************************************************
// func udp_close_()
//***********************************************************
//     in/out : *UdpSocketConfig    * udp_cfg_t * 	    * SOCKET 配置变量 * 
//     return : 			* STATUS * 		    * 始终返回 0 *
//***********************************************************
//  关闭 UDP 通讯
//***********************************************************	
IMPORT STATUS udp_close_(INOUT struct udp_cfg_t *UdpSocketConfig);

//***********************************************************
// func encode_data_to_buffer_()
//***********************************************************
//       out : *Buffer        * char * 	        * 存储数据流的储存地址 * 
//        in : *DataVal         * void *            * 任意类型的数据指针 *
//        in : Offset       * UINT *            * 指定在储存地址中的第几个字节开始存入 *
//        in : Size         * UINT *            * 指定存入字节大小 *
//    return : 			    * STATUS * 		    * 始终返回 0 *
//***********************************************************
//  将任意数据类型的数据以二进制流的形式存入到指定的储存地址中
//  一般在 SOCKET 二进制数据传输之前用这个函数进行数据打包
//***********************************************************	
IMPORT STATUS encode_data_to_buffer_(INOUT UCHAR *Buffer, IN const VOID *DataVal, INOUT UINT *Offset, IN UINT Size);

//***********************************************************
// func decode_data_from_buffer_()
//***********************************************************
//       out : *Buffer        * char * 	        * 指定需要取出数据的地址 * 
//        in : *DataVal         * void *            * 任意类型的数据指针 *
//        in : Offset       * UINT *            * 指定在储存地址中的第几个字节开始取出 *
//        in : Size         * UINT *            * 指定取出字节大小 *
//    return : 			    * STATUS * 		    * 始终返回 0 *
//***********************************************************
//  指定在一个二进制数据流中取出一个实际的数据
//  一般在 SOCKET 收到二进制数据后才这个函数进行数据解包
//***********************************************************	
IMPORT STATUS decode_data_from_buffer_(IN const UCHAR *Buffer, OUT VOID *DataVal, INOUT UINT *Offset, IN UINT Size);

#endif
