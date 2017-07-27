module test_ram_tb;

reg clk, rst, st;
reg [7:0] in1, in2, in3, in4;
wire [7:0] out1, out2, out3, out4, out5, out6, out7, out8;

reg [7:0] count;

test_ram xxx(.clk(clk), .rst(rst), .st(st), .in1(in1), .in2(in2),
			 .in3(in3), .in4(in4), .out1(out1), .out2(out2),
			 .out3(out3), .out4(out4), .out5(out5), .out6(out6), .out7(out7),
			 .out8(out8));

	initial
	begin
		clk = 1'b0;
		forever #5 clk = ~clk;
	end

	initial 
	begin
		rst = 1'b0;
		#3 rst = 1'b1;
		#4 rst = 1'b0;
	end

	initial
	begin
		st = 1'b0;
		#13 st = 1'b1;
		forever
			begin
				#10 st = 1'b0;
				#20 st = 1'b1;
			end
	end

	initial
	begin
		#12;
		for (count = 0; count < 20; count = count + 1)
			begin
				in1 = count;
				in2 = count + 1;
				in3 = count + 2;
				in4 = count + 3;
				#20;
			end		
	end
endmodule
