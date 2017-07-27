module storage_trellis
#(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=6)
(
	input wire clk,
	input wire we,
	input wire [ADDR_WIDTH - 1:0] addr_wr, addr_rd,
	input wire [DATA_WIDTH - 1:0] data_in,
	output reg [DATA_WIDTH -1:0] data_out
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];
	// Variable to hold the registered read address
	//reg [ADDR_WIDTH-1:0] addr_reg;

	always @(posedge clk) begin 
			if (we) begin
				ram[addr_wr] = data_in;			
			end
				data_out = ram[addr_rd];
	end

endmodule