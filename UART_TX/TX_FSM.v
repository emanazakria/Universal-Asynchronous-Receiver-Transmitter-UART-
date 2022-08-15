module TX_FSM 
(

 input   wire                  CLK          ,
 input   wire                  RST          ,
 input   wire                  Data_Valid   ,  
 input   wire                  ser_done     , 
 input   wire                  parity_enable,

 output  reg                   Ser_enable   ,
 output  reg     [1:0]         MUX_SEL      , 
 output  reg                   busy

);

localparam idle_state 		= 3'b000 ;
localparam start_state 		= 3'b001 ;
localparam data_state 		= 3'b011 ;
localparam parity_state 	= 3'b010 ;
localparam stop_state 		= 3'b110 ;

//localparam end_state 		= 3'b111 ;

reg         [2:0]      current_state , next_state ;			

reg                    busy_c ;

always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
    busy <= 1'b0 ;
   end
  else
   begin
    busy <= busy_c ;
   end
 end


//state transiton 
always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
    current_state <= IDLE       ;
  else
    current_state <= next_state ;
 end

// next state logic
always @ (*)
 begin
  case(current_state)
  IDLE   : begin
            if(Data_Valid)
			 next_state = start_state ;
			else
			 next_state = idle_state ; 			
           end
  start  : begin
			 next_state = data_state ;  
           end
  data   : begin
            if(ser_done)
			 begin
			  if(parity_enable)
			   next_state = parity_state ;
              else
			   next_state = stop_state ;			  
			 end
			else
			 next_state = data_state ; 			
           end
  parity : begin
			 next_state = stop_state ; 
           end
  stop   : begin
			 next_state = idle_state ; 
           end	
  default: begin
			 next_state = idle_state ; 
           end	
  endcase                 	   
 end


// output logic
always @ (*)
 begin
  case(current_state)
  idle_state   : 
            begin
			    Ser_enable  = 1'b0  ;
                mux_sel     = 2'b11 ;	
                busy_c      = 1'b0  ;									
            end
  start_state  : 
            begin
			    Ser_enable  = 1'b0  ;  
                busy_c      = 1'b1  ;
                mux_sel     = 2'b00 ;	
            end
  data_state   : 
            begin 
			    Ser_enable  = 1'b1  ;    
                busy_c      = 1'b1  ;
                mux_sel     = 2'b01 ;	
            if(ser_done)
			    Ser_enable  = 1'b0  ;  
			else
 			    Ser_enable  = 1'b1  ;              			 
            end
  parity_state : 
            begin
                busy_c  = 1'b1  ;
                mux_sel = 2'b10 ;	
            end
  stop_state   : 
            begin
                busy_c  = 1'b1  ;
                mux_sel = 2'b11 ;			
            end		
  default: 
            begin
                busy_c      = 1'b0  ;
			    Ser_enable  = 1'b0  ;
                mux_sel     = 2'b00 ;		
            end	
  endcase         	              
 end 
 
 
endmodule