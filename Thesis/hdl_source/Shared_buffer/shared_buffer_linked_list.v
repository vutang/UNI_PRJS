//------------------------------------------------------------
// Author			:	vantubk
// Date				:	2015-04-10 08:46:59
// Last Modified 	:	2015-05-28 18:25:17
// Description		:	bo nho dem goi tin, dung kien truc
// 						shared buffer
//
// 						TIMING: ip va rd_req, packet len vao cung mot thoi diem,
// 						idata va wr_req vao cung 1 thoi diem
// 						xem timing chi tiet o testbench
//
//------------------------------------------------------------
module shared_buffer_linked_list #(
	parameter PACKET_LEN_BITWIDTH         = 8,
	parameter SHARED_BUFFER_ADDR_BITWIDTH = 13,
	parameter PACKET_DATA_BITWIDTH        = 64,
	parameter SHARED_BUFFER_DATA_BITWIDTH = PACKET_DATA_BITWIDTH  +SHARED_BUFFER_ADDR_BITWIDTH+1 // 13: linked list addr, 1: end_packet
) (
	input                                        clk, // Clock
	input                                        rst, // Asynchronous reset
	input                                        wr_req, // tin hieu wr_req yeu cau ghi 1 goi tin vao bo nho
	input      [        PACKET_LEN_BITWIDTH-1:0] packet_len, // max 1500 byte / 64 bit
	input                                        rd_req, // tin hieu yeu cau doc du lieu ra khoi bo nho
	input      [SHARED_BUFFER_ADDR_BITWIDTH-1:0] ip, // dia chi cua goi tin can doc
	input      [       PACKET_DATA_BITWIDTH-1:0] idata, // du lieu can ghi vao
	output reg [SHARED_BUFFER_ADDR_BITWIDTH-1:0] op, // dia chi cua idata sau khi ghi vao
	output     [       PACKET_DATA_BITWIDTH-1:0] odata, // du lieu doc ra tu o nho co dia chi ip
	output                                       shared_buffer_full, // tin hieu bao hieu du lieu day, k ghi dc nua
	output                                       packet_read_done, 
	output                                       shared_buffer_empty  // du lieu trong, k con gi de doc ra
);
	//
	// reg  [SHARED_BUFFER_ADDR_BITWIDTH-1:0] pcount;
	reg  [SHARED_BUFFER_ADDR_BITWIDTH-1:0] shared_ram_wr_addr;
	reg  [SHARED_BUFFER_DATA_BITWIDTH-1:0] shared_ram_wr_data;
	wire [SHARED_BUFFER_ADDR_BITWIDTH-1:0] shared_ram_rd_addr;
	wire [SHARED_BUFFER_DATA_BITWIDTH-1:0] shared_ram_rd_data;
	//
	wire                                   pfifo_rd_en, pfifo_wr_en;
	reg  [SHARED_BUFFER_ADDR_BITWIDTH-1:0] pfifo_pin;
	wire [SHARED_BUFFER_ADDR_BITWIDTH-1:0] pfifo_pout;
	wire [  SHARED_BUFFER_ADDR_BITWIDTH:0] pfifo_data_count;
	//
	reg  [       PACKET_DATA_BITWIDTH-1:0] packet_data_buffer;
	reg  [SHARED_BUFFER_ADDR_BITWIDTH-1:0] shared_buffer_addr_next, shared_buffer_addr_current;
	wire                                   end_packet_write;
	reg                                    end_packet_read = 1;
	//
	reg [                    1:0] run_state;
	reg [PACKET_LEN_BITWIDTH-1:0] len_count;
	reg                           end_packet;
	reg                           read_packet_start; //
	//
	wire mem_empty;
	wire mem_full;
	// read, write state
	localparam RESET = 2'd0;
	localparam INIT_FIRST_ELELMENT = 2'd1;
	localparam INIT_SECOND_ELELMENT = 2'd2;
	localparam RUN_NORMAL = 2'd3;
	//
	dualport_shared_ram #(
		SHARED_BUFFER_ADDR_BITWIDTH,
		SHARED_BUFFER_DATA_BITWIDTH
	) dualport_shared_ram1 (
		.clk   (clk),
		.rd_en (rd_req),
		.wr_en (wr_req),
		// .rd_en  (1'b1),
		// .wr_en  (1'b1),
		.r_addr(shared_ram_rd_addr),
		.w_addr(shared_ram_wr_addr),
		.w_data(shared_ram_wr_data),
		.r_data(shared_ram_rd_data)
	);
	//
	syn_fifo #(
		SHARED_BUFFER_ADDR_BITWIDTH,
		SHARED_BUFFER_ADDR_BITWIDTH
	) shared_buf_pfifo (
		.clk     (clk),
		.rst     (rst),
		.data_in (pfifo_pin),
		.rd_en   (pfifo_rd_en),
		.wr_en   (pfifo_wr_en),
		// .data_count      (pfifo_data_count),
		.data_out(pfifo_pout),
		.empty   (mem_full), // khi fifo trong la bo nho day du lieu
		.full    (mem_empty  )  // khi fifo day la bo nho k co du lieu
	);
	//
	// fwft_fifo #(
	// 	SHARED_BUFFER_ADDR_BITWIDTH,
	// 	SHARED_BUFFER_ADDR_BITWIDTH
	// ) i_fwft_fifo (
	// 	.rst   (rst),
	// 	.clk   (clk),
	// 	.rd_en (pfifo_rd_en),
	// 	.wr_en (pfifo_wr_en),
	// 	.din   (pfifo_pin),
	// 	// .empty (empty),
	// 	// .full  (full),
	// 	.dout  (pfifo_pout)
	// );
	//
	assign pfifo_rd_en = (((run_state == RUN_NORMAL) && (!wr_req) && (!mem_full)))? 1'b0:1'b1;
	assign pfifo_wr_en = (rd_req && (!mem_empty))? 1'b1:1'b0;
	// assign shared_ram_rd_addr = (read_packet_start)? ip:shared_ram_rd_data[SHARED_BUFFER_ADDR_BITWIDTH:1];
	assign shared_ram_rd_addr = (end_packet_read)? ip:shared_ram_rd_data[SHARED_BUFFER_ADDR_BITWIDTH:1];
	assign end_packet_write   = (len_count < (packet_len))? 1'b0:1'b1;
	// assign end_packet_read    = shared_ram_rd_data[0];
	assign packet_read_done = end_packet_read;
	//
	always @* begin
		end_packet_read = shared_ram_rd_data[0];
	end
	always @(posedge clk) begin
		if(rst==1'b1) begin
			len_count         <= 'd1;
			read_packet_start <= 1'b1;
			// end_packet_read   <= 1'b1;
			run_state         <= RESET;
		end
		else begin
			case (run_state)
				RESET                : begin
					// pfifo_rd_en             <= 1;
					run_state                  <= INIT_FIRST_ELELMENT;
				end
				INIT_FIRST_ELELMENT  : begin
					// pfifo_rd_en             <= 1;
					shared_buffer_addr_current <= pfifo_pout;
					run_state                  <= INIT_SECOND_ELELMENT;
				end
				INIT_SECOND_ELELMENT : begin
					// pfifo_rd_en             <= 1;
					shared_buffer_addr_next    <= pfifo_pout;
					// run_state                  <= WAIT_1;
					run_state                  <= RUN_NORMAL;
				end
				// WAIT_1: begin
				// 	run_state                  <= WAIT_2;
				// end
				// WAIT_2: begin
				// 	run_state                  <= RUN_NORMAL;
				// end
				RUN_NORMAL           : begin
					run_state                  <= RUN_NORMAL;
					//-------------------wr_req-------------------
					if(wr_req) begin
						// pfifo_rd_en                <= 1;
						shared_ram_wr_addr         <= shared_buffer_addr_current;
						shared_buffer_addr_current <= shared_buffer_addr_next;
						shared_buffer_addr_next    <= pfifo_pout;
						shared_ram_wr_data         <= {idata,shared_buffer_addr_next,end_packet_write};
						op                         <= shared_buffer_addr_current;
						if(!end_packet_write) begin
							len_count         <= len_count + 'd1;
						end
						else begin
							len_count         <= 'd1;
						end
					end
					else begin
						// pfifo_rd_en                <= 0;
					end
					//-------------------rd_req-------------------
					if(rd_req) begin
						// if(read_packet_start && end_packet_read) begin
						if(end_packet_read) begin
							read_packet_start <= 1'b0;
							pfifo_pin         <= ip;
							// end_packet_read    <= 0;
						end
						else begin
							pfifo_pin         <= shared_ram_rd_data[SHARED_BUFFER_ADDR_BITWIDTH:1];
							// end_packet_read   <= shared_ram_rd_data[0];
						end
					end
					else begin
						read_packet_start     <= 1'b1;
					end
				end
				default              : /* default */;
			endcase
		end
	end
	// output packet
	assign odata               = shared_ram_rd_data[SHARED_BUFFER_DATA_BITWIDTH-1:SHARED_BUFFER_ADDR_BITWIDTH+1];
	assign shared_buffer_full  = mem_full;
	assign shared_buffer_empty = mem_empty;
endmodule