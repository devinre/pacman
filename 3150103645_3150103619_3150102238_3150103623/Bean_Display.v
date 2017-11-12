`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:07:55 01/01/2017 
// Design Name: 
// Module Name:    Bean_Display 
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
module Bean_Display(
		input wire [9:0] block_x, block_y,
		output wire [9:0] bean_l,
		output wire [9:0] bean_r,
		output wire [9:0] bean_t,
		output wire [9:0] bean_b
    );
	 
reg [9:0] bean_x;
reg [9:0] bean_y;

assign bean_l = 10*bean_x-10;
assign bean_r = 10*bean_x;
assign bean_t = 10*bean_y;
assign bean_b = 10*bean_y-10;

reg [40:0] loc_x;
reg [28:0] loc_y;
/*
	 localparam bean1_l = 10;localparam bean1_r = 20;localparam bean1_t = 20;localparam bean1_b = 10;
	 localparam bean2_l = 380;localparam bean2_r = 390;localparam bean2_t = 20;localparam bean2_b = 10;
	 localparam bean3_l = 10;localparam bean3_r = 20;localparam bean3_t = 270;localparam bean3_b = 260;
	 localparam bean4_l = 380;localparam bean4_r = 390;localparam bean4_t = 270;localparam bean4_b = 260;
	 localparam bean5_l = 90;localparam bean5_r = 100;localparam bean5_t = 60;localparam bean5_b = 50;
	 localparam bean6_l = 300;localparam bean6_r = 310;localparam bean6_t = 60;localparam bean6_b = 50;
	 localparam bean7_l = 90;localparam bean7_r = 100;localparam bean7_t = 240;localparam bean7_b = 230;
	 localparam bean8_l = 300;localparam bean8_r = 310;localparam bean8_t = 240;localparam bean8_b = 230;
	 localparam bean9_l = 120;localparam bean9_r = 130;localparam bean9_t = 110;localparam bean9_b = 100;
	 localparam bean10_l = 270;localparam bean10_r = 280;localparam bean10_t = 110;localparam bean10_b = 100;
*/
//	parameter bean1_x = 2; parameter bean1_y = 2;
//	parameter bean2_x = 39; parameter bean2_y = 2;
//	parameter bean3_x = 2; parameter bean3_y = 27;
initial
begin
	//loc_x = 41'b0;
	//loc_y = 29'b0;
	loc_x[2]=1;  loc_y[2]=1;//loc[2][2] = 1;
	loc_x[39]=1; loc_y[2]=1;//loc[39][2] = 1;
	loc_x[2]=1;  loc_y[27]=1;//loc[2][27] = 1;
	loc_x[29]=1; loc_y[27]=1;//loc[39][27] = 1;
	loc_x[10]=1; loc_y[6]=1;//loc[10][6] = 1;
	loc_x[31]=1; loc_y[6]=1;//loc[31][6] = 1;
	loc_x[10]=1; loc_y[24]=1;//loc[10][24] = 1;
	//loc[31][24] = 1;
	//loc[13][11] = 1;
	//loc[28][11] = 1;
	/*#705032704;
	bean_x = bean1_x; bean_y = bean1_y;
	#705032704;
	bean_x = bean2_x; bean_y = bean2_y;
	#705032704;
	bean_x = bean3_x; bean_y = bean3_y;*/
	/*#1000;
	bean_x = bean4_x; bean_y = bean4_y;
	#1000;
	bean_x = bean5_x; bean_y = bean5_y;
	#1000;
	bean_x = bean6_x; bean_y = bean6_y;
	#1000;
	bean_x = bean7_x; bean_y = bean7_y;
	#1000;
	bean_x = bean8_x; bean_y = bean8_y;
	#1000;
	bean_x = bean9_x; bean_y = bean9_y;
	#1000;
	bean_x = bean10_x; bean_y = bean10_y;*/
end

	integer i, j;

	always @*
	begin
		if ((loc_x[block_x]==1)&&(loc_y[block_y]==1)) 
		begin
			loc_x[block_x] = 0;
			loc_y[block_y] = 0;
		end
		
		for (i=1; i<41; i=i+1)
		begin
			for (j=1; j<29; j=j+1)
			begin
				if ((loc_x[i]==1)&&(loc_y[j]==1))
				begin
					bean_x = i;
					bean_y = j;
				end
			end
		end
	end
endmodule
