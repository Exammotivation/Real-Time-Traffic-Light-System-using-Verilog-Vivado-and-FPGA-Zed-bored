module IR_LED_Cntrl
  (
  input wire Clk,
  input wire Reset,
  
  input wire IR_LED,
  
  output wire IR_Interrupt  
  );

localparam [1:0]
		Zero_State = 2'b00,
        One_State = 2'b01;

		
// Define Signals
  reg [1:0] Pres_EState, Next_EState;
  reg Interrupt;  
  
// Sync Block
  always @(posedge Clk, posedge Reset)
    begin
      if(Reset)
       Pres_EState <= Zero_State;
          
      else
       Pres_EState <= Next_EState;
    end    
  
        
// Combo Logic     
always @(*)
    begin
		Next_EState = Pres_EState;
        Interrupt = 1'b0;
        
   
                
    case(Pres_EState)
       
       Zero_State:
        begin
			if(IR_LED)//6
            begin
                  Interrupt = 1'b1;
                  Next_EState = One_State;
            end      
             
        end
        
       
       //Start State
       One_State:
        begin
            if(~IR_LED)//6
            begin
                  Next_EState = Zero_State;
                    
            end   
            
        end
        
        default: Next_EState = Zero_State; 
        
   endcase        
   end// End of Combo
  assign IR_Interrupt = Interrupt;  
endmodule
    