module finish_time #(
	parameter N = 16)
	(
		input clk, 
		input start,
		input flow_idle,
		input [N-1:0] packet_l,
		input [N-1:0] flow_w,
		input [N-1:0] vtime,
		input [N-4:0] flow_id,
		output reg [N-1:0] ftime,
		output reg done_ftime
    );

	reg [N-1:0] dividend, divisor;
	wire [N-1:0] quotient;
	reg we;
	reg [N-4:0] r_addr, w_addr;
	reg [N-1:0] din;
	wire [N-1:0] dout;
	reg done, start_b;
	reg start_b1, start_b7 , start_b13;
	reg start_b2, start_b8 , start_b14;
	reg start_b3, start_b9 , start_b15;
	reg start_b4, start_b10, start_b16;
	reg start_b5, start_b11, start_b17;
	reg start_b6, start_b12, start_b18, start_b19, start_b20, start_b21;
	reg [N-1:0] vtime_b1, vtime_b7 , vtime_b13;
	reg [N-1:0] vtime_b2, vtime_b8 , vtime_b14;
	reg [N-1:0] vtime_b3, vtime_b9 , vtime_b15;
	reg [N-1:0] vtime_b4, vtime_b10, vtime_b16;
	reg [N-1:0] vtime_b5, vtime_b11, vtime_b17;
	reg [N-1:0] vtime_b6, vtime_b12, vtime_b18, vtime_b19;
	reg [N-1:0] iadd1, iadd2, oadd, iadd1_b;
	reg [N-1:0] stime, stime_b;
	reg [N-1:0] vtime_b; // vtime_b1;
	reg we_b;
	reg [N-4:0] flow_id_bw, flow_id_br;
	reg [N-4:0] flow_id_b,  flow_id_b1, flow_id_b7 , flow_id_b13;
	reg [N-4:0] flow_id_b2, flow_id_b8 , flow_id_b14;
	reg [N-4:0] flow_id_b3, flow_id_b9 , flow_id_b15;
	reg [N-4:0] flow_id_b4, flow_id_b10, flow_id_b16;
	reg [N-4:0] flow_id_b5, flow_id_b11, flow_id_b17;
	reg [N-4:0] flow_id_b6, flow_id_b12, flow_id_b18, flow_id_b19, flow_id_b20;
	reg flow_idle_b,  flow_idle_b1, flow_idle_b7 , flow_idle_b13;
	reg flow_idle_b2, flow_idle_b8 , flow_idle_b14;
	reg flow_idle_b3, flow_idle_b9 , flow_idle_b15;
	reg flow_idle_b4, flow_idle_b10, flow_idle_b16;
	reg flow_idle_b5, flow_idle_b11, flow_idle_b17, flow_idle_b20;
	reg flow_idle_b6, flow_idle_b12, flow_idle_b18, flow_idle_b19;
	reg s;

	div_non_restore_pip uut (
		.clk      (clk),
		.dividend (dividend),
		.divisor  (divisor),
		.quotient (quotient)
	);
	block_ram_ftime #(.N(13)) md_bram (.clk(clk), .we(we), .w_addr(w_addr), .r_addr(r_addr), .din(din), .dout(dout));
	
	always @(posedge clk)
	begin
		start_b1 <= start;			start_b7  <= start_b6;			start_b13 <= start_b12;
		start_b2 <= start_b1;		start_b8  <= start_b7;			start_b14 <= start_b13;
		start_b3 <= start_b2;		start_b9  <= start_b8;			start_b15 <= start_b14;
		start_b4 <= start_b3;		start_b10 <= start_b9;			start_b16 <= start_b15;
		start_b5 <= start_b4;		start_b11 <= start_b10;			start_b17 <= start_b16;
		start_b6 <= start_b5;		start_b12 <= start_b11;			start_b18 <= start_b17;		
		start_b19 <= start_b18;		start_b20 <= start_b19;			start_b21 <= start_b20;
		start_b  <= start_b17;
		done <= start_b;
		//vtime_b1 <= vtime;			vtime_b <= vtime_b1;
		vtime_b1 <= vtime;			vtime_b7  <= vtime_b6;			vtime_b13 <= vtime_b12;
		vtime_b2 <= vtime_b1;		vtime_b8  <= vtime_b7;			vtime_b14 <= vtime_b13;
		vtime_b3 <= vtime_b2;		vtime_b9  <= vtime_b8;			vtime_b15 <= vtime_b14;
		vtime_b4 <= vtime_b3;		vtime_b10 <= vtime_b9;			vtime_b16 <= vtime_b15;
		vtime_b5 <= vtime_b4;		vtime_b11 <= vtime_b10;			vtime_b17 <= vtime_b16;
		vtime_b6 <= vtime_b5;		vtime_b12 <= vtime_b11;			vtime_b18 <= vtime_b17;			vtime_b19 <= vtime_b18;
		vtime_b  <= vtime_b18;
		flow_id_b1 <= flow_id;			flow_id_b7  <= flow_id_b6;			flow_id_b13 <= flow_id_b12;
		flow_id_b2 <= flow_id_b1;		flow_id_b8  <= flow_id_b7;			flow_id_b14 <= flow_id_b13;
		flow_id_b3 <= flow_id_b2;		flow_id_b9  <= flow_id_b8;			flow_id_b15 <= flow_id_b14;
		flow_id_b4 <= flow_id_b3;		flow_id_b10 <= flow_id_b9;			flow_id_b16 <= flow_id_b15;
		flow_id_b5 <= flow_id_b4;		flow_id_b11 <= flow_id_b10;			flow_id_b17 <= flow_id_b16;
		flow_id_b6 <= flow_id_b5;		flow_id_b12 <= flow_id_b11;			flow_id_b18 <= flow_id_b17;
		flow_id_b19 <= flow_id_b18;		flow_id_b20 <= flow_id_b19;
		flow_id_bw  <= flow_id_b18;
		flow_id_br <= flow_id_b16;
		flow_idle_b1  <= flow_idle;			flow_idle_b7  <= flow_idle_b6;			flow_idle_b13 <= flow_idle_b12;
		flow_idle_b2  <= flow_idle_b1;		flow_idle_b8  <= flow_idle_b7;			flow_idle_b14 <= flow_idle_b13;
		flow_idle_b3  <= flow_idle_b2;		flow_idle_b9  <= flow_idle_b8;			flow_idle_b15 <= flow_idle_b14;
		flow_idle_b4  <= flow_idle_b3;		flow_idle_b10 <= flow_idle_b9;			flow_idle_b16 <= flow_idle_b15;
		flow_idle_b5  <= flow_idle_b4;		flow_idle_b11 <= flow_idle_b10;			flow_idle_b17 <= flow_idle_b16;
		flow_idle_b6  <= flow_idle_b5;		flow_idle_b12 <= flow_idle_b11;			flow_idle_b18 <= flow_idle_b17;
		flow_idle_b19 <= flow_idle_b18;		flow_idle_b   <= flow_idle_b18;		
	end
	
	always @(posedge clk)
	begin
		if (start) begin
			dividend <= packet_l;
			divisor <= flow_w;
		end
		if (done) begin
			//iadd1 <= quotient;
			//iadd1_b <= quotient;
			if (s )
				if (!flow_idle_b)
					din <= din + quotient;
				else
					din <= quotient + ((flow_idle_b) ? vtime_b : ((vtime_b >= dout) ? vtime_b : dout));
			else
				din <= quotient + ((flow_idle_b) ? vtime_b : ((vtime_b >= dout) ? vtime_b : dout));
		end
		//oadd <= iadd1 + ((flow_idle_b) ? vtime_b : ((vtime_b >= dout) ? vtime_b : dout));
		//iadd2 <= (flow_idle_b) ? vtime_b : ((vtime_b >= dout) ? vtime_b : dout);
		//iadd1 <= iadd1_b;
		s <= (r_addr==w_addr)?1'b1:1'b0;
		we_b <= start_b18;
		we <= we_b;
		if (we_b) begin
			w_addr <= flow_id_bw;
			//din <= oadd;
			//din <= iadd1 + iadd2;
			//ftime <= oadd;
		end
		//else begin
		r_addr <= flow_id_br;
		//end
		done_ftime <= start_b20;
		ftime <= din;
	end
endmodule