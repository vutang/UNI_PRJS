module wfq_computation #(
	parameter N = 16)
	(
		input clk,
		input rst,
		input arrival,
		input depart,
		input [N-1:0] packet_length,
		input [N-4:0] flow_id,
		output reg [N-1:0] oftime,
		output reg odone
	);
	// sum_weight block
	wire [N-1:0] sum_w, flow_w, delta_t;
	wire flow_idle;

	// virtual_time block
	reg vstart;
	reg [N-1:0] delta_t_b;
	reg [N-1:0] sum_weight_b;
	wire [N-1:0] vtime;
	
	// finish_time block
	reg fstart;
	reg flow_idle_b;
	reg [N-1:0] packet_l_b;
	reg [N-1:0] flow_w_b;
	reg [N-1:0] vtime_b;
	reg [N-4:0] flow_id_b;
	wire [N-1:0] ftime;
	wire done_ftime;
	
	reg vstart_b1, vstart_b2, vstart_b3, vstart_b4;
		
	reg fstart_b1, fstart_b7 , fstart_b13, fstart_b19;
	reg fstart_b2, fstart_b8 , fstart_b14, fstart_b20;
	reg fstart_b3, fstart_b9 , fstart_b15, fstart_b21;
	reg fstart_b4, fstart_b10, fstart_b16, fstart_b22, fstart_b27;
	reg fstart_b5, fstart_b11, fstart_b17, fstart_b23, fstart_b25;
	reg fstart_b6, fstart_b12, fstart_b18, fstart_b24, fstart_b26;
		
	reg [N-1:0]	packet_l_b1, packet_l_b7 , packet_l_b13, packet_l_b19;
	reg [N-1:0]	packet_l_b2, packet_l_b8 , packet_l_b14, packet_l_b20;
	reg [N-1:0]	packet_l_b3, packet_l_b9 , packet_l_b15, packet_l_b21;
	reg [N-1:0]	packet_l_b4, packet_l_b10, packet_l_b16, packet_l_b22, packet_l_b27;
	reg [N-1:0]	packet_l_b5, packet_l_b11, packet_l_b17, packet_l_b23, packet_l_b25;
	reg [N-1:0]	packet_l_b6, packet_l_b12, packet_l_b18, packet_l_b24, packet_l_b26;
		
	reg [N-1:0]	flow_w_b1, flow_w_b7 , flow_w_b13, flow_w_b19;
	reg [N-1:0]	flow_w_b2, flow_w_b8 , flow_w_b14, flow_w_b20;
	reg [N-1:0]	flow_w_b3, flow_w_b9 , flow_w_b15, flow_w_b21;
	reg [N-1:0]	flow_w_b4, flow_w_b10, flow_w_b16, flow_w_b22;
	reg [N-1:0]	flow_w_b5, flow_w_b11, flow_w_b17, flow_w_b23;
	reg [N-1:0]	flow_w_b6, flow_w_b12, flow_w_b18, flow_w_b24;
	
	reg flow_idle_b1, flow_idle_b7 , flow_idle_b13, flow_idle_b19;
	reg flow_idle_b2, flow_idle_b8 , flow_idle_b14, flow_idle_b20;
	reg flow_idle_b3, flow_idle_b9 , flow_idle_b15, flow_idle_b21;
	reg flow_idle_b4, flow_idle_b10, flow_idle_b16, flow_idle_b22;
	reg flow_idle_b5, flow_idle_b11, flow_idle_b17, flow_idle_b23;
	reg flow_idle_b6, flow_idle_b12, flow_idle_b18, flow_idle_b24;
		
	reg [N-4:0]	flow_id_b1, flow_id_b7 , flow_id_b13, flow_id_b19;
	reg [N-4:0]	flow_id_b2, flow_id_b8 , flow_id_b14, flow_id_b20;
	reg [N-4:0]	flow_id_b3, flow_id_b9 , flow_id_b15, flow_id_b21;
	reg [N-4:0]	flow_id_b4, flow_id_b10, flow_id_b16, flow_id_b22, flow_id_b27;
	reg [N-4:0]	flow_id_b5, flow_id_b11, flow_id_b17, flow_id_b23, flow_id_b25;
	reg [N-4:0]	flow_id_b6, flow_id_b12, flow_id_b18, flow_id_b24, flow_id_b26;
	
	sum_weight #(N) md_sum_weight (
		.clk     (clk),
		.rst	 (rst),
		.arrival (arrival),
		.depart  (depart),
		.flow_id (flow_id),
		.sum_w   (sum_w),
		.flow_w  (flow_w),
		.delta_t (delta_t),
		.flow_idle(flow_idle)
		);
	virtual_time #(N) md_virtual_time (
		.clk        (clk),
		.rst		(rst),
		.start      (vstart),
		.delta_t    (delta_t_b),
		.sum_weight (sum_weight_b),
		.ovtime     (vtime)
		);
	finish_time #(N) md_finish_time (
		.clk        (clk),
		.flow_idle  (flow_idle_b),
		.start      (fstart),
		.packet_l   (packet_l_b),
		.flow_w     (flow_w_b),
		.vtime      (vtime_b),
		.flow_id    (flow_id_b),
		.ftime      (ftime),
		.done_ftime (done_ftime)
		);
	
	always @(posedge clk) begin
		vstart_b1 <= arrival | depart;
		vstart_b2 <= vstart_b1;
		vstart_b3 <= vstart_b2;
		vstart_b4 <= vstart_b3;
		
		fstart_b1 <= arrival;			fstart_b7 <= fstart_b6;			fstart_b13 <= fstart_b12;		fstart_b19 <= fstart_b18;
		fstart_b2 <= fstart_b1;			fstart_b8 <= fstart_b7;			fstart_b14 <= fstart_b13;		fstart_b20 <= fstart_b19;
		fstart_b3 <= fstart_b2;			fstart_b9 <= fstart_b8;			fstart_b15 <= fstart_b14;		fstart_b21 <= fstart_b20;
		fstart_b4 <= fstart_b3;			fstart_b10 <= fstart_b9;		fstart_b16 <= fstart_b15;		fstart_b22 <= fstart_b21;
		fstart_b5 <= fstart_b4;			fstart_b11 <= fstart_b10;		fstart_b17 <= fstart_b16;		fstart_b23 <= fstart_b22;
		fstart_b6 <= fstart_b5;			fstart_b12 <= fstart_b11;		fstart_b18 <= fstart_b17;		fstart_b24 <= fstart_b23;
		fstart_b25 <= fstart_b24;		fstart_b26 <= fstart_b25;		fstart_b27 <= fstart_b26;
		
		packet_l_b1 <= packet_length;	packet_l_b7  <= packet_l_b6;	packet_l_b13 <= packet_l_b12;	packet_l_b19 <= packet_l_b18;
		packet_l_b2 <= packet_l_b1;		packet_l_b8  <= packet_l_b7;	packet_l_b14 <= packet_l_b13;	packet_l_b20 <= packet_l_b19;
		packet_l_b3 <= packet_l_b2;		packet_l_b9  <= packet_l_b8;	packet_l_b15 <= packet_l_b14;	packet_l_b21 <= packet_l_b20;
		packet_l_b4 <= packet_l_b3;		packet_l_b10 <= packet_l_b9;	packet_l_b16 <= packet_l_b15;	packet_l_b22 <= packet_l_b21;
		packet_l_b5 <= packet_l_b4;		packet_l_b11 <= packet_l_b10;	packet_l_b17 <= packet_l_b16;	packet_l_b23 <= packet_l_b22;
		packet_l_b6 <= packet_l_b5;		packet_l_b12 <= packet_l_b11;	packet_l_b18 <= packet_l_b17;	packet_l_b24 <= packet_l_b23;
		packet_l_b25 <= packet_l_b24;	packet_l_b26 <= packet_l_b25;	packet_l_b27 <= packet_l_b26;
		
		flow_w_b1 <= flow_w;		    flow_w_b7  <= flow_w_b6;		flow_w_b13 <= flow_w_b12;		flow_w_b19 <= flow_w_b18;
		flow_w_b2 <= flow_w_b1;			flow_w_b8  <= flow_w_b7;		flow_w_b14 <= flow_w_b13;		flow_w_b20 <= flow_w_b19;
		flow_w_b3 <= flow_w_b2;			flow_w_b9  <= flow_w_b8;		flow_w_b15 <= flow_w_b14;		flow_w_b21 <= flow_w_b20;
		flow_w_b4 <= flow_w_b3;			flow_w_b10 <= flow_w_b9;		flow_w_b16 <= flow_w_b15;		flow_w_b22 <= flow_w_b21;
		flow_w_b5 <= flow_w_b4;			flow_w_b11 <= flow_w_b10;		flow_w_b17 <= flow_w_b16;		flow_w_b23 <= flow_w_b22;
		flow_w_b6 <= flow_w_b5;			flow_w_b12 <= flow_w_b11;		flow_w_b18 <= flow_w_b17;		//flow_w_b24 <= flow_w_b23;
		
		flow_idle_b1 <= flow_idle;		flow_idle_b7  <= flow_idle_b6;	flow_idle_b13 <= flow_idle_b12;	flow_idle_b19 <= flow_idle_b18;
		flow_idle_b2 <= flow_idle_b1;	flow_idle_b8  <= flow_idle_b7;	flow_idle_b14 <= flow_idle_b13;	flow_idle_b20 <= flow_idle_b19;
		flow_idle_b3 <= flow_idle_b2;	flow_idle_b9  <= flow_idle_b8;	flow_idle_b15 <= flow_idle_b14;	flow_idle_b21 <= flow_idle_b20;
		flow_idle_b4 <= flow_idle_b3;	flow_idle_b10 <= flow_idle_b9;	flow_idle_b16 <= flow_idle_b15;	flow_idle_b22 <= flow_idle_b21;
		flow_idle_b5 <= flow_idle_b4;	flow_idle_b11 <= flow_idle_b10;	flow_idle_b17 <= flow_idle_b16;	flow_idle_b23 <= flow_idle_b22;
		flow_idle_b6 <= flow_idle_b5;	flow_idle_b12 <= flow_idle_b11;	flow_idle_b18 <= flow_idle_b17;
		
		flow_id_b1 <= flow_id;		    flow_id_b7  <= flow_id_b6;		flow_id_b13 <= flow_id_b12;		flow_id_b19 <= flow_id_b18;
		flow_id_b2 <= flow_id_b1;		flow_id_b8  <= flow_id_b7;		flow_id_b14 <= flow_id_b13;		flow_id_b20 <= flow_id_b19;
		flow_id_b3 <= flow_id_b2;		flow_id_b9  <= flow_id_b8;		flow_id_b15 <= flow_id_b14;		flow_id_b21 <= flow_id_b20;
		flow_id_b4 <= flow_id_b3;		flow_id_b10 <= flow_id_b9;		flow_id_b16 <= flow_id_b15;		flow_id_b22 <= flow_id_b21;
		flow_id_b5 <= flow_id_b4;		flow_id_b11 <= flow_id_b10;		flow_id_b17 <= flow_id_b16;		flow_id_b23 <= flow_id_b22;
		flow_id_b6 <= flow_id_b5;		flow_id_b12 <= flow_id_b11;		flow_id_b18 <= flow_id_b17;		flow_id_b24 <= flow_id_b23;
		flow_id_b25 <= flow_id_b24;		flow_id_b26 <= flow_id_b25;		flow_id_b27 <= flow_id_b26;
	end
	always @(posedge clk) begin
		vstart <= vstart_b4;
		delta_t_b <= delta_t;
		sum_weight_b <= sum_w;
		
		fstart <= fstart_b27;
		packet_l_b <= packet_l_b27;
		flow_w_b <= flow_w_b23;
		flow_idle_b <= flow_idle_b23;
		vtime_b <= vtime;
		flow_id_b <= flow_id_b27;
		oftime <= ftime;
		odone <= done_ftime; 
	end 
endmodule