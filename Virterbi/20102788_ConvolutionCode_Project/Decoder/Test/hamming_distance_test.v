module hamming_distance_test();
reg [1:0] in1, in2;
wire [1:0] hd;

integer index1, index2;

hamming_distance #(2) xxx (.in1(in1), .in2(in2), .hd(hd));

initial 
begin
	for(index1 = 0; index1 < 4; index1 = index1 + 1)
		begin
			for(index2 = index1; index2 < 4; index2 = index2 + 1)
				begin
					in1 = index1;
					in2 = index2;
					#10;
				end
		end
end

endmodule
	