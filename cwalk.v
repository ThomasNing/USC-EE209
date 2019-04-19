`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:38:52 10/20/2017 
// Design Name: 
// Module Name:    cwalk 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module cwalk(
    input clk,
    input reset,
    output walk,
    output hand,
    output num_on,
    output [3:0] num
    );

// Instantiate your datapath units (counters, adder) and FSM module here
// Add other "glue" logic (basic gates) and wires to connect all the components
// together.
wire peEnable2;
wire peEnable1;
wire peEnable;
wire nextstate;
wire [3:0] cntr_1;
wire [3:0] cntr_2;
wire [3:0] cntr_3;
wire ce1;
wire none;




cntr4 myC1(
    .clk(clk),
    .reset(reset),
    .pe(peEnable),
    .p(4'b0000),
    .ce(1'b1),
    .q(cntr_1),
    .tc(nextState)
    );

cntr4 myC2(
    .clk(clk),
    .reset(reset),
    .pe(peEnable1),
    .p(4'b0000),
    .ce(nextState),
    .q(cntr_2),
    .tc(none)
);

cntr4 blinking(
    .clk(clk),
    .reset(reset),
    .pe(peEnable2),
    .p(4'b0000),
    .ce(ce1),
    .q(cntr_3),
    .tc(none)
);

assign num = 4'b1000 - cntr_3;

assign ce1 = hand & num_on;

assign peEnable = cntr_2[1] & ~cntr_2[0] & ~cntr_1[3] & cntr_1[2] & cntr_1[1] & cntr_1[0]; // check for 00100111, which is 39
assign peEnable1= cntr_2[1] & ~cntr_2[0] & ~cntr_1[3] & cntr_1[2] & cntr_1[1] & cntr_1[0];
assign peEnable2=walk;

assign walk = ~cntr_2[0] & ~cntr_2[1] &  ~cntr_1[3];

assign hand = (num_on&cntr_1[0]) + cntr_2[1] + (cntr_2[0] & cntr_1[3]); 


assign num_on = (~cntr_2[1]) & ((cntr_2[0] &~cntr_1[3])+(~cntr_2[0]&cntr_1[3]));



endmodule

