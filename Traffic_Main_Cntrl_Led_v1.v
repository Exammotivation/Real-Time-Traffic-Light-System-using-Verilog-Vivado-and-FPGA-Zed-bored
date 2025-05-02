module Traffic_Main_Cntrl                
// Port Declaration
  (
  input wire Clk,
  input wire Reset,
  
 //output wire [3:0] Digit_LSB,
 // output wire [3:0] Digit_MSB,
  output wire [7:0] Lcd_Out,
  output wire Rs,
  output wire Rw,
  output wire En,
  
  input wire IR_LED,
  
  output wire N_RedLed,
  output wire N_AmberLed,
  output wire N_GreenLed,
  
  output wire E_RedLed,
  output wire E_AmberLed,
  output wire E_GreenLed,
  
  output wire S_RedLed,
  output wire S_AmberLed,
  output wire S_GreenLed,
  
  output wire W_RedLed,
  output wire W_AmberLed,
  output wire W_GreenLed
  
  
   
  );
   
  // Define States
  localparam [3:0]
        Start_Idle = 4'b0000,
        
        S2N_StateG = 4'b0001,
        S2N_StateA = 4'b0010,
         
        W2E_StateG = 4'b0011,
        W2E_StateA = 4'b0100,
        
        N2S_StateG = 4'b0101,
        N2S_StateA = 4'b0110,
        
        E2W_StateG = 4'b0111,
        E2W_StateA = 4'b1000;
        
        
        
// Define Signals
  reg [3:0] P_Traf_Main_State, N_Traf_Main_State;
  reg [27:0]P_WState1, N_WState1;
  reg [7:0]P_WState2, N_WState2;
  
  reg N_Red, N_Amber, N_Green, E_Red, E_Amber, E_Green, S_Red, S_Amber, S_Green, W_Red, W_Amber, W_Green;
  //reg LCD_Data8;
  wire [7:0]LCD_Data8;
  
  wire IR_Int;
  
  
 // Component Instantiate LCD unit  
 Lcd_Cntrl M1(.Clk(Clk), 
              .Reset(Reset), 
              .Lcd_Out(Lcd_Out),
              .Rs(Rs),
              .Rw(Rw),
              .Display_Data8(LCD_Data8),
              //.Display_Data8(8'h05),
              .En(En));     
  
 // Component Instantiate LCD unit  
 IR_LED_Cntrl M2(.Clk(Clk),
                 .Reset(Reset),
                 .IR_LED(IR_LED),
                 .IR_Interrupt(IR_Int));
                   

   
// Sync Block
  always @(posedge Clk, posedge Reset)
    begin
      if (Reset)
        begin
            P_Traf_Main_State <=  Start_Idle;
            P_WState1 <= 0;
            P_WState2 <= 8'h09;
            
        end
      else
        begin   
            P_Traf_Main_State <= N_Traf_Main_State;
            P_WState1 <= N_WState1;
            P_WState2 <= N_WState2;
            
        end
    end    
        
