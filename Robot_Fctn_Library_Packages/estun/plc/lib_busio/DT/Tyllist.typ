(*
NDTE: 5
NCPE: 32
NDME: 3
*)
3 0	lib_busio_t\lib_busio_t	busin_t	1024	16	USER	STRUCT				
5 0		BusIoSt	UINT	7	0	
6 0		SysReady	BOOL	1	0	
7 0		SysInited	BOOL	1	0	
8 0		StopMov	BOOL	1	0	
9 0		OnMeasure	BOOL	1	0	
10 0		MeasureOver	BOOL	1	0	
11 0		ResultOk	BOOL	1	0	
12 0		ResultNg	BOOL	1	0	
13 0		Finished	BOOL	1	0	
14 0		DeviceId	BYTE	17	0	
15 0		JobId	BYTE	17	0	
16 0		ErrorId	BYTE	17	0	
17 0		AgentTellId	BYTE	17	0	
18 0		AgentMsgType	BYTE	17	0	
19 0		TellId	BYTE	17	0	
20 0		MsgType	BYTE	17	0	
23 0	lib_busio_t\lib_busio_t	busout_t	1025	16	USER	STRUCT				
25 0		BusIoSt	UINT	7	0	
26 0		SysEnable	BOOL	1	0	
27 0		SysInit	BOOL	1	0	
28 0		RobMoving	BOOL	1	0	
29 0		MeasuerSt	BOOL	1	0	
30 0		MeasuerEd	BOOL	1	0	
31 0		Reserverd1	BOOL	1	0	
32 0		Reserverd2	BOOL	1	0	
33 0		CycleEnd	BOOL	1	0	
34 0		RobotId	BYTE	17	0	
35 0		JobId	BYTE	17	0	
36 0		ProtocolId	BYTE	17	0	
37 0		TellId	BYTE	17	0	
38 0		MsgType	BYTE	17	0	
39 0		RobTellId	BYTE	17	0	
40 0		RobMsgType	BYTE	17	0	
43 0	lib_busio_t\lib_busio_t	busbyte2_t	1026	1	USER	ARRAY	BYTE	17			
43 0			0	1	
45 0	lib_busio_t\lib_busio_t	busbyte4_t	1027	1	USER	ARRAY	BYTE	17			
45 0			0	3	
47 0	lib_busio_t\lib_busio_t	busbyte256_t	1028	1	USER	ARRAY	BYTE	17			
47 0			0	255	
