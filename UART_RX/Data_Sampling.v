module Data_Sampling  # 	( parameter BusWidth 	= 8 ) 
	(
		input 	wire 	CLK 		,
		input 	wire 	RST 		,
		input 	wire 	DAT_SAMP_EN	,
		input 	wire 	PRESCALE 	,
		input 	wire 	EDGE_CNT 	,
		input 	wire 	RX_IN 		,
							  
		output 	reg		SAMPLED_BIT 		  
	);

reg  [1:0] OneCounter , ZeroCounter		;


always @ (posedge CLK or negedge RST)
 begin
	if(!RST)
		begin
			SAMPLED_BIT 	<= 1'b0		;
			OneCounter 	<= 2'b0 	;
			ZeroCounter 	<= 2'b0 	;
		end
	else if (DAT_SAMP_EN)
		begin
		
			if(EDGE_CNT == (PRESCALE/2-1))
				begin
					if(RX_IN == 1)
						OneCounter <= OneCounter + 1 	;
					else
						ZeroCounter <= ZeroCounter + 1	;
				end	
				
			if(EDGE_CNT == (PRESCALE/2))
				begin
					if(RX_IN == 1)
						OneCounter <= OneCounter + 1 	;
					else
						ZeroCounter <= ZeroCounter + 1 	;
				end	
				
			if(EDGE_CNT == (PRESCALE/2+1))
				begin
					if(RX_IN == 1)
						OneCounter <= OneCounter + 1 	;
					else
						ZeroCounter <= ZeroCounter + 1 	;
				end	
				
			if(EGDE_CNT == PRESCALE)
				begin
					if (OneCounter > ZeroCounter)	
						SAMPLED_BIT <= 1'b1 ;
					else 	
						SAMPLED_BIT <= 1'b0 ;
					end
				end	
					
 end	
 
 endmodule
