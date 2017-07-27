`timescale 1ps/1ps
module test_MQ;
reg clk,rst;
reg D,flush;
reg [4:0]CX;
wire[15:0] ByteOut;
wire[7:0] BP;
wire flush_out;

MQCode_top mq(.clk(clk),.rst(rst),.DIn(D),.flush(flush),.CXIn(CX),
			  .ByteOut(ByteOut),.BP(BP), .flush_out(flush_out));
 
initial
begin
	clk = 1'b1;
	forever #5 clk = ~clk;
end

initial
begin
	rst = 1'b0;
	#8 rst = 1'b1;
	#5 rst = 1'b0;
end

reg [19:0] bit_in={20'b10000111011111011101};
// reg [10*5-1:0] ctx={5'd1,5'd2,5'd3,5'd1,5'd2,5'd3,5'd1,5'd2,5'd3,5'd1};
reg [20*5-1:0] ctx={5'd1,5'd2,5'd3,5'd4,5'd1,5'd2,5'd3,5'd4,5'd1,5'd2, 
					           5'd3,5'd4,5'd1,5'd2,5'd3, 5'd4,5'd1,5'd2,5'd3,5'd4};
initial
begin
	#18
	flush=0;
	repeat(20)
	begin
	D=bit_in[0]; CX=ctx;
	#10  bit_in=bit_in>>1; ctx=ctx>>5;

		// RAM[BP]=ByteOut; RAM[BP+1]=ByteOut>>8;
	end
	flush=1;D=0;CX=5'd0;

end

endmodule
