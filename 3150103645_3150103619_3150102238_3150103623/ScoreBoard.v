`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:06:46 01/02/2017 
// Design Name: 
// Module Name:    ScoreBoard 
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
module ScoreBoard(
input wire clk,
input wire [15:0] score,
output wire [3:0] AN,
output wire [7:0] SEGMENT
    );

//display the score on Sword Board
disp_num d0(clk, score, 4'b0, 4'b0, 1'b0, AN, SEGMENT);

endmodule
