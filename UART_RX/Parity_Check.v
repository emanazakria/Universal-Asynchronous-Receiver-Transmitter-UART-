module Parity_Check  # 	( parameter BusWidth 	= 8 ) 
	(
		input 	wire  					CLK				,
		input 	wire  					RST 			,
		input 	wire  					PAR_CHK_EN 		,
		input 	wire  					PAR_TYP 		,
		input 	wire  					SAMPLED_BIT 	,
		input 	wire 	[BusWidth-1:0] 	P_DATA 			,
							
		output 	reg 	PAR_ERR 

	);
							

always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
	PAR_ERR 	<= 'b0 	;
   end
  else if(PAR_CHK_EN)
   begin					
				case (PAR_TYP) 
					1'b0 : 	begin //even
								if(SAMPLED_BIT == ^DATA)
									PAR_ERR <= 1'b0 ;
								else
									PAR_ERR <= 1'b1 ;
							end
							
					1'b1 : 	begin //odd
								if(SAMPLED_BIT == ~(^DATA))
									PAR_ERR <= 1'b0 ;
								else
									PAR_ERR <= 1'b1 ;
							end			
				endcase
			end 
	end
	else
		begin
			PAR_ERR <= 1'b0 ;
		end
 end						
endmodule
