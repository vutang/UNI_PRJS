module sum_weight #(
	parameter N = 16)
	(
		input clk,
		input rst,
		input arrival, depart,
		input [N-4:0] flow_id,
		output reg [N-1:0] sum_w,
		output reg [N-1:0] flow_w,
		output reg [N-1:0] delta_t,
		output reg flow_idle
	);
	
	reg we1, we2, we1_b;
	reg s; // chi ra khi co dia chi doc va ghi giong nhau.
	reg arrival_b, arrival_we, arrival_b1, arrival_b2;
	reg [N-4:0] w_addr=0, r_addr, addr2;
	reg [N-9:0] din1;
	reg [N-1:0] din2;
	wire [N-9:0] dout1;
	wire [N-1:0] dout2;
	reg [N-9:0] dout1_b;
	reg [N-1:0] sum_w_tmp = 0;
	reg [N-4:0] flow_id_b, flow_id_b1, flow_id_b2, flow_id_b3;
	reg depart_b, depart_b1, depart_b2, we1_de;
	reg [N-1:0] flow_w_b;

	reg [N-1:0] count, cnt;
	reg ena;
	reg [N-1:0] delta_t_b, delta_t_b1;
	reg flow_idle_b1, flow_idle_b2, flow_idle_b;
	
	block_ram_count  #(.N(13)) ram_count  (.clk(clk), .we(we1), .w_addr(w_addr), .r_addr(r_addr), .din(din1), .dout(dout1));
	block_ram_weight #(.N(13)) ram_flow_w (.clk(clk), .we(1'b0), .addr(addr2), .din(din2), .dout(dout2));
	
	always @(posedge clk)
	begin
		if (rst) begin
			sum_w_tmp <= 0;
			cnt <= 0;
			flow_id_b <= 0;
		end
		else begin
		// ---------------- 
			ena <= arrival | depart;
			if (ena) begin
				count <= cnt;
				cnt <= 1;
			end
			else begin
				cnt <= cnt + 1;
			end
		// ----------------
			arrival_b1 <= arrival;		arrival_b <= arrival_b1;		//arrival_b <= arrival_b2;
			flow_id_b1 <= flow_id;		flow_id_b <= flow_id_b1;		//flow_id_b3 <= flow_id_b2;		flow_id_b <= flow_id_b3;

			depart_b1 <= depart;		depart_b <= depart_b1;			//depart_b <= depart_b2;
			delta_t_b <= count;		//delta_t_b <= delta_t_b1;	
		// -----------------
			flow_idle_b <= (arrival_b && (dout1 == 0) && s!=1) ? 1 : 0;
			if (arrival_b)
				if (s)
					if (din1==0)
						flow_idle_b <= 1;
					else
						flow_idle_b <= 0;
				else 
					if (dout1==0)
						flow_idle_b <= 1;
					else
						flow_idle_b <= 0;
			else
				flow_idle_b <= 0;
				
			flow_idle <= flow_idle_b;
			
			addr2 <= flow_id;
			
			if (arrival_b && dout1==0) begin
				//if (!s)
					//if (dout1==0)
						sum_w_tmp <= sum_w_tmp + dout2;
			end
			if (arrival_b && s) begin
				//else
					if (din1==0)
						sum_w_tmp <= sum_w_tmp + dout2;
					if (dout1==0)
						sum_w_tmp <= sum_w_tmp;
			end
			we1_b <= arrival_b1;
			we1_de <= depart_b1;
			we1 <= we1_b | we1_de;
			if (we1_b) begin
				if (s) 
					din1 <= din1 + 1;
				else
					din1 <= dout1 + 1;
				w_addr <= flow_id_b;
			end
			r_addr <= flow_id;
			s <= (r_addr==w_addr && r_addr!=0 && w_addr!=0)? 1'b1 : 1'b0;
			
			if (depart_b ) begin
				if (dout1==1)
					sum_w_tmp <= sum_w_tmp - dout2;
				else 
					if (s && din1==1)
						sum_w_tmp <= sum_w_tmp - dout2;
			end
			if (we1_de) begin
				if (s)
					din1 <= din1 - 1;
				else
					din1 <= dout1 - 1;
				w_addr <= flow_id_b;
			end
			if (arrival_b) begin
				flow_w_b <= dout2;
			end
			sum_w <= sum_w_tmp;
			flow_w <= flow_w_b;
			delta_t <= delta_t_b;
		end
	end 
endmodule