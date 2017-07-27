module test_ram
(
	input clk, rst, st,
	input [7:0] in1, in2, in3, in4,
	output reg [7:0] out1, out2, out3, out4, out5, out6, out7, out8
);

reg [7:0] RAM [7:0];
reg [2:0] base_addr;

always @(posedge clk)
begin
	if (rst)
		begin
			RAM[0] = 0;
			RAM[1] = 0;
			RAM[2] = 0;
			RAM[3] = 0;
			RAM[4] = 0;
			RAM[5] = 0;
			RAM[6] = 0;
			RAM[7] = 0;
			base_addr = 0;
		end
	else
		begin
			if (st)
				begin
					out1 = RAM[0];
					out2 = RAM[1];
					out3 = RAM[2];
					out4 = RAM[3];
					out5 = RAM[4];
					out6 = RAM[5];
					out7 = RAM[6];
					out8 = RAM[7];
					RAM[base_addr] = in1;
					RAM[base_addr + 1] = in2;
					RAM[base_addr + 2] = in3;
					RAM[base_addr + 3] = in4;
					base_addr = base_addr + 4;
					if (base_addr > 4)
						base_addr = 0;

				end
		end
end

/*assign out1 = RAM[0];
assign out2 = RAM[1];
assign out3 = RAM[2];
assign out4 = RAM[3];
assign out5 = RAM[4];
assign out6 = RAM[5];
assign out7 = RAM[6];
assign out8 = RAM[7];
*/
endmodule