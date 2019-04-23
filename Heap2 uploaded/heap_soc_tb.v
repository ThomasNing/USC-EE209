// Verilog test fixture created from schematic C:\Users\Mark\Dropbox\EE209\Lab\sqrt2\sqrt_sys.sch - Wed Nov 25 15:46:16 2015

`timescale 1ns / 1ps

module heap_soc_tb();

// Inputs
   reg [3:0] BTNS;
	reg [7:0] SWITCHES;
   reg CLK;
   reg RESET;

// Output
   wire [7:0] DISP;
	wire [7:0] LEDS;

// Bidirs


   task do_pblaze_push;
	input [7:0] val;
	begin
		BTNS[0] = 1;
		SWITCHES = val;
		#260; 		// leave enough to time for Picoblaze to poll and see this input
		BTNS[0] = 0;
		for(i=0; i < 80; i=i+1) begin
			wait(CLK == 0);
			wait(CLK == 1);
		end
		#5;
	end
	endtask

   task do_pblaze_pop;
	begin
		BTNS[1] = 1;
		#260; 		// leave enough to time for Picoblaze to poll and see this input
		BTNS[1] = 0;
		for(i=0; i < 80; i=i+1) begin
			wait(CLK == 0);
			wait(CLK == 1);
		end
		#5;
	end
	endtask
	
   task do_pblaze_top;
	begin
		BTNS[2] = 1;
		#260; 		// leave enough to time for Picoblaze to poll and see this input
		BTNS[2] = 0;
		for(i=0; i < 32; i=i+1) begin
			wait(CLK == 0);
			wait(CLK == 1);
		end
		#5;
	end
	endtask
	
   task do_pblaze_size;
	begin
		BTNS[3] = 1;
		#260; 		// leave enough to time for Picoblaze to poll and see this input
		BTNS[3] = 0;
		for(i=0; i < 32; i=i+1) begin
			wait(CLK == 0);
			wait(CLK == 1);
		end
		#5;
	end
	endtask

// UUT instantiation
   heap_soc UUT (
		.clk(CLK), 
		.reset(RESET),
		.btns(BTNS), 
		.switches(SWITCHES),
		.leds(LEDS),
		.disp(DISP)
   );
	integer i;
// Initialize Inputs
	always #10 CLK = ~CLK;
	
	initial 
	begin
		CLK = 1;
		RESET = 1;
		BTNS = 3'b0000;
		#105;
		RESET = 0;
		
		// SIZE op
		do_pblaze_size();
		
		// PUSH op
		do_pblaze_push(8'h07);

		// PUSH op
		do_pblaze_push(8'h04);

		// SIZE op
		do_pblaze_size();

		// TOP op
		do_pblaze_top();
		
		// POP op
		do_pblaze_pop();

		// SIZE op
		do_pblaze_size();

		// TOP op
		do_pblaze_top();
		#5;
		$stop();
    end
endmodule
