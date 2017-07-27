//------------------------------------------------------------
// Author			:	vantubk
// Date				:	2015-05-05 09:29:27
// Last Modified 	:	2015-06-06 21:27:27
// Description		:	top design
//------------------------------------------------------------
module WFQ_top #(
   parameter WFQ_COMPUTATION_BITWIDTH    = 16,
	parameter FLOWID_BITWIDTH             = 13,
	parameter TAG_VALUE_BITWIDTH          = 12,
	parameter TAG_STORAGE_ADDR_BITWITDH   = 13,
	parameter PACKET_LEN_BITWIDTH         = 9,
	parameter SHARED_BUFFER_ADDR_BITWIDTH = 13,
	parameter PACKET_DATA_BITWIDTH        = 64
) (
	input                                 clk, // Clock
	input                                 rst,
	input                                 in_packet_arrival,
	input                                 in_data_arrival,
	input  [     PACKET_LEN_BITWIDTH-1:0] in_packet_length,
	input  [WFQ_COMPUTATION_BITWIDTH-4:0] in_flow_id,
	input  [    PACKET_DATA_BITWIDTH-1:0] in_packet_data,
	//
	input                                 in_rd_packet_req,
	output                                out_packet_buffer_empty,
	output [    PACKET_DATA_BITWIDTH-1:0] out_packet_data_out
);
	// local params
	localparam DELAY_WFQ_SB = 49;
	localparam DELAY_RD_REQ = 3;
	//
	// regs and wires
	wire                                wfq_packet_arrival;
	wire                                wfq_packet_depart;
	wire [WFQ_COMPUTATION_BITWIDTH-1:0] wfq_ftag_out;
	wire                                wfq_ftag_odone;
	reg                                 wfq_ftag_odone_delay1;
	//
    wire                          tc_ena;
	wire                          tc_ena2;
	wire [TAG_VALUE_BITWIDTH-1:0] tc_incoming_tag;
	// wire [         TAG_VALUE_BITWIDTH-1:0] tc_tagvalue_del;
	wire                                   tc_pak_addr_req;
	wire [SHARED_BUFFER_ADDR_BITWIDTH-1:0] tc_pak_addr_min_out;
	wire [         TAG_VALUE_BITWIDTH-1:0] op_del;
	wire                                   wr_done_mem_out;
   	reg  [WFQ_COMPUTATION_BITWIDTH-4:0]    tc_in_flow_id;
	wire [WFQ_COMPUTATION_BITWIDTH-4:0]    tc_pck_id_out;
	//
	reg [3:0] tc_init_count;
	//
	wire                                   sb_full;
	wire                                   sb_empty;
	wire [SHARED_BUFFER_ADDR_BITWIDTH-1:0] sb_opointer;
	wire [       PACKET_DATA_BITWIDTH-1:0] sb_packet_odata;
	wire [SHARED_BUFFER_ADDR_BITWIDTH-1:0] sb_ip;
	wire                                   sb_rd_packet_req;
	wire                                   sb_packet_read_done;
	//
	reg [SHARED_BUFFER_ADDR_BITWIDTH-1:0] sb_opointer_delay_reg[DELAY_WFQ_SB-1:0];
	// cais delay trong tc la k co dinh theo clock, ma bang 8 lan enable
	reg [               DELAY_RD_REQ-1:0] rd_packet_req_delayed;
	// reg  []
	wire [SHARED_BUFFER_ADDR_BITWIDTH-1:0] tc_in_pck_spb_addr;
	//
	//
	wfq_computation # (WFQ_COMPUTATION_BITWIDTH) i_wfq_computation (
		.clk           (clk),
		.rst           (rst),
		.arrival       (wfq_packet_arrival),
		.depart        (wfq_packet_depart),
		// .packet_length({4'd0,in_packet_length,3'd0}),
		// .packet_length (16'd8),
		.packet_length (in_packet_length*8),
		.flow_id       (in_flow_id),
		.oftime        (wfq_ftag_out),
		.odone         (wfq_ftag_odone)
	);
	//-------------------tag cu, tag moi dung 2 ena-------------------
   Tag_Circuit_Top #(
      TAG_VALUE_BITWIDTH,
      SHARED_BUFFER_ADDR_BITWIDTH,
      TAG_STORAGE_ADDR_BITWITDH,
      FLOWID_BITWIDTH
   ) i_Tag_Circuit_Top (
      .clk             (clk),
      .rst             (rst),
      .ena1            (tc_ena),
      .ena2            (tc_ena2),
      .incoming_tag    (tc_incoming_tag),
      // .pck_id_in       (tc_in_flow_id),
      .pck_id_in       (0), // chua co gia tri, lap tam
      .pck_spb_addr_in (tc_in_pck_spb_addr),
      .pck_addr_req    (tc_pak_addr_req),
      .pck_addr_out    (tc_pak_addr_min_out), //incoming addr with incoming tag
      .pck_id_out      (tc_pck_id_out),
      .wr_done_mem     (wr_done_mem_out)
   );
   //
	shared_buffer_linked_list #(
		PACKET_LEN_BITWIDTH,
		SHARED_BUFFER_ADDR_BITWIDTH,
		PACKET_DATA_BITWIDTH,
		PACKET_DATA_BITWIDTH+SHARED_BUFFER_ADDR_BITWIDTH+1
	) i_shared_buffer_linked_list (
		.clk                 (clk),
		.rst                 (rst),
		.wr_req              (sb_wr_req),
		.packet_len          (in_packet_length),
		.rd_req              (sb_rd_packet_req),
		.ip                  (sb_ip),
		.idata               (in_packet_data),
		.op                  (sb_opointer),
		.odata               (sb_packet_odata),
		.shared_buffer_full  (sb_full),
		.shared_buffer_empty (sb_empty),
		.packet_read_done    (sb_packet_read_done)
	);
	//
	assign out_packet_data_out     = sb_packet_odata;
	assign out_packet_buffer_empty = sb_empty;
	//
	assign wfq_packet_depart  = 1'b0;
	assign wfq_packet_arrival = (sb_full)? 1'b0 : in_packet_arrival;
	assign sb_wr_req          = (sb_full)? 1'b0 : in_data_arrival;
	assign sb_rd_packet_req   = rd_packet_req_delayed[DELAY_RD_REQ-1];
	assign sb_ip              = tc_pak_addr_min_out;
	//
	// tc_ena = 1 trong 8 chu ki dau tien de flood tree
    assign tc_ena2 = (tc_init_count<8)? 1'b0 : wfq_ftag_odone;
	assign tc_ena  = wfq_ftag_odone;
	// assign tc_incoming_tag = wfq_ftag_out[(TAG_VALUE_BITWIDTH-1+4):(0+4)];
	// assign tc_incoming_tag = {2'd0,wfq_ftag_out[(TAG_VALUE_BITWIDTH-1+4):(0+6)]};
   // assign tc_incoming_tag = (tc_init_count<8)? 'd0:{2'd0,wfq_ftag_out[(TAG_VALUE_BITWIDTH-1+4):(0+6)]};
	assign tc_incoming_tag = wfq_ftag_out[TAG_VALUE_BITWIDTH-1+4:0+4];
	// assign tc_pak_addr_req = (sb_empty)? 1'b0: in_rd_packet_req;
	// assign tc_pak_addr_req = in_rd_packet_req;
	assign tc_pak_addr_req = in_rd_packet_req && sb_packet_read_done;
	// delay signal
	// sb_opointer vao idata 2 trong tag_circit top, 
   // nen phai dong bo voi i_imcoming tag trong do
	assign tc_in_pck_spb_addr = sb_opointer_delay_reg[DELAY_WFQ_SB-1];
   //
	integer i, j;
	always @(posedge clk) begin
		//
		sb_opointer_delay_reg[0] <= sb_opointer;
		wfq_ftag_odone_delay1    <= wfq_ftag_odone;
		for (i=1; i<DELAY_WFQ_SB;i=i+1) begin
			sb_opointer_delay_reg[i] <= sb_opointer_delay_reg[i-1];
		end
		//
		// rd_packet_req_delayed <= {rd_packet_req_delayed[DELAY_RD_REQ-2:0],tc_pak_addr_req};
		rd_packet_req_delayed <= {rd_packet_req_delayed[DELAY_RD_REQ-2:0],in_rd_packet_req};
	end
	//
	//-------------------tc init-------------------
	always @(posedge clk) begin
		if(rst) begin
			tc_init_count <= 0;
		end
		else begin
         if(wfq_ftag_odone) begin
   			if(tc_init_count < 8) begin
   				tc_init_count <= tc_init_count + 1;
   			end
         end
		end
	end
endmodule