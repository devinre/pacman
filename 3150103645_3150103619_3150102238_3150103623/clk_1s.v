`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:13:07 12/06/2016 
// Design Name: 
// Module Name:    clk_1s 
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
module counter_1s(clk, clk_1s);
input wire clk;
output reg clk_1s;
reg [31:0] cnt;
always @ (posedge clk) begin
   if (cnt < 50_000_000) begin    //use count to divide
       cnt <= cnt + 1;
   end else begin
       cnt <= 0;
       clk_1s <= ~clk_1s;	//reverse
   end
end
endmodule

