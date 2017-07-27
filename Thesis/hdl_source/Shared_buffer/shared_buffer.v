//------------------------------------------------------------
// Author			:	vantubk
// Date				:	2015-04-10 08:46:59
// Last Modified 	:	2015-05-03 23:52:13
// Description		:	bo nho dem goi tin, dung kien truc
// 						shared buffer
//
// 						TIMING: ip va rd_req vao cung mot thoi diem,
// 						idata va wr_req vao cung 1 thoi diem
//
//------------------------------------------------------------
module shared_buffer #(
	parameter SHARED_BUFFER_ADDR_BITWIDTH = 4,
	parameter PACKET_DATA_BITWIDTH        = 4,
	// parameter SHARED_BUFFER_DATA_BITWIDTH = PACKET_DATA_BITWIDTH  +SHARED_BUFFER_ADDR_BITWIDTH+1 // 13: linked list addr, 1: end_packet
	parameter SHARED_BUFFER_DATA_BITWIDTH = PACKET_DATA_BITWIDTH
) (
	input                                        clk, // Clock
	input                                        rst, // Asynchronous reset
	input                                        wr_req,
	// input      [                            7:0] packet_len, // max 1500 byte / 64 bit
	input                                        rd_req,
	input      [SHARED_BUFFER_ADDR_BITWIDTH-1:0] ip, // dia chi cua goi tin can doc
	input      [       PACKET_DATA_BITWIDTH-1:0] idata, // du lieu can ghi vao
	output reg [SHARED_BUFFER_ADDR_BITWIDTH-1:0] op, // dia chi cua idata sau khi ghi vao
	output     [       PACKET_DATA_BITWIDTH-1:0] odata       // du lieu doc ra tu o nho co dia chi ip
);
	//
	reg  [SHARED_BUFFER_ADDR_BITWIDTH-1:0] pcount;
	reg  [SHARED_BUFFER_ADDR_BITWIDTH-1:0] shared_ram_wr_addr;
	reg  [SHARED_BUFFER_DATA_BITWIDTH-1:0] shared_ram_wr_data;
	// reg  [SHARED_BUFFER_ADDR_BITWIDTH-1:0] shared_ram_rd_addr;
	// wire [SHARED_BUFFER_DATA_BITWIDTH-1:0] shared_ram_rd_data;
	//
	reg                                    pfifo_rd_en, pfifo_wr_en;
	reg  [SHARED_BUFFER_ADDR_BITWIDTH-1:0] pfifo_pin;
	wire [SHARED_BUFFER_ADDR_BITWIDTH-1:0] pfifo_pout;
	wire [  SHARED_BUFFER_ADDR_BITWIDTH:0] pfifo_data_count;
	//
	// reg [       PACKET_DATA_BITWIDTH-1:0] packet_data_buffer;
	// reg [SHARED_BUFFER_ADDR_BITWIDTH-1:0] shared_buffer_addr_next, shared_buffer_addr_current;
	// reg                                   end_packet_write_buffer;
	//
	// reg [ 1:0] write_state;
	// reg [10:0] len_count;
	// reg        end_packet;
	// reg        read_packet_start; //
	// reg        rd_req_b, wr_req_b, rd_req_b2, wr_req_b2;
	//read, write state
	// localparam WRITE_IDLE = 2'b00;
	// localparam WRITE_START = 1'b01;
	// localparam WRITE_PROCESS = 1'b10;
	// localparam WRITE_LAST = 1'b11;
	//
	dualport_shared_ram #(
		SHARED_BUFFER_ADDR_BITWIDTH,
		SHARED_BUFFER_DATA_BITWIDTH
	) dualport_shared_ram1 (
		.clk   (clk),
		// .rd_en  (rd_req),
		// .wr_en  (wr_req),
		.rd_en (1'b1),
		.wr_en (1'b1),
		.r_addr(ip),
		.w_addr(shared_ram_wr_addr),
		.w_data(shared_ram_wr_data),
		.r_data(odata)
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
		// .data_count  (pfifo_data_count),
		.data_out(pfifo_pout )
	);
	//
	always @(posedge clk) begin
		if(rst=='d1) begin
			pcount = 'd0;
		end
		else begin
			//-------------------write request-------------------
			if (wr_req) begin
				if (pcount < 13'b1_1111_1111_1111) begin
					shared_ram_wr_addr = pcount;
					shared_ram_wr_data = idata;
					pcount             = pcount + 1;
				end
				else begin
					pfifo_rd_en        = 1;
					shared_ram_wr_addr = pfifo_pout;
					shared_ram_wr_data = idata;
				end
				op = shared_ram_wr_addr;
			end
			else begin
				pfifo_rd_en = 0;
			end
			//-------------------read request-------------------
			if (rd_req) begin
				pfifo_wr_en = 1;
				pfifo_pin   = ip;
			end
			else begin
				pfifo_wr_en = 0;
			end
		end
	end
endmodule