

module heap_soc(
    input clk,
    input reset,
    input [3:0] btns,
	 input [7:0] switches,
	 output [7:0] leds,
    output [7:0] disp
    );

	// btns mapping => btns[3:0] = {size, top, pop, push}
	
	wire			interrupt;            //See note above
	wire			kcpsm6_sleep;         //See note above
	wire			kcpsm6_reset;         //See note above


	// Generic KCPSM6 I/O
	wire [11:0]  address;
	wire [17:0] instruction;
	wire [7:0] port_id, out_port, in_port;
	wire write_strobe, k_write_strobe, read_strobe, interrupt_ack, bram_enable;
		

	//
	// Some additional signals are required if your system also needs to reset KCPSM6. 
	//
	wire			cpu_reset;
	wire			rdl;

	//
	// When interrupt is to be used then the recommended circuit included below requires 
	// the following signal to represent the request made from your system.
	//
	wire			int_request;

	// Heap engine signals
	wire [7:0] dout;
	wire [7:0] size;
	wire [7:0] din;
	wire push, pop, valid, done, ack;


	/////////////////////////////////////////////////////////////////////////////////////////
	// Add your own declarations here
	/////////////////////////////////////////////////////////////////////////////////////////

	wire [7:0]btns8;
	assign btns8={4'b000,btns[3:0]};
	assign pop=(out_port==8'b00000010)&(port_id==8'b00000010)&write_strobe;
	assign push=(out_port==8'b00000001)&(port_id=='b00000010)&write_strobe;
	assign ack=(port_id==8'b00000100)&write_strobe;
	wire [7:0]doneflag;
	assign doneflag={7'b0000000,doneflag1};
	
	wire dinenable;
	wire dispenable;
	wire ledsenable;
	
	assign dinenable=((port_id==8'b00000001)&write_strobe);
	assign dispenable=((port_id==8'b00001000)&write_strobe);
	assign ledsenable=((port_id==8'b00010000)&write_strobe);
	
	reg8e dinreg(.clk(clk),.reset(reset),.en(dinenable),.d(out_port[7:0]),.q(din[7:0]));
	reg8e dispreg(.clk(clk),.reset(reset),.en(dispenable),.d(out_port[7:0]),.q(disp[7:0]));
	reg8e ledsreg(.clk(clk),.reset(reset),.en(ledsenable),.d(out_port[7:0]),.q(leds[7:0]));
	
	dff1s dff(.clk(clk),.clr(ack|reset),.set(done),.d(doneflag1),.q(doneflag1));
	
	wire [7:0]input0;
	wire [7:0]input1;
	wire [7:0]input2;
	
	
	mux21_8bit mux0(.i0(btns8[7:0]),.i1(switches[7:0]),.s(port_id[0]),.y(input0[7:0]));
	mux21_8bit mux1(.i0(doneflag[7:0]),.i1(dout[7:0]),.s(port_id[0]),.y(input1[7:0]));
	mux21_8bit mux2(.i0(input0[7:0]),.i1(input1[7:0]),.s(port_id[1]),.y(input2[7:0]));
	mux21_8bit mux3(.i0(input2[7:0]),.i1(size[7:0]),.s(port_id[2]),.y(in_port[7:0]));
	

	/////////////////////////////////////////////////////////////////////////////////////////
	// Complete:  Instantiate KCPSM6 and connect to Program Memory
	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// The KCPSM6 parameters can be defined as required but the default values are shown below
	// and these would be adequate for most designs.
	//

	kcpsm6 #(
		.interrupt_vector	(12'h3FF),
		.scratch_pad_memory_size(64),
		.hwbuild		(8'h00))
	processor (
		.address 		(address),
		.instruction 	(instruction),
		.bram_enable 	(bram_enable),
		.port_id 		(port_id),
		.write_strobe 	(write_strobe),
		.k_write_strobe 	(k_write_strobe),
		.out_port 		(out_port),
		.read_strobe 	(read_strobe),
		.in_port 		(in_port),
		.interrupt 		(interrupt),
		.interrupt_ack 	(interrupt_ack),
		.reset 		(kcpsm6_reset),
		.sleep		(kcpsm6_sleep),
		.clk 			(clk)); 


	assign kcpsm6_reset = reset; 
	assign kcpsm6_sleep = 1'b0;
	assign interrupt = 1'b0;

	// Using non-JTAG, simplified memory
  heap2_prog program_rom (    				//Name to match your PSM file
	.enable 		(bram_enable),
	.address 		(address),
	.instruction 	(instruction),
	.clk 			(clk));

	heap heap_eng(
	    .clk(clk),
		 .reset(reset),
		 .push(push),
		 .pop(pop),
		 .din(din),
		 .dout(dout),
		 .size(size),
		 .done(done),
		 .valid(valid));
	
	/////////////////////////////////////////////////////////////////////////////////////////
	// Add all of your logic below this point
	/////////////////////////////////////////////////////////////////////////////////////////


endmodule
