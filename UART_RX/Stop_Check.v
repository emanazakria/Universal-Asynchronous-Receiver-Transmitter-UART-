module Stop_Check		
	(
		input 	wire  	CLK				,
		input 	wire  	RST 			,
		input 	wire  	STP_CHK_EN		,
		input 	wire  	SAMPLED_BIT 	,
							
		output 	reg 	STP_ERR 
	);
						
always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
	STP_ERR <= 1'b0 ;
   
  else if(STP_CHK_EN)	
	begin
		if (SAMPLED_BIT == 1'b1)
			STP_ERR <= 1'b0 ;
		else
			STP_ERR <= 1'b1 ;
	end
end
endmodule