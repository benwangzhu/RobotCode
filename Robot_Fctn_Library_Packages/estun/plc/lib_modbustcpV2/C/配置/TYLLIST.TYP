(*
NDTE: 3
NCPE: 3
NDME: 2
*)
3 0	lib_modbustcp_t\lib_modb	modbus_r_t	1029	1	USER	ARRAY	WORD	18			
3 0			0	99	
4 0	lib_modbustcp_t\lib_modb	modbus_w_t	1030	1	USER	ARRAY	WORD	18			
4 0			0	299	
6 0	lib_modbustcp_t\lib_modb	modbus_rw_t	1031	3	USER	STRUCT				
8 0		Connected	BOOL	1	0	
9 0		ModbusIn	modbus_r_t	1029	0	
10 0		ModbusOut	modbus_w_t	1030	0	
