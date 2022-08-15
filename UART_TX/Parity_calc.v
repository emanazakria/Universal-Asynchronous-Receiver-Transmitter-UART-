module parity_calc # ( parameter WIDTH = 8 )

(
 input   wire                  CLK          ,
 input   wire                  RST          ,
 input   wire                  parity_enable,
 input   wire                  PAR_TYP      ,
 input   wire   [WIDTH-1:0]    P_DATA       ,
 input   wire                  Data_Valid   ,

 output  reg                   parity_bit 
);

reg  [WIDTH-1:0]    DATA ;

always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
    parity_bit <= 'b0 ;
   end
  else
   begin
    if (parity_enable)
	 begin
	  case(PAR_TYP)
	  1'b0 : begin                 
	          parity_bit <= ^DATA  ;     // Even Parity
	         end
	  1'b1 : begin
	          parity_bit <= ~^DATA ;     // Odd Parity
	         end		
	  endcase       	 
	 end
   end
 end 


always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
    DATA <= 'b0     ;
   end
  else if(Data_Valid)
   begin
    DATA <= P_DATA  ;
   end 
 end
 
endmodule