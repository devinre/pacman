`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:53:06 12/17/2016 
// Design Name: 
// Module Name:    vga_sync 
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
//`include "Definition.h"

module VGA_Sync(
    input clk,
    output reg hs,
    output reg vs,
	 output wire p_tick,
	 output wire [9:0] p_x, p_y
    );
	
	assign p_tick = clk_25M;
	assign p_x = Hcnt;
	assign p_y = Vcnt;
	//parameter definition
	parameter PAL = 640;		//Pixels/Active Line (pixels)
	parameter LAF = 480;		//Lines/Active Frame (lines)
	parameter PLD = 800;	    //Pixel/Line Divider
	parameter LFD = 521;		//Line/Frame Divider
	parameter HPW = 96;			//Horizontal synchro Pulse Width (pixels)
	parameter HFP = 16;			//Horizontal synchro Front Porch (pixels)
	parameter VPW = 2;			//Verical synchro Pulse Width (lines)
	parameter VFP = 10;			//Verical synchro Front Porch (lines)
	
	/*register definition*/
	reg [9:0] Hcnt;      // horizontal counter  if = PLD-1 -> Hcnt <= 0
	reg [9:0] Vcnt;      // verical counter  if = LFD-1 -> Vcnt <= 0
	reg clk_25M = 0;     //25MHz frequency
	reg clk_50M_reg = 0;     //50 MHz frequency
	assign clk_50M = clk_50M_reg;
	//generate a half frequency clock of 25MHz
	always@(posedge(clk))
	begin
		clk_50M_reg <= ~clk_50M_reg;
	end
	
	always@(posedge(clk_50M_reg))
	begin
		clk_25M <= ~clk_25M;
	end
	
	/*generate the hs && vs timing*/
	always@(posedge(clk_25M)) 
	begin
		/*conditions of reseting Hcnter && Vcnter*/
		if( Hcnt == PLD-1 ) //have reached the edge of one line
		begin
			Hcnt <= 0; //reset the horizontal counter
			if( Vcnt == LFD-1 ) //only when horizontal pointer reach the edge can the vertical counter ++
				Vcnt <=0;
			else
				Vcnt <= Vcnt + 1;
		end
		else
			Hcnt <= Hcnt + 1;
		
		/*generate hs timing*/
		if( Hcnt == PAL - 1 + HFP)
			hs <= 1'b0;
		else if( Hcnt == PAL - 1 + HFP + HPW )
			hs <= 1'b1;
		
		/*generate vs timing*/		
		if( Vcnt == LAF - 1 + VFP ) 
			vs <= 1'b0;
		else if( Vcnt == LAF - 1 + VFP + VPW )
			vs <= 1'b1;					
	end
endmodule
