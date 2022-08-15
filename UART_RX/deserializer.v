module deserializer  # 	( parameter BusWidth 	= 8 ) 
	(
		input 	wire  				CLK				,
		input 	wire  				RST 			,
		input 	wire  				DESER_EN		,
		input 	wire  				SAMPLED_BIT 	,
							
		output 	reg  [BusWidth-1:0]	P_DATA 
	);
						


always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
	begin
		P_DATA 		<= 	'b0 ;
	end
  else if(DESER_EN)
		P_DATA 	<= { SAMPLED_BIT , P_DATA[BusWidth-1:1] }	;
			
 end
 

endmodule