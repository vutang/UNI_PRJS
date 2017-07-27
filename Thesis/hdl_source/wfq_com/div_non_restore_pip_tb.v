`timescale 1ns / 1ps
module div_non_restore_pip_tb;

	// Inputs
	reg        clk;
	reg [15:0] dividend;
	reg [15:0] divisor;

	// Outputs
	wire [15:0] quotient;

	// Instantiate the Unit Under Test (UUT)
	div_non_restore_pip uut (
		.clk      (clk),
		.dividend (dividend),
		.divisor  (divisor),
		.quotient (quotient)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		dividend = 0;
		divisor = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
        dividend = 16'h0005;
        divisor = 16'b0010011000000000; // 0.15
        #10;
        dividend <= 16'h0011;
		divisor <= 16'b1100000000000000; // 0.75
		#10;
		dividend <= 16'd20;
		divisor <= 16'h8000;

	end
	always begin 
		#5 clk = ~clk;
	end
      
endmodule

