`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:46:33 09/28/2016 
// Design Name: 
// Module Name:    cntr4 
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
module cntr4(
    input clk,
    input reset,
    input pe,
    input [3:0] p,
    input ce,
    output [3:0] q,
    output tc
    );

	wire [3:0] myd, qinc;
	
	adder4 add_inc(
		.A(q),
		.B(4'b0001),
		.C0(1'b0),
		.S(qinc),
		.C4() // open / unattached 
		); 
	reg4e cntr_reg(
		.clk(clk),
		.reset(reset),
		.en(1'b1), // change this if you like
		.d(myd),
	   .q(q));	
	assign tc = (q == 4'b1111) && ce;

	// Add mux21_4bit instantiations (1 or more) to complete your 4-bit counter
	//  The goal of the muxes is to select the correct value to be passed
	//  to myd (the D input of the actual register).
	wire [3:0]muxtest;
	mux21_4bit m1(
		.I0(q),
		.I1(qinc),
		.S(ce),
		.Y(muxtest));
		
	mux21_4bit m2(
		.I0(muxtest),
		.I1(p),
		.S(pe),
		.Y(myd));
	
	
		

	
	
endmodule
