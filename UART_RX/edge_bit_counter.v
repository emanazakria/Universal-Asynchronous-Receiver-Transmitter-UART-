module edge_bit_counter  # 	( parameter BusWidth 	= 8 ) 
	(
			input 	wire 		CLK 		,
			input 	wire 		RST 		,
			input 	wire 		CNT_EN 		,
			input 	wire 		PRESCALE 	,
							  
			output 	reg	[4:0]	BIT_CNT 	,
			output 	reg 	[4:0]	EDGE_CNT 	
							  
	);
		
wire                           edge_count_done ;					

assign edge_count_done = (EDGE_CNT == 'b111) ? 1'b1 : 1'b0 ; 

//egde counter						
always @ (posedge CLK or negedge RST)
 begin
 	if(!RST)
		begin
			EDGE_CNT 	<= 'b0								;
		end
	else if (CNT_EN)
		begin
			if ( (EDGE_CNT == PRESCALE) && (!edge_count_done) )  
				EDGE_CNT 		<= EDGE_CNT_REG + 1 				;
			else
				EDGE_CNT 		<= 'b0 						;
		end
	else 
		EDGE_CNT 	<= 'b0 									;	
 end

//bit counter			
always @ (posedge CLK or negedge RST)
 begin
	if(!RST)
		begin
			BIT_CNT 	<= 'b0								;
		end
	else if (CNT_EN)
		begin
			if ((EDGE_CNT == PRESCALE - 1) && (!edge_count_done))  
				BIT_CNT 		<= BIT_CNT + 'b1 			;
			else
				BIT_CNT 		<= 'b0 						;
		end
	else 
		BIT_CNT 	<= 'b0 									;
 end

						
endmodule
