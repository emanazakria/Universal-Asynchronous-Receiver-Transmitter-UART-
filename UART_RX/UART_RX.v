module UART_RX  # 	( parameter BusWidth 	= 8 ) 
	(
		input 	wire 				RX_IN 	,
		input 	wire [4:0] 			PRESCALE,
		input 	wire 				PAR_EN 	,
		input 	wire 				PAR_TYP ,
		input 	wire 				CLK 	,
		input 	wire 				RST 	,
						
		output 	wire [BusWidth-1:0] P_DATA	,
		output 	wire 				DATA_VALID
	);
					
wire 	PAR_CHK_EN 	,
		PAR_ERR 	,
		STRT_CHK_EN ,
		STRT_GLITSH	,
		STP_CHK_EN 	,
		STP_ERR 	,
		DESER_EN 	,
		SAMPLED_BIT ,
		DAT_SAMP_EN ,
		CNT_EN	 	;			
		

wire 	[4:0]	EDGE_CNT 	,
				BIT_CNT		;

RX_FSM  U_RX_FSM (
.CLK(CLK)					,
.RST(RST)					,
.PAR_EN(PAR_EN)				, 
.RX_IN(RX_IN)				,
.PAR_ERR(PAR_ERR)			, 
.STRT_GLITCH(STRT_GLITCH)	,
.STP_ERR(STP_ERR)			,
.EDGE_CNT(EDGE_CNT)			,	
.BIT_CNT(BIT_CNT)			, 
.CNT_EN(CNT_EN)				,	 
.PAR_CHK_EN(PAR_CHK_EN)		,
.STRT_CHK_EN(STRT_CHK_EN)	,
.STP_CHK_EN(STP_CHK_EN)		,
.DESER_EN(DESER_EN)			,
.DAT_SAMP_EN(DAT_SAMP_EN)	,
.DATA_VALID(DATA_VALID)	
);		

edge_bit_counter U_edge_bit_counter 
(
.CLK(CLK)					,
.RST(RST)					,
.CNT_EN(CNT_EN) 			,
.PRESCALE(PRESCALE) 		,
.BIT_CNT(BIT_CNT) 			,
.EDGE_CNT(EDGE_CNT)
);

Data_Sampling U_Data_Sampling 
(
.CLK(CLK)					,
.RST(RST)					,
.DAT_SAMP_EN(DAT_SAMP_EN) 	,
.PRESCALE(PRESCALE) 		,
.EDGE_CNT(EDGE_CNT)			,
.RX_IN(RX_IN) 				,
.SAMPLED_BIT(SAMPLED_BIT) 
);

Parity_Check U_Parity_Check
(
.CLK(CLK)					,
.RST(RST)					,
.PAR_CHK_EN(PAR_CHK_EN) 	,
.PAR_TYP(PAR_TYP) 			,
.SAMPLED_BIT(SAMPLED_BIT) 	,
.P_DATA(P_DATA) 			, 
.PAR_ERR(PAR_ERR)
);

Start_Check U_Start_Check
(
.STRT_CHK_EN(STRT_CHK_EN) 	,
.STRT_GLITCH(STRT_GLITCHS)	,
.SAMPLED_BIT(SAMPLED_BIT)
);

Stop_Check U_Stop_Check
(
.CLK(CLK)					,
.RST(RST)					,
.STP_CHK_EN(STP_CHK_EN) 	,
.STP_ERR(STP_ERR)			,
.SAMPLED_BIT(SAMPLED_BIT)
);

deserializer U_deserializer 
(
.CLK(CLK)					,
.RST(RST)					,
.DESER_EN(DESER_EN) 		,
.SAMPLED_BIT(SAMPLED_BIT) 	,
.P_DATA(P_DATA) 
);

endmodule