module Lcd_Cntrl
              
  // Port Declaration
  (
  input wire Clk,
  input wire Reset,
  
  input wire [7:0] Display_Data8,
  output reg [7:0] Lcd_Out,
  
  output reg Rs,
  output reg Rw,
  output reg En
     
  );
  
  
  localparam [5:0]
		Init_State = 6'd0,
		
        Init_Wait1 = 6'd1,
		
		Init_Cmd1 = 6'd2,
		Init_Wait2 = 6'd3,
		
        Init_Cmd2= 6'd4,
		Init_Wait3 = 6'd5,
		
		Init_Cmd3 = 6'd6,
		
		
		Fun_Cmd = 6'd7,
		Cur_Cmd = 6'd8,
		Don_Cmd = 6'd9,
		Enty_Cmd = 6'd10,
		
		
		Dclr_Cmd = 6'd11,
		Disp_Blik_Cmd = 6'd12,
		
		Cur_Home1 = 6'd13,
		Wait_Home1 = 6'd14,
		Line1_Cmd= 6'd15,
		Write_Cha1 = 6'd16,
		Write_Cha2 = 6'd17,
		Write_Cha3 = 6'd18,
		Write_Cha4 = 6'd19,
		Write_Cha5 = 6'd20,
		Write_Cha6 = 6'd21,
		Write_Cha7 = 6'd22,
		Write_Cha8 = 6'd23,
		Write_Cha9 = 6'd24,
		Write_Cha10 = 6'd25,
		Write_Cha11 = 6'd26,
		Write_Cha12 = 6'd27,
		Write_Cha13 = 6'd28,
		
		Write_Cha14 = 6'd29,
		Write_Cha15 = 6'd30,
		Write_Cha16 = 6'd31,
		Write_Cha17 = 6'd32,
		Write_Cha18 = 6'd33,
		Write_Cha19 = 6'd34,
		Write_Cha20 = 6'd35,
		
		
		
		
		Cur_Home2 = 6'd36,
		Wait_Home2 = 6'd37,
		Line2_Cmd= 6'd38,
		Conv_Dec =6'd39,
		Chk_Dec1 =6'd40,
		Chk_Dec2 =6'd41,
		Chk_Dec3 =6'd42,
		Chk_Dec4 =6'd43,
		
		
		
		Write_Cha21 = 6'd44,
		Write_Cha22 = 6'd45,
		Write_Cha23 = 6'd46,
		Write_Cha24 = 6'd47,
		
		
		
		
		
		
		Wait_Next_Sample = 6'd48,
		Stop_Lcntrl = 6'd49;
		
		
		
		
        
        
		
		
  
  reg [5:0] Pres_Lcntrl_State, Next_Lcntrl_State;
 
  reg [26:0] Pres_Wstate, Next_Wstate;
  reg [15:0] Pres_Ewidth, Next_Ewidth;
  
  reg [3:0] Pres_Shift, Next_Shift;
  
  reg [25:0] Pres_Dsample, Next_Dsample;
  
  reg [15:0] Temp_Digital_Data16;
  
 
  
  // Sync Block
  always @(posedge Clk, posedge Reset)
    begin
      if (Reset)
        begin
            Pres_Lcntrl_State <= Init_State;
            Pres_Wstate <=0;
			Pres_Ewidth <= 0;
			Pres_Shift <= 0;
			Pres_Dsample <= 0;
			
        end
      else
        begin
			Pres_Lcntrl_State <= Next_Lcntrl_State;
            Pres_Wstate <=Next_Wstate;
			Pres_Ewidth <= Next_Ewidth;
			Pres_Shift <= Next_Shift;
			Pres_Dsample <= Next_Dsample;
		end
    end    
        
