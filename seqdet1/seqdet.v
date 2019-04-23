`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:22:47 09/13/2016 
// Design Name: 
// Module Name:    seqdet 
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
module seqdet(
    input clk,
    input reset,
    input x,
    output z,
    output q1,
	 output q0
    );
	
	// Open the dff1.v file to find the input/output order
	//  to use when instantiating the flip-flops
	wire d0, d1;
	wire a0,a1,a2;
	
	and(a0,q1,~q0);
	or(d0,a0,~x);
	
	and(a1,~q1,q0,x);
	and(a2,q1,~q0,x);
	or(d1,a1,a2);
	
	dff1 d00(clk,reset,0,d0,q0);
	dff1 d11(clk,reset,0,d1,q1);
	and(z,q1,q0,~x);
	
endmodule
