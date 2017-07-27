module Multibit_Tree
#(
	parameter T = 12
)
(
	input wire				clk, rst,				// clock and reset signals
	input wire 				ena,
	input wire	[T-1:0]		incoming_tag, 
	output wire	[T-1:0] 	matching_tag,
	output wire	[T-1:0] 	incoming_tag_forward
);

	// Internal signals
	// st 1
	wire 	[T-1:0]		incoming_tag_from_input_reg;
	wire 	[15:0] 		do_mem_1;
	wire 	[T-1:0] 	incoming_tag_from_mem_1;
	wire 	[3:0] 		incoming_tag_for_bak_1;
	wire 	[3:0] 		incoming_tag_for_bak_2;

	wire 	[3:0] 		incoming_tag_for_bak_1_from_st_1;
	wire 	[3:0] 		incoming_tag_for_bak_2_from_st_1;

	// st 2
	wire 	[3:0]		matching_tag_1_from_matcher_st_2;
	wire 	[3:0]		matching_tag_1_from_matcher_bak_st_2;
	wire 	[3:0] 		matching_tag_1_from_st_2;
	wire 	[3:0]		matching_tag_1_bak_from_st_2;
	wire	[15:0]		do_1_mem_2;
	wire 	[15:0] 		do_2_mem_2;
	wire 	[11:0] 		incoming_tag_from_st_2;
	wire 	[3:0] 		incoming_tag_for_bak_2_from_st_2;

	// st 3
	wire 	[T-1:0] 	incoming_tag_from_st_3;
	wire 	[3:0] 		matching_tag_1_from_st_3;
	wire 	[3:0] 		matching_tag_1_bak_from_st_3;
	wire 	[15:0] 		do_1_mem_3;
	wire 	[15:0] 		do_2_mem_3;
	wire 	[3:0] 		incoming_tag_for_bak_2_from_st_3;

	// st 4
	wire 	[3:0] 		matching_tag_2_from_matcher_st_4;
	wire 	[3:0] 		matching_tag_2_from_matcher_bak_1_st_4;
	wire 	[3:0] 		matching_tag_2_from_matcher_bak_2_st_4;
	wire 	[3:0]		matching_tag_2_from_st_4;
	wire 	[3:0]		matching_tag_2_bak_1_from_st_4;
	wire 	[3:0]		matching_tag_2_bak_2_from_st_4;
	wire 	[3:0] 		matching_tag_1_from_st_4;
	wire 				not_found_from_matcher_bak_1_st_4;
	wire 				not_found_bak_1_from_st_4;
	wire 	[3:0] 		matching_tag_1_bak_from_st_4;
	wire 	[11:0]		incoming_tag_from_st_4;

	// st 5	
	wire 	[T-1:0]		incoming_tag_from_st_5;
	wire 	[7:0]		matching_tag_1_2_from_st_5;
	wire 	[7:0] 		matching_tag_1_2_bak_from_st_5;
	wire 	[7:0] 		node_addr_1_mem_3; 
	wire 	[7:0]		node_addr_2_mem_3;
	wire 	[7:0] 		matching_tag_bak_from_st_2_4;
	reg 	[7:0] 		update_node_addr_mem_3;

	// st 6
	wire 	[3:0] 		matching_tag_from_matcher_st_6;
	wire 				not_found_from_matcher_st_6;
	wire 	[3:0] 		matching_tag_from_matcher_bak_st_6;
	wire 	[11:0] 		matching_tag_combination;

	// ==================================================================
	// --------------     St_1_reg -----------------------------------
	// ==================================================================
	wire ena_foward_from_input_reg;
	Input_Reg St_1_Reg_Input (
				.clk (clk), .rst	(rst), .ena (ena),
		 		.incoming_tag_in 			(incoming_tag), 
		 		.incoming_tag_out 			(incoming_tag_from_input_reg),
		 		.ena_foward 				(ena_foward_from_input_reg)
		 	);	

	assign incoming_tag_for_bak_1 = (incoming_tag_from_input_reg[11:8] != 0) 	? 
									(incoming_tag_from_input_reg[11:8] - 4'b1) 	: 0;
	assign incoming_tag_for_bak_2 = (incoming_tag_from_input_reg[7:4] != 0) 	?
									(incoming_tag_from_input_reg[7:4] - 4'b1) 	: 0;

	reg [15:0] data_in_for_mem_1;
 	reg [15:0] data_in_for_mem_1_buf;

	Mem_Layer_1 St_1_CR 
				(
					.clk (clk), .rst (rst), .ena (ena),
			 		.data_out 					(do_mem_1),
			 		.collision					(incoming_tag_from_mem_1[11:8] == incoming_tag_from_input_reg[11:8]),
			 		.data_in 			 		(data_in_for_mem_1_buf)
 			 	);

 		always @(incoming_tag_from_input_reg[11:8]) begin
		case (incoming_tag_from_input_reg[11:8])
			4'd0:  	data_in_for_mem_1 <= 16'h0001;
			4'd1: 	data_in_for_mem_1 <= 16'h0002;
			4'd2: 	data_in_for_mem_1 <= 16'h0004;
			4'd3: 	data_in_for_mem_1 <= 16'h0008;
			4'd4: 	data_in_for_mem_1 <= 16'h0010;
			4'd5: 	data_in_for_mem_1 <= 16'h0020;
			4'd6: 	data_in_for_mem_1 <= 16'h0040;
			4'd7: 	data_in_for_mem_1 <= 16'h0080;
			4'd8: 	data_in_for_mem_1 <= 16'h0100;
			4'd9: 	data_in_for_mem_1 <= 16'h0200;
			4'd10: 	data_in_for_mem_1 <= 16'h0400;
			4'd11: 	data_in_for_mem_1 <= 16'h0800;
			4'd12: 	data_in_for_mem_1 <= 16'h1000;
			4'd13: 	data_in_for_mem_1 <= 16'h2000;
			4'd14: 	data_in_for_mem_1 <= 16'h4000;
			4'd15: 	data_in_for_mem_1 <= 16'h8000;
			default: data_in_for_mem_1 <= 0;
		endcase
	end

	reg ena_foward_from_s_1;
	always @(posedge clk) begin
		if (rst) begin
			data_in_for_mem_1_buf <= 0;
			ena_foward_from_s_1 <= 0;
		end
		else if (ena) begin
			data_in_for_mem_1_buf <= data_in_for_mem_1;
			ena_foward_from_s_1 <= ena_foward_from_input_reg;
		end
		// else  else 
	end

 	Stage_1_Reg St_1_R
 				(
 					.clk (clk), .rst (rst), .ena (ena),
 					// forwarding signals
 			 		.incoming_tag_forward_in 	(incoming_tag_from_input_reg),
 			 		.incoming_tag_forward_out 	(incoming_tag_from_mem_1),

 			 		.incoming_tag_for_bak_1_in	(incoming_tag_for_bak_1),
 			 		.incoming_tag_for_bak_1_out	(incoming_tag_for_bak_1_from_st_1),

 			 		.incoming_tag_for_bak_2_in	(incoming_tag_for_bak_2),
 			 		.incoming_tag_for_bak_2_out	(incoming_tag_for_bak_2_from_st_1)
 				);

	// ======================================================================
	// -------------- St 2 Matcher Layer 1--------------------------------
	// ======================================================================
	Matcher_16bit St_2_Matcher (
				.d 							(incoming_tag_from_mem_1[11:8]), 
				.m 							(do_mem_1), 
				.n 							(matching_tag_1_from_matcher_st_2), 
				.r_out 						(), .not_found 					()
			);
 	
 	Matcher_16bit St_2_Matcher_Bak (
				.d 							(incoming_tag_for_bak_1_from_st_1),
				.m 							(do_mem_1),
				.n 							(matching_tag_1_from_matcher_bak_st_2),
				.r_out						(),	.not_found()
			);
 	reg n_equal_inc_mat_tag_1_from_st_2;
 	reg ena_foward_from_s_2;
 	
 	always @(posedge clk) begin
 		if (rst) begin
 			ena_foward_from_s_2 <= 0;
 			n_equal_inc_mat_tag_1_from_st_2 <= 0;
 		end
 		else if (ena) begin
 			ena_foward_from_s_2 <= ena_foward_from_s_1;
 			n_equal_inc_mat_tag_1_from_st_2 <= (matching_tag_1_from_matcher_st_2 != incoming_tag_from_mem_1[11:8]);
 		end
 	end

	Stage_2_Reg St_2_R (
				.clk(clk), .rst(rst), .ena(ena),
				// forward signals
				.matching_tag_stage_2_in 	(matching_tag_1_from_matcher_st_2), 
				.matching_tag_stage_2_out 	(matching_tag_1_from_st_2),

				.matching_tag_bak_stage_2_in(matching_tag_1_from_matcher_bak_st_2),
				.matching_tag_bak_stage_2_out(matching_tag_1_bak_from_st_2),

				.incoming_tag_forward_in 	(incoming_tag_from_mem_1),
				.incoming_tag_forward_out 	(incoming_tag_from_st_2),

				.incoming_tag_for_bak_2_in	(incoming_tag_for_bak_2_from_st_1),
				.incoming_tag_for_bak_2_out	(incoming_tag_for_bak_2_from_st_2)
			);

	// ==================================================================
	// ------------- Stage 3 MEM Layer 2---------------------------------
	// ==================================================================

	wire [15:0] mask_mem_2_from_state_3;
	reg ena_foward_from_s_3;

	Mem_Layer_2 St_3_CR (
				.clk (clk), .rst (rst), .ena (ena),			
				.ena_foward 				(ena_foward_from_s_3),		
				// read data
				//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				// .node_address_1 			(incoming_tag_from_st_2[7:4]),
				.node_address_1 			(matching_tag_1_from_st_2),
				.data_out_1 				(do_1_mem_2), 
				.node_address_2 			(matching_tag_1_bak_from_st_2), 				
				.data_out_2 				(do_2_mem_2),
				
				.update_node_addr			(incoming_tag_from_st_3[11:8]),
				.update_node_data			(mask_mem_2_from_state_3)
				);

 	reg [15:0] mask_mem_2 = 16'h0000;

	always @(incoming_tag_from_st_2[7:4])
		case (incoming_tag_from_st_2[7:4])
			4'd0:  	mask_mem_2 <= 16'h0001; 4'd1: 	mask_mem_2 <= 16'h0002;
			4'd2: 	mask_mem_2 <= 16'h0004;	4'd3: 	mask_mem_2 <= 16'h0008;
			4'd4: 	mask_mem_2 <= 16'h0010;	4'd5: 	mask_mem_2 <= 16'h0020;
			4'd6: 	mask_mem_2 <= 16'h0040;	4'd7: 	mask_mem_2 <= 16'h0080;
			4'd8: 	mask_mem_2 <= 16'h0100;	4'd9: 	mask_mem_2 <= 16'h0200;
			4'd10: 	mask_mem_2 <= 16'h0400;	4'd11: 	mask_mem_2 <= 16'h0800;
			4'd12: 	mask_mem_2 <= 16'h1000;	4'd13: 	mask_mem_2 <= 16'h2000;
			4'd14: 	mask_mem_2 <= 16'h4000;	4'd15: 	mask_mem_2 <= 16'h8000;
			default: mask_mem_2 <= 0;
		endcase

	reg n_equal_inc_mat_tag_1_from_st_3;
 	always @(posedge clk) begin
 		if (rst) begin
 			ena_foward_from_s_3 <= 0;
 			n_equal_inc_mat_tag_1_from_st_3 <= 0;
 		end
 		else if (ena) begin
 			ena_foward_from_s_3 <= ena_foward_from_s_2;
 			n_equal_inc_mat_tag_1_from_st_3 <= n_equal_inc_mat_tag_1_from_st_2;
 		end
 	end

 	Stage_3_Reg St_3_R (
				.clk (clk),	.rst (rst), .ena (ena),
				// forward data
				.matching_tag_forward_in 	(matching_tag_1_from_st_2),
				.matching_tag_forward_out 	(matching_tag_1_from_st_3),

				.matching_tag_bak_forward_in(matching_tag_1_bak_from_st_2),
				.matching_tag_bak_forward_out(matching_tag_1_bak_from_st_3),

				.incoming_tag_forward_in 	(incoming_tag_from_st_2),
				.incoming_tag_forward_out 	(incoming_tag_from_st_3),

				.mask_mem_2_in 				(mask_mem_2),
				.mask_mem_2_out				(mask_mem_2_from_state_3),

				.incoming_tag_for_bak_2_in	(incoming_tag_for_bak_2_from_st_2),
				.incoming_tag_for_bak_2_out	(incoming_tag_for_bak_2_from_st_3)
			);

 	// ===================================================================
	// ------------- Stage 4 ---------------------------------------------
	// ===================================================================
	wire not_found_from_matcher_st_4;
	wire [3:0] data_in_for_matcher_st_4;
	assign data_in_for_matcher_st_4 = (n_equal_inc_mat_tag_1_from_st_3)? 4'd15 : incoming_tag_from_st_3[7:4];
	Matcher_16bit St_4_Matcher(
				.d 							(data_in_for_matcher_st_4), 
				.m 							(do_1_mem_2),
	 			.n 							(matching_tag_2_from_matcher_st_4), 
	 			.r_out 						(), 
	 			.not_found 					(not_found_from_matcher_st_4)
	 		);

	wire not_found_from_matcher_bak_1_st_4_tmp;
	Matcher_16bit St_4_Matcher_Bak_1(
				.d 							(incoming_tag_for_bak_2_from_st_3),
				.m 							(do_1_mem_2),
				.n 							(matching_tag_2_from_matcher_bak_1_st_4),
				.r_out						(),
				.not_found					(not_found_from_matcher_bak_1_st_4_tmp)
			);
	
	// assign not_found_from_matcher_bak_1_st_4 = ((incoming_tag_for_bak_2_from_st_3 == 0) & 
	// 												(incoming_tag_from_st_3[7:4] == 0)) ? 1 
	// 										: (not_found_from_matcher_bak_1_st_4_tmp | not_found_from_matcher_st_4);	

	assign not_found_from_matcher_bak_1_st_4 = (not_found_from_matcher_bak_1_st_4_tmp | not_found_from_matcher_st_4);
	// Matcher Backup 2
	Matcher_16bit St_4_Matcher_Bak_2	(
				.d 							(4'd15),
				.m 							(do_2_mem_2),
				.n 							(matching_tag_2_from_matcher_bak_2_st_4),
				.r_out						(),
				.not_found 					()
			);
	
	reg n_equal_inc_mat_tag_1_from_st_4;
	always @(posedge clk) begin
		if (rst) begin
			n_equal_inc_mat_tag_1_from_st_4 <= 0;
		end
		else if (ena) begin
			n_equal_inc_mat_tag_1_from_st_4 <= n_equal_inc_mat_tag_1_from_st_3;
		end
	end

	Stage_4_Reg	St_4_R	(
				.clk						(clk), 
				.rst						(rst),
				.ena 						(ena),

	 			.matching_tag_stage_4_in 	(matching_tag_2_from_matcher_st_4), 
	 			.matching_tag_stage_4_out 	(matching_tag_2_from_st_4),

	 			// back up path signals
	 			.matching_tag_bak_1_stage_4_in(matching_tag_2_from_matcher_bak_1_st_4),
	 			.matching_tag_bak_1_stage_4_out(matching_tag_2_bak_1_from_st_4),

	 			.matching_tag_bak_2_stage_4_in(matching_tag_2_from_matcher_bak_2_st_4),
	 			.matching_tag_bak_2_stage_4_out(matching_tag_2_bak_2_from_st_4),
	 			// not found bak 1 signals
	 			.not_found_signal_in		(not_found_from_matcher_bak_1_st_4),
	 			.not_found_signal_out		(not_found_bak_1_from_st_4),
	 			// forwarding signals
	 			.incoming_tag_forward_in 	(incoming_tag_from_st_3),
	 			.incoming_tag_forward_out 	(incoming_tag_from_st_4),

	 			.matching_tag_forward_in 	(matching_tag_1_from_st_3),
	 			.matching_tag_forward_out 	(matching_tag_1_from_st_4),

	 			.matching_tag_1_bak_in 		(matching_tag_1_bak_from_st_3),
	 			.matching_tag_1_bak_out		(matching_tag_1_bak_from_st_4)
	 		);

	// =======================================================
	// ------------ Stage 5 Buffer----------------------------
	// =======================================================

	reg [11:0] 	incoming_tag_from_st_5_buf;
	reg [7:0] 	matching_tag_1_2_from_st_5_buf;
	reg [7:0] 	matching_tag_1_2_bak_from_st_5_buf;
	reg [7:0] 	node_addr_1_mem_3_buf;
	reg [7:0] 	node_addr_2_mem_3_buf;
	wire [7:0] 	update_node_addr_mem_3_buf;
	reg [15:0] 	update_node_data_mem_3_buf;

	wire [4:0] 	data_for_matcher_st_6_st_5;
	reg [4:0] 	data_for_matcher_st_6_st_5_buf;
	reg 		n_equal_inc_mat_tag_1_from_st_5_buf;

	// ????????????????????????????????????????????
	// assign 		node_addr_1_mem_3 = incoming_tag_from_st_4[11:8] * 16 
											// + incoming_tag_from_st_4[7:4];
	assign 		node_addr_1_mem_3 = matching_tag_1_from_st_4 * 16 
											+ matching_tag_2_from_st_4;

	assign node_addr_2_mem_3 = (~not_found_bak_1_from_st_4) ?
			(matching_tag_1_from_st_4 * 16 + matching_tag_2_bak_1_from_st_4) :
			(matching_tag_1_bak_from_st_4 * 16 + matching_tag_2_bak_2_from_st_4);

	assign data_for_matcher_st_6_st_5 = (matching_tag_2_from_st_4 == incoming_tag_from_st_4[7:4]) ?
									incoming_tag_from_st_4[3:0] : 4'd15; 

	assign matching_tag_bak_from_st_2_4 = (~not_found_bak_1_from_st_4) ?
				{matching_tag_1_from_st_4, matching_tag_2_bak_1_from_st_4} :
				{matching_tag_1_bak_from_st_4, matching_tag_2_bak_2_from_st_4};
	
	always @(posedge clk) begin
		if (rst) begin
			incoming_tag_from_st_5_buf <=	12'b0;
			matching_tag_1_2_from_st_5_buf <= 8'b0;
			matching_tag_1_2_bak_from_st_5_buf <= 8'b0;
			node_addr_1_mem_3_buf <= 8'b0;
			node_addr_2_mem_3_buf <= 8'b0;
			data_for_matcher_st_6_st_5_buf <= 4'b0;
			n_equal_inc_mat_tag_1_from_st_5_buf <= 0;
		end
		else begin
			if (ena) begin
				incoming_tag_from_st_5_buf <= incoming_tag_from_st_4;
				matching_tag_1_2_from_st_5_buf <= {matching_tag_1_from_st_4, matching_tag_2_from_st_4};
				matching_tag_1_2_bak_from_st_5_buf <= matching_tag_bak_from_st_2_4;
				node_addr_1_mem_3_buf <= node_addr_1_mem_3;
				node_addr_2_mem_3_buf <= node_addr_2_mem_3;
				data_for_matcher_st_6_st_5_buf <= data_for_matcher_st_6_st_5;	
				n_equal_inc_mat_tag_1_from_st_5_buf <= n_equal_inc_mat_tag_1_from_st_4;
			end			
		end
	end
	// =======================================================
	// ============= Stage 5 =================================
	// =======================================================

	reg [3:0] data_for_matcher_st_6_st_5_out;
	assign update_node_addr_mem_3_buf = incoming_tag_from_st_5_buf[11:8] * 16 
									+ incoming_tag_from_st_5_buf[7:4];

	reg [15:0] mask, mask_buf;

	always @(incoming_tag_from_st_5_buf[3:0]) begin
		case (incoming_tag_from_st_5_buf[3:0])
			4'd0: 	mask <= 16'h0001; 4'd1: 	mask <= 16'h0002;
			4'd2: 	mask <= 16'h0004; 4'd3: 	mask <= 16'h0008;
			4'd4: 	mask <= 16'h0010; 4'd5: 	mask <= 16'h0020;
			4'd6: 	mask <= 16'h0040; 4'd7: 	mask <= 16'h0080;
			4'd8: 	mask <= 16'h0100; 4'd9: 	mask <= 16'h0200;
			4'd10: 	mask <= 16'h0400; 4'd11: 	mask <= 16'h0800;
			4'd12: 	mask <= 16'h1000; 4'd13: 	mask <= 16'h2000;
			4'd14: 	mask <= 16'h4000; 4'd15: 	mask <= 16'h8000;
			default: mask <= 0;
		endcase 
	end

	Mem_Layer_3 St_5_CR (
				.clk (clk), .rst (rst), .ena (ena),
				// read mem
				.node_address_1 			(node_addr_1_mem_3_buf),
				.data_out_1 				(do_1_mem_3), 

	 			.node_address_2 			(node_addr_2_mem_3_buf),		 			
	 			.data_out_2 				(do_2_mem_3), 
	 			// update mem
				.update_node_addr			(update_node_addr_mem_3),
				.update_node_data			(mask_buf)
	 		);	

	reg n_equal_inc_mat_tag_1_from_st_5;
	always @(posedge clk) begin
		if (rst) begin
			data_for_matcher_st_6_st_5_out <= 0;
			update_node_addr_mem_3 <= 0;
			mask_buf <= 0;
			n_equal_inc_mat_tag_1_from_st_5 <= 0;
		end
		else if (ena) begin
			data_for_matcher_st_6_st_5_out <= data_for_matcher_st_6_st_5_buf;
			update_node_addr_mem_3 <= update_node_addr_mem_3_buf;
			mask_buf <= mask;
			n_equal_inc_mat_tag_1_from_st_5 <= n_equal_inc_mat_tag_1_from_st_5_buf;
		end
	end

	Stage_5_Reg St_5_R	(
				.clk (clk),	.rst (rst),.ena (ena),
	 			.incoming_tag_forward_in 	(incoming_tag_from_st_5_buf),
			 	.incoming_tag_forward_out 	(incoming_tag_from_st_5),

	 			.matching_tag_forward_in 	(matching_tag_1_2_from_st_5_buf),
	 			.matching_tag_forward_out 	(matching_tag_1_2_from_st_5),

	 			.matching_tag_bak_forward_in(matching_tag_1_2_bak_from_st_5_buf),
	 			.matching_tag_bak_forward_out(matching_tag_1_2_bak_from_st_5)
			);

	// =======================================================
	// ------------ Stage 6 ----------------------------------
	// =======================================================
	wire [3:0] data_for_matcher_st_6;
	assign data_for_matcher_st_6 = (n_equal_inc_mat_tag_1_from_st_5) ? 4'd15 : data_for_matcher_st_6_st_5_out;
	Matcher_16bit St_6_Matcher(
				.d 							(data_for_matcher_st_6_st_5_out), 
				// .d 							(matching_tag_1_2_from_st_5[3:0]), 
				.m 							(do_1_mem_3),
	 			.n  						(matching_tag_from_matcher_st_6), 
	 			.r_out 						(), 
	 			.not_found					(not_found_from_matcher_st_6)
	 		);		

	Matcher_16bit St_6_Matcher_Bak_2	(
				// .d 							(data_in_for_matcher_bak_st_6_from_5),
				.d 							(4'd15),
				.m 							(do_2_mem_3),
				.n 							(matching_tag_from_matcher_bak_st_6),
				.r_out 						(),
				.not_found 					()
			);

	assign matching_tag_combination = 
			(~not_found_from_matcher_st_6) ?
			{matching_tag_1_2_from_st_5, matching_tag_from_matcher_st_6} :
			{matching_tag_1_2_bak_from_st_5, matching_tag_from_matcher_bak_st_6};

	Stage_6_Reg St_6_R	(
				.clk						(clk), 
				.rst						(rst), 
				.ena 						(ena),
	 			.matching_tag_forward_in 	(matching_tag_combination),
	 			.matching_tag_forward_out 	(matching_tag),

	 			.incoming_tag_forward_in	(incoming_tag_from_st_5),
	 			.incoming_tag_forward_out 	(incoming_tag_forward) 	
	 		);	
endmodule