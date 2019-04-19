`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:31:33 10/24/2016 
// Design Name: 
// Module Name:    ping 
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
module ping(
    input clk,
    input reset,
    input go,
    input inches,
    input pulsein,
	 output pulseout,
	 output pulseen,
    output convdone,
    output [7:0] result
    );
 
  wire eqsend, eqhold, eqwait;
  wire qwait,qinit,qholdoff,qlisten,qsend,qmeasure;
  wire [15:0] countsend,counthold,countwait,countdistance;
  
  assign convdone=((qwait|qinit)&eqwait);

  cntr16ce countersend(clk,qinit|reset,qsend,countsend);
  cntr16ce counterhold(clk,qinit|reset,qholdoff,counthold);
  cntr16ce counterwait(clk,qinit|reset,qwait,countwait);
  cntr16ce counterdistance(clk,qinit|reset,qmeasure,countdistance);
  
  compeq16 comparatorSend(countsend,16'b0000000000000010,eqsend);
  compeq16 comparatorHold(counthold,16'b0000000100100101,eqhold);
  compeq16 comparatorWait(countwait,16'b0000000001001111,eqwait); 
  
  wire [15:0]scale;
  mux16bit inchCm(16'b0000010001111001,16'b0000101101011101,~inches,scale);
  
  fsm stateMachine(go,
  clk,
  reset,
  pulsein,
  eqsend,
  eqhold,
  eqwait,
  pulseout,
  pulseen,
  convdone,
  qinit,
  qsend,
  qholdoff,
  qlisten,
  qwait,
  qmeasure
  );
  
  wire [31:0]multiplier;
  mult16x16 multi(countdistance,scale,multiplier);
  wire [7:0] finalresult;
  assign finalresult=multiplier[23:16];
  wire [7:0]result;
  reg8e finally(clk,reset,convdone,finalresult,result);
  
  
  

endmodule
