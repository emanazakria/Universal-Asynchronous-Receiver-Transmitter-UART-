module Serializer # ( parameter WIDTH = 8 )

(
 input   wire                  CLK          ,
 input   wire                  RST          ,
 input   wire   [WIDTH-1:0]    P_DATA       ,
 input   wire                  Enable       , 
 input   wire                  Busy         ,
 input   wire                  Data_Valid   ,
 
 output  wire                  ser_data      ,
 output  wire                  ser_done
);

    
reg  [WIDTH-1:0]    DATA ;
reg  [2:0]          ser_count ;
       
assign ser_done = (ser_count == 'b111) ? 1'b1 : 1'b0 ;

assign ser_out  = DATA[0] ;

always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
    ser_count <= 'b0                ;
   end
  else
   begin
    if (Enable)
      ser_count <= ser_count + 'b1  ;
	else 
      ser_count <= 'b0              ;	
   end
 end 

always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
    DATA <= 'b0         ;
  else if(Data_Valid && !Busy)
    DATA <= P_DATA      ;	
  else if(Enable)
    DATA <= DATA >> 1   ;         // shift register
 end

endmodule