// Combo Logic 
  always @(*)
    begin
        N_Traf_Main_State = P_Traf_Main_State;
        N_WState1 = P_WState1;
        N_WState2 = P_WState2;
        //LCD_Data8 = P_WState2;
        
        N_Red = 0;
        N_Amber = 0;
        N_Green = 0;
        
        E_Red = 0;
        E_Amber = 0;
        E_Green = 0;
        
        S_Red = 0;
        S_Amber = 0;
        S_Green =0;
        
        W_Red = 0;
        W_Amber = 0;
        W_Green = 0;
  
     case(P_Traf_Main_State)
       
        // Idle State
         Start_Idle:
            begin
                 N_Amber = 1;
                 E_Amber = 1;
                 S_Amber = 1;
                 W_Amber = 1;
       
                if(P_WState2==8'h0)
                    begin
                        N_WState2 = 8'h14;
                        N_WState1 = 0;
                        N_Traf_Main_State = S2N_StateG;
                    end
                else
                    begin
                        if(P_WState1==27'h5F5E100)
                            begin
                                N_WState2 = P_WState2 - 1;
                                N_WState1 = 0;
                            end    
                        else
                            begin
                                N_WState1 = P_WState1 + 1;
                            end
                    end    
                    
            end 
                 
                 
                 
        
            
        S2N_StateG:
            begin
                 N_Green = 1;
                 E_Red = 1;
                 S_Red = 1;
                 W_Red = 1;
       
                if(P_WState2==8'h0)
                    begin
                        N_WState2 = 8'h03;
                        N_WState1 = 0;
                        N_Traf_Main_State = S2N_StateA;
                    end
                else
                    begin
                        if(P_WState1==27'h5F5E100)
                           begin
                              /*  if(IR_Int)
                                    begin
                                        N_WState2= P_WState2 + 8'h03; 
                                        N_WState1 = 0;                                       
                                    end
                                else
                                    begin
                                        N_WState2 = P_WState2 - 1;
                                        //LCD_Data8 = P_WState2 + 1;
                                        N_WState1 = 0;
                                    end  */
                                N_WState2 = P_WState2 - 1;
                                //LCD_Data8 = P_WState2 + 1;
                                N_WState1 = 0;    
                                    
                           end    
                        else
                            begin
                                  if(IR_Int)
                                    begin
                                        N_WState2= P_WState2 + 8'h01; 
                                    end
                                  else
                                    begin
                                        N_WState1 = P_WState1 + 1;
                                    end
                                  //N_WState1 = P_WState1 + 1;
                            end
                    end    
                    
            end 
            
            
            
           
        
        S2N_StateA:
            begin
                 N_Amber = 1;
                 E_Red = 1;
                 S_Red = 1;
                 W_Red = 1;
       
                if(P_WState2==8'h0)
                    begin
                        N_WState2 = 8'h14;
                        N_WState1 = 0;
                        N_Traf_Main_State = W2E_StateG;
                    end
                else
                    begin
                        if(P_WState1==27'h5F5E100)
                            begin
                                N_WState2 = P_WState2 - 1;
                                N_WState1 = 0;
                            end    
                        else
                            begin
                                N_WState1 = P_WState1 + 1;
                            end
                    end    
                    
            end 
            
        
        W2E_StateG:
            begin
                 E_Green = 1;
                 W_Red = 1;
                 S_Red = 1;
                 N_Red = 1;
       
                if(P_WState2==8'h0)
                    begin
                        N_WState2 = 8'h03;
                        N_WState1 = 0;
                        N_Traf_Main_State = W2E_StateA;
                    end
                else
                    begin
                        if(P_WState1==27'h5F5E100)
                            begin
                                N_WState2 = P_WState2 - 1;
                                N_WState1 = 0;
                            end    
                        else
                            begin
                                  if(IR_Int)
                                    begin
                                        N_WState2= P_WState2 + 8'h01; 
                                    end
                                  else
                                    begin
                                        N_WState1 = P_WState1 + 1;
                                    end
                                  //N_WState1 = P_WState1 + 1;
                            end
                    end    
                    
            end 
            
            
        W2E_StateA:
            begin
                 E_Amber = 1;
                 W_Red = 1;
                 S_Red = 1;
                 N_Red = 1;
       
                if(P_WState2==8'h0)
                    begin
                        N_WState2 = 8'h14;
                        N_WState1 = 0;
                        N_Traf_Main_State = N2S_StateG;
                    end
                else
                    begin
                        if(P_WState1==27'h5F5E100)
                            begin
                                N_WState2 = P_WState2 - 1;
                                N_WState1 = 0;
                            end    
                        else
                            begin
                                N_WState1 = P_WState1 + 1;
                            end
                    end    
                    
            end 
            
             
        N2S_StateG:
            begin
                 S_Green = 1;
                 W_Red = 1;
                 E_Red = 1;
                 N_Red = 1;
       
                if(P_WState2==8'h0)
                    begin
                        N_WState2 =8'h03;
                        N_WState1 = 0;
                        N_Traf_Main_State = N2S_StateA;
                    end
                else
                    begin
                        if(P_WState1==27'h5F5E100)
                            begin
                                N_WState2 = P_WState2 - 1;
                                N_WState1 = 0;
                            end    
                        else
                            begin
                                if(IR_Int)
                                    begin
                                        N_WState2= P_WState2 + 8'h01; 
                                    end
                                  else
                                    begin
                                        N_WState1 = P_WState1 + 1;
                                    end
                                  //N_WState1 = P_WState1 + 1;
                            
                                
                            end
                    end    
                    
            end 
            
            
        N2S_StateA:
            begin
                 S_Amber = 1;
                 W_Red = 1;
                 E_Red = 1;
                 N_Red = 1;
       
                if(P_WState2==8'h0)
                    begin
                        N_WState2 = 8'h14;
                        N_WState1 = 0;
                        N_Traf_Main_State = E2W_StateG;
                    end
                else
                    begin
                        if(P_WState1==27'h5F5E100)
                            begin
                                N_WState2 = P_WState2 - 1;
                                N_WState1 = 0;
                            end    
                        else
                            begin
                                N_WState1 = P_WState1 + 1;
                            end
                    end    
                    
            end 
            
        E2W_StateG:
            begin
                 W_Green = 1;
                 S_Red = 1;
                 E_Red = 1;
                 N_Red = 1;
       
                if(P_WState2==8'h0)
                    begin
                        N_WState2 = 8'h03;
                        N_WState1 = 0;
                        N_Traf_Main_State = E2W_StateA;
                    end
                else
                    begin
                        if(P_WState1==27'h5F5E100)
                            begin
                                N_WState2 = P_WState2 - 1;
                                N_WState1 = 0;
                            end    
                        else
                            begin
                                if(IR_Int)
                                    begin
                                        N_WState2= P_WState2 + 8'h01; 
                                    end
                                 else
                                    begin
                                        N_WState1 = P_WState1 + 1;
                                    end
                                  //N_WState1 = P_WState1 + 1;
                            end
                    end    
                    
            end 
            
            
        E2W_StateA:
            begin
                 W_Amber = 1;
                 E_Red = 1;
                 S_Red = 1;
                 N_Red = 1;
       
                if(P_WState2==8'h0)
                    begin
                        N_WState2 = 8'h14;
                        N_WState1 = 0;
                        N_Traf_Main_State = S2N_StateG;
                    end
                else
                    begin
                        if(P_WState1==27'h5F5E100)
                            begin
                                N_WState2 = P_WState2 - 1;
                                N_WState1 = 0;
                            end    
                        else
                            begin
                                N_WState1 = P_WState1 + 1;
                            end
                    end    
                    
            end 
            
             
             
             
             
             
             
             
             
             
             
             
             
             
             
             
             
             
             
        

        endcase        
    end// End of Combo
    
    assign N_RedLed = N_Red;
    assign N_AmberLed = N_Amber;
    assign N_GreenLed = N_Green;
    
    assign E_RedLed = E_Red;
    assign E_AmberLed = E_Amber;
    assign E_GreenLed = E_Green;
    
    assign S_RedLed = S_Red;
    assign S_AmberLed = S_Amber;
    assign S_GreenLed = S_Green;
    
    assign W_RedLed = W_Red;
    assign W_AmberLed = W_Amber;
    assign W_GreenLed = W_Green;
    
    assign LCD_Data8 = P_WState2; 
endmodule