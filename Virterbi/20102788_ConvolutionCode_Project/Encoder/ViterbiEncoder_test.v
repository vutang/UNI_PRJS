`timescale 1ns/1ps
module ViterbiEncoder_test;
  //signal for porting map ViterbiEncoder.v
  reg clk, rst;
  reg st;
  reg code_in;  
  wire [1:0] code_out;

  //signal for simulation
  reg [0:0] input_bits [7:0];
  reg [7:0] index;
  integer file;
  
  ViterbiEncoder tested_module(.clk(clk), .rst(rst), .st(st), .code_in(code_in),
                               .code_out(code_out));
  
  //generate clock and reset signal
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

  //read input stream
  initial
  begin
    $readmemb("input_bits.txt",input_bits);
  end

  initial 
  begin 
    file = $fopen("output_bits.txt", "w");
    $fclose(file);
    file = $fopen("output_bits.txt", "a+");
    #13;
    for (index = 0; index < 8; index = index + 1)
      begin
        code_in = input_bits[index]; #10;
        $fwrite(file, "%b\t", code_out);
      end
    code_in = 0; #10;
    $fwrite(file, "%b\t", code_out);
    code_in = 0; #10;
    $fwrite(file, "%b\t", code_out);
    code_in = 1'bx;
    $fclose(file);
  end


endmodule
