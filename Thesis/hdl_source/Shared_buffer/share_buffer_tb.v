`timescale 1ns / 1ps
module share_buffer_tb();
	parameter N = 4;
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

	// Instantiate the Unit Under Test (UUT)
	shared_buffer uut (
		.clk        (clk),
		.rst        (rst),
		.wr_req     (wr_req),
		.rd_req     (rd_req),
		.ip         (ip),
		// .packet_len (packet_len),
		.idata      (idata),
		.op         (op),
		.odata      (odata)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		wr_req = 0;
		rd_req = 0;
		ip = 0;
		idata = 0;
		packet_len = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#3 rst = 1;
		#10 rst = 0;
		#10 wr_req = 1; idata = 'd13;
		#10 wr_req = 0;
		// #10 rd_req = 1; ip = 'd0;
		// #10 rd_req = 0;
		#10 wr_req = 1; idata = 'd2;
		#10 wr_req = 0;
		#10 rd_req = 1; ip = 13'd1;
		// #10 ip = 13'd0;
		#10 ip = 13'd20;
		#10 rd_req = 0;

		// #10 wr_req = 1;
		// #82000 wr_req = 0;


		// wr_req = 1; idata = 'd1300;
		// #16 rd_req = 1; ip = 'd20;
	end
	//
	always begin 
		#5 clk = ~clk;
	end
      
endmodule

