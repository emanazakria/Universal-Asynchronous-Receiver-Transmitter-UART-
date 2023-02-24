module Start_Check		
	(
		input 	wire  	STRT_CHK_EN	,
		input 	wire  	SAMPLED_BIT 	,
							
		output 	reg 	STRT_GLITCH 
	);
						
always @ (*)
 begin
  if(STRT_CHK_EN)	
	begin
		if (SAMPLED_BIT == 1'b0)
			STRT_GLITCH <= 1'b0 ;
		else
			STRT_GLITCH <= 1'b1 ;
	end
end	
endmodule
