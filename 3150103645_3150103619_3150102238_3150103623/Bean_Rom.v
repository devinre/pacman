`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:15:37 01/02/2017 
// Design Name: 
// Module Name:    Bean_Rom 
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
module Bean_Rom(
		input wire [9:0] p_x, p_y,
		input wire [9:0] bean_b, bean_l,//bean area
		input wire eaten,  //eaten or not signal
		output wire rd_bean_on
    );
	 
	 wire sq_bean_on;
	 wire [11:0] bean_rgb;
	 wire [3:0] bean_addr, bean_col; 
	 wire bean_bit;
	 
	 assign sq_bean_on = (bean_l<p_x&&p_x<(bean_l+10))&&(bean_b<p_y&&p_y<(bean_b+10));//bean area
	 assign bean_addr = p_y - bean_b;//bean rom address
	 assign bean_col = p_x - bean_l;//bean rom colume
	 assign bean_bit = bean_data[bean_col];//bean bit
	 assign rd_bean_on = sq_bean_on&&bean_bit&&eaten;//bean bit on
	  
	 reg [9:0] bean_data;
	 always @*
		 case (bean_addr)
			4'h0: bean_data = 10'b0000000000;//
			4'h1: bean_data = 10'b0000000000;//
			4'h2: bean_data = 10'b0000110000;//    **
			4'h3: bean_data = 10'b0001111000;//   ****
			4'h4: bean_data = 10'b0011111100;//  ******
			4'h5: bean_data = 10'b0011111100;//  ******
			4'h6: bean_data = 10'b0001111000;//   ****
			4'h7: bean_data = 10'b0000110000;//    **
			4'h8: bean_data = 10'b0000000000;//
			4'h9: bean_data = 10'b0000000000;//
		 endcase
endmodule
