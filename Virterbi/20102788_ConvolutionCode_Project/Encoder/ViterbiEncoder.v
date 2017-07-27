module ViterbiEncoder
(
	input clk, rst, st,
	input code_in,
	output [1:0] code_out
	//output reg done
);

reg [2:0] shift_reg;
reg check;
always @(posedge clk or posedge rst) begin
	if (rst) 
	begin
		// reset
		shift_reg <= 3'b0;
		//done = 1'b0;
	end
	else
	begin
		//if(~eof) begin
		//	shift_reg = {shift_reg[1:0],code_in};
		//end	
		//else begin
		//	shift_reg = {shift_reg[1:0], 1'b0};
		//	check = 1'b1;
		//end
		//if(check)
		//begin
		//	shift_reg = {shift_reg[1:0], 1'b0};
		//	done = 1'b1;
		//end
		shift_reg = {shift_reg[1:0], code_in};
	end
end

//always @(code_in)
//begin
//	code_out[1] = shift_reg[2] | shift_reg[1] | shift_reg[0];
//	code_out[0] = shift_reg[2] | shift_reg[0];
//end

assign code_out[1] = shift_reg[2] ^ shift_reg[1] ^ shift_reg[0];
assign code_out[0] = shift_reg[2] ^ shift_reg[0];
endmodule
