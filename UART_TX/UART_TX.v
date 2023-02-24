module UART_TX  (

 input   wire                  CLK		,
 input   wire                  RST		,
 input   wire     [7:0]        P_DATA		,
 input   wire                  Data_Valid	,
 input   wire                  parity_enable	,
 input   wire                  parity_type	,	 
 output  wire                  TX_OUT		,
 output  wire                  busy

 );

wire 	        seriz_en   	; 
wire          	seriz_done  	;
wire	 	ser_data    	;
wire	 	parity      	;
			
wire  [1:0]  	mux_sel 	;
 
TX_FSM  U_TX_FSM (
.CLK(CLK)			,
.RST(RST)			,
.Data_Valid(Data_Valid)		, 
.parity_enable(parity_enable)	,
.ser_done(seriz_done)		, 
.Ser_enable(seriz_en)		,
.MUX_SEL(mux_sel)		, 
.busy(busy)
);

Serializer U_Serializer (
.CLK(CLK)			,
.RST(RST)			,
.P_DATA(P_DATA)			,
.Busy(busy)			,
.Enable(seriz_en)		,	 
.Data_Valid(Data_Valid)		, 
.ser_out(ser_data)		,
.ser_done(seriz_done)
);

Mux U_Mux (
.CLK(CLK)			,
.RST(RST)			,
.IN_0(1'b0)			,
.IN_1(ser_data)			,
.IN_2(parity)			,
.IN_3(1'b1)			,
.MUX_SEL(mux_sel)		,
.OUT(TX_OUT) 
);

Parity_calc U_Parity_calc (
.CLK(CLK)			,
.RST(RST)			,
.parity_enable(parity_enable)	,
.PAR_TYP(parity_type)		,
.P_DATA(P_DATA)			,
.Data_Valid(Data_Valid)		, 
.parity_bit(parity)
); 
       
 endmodule
