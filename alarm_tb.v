`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:52:50 12/29/2016
// Design Name:   alarm
// Module Name:   C:/Users/Mark/Dropbox/EE209/Lab/alarm/alarm_tb.v
// Project Name:  alarm
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: alarm
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module alarm_tb;

	// Inputs
	reg N;
	reg X;
	reg W;
	reg D;
	reg G;

	// Outputs
	wire A;
	integer i;

	// Instantiate the Unit Under Test (UUT)
	alarm uut (
		.N(N), 
		.X(X), 
		.W(W), 
		.D(D), 
		.G(G), 
		.A(A)
	);

	initial 
	begin
	
	for(i=0;i<32;i=i+1)
		begin
		{N,X,W,D,G}=i;
		#10;
		end
		
	end
      
endmodule

