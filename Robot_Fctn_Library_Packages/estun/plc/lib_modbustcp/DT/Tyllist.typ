(*
NDTE: 8
NCPE: 5
NDME: 4
*)
2 0	DataTypes\DataTypes	STRING_51	1024	51	USER	STRING				
2 0	Cmd_DataTypes\Cmd_DataTy	UDINT_ARRAY_10	1025	1	USER	ARRAY	UDINT	8			
2 0			1	10	
6 0	Cmd_DataTypes\Cmd_DataTy	STRING512	1026	512	USER	STRING				
1 0	SIMIO_DATATYPE\SIMIO_DAT	SIMIO_BYTE_BUFF	1027	1	USER	ARRAY	BYTE	17			
1 0			1	256	
4 0	SIMIO_DATATYPE\SIMIO_DAT	SIM_IO_BYTE_BUFF_MANAGE	1028	2	USER	STRUCT				
6 0		SimDIByteBuff	SIMIO_BYTE_BUFF	1027	0	
7 0		SimDOByteBuff	SIMIO_BYTE_BUFF	1027	0	
3 0	lib_modbustcp_t\lib_modb	modbus_r_t	1029	1	USER	ARRAY	WORD	18			
3 0			0	99	
4 0	lib_modbustcp_t\lib_modb	modbus_w_t	1030	1	USER	ARRAY	WORD	18			
4 0			0	299	
6 0	lib_modbustcp_t\lib_modb	modbus_rw_t	1031	3	USER	STRUCT				
8 0		Connected	BOOL	1	0	
9 0		ModbusIn	modbus_r_t	1029	0	
10 0		ModbusOut	modbus_w_t	1030	0	
