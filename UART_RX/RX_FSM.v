module RX_FSM  # 	( parameter BusWidth 	= 8 ) 
	(
		input   wire                 	CLK		,
		input   wire                  	RST		,
		input   wire                  	PAR_EN		,	 
		input   wire                  	RX_IN		, 
		input   wire                  	PAR_ERR		, 
		input  	wire       	        STRT_GLITCH	,
		input 	wire 	   	     	STP_ERR		, 
		input 	wire 			EDGE_CNT	, 
		input 	wire 			BIT_CNT		,

		output 	reg			CNT_EN 		,
		output 	reg			PAR_CHK_EN 	,
		output 	reg			STRT_CHK_EN 	,
		output 	reg			STP_CHK_EN 	,
		output 	reg			DESER_EN 	,
		output 	reg			DAT_SAMP_EN 	,
		output 	reg			DATA_VALID 
							
	);
						
// gray state encoding
parameter   [2:0]      	IDLE   		= 3'b000		,
			start 		= 3'b001		,
                       	data  		= 3'b011		,
			parity   	= 3'b010		,
		  	stop 		= 3'b110		,
		   	error_check 	= 3'b111 		;
					   
reg         [2:0]      current_state , next_state 		;

initial begin
current_state   = IDLE			;
end
					   
					   
					
always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
    current_state <= IDLE 		;
  else
    current_state <= next_state 	;
 end
		
// next state &	OUTPUT logic
always @ (*)
 begin
  case(current_state)
  
  IDLE   		:	begin
						if(RX_IN != 1'b1)
							begin
							
								STRT_CHK_EN 	<= 1'b1 ;
								CNT_EN 		<= 1'b1 ;
								DAT_SAMP_EN 	<= 1'b1 ;
								
								next_state 	<= data ;
								
							end
						else
							begin
								
								CNT_EN 		<= 1'b0 	;
								PAR_CHK_EN 	<= 1'b0 	;
								STRT_CHK_EN 	<= 1'b0 	;
								STP_CHK_EN 	<= 1'b0 	;
								DESER_EN 	<= 1'b0 	;
								DAT_SAMP_EN 	<= 1'b0 	;
								DATA_VALID 	<= 1'b0 	;
				
								next_state 	<= IDLE 	;
							end
						
					end
		   
		   
  data   		: 	begin
						
						if (STRT_GLITCH == 1'b1)
							begin
								next_state <= 	IDLE 				;
							end	
						else
							begin
								if(BIT_CNT == BusWidth) //start bit inculded
									if(PAR_EN)
										next_state 	<= 	parity 	;
									else 
										next_state 	<= 	stop 	;
								else
										next_state 	<= 	data 	;
										DESER_EN 	<= 	1'b1	;
							end
							
					end
		   
  parity 		: 	begin
  
						PAR_CHK_EN <= 1'b1 			;	
						next_state <= stop	 		;				
						
					end
		   
  stop   		: 	begin
  
						STP_CHK_EN <= 1'b1 			;
						next_state <= error_check 		;
						
					end	
		   
  error_check   : 	begin
						next_state <= IDLE 			;
						
						if ( (PAR_ERR == 0) && (STP_ERR == 0) )
							DATA_VALID <= 1'b1		;
						else
							DATA_VALID <= 1'b0		;
						
					end	
		   
  default: begin
				next_state = IDLE ;

				CNT_EN 		<= 1'b0 	;
				PAR_CHK_EN 	<= 1'b0 	;
				STRT_CHK_EN 	<= 1'b0 	;
				STP_CHK_EN 	<= 1'b0 	;
				DESER_EN 	<= 1'b0 	;
				DAT_SAMP_EN 	<= 1'b0 	;
				DATA_VALID 	<= 1'b0 	;
           end	
  endcase                 	   
 end 	


 
		
endmodule
