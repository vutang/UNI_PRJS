`timescale 1ns / 1ps
module WFQ_top_tb;
	// Inputs
	reg        clk;
	reg        rst;
	reg        in_packet_arrival;
	reg        in_data_arrival;
	reg [ 8:0] in_packet_length;
	reg [12:0] in_flow_id;
	reg        in_rd_packet_req;
	reg [63:0] in_packet_data;
	reg [10:0] in_rd_packet_req_delay ;
	//
	// Outputs
	wire        out_packet_buffer_empty;
	wire [63:0] out_packet_data_out;
	//
	//parameter
	localparam NUM_INPUT_LOOP = 256;
	localparam NUM_READ_LOOP = 256;
	localparam NUM_FLOWS = 4;
	// localparam NUM_INPUT_LOOP = 500;
	// localparam NUM_READ_LOOP = 500;
	integer in_count;
	integer read_count;
	integer flow_id;
	reg [4:0] flow_id_count;
	integer count_flow [NUM_FLOWS-1:0];
	integer count_sum;
	integer count_sum_count;
	integer count_each_flow_idx;
	// Instantiate the Unit Under Test (UUT)
	WFQ_top uut (
		.clk                     (clk),
		.rst                     (rst),
		.in_packet_arrival       (in_packet_arrival),
		.in_data_arrival         (in_data_arrival),
		.in_packet_length        (in_packet_length),
		.in_packet_data          (in_packet_data),
		.in_flow_id              (in_flow_id),
		.in_rd_packet_req        (in_rd_packet_req),
		.out_packet_buffer_empty (out_packet_buffer_empty),
		.out_packet_data_out     (out_packet_data_out)
	);
	//
	initial begin: init
		// Initialize Inputs
		clk = 0;
		rst = 0;
		in_packet_arrival = 0;
		in_data_arrival = 0;
		in_packet_length = 0;
		in_flow_id = 0;
		in_rd_packet_req = 0;
		in_packet_data = 0;
		count_sum_count = 0;
		flow_id_count = 0;
		count_sum = 0;
		for(flow_id = 0; flow_id<NUM_FLOWS; flow_id = flow_id + 1) begin 
			count_flow[flow_id] = 0;
		end
		//
		// Wait 100 ns for global reset to finish
		#100;
		//
		// Add stimulus here
		#10 rst = 1;
		#10 rst = 0;
		#10;
		#10;
		#10;
		#10;
		#10;
		// rst lau lau ti de cac khoi initial hoat dong, nhu nay la du roi
		in_packet_length = 'd1;
		//
		//-------------------packet data in-------------------
		for(in_count = 0; in_count < NUM_INPUT_LOOP; in_count = in_count + 1) begin
			for(flow_id = 0; flow_id < NUM_FLOWS; flow_id = flow_id + 1) begin 
				in_packet_arrival = 1; in_data_arrival = 1; in_flow_id = flow_id; in_packet_data = flow_id; // trong so 0.75
				#10;
				in_packet_arrival = 0; in_data_arrival = 0; in_flow_id = 0;
				// #40;
				#(10 + 10*$unsigned($random())%5);
				// in_packet_arrival = 0; in_data_arrival = 1; in_flow_id = flow_id; in_packet_data = flow_id; // trong so 0.75
				// #10;
				// in_packet_arrival = 0; in_data_arrival = 0; in_flow_id = 0;
				// #40;
				// in_packet_arrival = 0; in_data_arrival = 1; in_flow_id = flow_id; in_packet_data = flow_id; // trong so 0.75
				// #10;
				// in_packet_arrival = 0; in_data_arrival = 0; in_flow_id = 0;
				// #40;
			end
		end
	end
	//--------------------------------------
	initial begin
		#3000;
		//
		//-------------------packet read-------------------
		for (read_count = 0; read_count < NUM_READ_LOOP; read_count=read_count+1) begin
			in_rd_packet_req = 1;
			#10;
			in_rd_packet_req = 0;
			#(30 + 10*$unsigned($random())%5); 
		end
		#500;
		for(count_sum_count = 0; count_sum_count < NUM_FLOWS; count_sum_count = count_sum_count + 1) begin 
			count_sum =count_sum + count_flow[count_sum_count];
		end
		$display("FLOW \t\t BYTES SERVED \t PERCENTAGE ");
		$display("------------------------------------------");

		// $display("flow 1:\t %d \t %f %%",count_flow1*8,count_flow1*100.0/count_sum);
		// $display("flow 2:\t %d \t %f %%",count_flow2*8,count_flow2*100.0/count_sum);
		// $display("flow 3:\t %d \t %f %%",count_flow3*8,count_flow3*100.0/count_sum);
		// $display("flow 4:\t %d \t %f %%",count_flow4*8,count_flow4*100.0/count_sum);
		for(flow_id_count = 0; flow_id_count < NUM_FLOWS; flow_id_count = flow_id_count + 1) begin 
			$display("flow %d: %d \t\t %f %%",flow_id_count, count_flow[flow_id_count]*8,count_flow[flow_id_count]*100.0/count_sum);
		end
		// #10 $finish;

	end
	// assign count_sum =  count_flow1+count_flow2+count_flow3+count_flow4;
	always begin
		#5 clk = ~clk;
	end

	//-------------------count read for each flows-------------------
	always @(posedge clk) begin
		in_rd_packet_req_delay <= {in_rd_packet_req_delay[9:0], in_rd_packet_req};

		if(in_rd_packet_req_delay[6] == 1) begin 
		// if(in_rd_packet_req) begin 
			for (count_each_flow_idx = 0; count_each_flow_idx < NUM_FLOWS; count_each_flow_idx = count_each_flow_idx + 1) begin 
				if(out_packet_data_out == count_each_flow_idx) begin 
					count_flow[count_each_flow_idx] = count_flow[count_each_flow_idx] + 1;
				end
			end
		end
	end
endmodule

