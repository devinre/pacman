`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:30:34 01/06/2017
// Design Name:   counter_1s
// Module Name:   C:/Users/CST/Desktop/Pac-Man0.78/sim_counter_1s.v
// Project Name:  Pac-Man
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: counter_1s
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module sim_counter_1s;

	// Inputs
	reg clk;

	// Outputs
	wire clk_1s;

	// Instantiate the Unit Under Test (UUT)
	counter_1s uut (
		.clk(clk), 
		.clk_1s(clk_1s)
	);

	initial begin
		// Initialize Inputs
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;

	end
	
	initial forever
	begin
		clk = ~clk;
		#100;
	end;
      
endmodule

