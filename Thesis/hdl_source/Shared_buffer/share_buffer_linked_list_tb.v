`timescale 1ns / 1ps
module share_buffer_linked_list_tb();
	parameter N = 13;
	// Inputs
	reg        clk;
	reg        rst;
	reg        wr_req;
	reg        rd_req;
	// reg [12:0] ip;
	// reg [71:0] idata;
	reg [N-1:0] ip;
	reg [N-1:0] idata;
	reg [ 7:0] packet_len;

	// Outputs
	// wire [12:0] op;
	// wire [71:0] odata;
	wire [N-1:0] op;
	wire [N-1:0] odata;
	wire shared_buffer_empty;
	wire shared_buffer_full;
	//
	integer read_count, in_count;
	localparam NUM_INPUT_LOOP = 10;
	localparam NUM_READ_LOOP = 20;
	// Instantiate the Unit Under Test (UUT)
	shared_buffer_linked_list uut (
		.clk                 (clk),
		.rst                 (rst),
		.wr_req              (wr_req),
		.rd_req              (rd_req),
		.ip                  (ip),
		.packet_len          (packet_len),
		.idata               (idata),
		.op                  (op),
		.odata               (odata),
		.shared_buffer_empty (shared_buffer_empty),
		.shared_buffer_full  (shared_buffer_full)
	);
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		wr_req = 0;
		rd_req = 0;
		ip = 'bx;
		idata = 0;
		packet_len = 0;
		// Wait 100 ns for global reset to finish
		#100;
		// Add stimulus here
		#3 rst = 1;
		#10 rst = 0;
		#40;
		//
		for(in_count = 0; in_count < NUM_INPUT_LOOP; in_count = in_count + 1) begin
			packet_len = 3;
			wr_req = 1; idata=1+in_count; // trong so 0.75
			#10;
			wr_req = 0; idata=0;
			#(10 + 10*$unsigned($random())%10);
			wr_req = 1; idata=2+in_count; 
			#10;
			wr_req = 0; idata=0;
			#(10 + 10*$unsigned($random())%10);
			wr_req = 1; idata=3+in_count; 
			#10;
			wr_req = 0; idata=0;
			#(10 + 10*$unsigned($random())%10);
			packet_len = 2;
			wr_req = 1; idata=100+in_count; // trong so 0.75
			#10;
			wr_req = 0; idata=0;
			#(10 + 10*$unsigned($random())%10);
			wr_req = 1; idata=101+in_count; 
			#10; 
			wr_req = 0; idata=0;
			#(10 + 10*$unsigned($random())%10);
		end
		wr_req = 0; idata=0;
	end
	initial begin 
		#300;
		//
		//-------------------packet read-------------------
		// for (read_count = 0; read_count < NUM_READ_LOOP; read_count=read_count+1) begin
		// 	rd_req = 1; ip = read_count;
		// 	#10;
		// 	// rd_req = 0; ip = 0;
		// 	// #30; 
		// end
		// 
		// rd_req = 1; ip = 3;
		// #10;
		// rd_req = 1;
		// #10;
		// 
		rd_req = 1; ip = 0;
		#10;
		rd_req = 0;
		#(10 + 10*$unsigned($random())%10);
		rd_req = 1;
		#10;
		rd_req = 0;
		#(10 + 10*$unsigned($random())%10);
		rd_req = 1;
		#10;
		rd_req = 0;
		#(10 + 10*$unsigned($random())%10);
		// 
		rd_req = 1; ip = 5;
		#10;
		rd_req = 0;
		#(10 + 10*$unsigned($random())%10);
		rd_req = 1;
		#10;
		rd_req = 0;
		#(10 + 10*$unsigned($random())%10);
		rd_req = 1;
		#10;
		rd_req = 0;
		#(10 + 10*$unsigned($random())%10);
		// 
		rd_req = 1; ip = 3;
		#10;
		rd_req = 0;
		#(10 + 10*$unsigned($random())%10);
		rd_req = 1;
		#10;
		rd_req = 0;
		#(10 + 10*$unsigned($random())%10);
		//
		rd_req = 1; ip = 8;
		#10;
		rd_req = 0;
		#10;

		rd_req = 0; ip = 0;
	end
	//
	always begin 
		#5 clk = ~clk;
	end
      
endmodule

