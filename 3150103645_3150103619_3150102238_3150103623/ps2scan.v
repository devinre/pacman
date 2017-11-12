`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:06:20 12/18/2016 
// Design Name: 
// Module Name:    ps2scan 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ps2scan(clk, rst, ps2k_clk, ps2k_data, ps2_byte, ps2_state);
input wire clk; //100MHz clock signal
input wire rst;  //Reset signal
input ps2k_clk;   //Clock signal of the PS2 interface
input ps2k_data;  //Data signal of the PS2 interface
output[7:0] ps2_byte;    //The ASCII Code of the key which is pressed
output ps2_state;    //The status of the PS2, when a key is pressed, the value turns to 1
//------------------------------------------
reg ps2k_clk_r0,ps2k_clk_r1,ps2k_clk_r2;  //ps2k_clk status registers
wire neg_ps2k_clk;   //ps2k_clk negtive edge flag
always @ (posedge clk or negedge rst) begin
    if(!rst) begin
           ps2k_clk_r0 <= 1'b0;
           ps2k_clk_r1 <= 1'b0;
           ps2k_clk_r2 <= 1'b0;
       end
    else begin  //A simple filtering circuit
           ps2k_clk_r0 <= ps2k_clk;
           ps2k_clk_r1 <= ps2k_clk_r0;
           ps2k_clk_r2 <= ps2k_clk_r1;
       end
end
assign neg_ps2k_clk = ~ps2k_clk_r1 & ps2k_clk_r2; 
//------------------------------------------
reg[7:0] ps2_byte_r;     //The register which stores the make code received from the PS2
reg[7:0] temp_data;  //The register which stores the current scan code received from the PS2
reg[3:0] num; //Counter register
always @ (posedge clk or negedge rst) begin
    if(!rst) begin
           num <= 4'd0;
           temp_data <= 8'd0;
       end
    else if(neg_ps2k_clk) begin 
           case (num)
              4'd0:  num <= num+1'b1;
              4'd1:  begin
                         num <= num+1'b1;
                         temp_data[0] <= ps2k_data;  
                     end
              4'd2:  begin
                         num <= num+1'b1;
                         temp_data[1] <= ps2k_data; 
                     end
              4'd3:  begin
                         num <= num+1'b1;
                         temp_data[2] <= ps2k_data; 
                     end
              4'd4:  begin
                         num <= num+1'b1;
                         temp_data[3] <= ps2k_data; 
                     end
              4'd5:  begin
                         num <= num+1'b1;
                         temp_data[4] <= ps2k_data;  
                     end
              4'd6:  begin
                         num <= num+1'b1;
                         temp_data[5] <= ps2k_data; 
                     end
              4'd7:  begin
                         num <= num+1'b1;
                         temp_data[6] <= ps2k_data;  
                     end
              4'd8:  begin
                         num <= num+1'b1;
                         temp_data[7] <= ps2k_data;  
                     end
              4'd9:  begin
                         num <= num+1'b1;  //Parity bit
                     end
              4'd10: begin
                         num <= 4'd0;  //Clear num
                     end
              default: ;
              endcase
       end
end
reg key_f0;       //A flag to show whether the break code has been transmitted or not
reg ps2_state_r;  //PS2 status, when a key is pressed, the value turns to 1

always @ (posedge clk or negedge rst) begin //Dealing with the scan code received from PS2
    if(!rst) begin
           key_f0 <= 1'b0;
           ps2_state_r <= 1'b0;
       end
    else if(num==4'd10&&neg_ps2k_clk) begin   //A byte data has just been transmitted
           if(temp_data == 8'hf0) key_f0 <= 1'b1;
			  else if(temp_data == 8'he0) ;
           else begin
                  if(!key_f0) begin 
                         ps2_state_r <= 1'b1;
                         ps2_byte_r <= temp_data; 
        
                     end
                  else begin
                         ps2_state_r <= 1'b0;
                         key_f0 <= 1'b0;
        
        
                     end
              end
       end
end
reg[7:0] ps2_asci=0;   //The register which stores ASCII Code corresponding to the make code received from PS2
always @ (posedge clk) begin
    case (ps2_byte_r)    //Convert the make code to the ASCII Code
		8'h75: ps2_asci = 8'h48; //Up
		8'h6B: ps2_asci = 8'h4B;	//Left
		8'h72: ps2_asci = 8'h50;	//Down
		8'h74: ps2_asci = 8'h4D;   //Right
       default: ps2_asci = 8'hFF;
       endcase
end
assign ps2_byte = ps2_asci;
assign ps2_state = ps2_state_r;
endmodule
 
 