// Combo Logic 
  always @(*)
    begin
		Next_Lcntrl_State = Pres_Lcntrl_State;
        Next_Wstate = Pres_Wstate;
		Next_Ewidth = Pres_Ewidth;
		Next_Shift = Pres_Shift;
		Next_Dsample = Pres_Dsample;
  
        Rs = 1'b0;
		Rw = 1'b0;
		En = 1'b0;
		Lcd_Out= 8'b00110000;
		
		
   
                
    case(Pres_Lcntrl_State)
       
       Init_State:
        begin
			Next_Wstate = 0;
			Next_Ewidth = 0;
			//Next_Dsample = {10'b0000000000, Digital_Data16[15:0]};
			Next_Dsample = {12'b0000000000, Display_Data8[7:0]};
			Next_Shift = 0;
			Next_Lcntrl_State = Init_Wait1;
			 
             
        end
        
       
       //Start State
       Init_Wait1:
        begin
            //if(Pres_Wstate==15ms)
            if(Pres_Wstate == 25'h2BF20)//6
            begin
                    Next_Wstate = 0;
                    Next_Lcntrl_State = Init_Cmd1;
                end    
            else
                begin
                    Next_Wstate = Pres_Wstate +1;        
                end
        end
        
        
       
       Init_Cmd1:
        begin
            Lcd_Out = 8'h30;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Init_Wait2;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
        end
                        
       Init_Wait2:
       begin
        //if(Pres_Wstate==4.1ms)
        if(Pres_Wstate == 25'hC030)//6
            begin
                Next_Wstate = 0;
                Next_Lcntrl_State = Init_Cmd2;
            end    
        else
            begin
                Next_Wstate = Pres_Wstate +1;        
            end
        end
        
        
       
       
       Init_Cmd2:
        begin
            Lcd_Out = 8'h30;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Init_Wait3;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
        end

       
       
       
       Init_Wait3:
       begin
        //if(Pres_Wstate==100us)
        if(Pres_Wstate == 25'h4B0)//6
            begin
                Next_Wstate = 0;
                Next_Lcntrl_State = Init_Cmd3;
            end    
        else
            begin
                Next_Wstate = Pres_Wstate +1;        
            end
        end
        
       
       Init_Cmd3:
        begin
            Lcd_Out = 8'h30;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Fun_Cmd;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
        end
        
        
        Fun_Cmd:
        begin
            Lcd_Out = 8'h38;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Cur_Cmd;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
        end


        Cur_Cmd:
        begin
            Lcd_Out = 8'h14;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Don_Cmd;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
        end

       
        Don_Cmd: 
        begin
            Lcd_Out = 8'h0E;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Enty_Cmd;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
        end

        
        
        Enty_Cmd:
        begin
            Lcd_Out = 8'h06;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Dclr_Cmd;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
        end
       
        
		//////
		
		Dclr_Cmd:
        begin
            Lcd_Out = 8'h01;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Cur_Home1;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
        end
	
        Cur_Home1:
        begin
            Lcd_Out = 8'h02;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Wait_Home1;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
        end
       
       Wait_Home1:
       begin
			//if(Pres_Wstate==4.1ms)
            if(Pres_Wstate == 25'hC030)//6
            begin
                Next_Wstate = 0;
                Next_Lcntrl_State = Line1_Cmd;
            end    
        else
            begin
                Next_Wstate = Pres_Wstate +1;        
            end
        end
       
       Line1_Cmd:
       begin
            //if(Pres_Wstate==4.1ms)
            Lcd_Out = 8'h80;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Write_Cha1;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
       end
       
       Write_Cha1:   
       begin
            //if(Pres_Wstate==4.1ms)
            Rs = 1'b1;
            Lcd_Out = 8'h54;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Write_Cha2;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
       end
       
       
       Write_Cha2:   
       begin
            Rs = 1'b1;
            Lcd_Out = 8'h72;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Write_Cha3;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
       end
		
       
       Write_Cha3:   
       begin
            Rs = 1'b1;
            Lcd_Out = 8'h61;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Write_Cha4;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
       end
		
       Write_Cha4:   
       begin
            Rs = 1'b1;
            Lcd_Out = 8'h66;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Write_Cha5;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
       end
		
      Write_Cha5:   
       begin
            Rs = 1'b1;
            Lcd_Out = 8'h66;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Write_Cha6;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
       end
	   
	  Write_Cha6:   
       begin
            Rs = 1'b1;
            Lcd_Out = 8'h69;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Write_Cha7;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
       end
	  
	  
	  Write_Cha7:   
       begin
            Rs = 1'b1;
            Lcd_Out = 8'h63;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Write_Cha8;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
       end
		 	
	   
	  Write_Cha8:   
       begin
            Rs = 1'b1;
            Lcd_Out = 8'h20;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Write_Cha9;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
       end
		
	  Write_Cha9:   
       begin
            Rs = 1'b1;
            Lcd_Out = 8'h54;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Write_Cha10;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
       end
		
	  Write_Cha10:   
       begin
            Rs = 1'b1;
            Lcd_Out = 8'h69;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Write_Cha11;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
       end
	 
	 Write_Cha11:   
       begin
            Rs = 1'b1;
            Lcd_Out = 8'h6D;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Write_Cha12;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
       end
	 
	 Write_Cha12:   
       begin
            Rs = 1'b1;
            Lcd_Out = 8'h65;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Write_Cha13;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
       end	
	   
	   
	 Write_Cha13:   
       begin
            Rs = 1'b1;
            Lcd_Out = 8'h72;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Write_Cha14;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
       end	
	   
	   
	   
	 Write_Cha14:   
       begin
            Rs = 1'b1;
            Lcd_Out = 8'h20;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    //Next_Lcntrl_State = Write_Cha15;
                    Next_Lcntrl_State =  Cur_Home2;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
       end	
	   	 
	// End of Traffic Timer
	/*
	Write_Cha15:   
       begin
            Rs = 1'b1;
            Lcd_Out = 8'h20;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Write_Cha16;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
       end	
	   
	Write_Cha16:   
       begin
            Rs = 1'b1;
            Lcd_Out = 8'h54;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Write_Cha17;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
       end	
	
	Write_Cha17:   
       begin
            Rs = 1'b1;
            Lcd_Out = 8'h69;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Write_Cha18;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
       end

	Write_Cha18:   
       begin
            Rs = 1'b1;
            Lcd_Out = 8'h6D;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Write_Cha19;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
       end		
	
	
	Write_Cha19:   
       begin
            Rs = 1'b1;
            Lcd_Out = 8'h65;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Write_Cha20;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
       end

    Write_Cha20:   
       begin
            Rs = 1'b1;
            Lcd_Out = 8'h72;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Cur_Home2;
					//Next_Lcntrl_State =  Stop_Lcntrl;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
       end


*/
	   
	  Cur_Home2:
        begin
            Lcd_Out = 8'h02;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Wait_Home2;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
        end
       
       Wait_Home2:
       begin
			//if(Pres_Wstate==4.1ms)
			if(Pres_Wstate == 25'hC030)//6
            begin
                Next_Wstate = 0;
                Next_Lcntrl_State = Line2_Cmd;
            end    
        else
            begin
                Next_Wstate = Pres_Wstate +1;        
            end
        end
       
      Line2_Cmd:
       begin
            Lcd_Out = 8'hC0;
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    //Next_Dsample = {10'b0000000000, Digital_Data16[15:0]};
                    Next_Dsample = {12'b0000000000, Display_Data8[7:0]};
                    //Next_Dsample = {12'b0000000000, 8'b00100100}-1;
                    Next_Lcntrl_State = Conv_Dec;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
       end
       
      Conv_Dec:
        begin
            if(Pres_Shift == 7)
                begin
                    Next_Dsample = {Pres_Dsample[18:0],1'b0};
                    Next_Shift = 0;
                    Next_Lcntrl_State = Write_Cha21;
                end    
            else 
                begin
                    Next_Dsample = {Pres_Dsample[18:0],1'b0};
                    Next_Shift = Pres_Shift + 1;
                    Next_Lcntrl_State = Chk_Dec1;
                end
                
                
        end
       
      Chk_Dec1:
        begin
            if(Pres_Dsample[11:8] > 4)
                Next_Dsample = Pres_Dsample + {19'b0000_0000_0011_0000_0000} ;
                    
            Next_Lcntrl_State = Chk_Dec2;    
        end
        
        
        
       
      Chk_Dec2:
        begin
            if(Pres_Dsample[15:12] > 4)
                Next_Dsample = Pres_Dsample + {19'b0011_0000_0000_0000} ;
             Next_Lcntrl_State = Chk_Dec3;    
        end
       
       
       
     Chk_Dec3:
        begin
             if(Pres_Dsample[19:16] > 4)
                Next_Dsample = Pres_Dsample + {19'b0011_0000_0000_0000_0000} ;
             Next_Lcntrl_State = Conv_Dec;    
        end
       
       
     /*  
     Chk_Dec4:
        begin
             if(Pres_Dsample[25:22] > 4)
                Next_Dsample = Pres_Dsample + {26'b00_1100_0000_0000_0000_0000_0000} ;
             Next_Lcntrl_State = Conv_Dec;    
        end
     
       */
       
       
       
       Write_Cha21:   
       begin
            Rs = 1'b1;
            Lcd_Out = {4'b0000,Pres_Dsample[19:16]} + {8'b00110000};
            
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Write_Cha22;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
       end
       	
	  Write_Cha22:   
       begin
            Rs = 1'b1;
            Lcd_Out = {4'b0000, Pres_Dsample[15:12]} + {8'b00110000};
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Write_Cha23;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
       end
       	
	  Write_Cha23:   
       begin
            Rs = 1'b1;
            Lcd_Out = {4'b0000, Pres_Dsample[11:08]} + {8'b00110000};
            
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Wait_Next_Sample;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
       end 
      /* 	
	  Write_Cha24:   
       begin
            Rs = 1'b1;
            Lcd_Out = {4'b0000, Pres_Dsample[13:10]} + {8'b00110000};
            
            if(Pres_Ewidth == 16'hFFFC)
                begin
                    Next_Ewidth = 0;
                    Next_Lcntrl_State = Wait_Next_Sample;
                end    
            else if (Pres_Ewidth > 16'h03FF)
                begin
                    Next_Ewidth = Pres_Ewidth +1;        
                end
            else
                begin
                    Next_Ewidth = Pres_Ewidth +1;
                    En = 1'b1;
                    
                end
       end
       */
       
       
       //Start State
       Wait_Next_Sample:
        begin
            //if(Pres_Wstate==15ms)
            if(Pres_Wstate == 27'h1FF_FFFC)
            begin
                    Next_Wstate = 0;
                    Next_Lcntrl_State = Cur_Home2;
                end    
            else
                begin
                    Next_Wstate = Pres_Wstate +1;        
                end
        end
       
      	
	  Stop_Lcntrl:
		begin
           
            Next_Lcntrl_State = Stop_Lcntrl;
        end       
        
		
		
    
       
       
       
             
    endcase        
   end// End of Combo
 
   
  
endmodule
    
    
        
        
         
          
      
        
        
        
        
        
        
  
  
  
  
   