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
//     in/out : *TcpSocketConfig    * sock_cfg_t * 	    * SOCKET ���ñ��� * 
//     return : 			* STATUS * 		    * [0 == ���ӳɹ�] / [!0 == ����ʧ��] *
//***********************************************************
//  ��������Ϊ�ͻ��ˣ��ͷ���˽�����������
//  ����˵� IP ����ǰ���õ� TcpSocketConfig.Host 
//  ����˵� PORT ����ǰ���õ� TcpSocketConfig.Port
//  �ɹ����ӻ�õ�һ�� SOCKET ID ���Ҹ�ֵ�� TcpSocketConfig.SockFd , ���� TcpSocketConfig.Connected ���� TRUE
//***********************************************************	
IMPORT STATUS tcp_connect_(INOUT struct sock_cfg_t *TcpSocketConfig);

//***********************************************************
// func tcp_accept_()
//***********************************************************
//     in/out : *TcpSocketConfig    * sock_cfg_t * 	    * SOCKET ���ñ��� * 
//     return : 			* STATUS * 		    * [0 == ���ӳɹ�] / [!0 == ����ʧ��] *
//***********************************************************
//  ��������Ϊ����ˣ������ͻ��˵�����
//  ����˵� IP ָ�� TcpSocketConfig.Host = "0.0.0.0"
//  ����˵� PORT ����ǰ���õ� TcpSocketConfig.Port
//  �ɹ����ӻ�õ�һ�� SOCKET ID ���Ҹ�ֵ�� TcpSocketConfig.SockFd , ���� TcpSocketConfig.Connected ���� TRUE
//***********************************************************	
IMPORT STATUS tcp_accept_(INOUT struct sock_cfg_t *TcpSocketConfig);

//***********************************************************
// func tcp_disconnect_()
//***********************************************************
//     in/out : *TcpSocketConfig    * sock_cfg_t * 	    * SOCKET ���ñ��� * 
//     return : 			* STATUS * 		    * ʼ�շ��� 0 *
//***********************************************************
//  �Ͽ������˺��ⲿ����������
//  �����ǻ�������Ϊ����˻��ǿͻ��˶�����ʹ�� ������ TcpSocketConfig.Connected ���� FALSE
//***********************************************************	
IMPORT STATUS tcp_disconnect_(INOUT struct sock_cfg_t *TcpSocketConfig);

//***********************************************************
// func tcp_buffer_()
//***********************************************************
//     in/out : *TcpSocketConfig    * sock_cfg_t * 	    * SOCKET ���ñ��� * 
//     return : 			* STATUS * 		    * [>0 == ������] / [=0 == ������] / [<0 == �����쳣] *
//***********************************************************
//  ��� SOCKET ���������ֽ�����
//  ����������������Ӷ����Ƿ��쳣�Ͽ���ò�ư����ߵ����ּ�鲻����
//  �������Ľ��Ҳ��洢�� TcpSocketConfig.NByte 
//***********************************************************	
IMPORT STATUS tcp_buffer_(INOUT struct sock_cfg_t *TcpSocketConfig);

//***********************************************************
// func tcp_send_msg_()
//***********************************************************
//     in/out : *TcpSocketConfig    * sock_cfg_t * 	    * SOCKET ���ñ��� * 
//         in : *Message        * CHAR *            * ��Ҫ���͵���Ϣָ�� *
//         in : Lenght         * USHORT *          * ��Ҫ���͵���Ϣ�ֽڴ�С *
//     return : 			* STATUS * 		    * [>0 == �ɹ�����] *
//***********************************************************
//  �����Ӷ���������
//***********************************************************	
IMPORT STATUS tcp_send_msg_(INOUT struct sock_cfg_t *TcpSocketConfig, IN const CHAR* Message, IN USHORT Lenght);

//***********************************************************
// func tcp_received_msg()
//***********************************************************
//     in/out : *TcpSocketConfig    * sock_cfg_t * 	    * SOCKET ���ñ��� * 
//        out : *MessageBuffer    * char *            * ���մ洢��Ϣ��ָ�� *
//         in : Lenght         * USHORT *          * ��Ҫ���յ���Ϣ�ֽڴ�С *
//     return : 			* STATUS * 		    * [>0 == �ɹ�����] *
//***********************************************************
//  �����Ӷ����ȡ����
//  ��ȡ�����ݴ洢�� *MessageBuffer ��
//***********************************************************	
IMPORT STATUS tcp_received_msg_(INOUT struct sock_cfg_t *TcpSocketConfig, OUT char* MessageBuffer, IN USHORT Lenght);

//***********************************************************
// func tcp_received_json_()
//***********************************************************
//     in/out : *TcpSocketConfig                        * sock_cfg_t * 	    * SOCKET ���ñ��� * 
//        out : IntData[]                       * int *             * �������ʹ洢���� *
//        out : FloatData[]                     * float *           * ���ո����ʹ洢���� *
//        out : StringfData[][JSON_MAX_STR]     * char *            * �����ַ��ʹ洢���� *
//        out : PosData[][JSON_MAX_AXS]         * float *           * ���������ʹ洢���� *
//     return : 			                    * STATUS * 		    * [=0 == �ɹ�����] *
//***********************************************************
//  �� JSON ��ʽ�����Ӷ����ж�ȡ���ݣ���ȡ�����ݸ����������ͷֱ�洢�ں���ı�����
//  ������ʽ�� : key{a:int;b:float;c:str;d:xyzabc}value{a:10;b:20.0;c:hello;d:15.1,16.2,18.2,180.0,90.0,0.0}
//***********************************************************	
IMPORT STATUS tcp_received_json_(INOUT struct sock_cfg_t *TcpSocketConfig, OUT INT32 IntData[], OUT FLOAT FloatData[], OUT CHAR StringData[][JSON_MAX_STR], OUT FLOAT PosData[][JSON_MAX_AXS]);

//***********************************************************
// func udp_create_()
//***********************************************************
//     in/out : *UdpSocketConfig    * udp_cfg_t * 	    * UDP ���ñ��� * 
//     return : 			* STATUS * 		    * [0 == �ɹ�] / [!0 == ʧ��] *
//***********************************************************
//  ����һ�� UDP ͨѶ
//  �ڲ����ⲿ ID PORT �� UdpSocketConfig �ж���
IMPORT STATUS udp_create_(INOUT struct udp_cfg_t *UdpSocketConfig);

//***********************************************************
// func udp_send_msg_()
//***********************************************************
//     in/out : *UdpSocketConfig    * udp_cfg_t * 	    * UDP ���ñ��� * 
//         in : *Message        * CHAR *            * ��Ҫ���͵���Ϣָ�� *
//         in : Lenght         * USHORT *          * ��Ҫ���͵���Ϣ�ֽڴ�С *
//     return : 			* STATUS * 		    * [>0 == �ɹ�����] *
//***********************************************************
//  ���� UDP ͨѶ ��������
//***********************************************************	
IMPORT STATUS udp_send_msg_(INOUT struct udp_cfg_t *UdpSocketConfig, IN CHAR* Message, IN USHORT Lenght);

//***********************************************************
// func udp_received_msg_()
//***********************************************************
//     in/out : *UdpSocketConfig    * udp_cfg_t * 	    * SOCKET ���ñ��� * 
//        out : *MessageBuffer    * CHAR *            * ���մ洢��Ϣ��ָ�� *
//         in : Lenght         * USHORT *          * ��Ҫ���յ���Ϣ�ֽڴ�С *
//     return : 			* STATUS * 		    * [>0 == �ɹ�����] *
//***********************************************************
//  ���� UDP ͨѶ ��������
//***********************************************************	
IMPORT STATUS udp_received_msg_(INOUT struct udp_cfg_t *UdpSocketConfig, OUT CHAR* MessageBuffer, IN USHORT Lenght);

//***********************************************************
// func udp_close_()
//***********************************************************
//     in/out : *UdpSocketConfig    * udp_cfg_t * 	    * SOCKET ���ñ��� * 
//     return : 			* STATUS * 		    * ʼ�շ��� 0 *
//***********************************************************
//  �ر� UDP ͨѶ
//***********************************************************	
IMPORT STATUS udp_close_(INOUT struct udp_cfg_t *UdpSocketConfig);

//***********************************************************
// func encode_data_to_buffer_()
//***********************************************************
//       out : *Buffer        * char * 	        * �洢�������Ĵ����ַ * 
//        in : *DataVal         * void *            * �������͵�����ָ�� *
//        in : Offset       * UINT *            * ָ���ڴ����ַ�еĵڼ����ֽڿ�ʼ���� *
//        in : Size         * UINT *            * ָ�������ֽڴ�С *
//    return : 			    * STATUS * 		    * ʼ�շ��� 0 *
//***********************************************************
//  �������������͵������Զ�����������ʽ���뵽ָ���Ĵ����ַ��
//  һ���� SOCKET ���������ݴ���֮ǰ����������������ݴ��
//***********************************************************	
IMPORT STATUS encode_data_to_buffer_(INOUT UCHAR *Buffer, IN const VOID *DataVal, INOUT UINT *Offset, IN UINT Size);

//***********************************************************
// func decode_data_from_buffer_()
//***********************************************************
//       out : *Buffer        * char * 	        * ָ����Ҫȡ�����ݵĵ�ַ * 
//        in : *DataVal         * void *            * �������͵�����ָ�� *
//        in : Offset       * UINT *            * ָ���ڴ����ַ�еĵڼ����ֽڿ�ʼȡ�� *
//        in : Size         * UINT *            * ָ��ȡ���ֽڴ�С *
//    return : 			    * STATUS * 		    * ʼ�շ��� 0 *
//***********************************************************
//  ָ����һ����������������ȡ��һ��ʵ�ʵ�����
//  һ���� SOCKET �յ����������ݺ����������������ݽ��
//***********************************************************	
IMPORT STATUS decode_data_from_buffer_(IN const UCHAR *Buffer, OUT VOID *DataVal, INOUT UINT *Offset, IN UINT Size);

#endif
