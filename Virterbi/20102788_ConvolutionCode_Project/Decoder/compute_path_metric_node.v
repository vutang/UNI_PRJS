module compute_path_metric_node
(
	input clk, rst, st,
	input [4:0] pre_metric1, pre_metric2, pre_metric3, pre_metric0,
	input [1:0] bm0_1, bm0_2, bm1_1, bm1_2, bm2_1, bm2_2, bm3_1, bm3_2,
	output [7:0] data1, data2, data3, data0,
	output done
);

/*function [6:0] compute_metric_func;	
	input [1:0] branch_metric1, branch_metric2;
	input [4:0] pre_metric;
	begin
		if(branch_metric1 <= branch_metric2)
			begin
				compute_metric_func[6:2] = pre_metric + branch_metric1;
				compute_metric_func[1:0] = 2'b10;
			end
		else
			begin
				compute_metric_func[6:2] = pre_metric + branch_metric2;
				compute_metric_func[1:0] = 2'b01;
			end
	end
endfunction*/

/*assign data0 = compute_metric_func(bm0_1, bm0_2, pre_metric0);
assign data1 = compute_metric_func(bm1_1, bm1_2, pre_metric1);
assign data2 = compute_metric_func(bm2_1, bm2_2, pre_metric2);
assign data3 = compute_metric_func(bm3_1, bm3_2, pre_metric3);*/
assign data0 = (bm0_1 < bm0_2) ? ({(pre_metric0 + bm0_1),2'b10}) 
							   : ({(pre_metric0 + bm0_2),2'b01});
assign data1 = (bm1_1 < bm1_2) ? ({(pre_metric1 + bm1_1),2'b10}) 
							   : ({(pre_metric1 + bm1_2),2'b01});
assign data2 = (bm2_1 < bm2_2) ? ({(pre_metric2 + bm2_1),2'b10}) 
							   : ({(pre_metric2 + bm2_2),2'b01});
assign data3 = (bm3_1 < bm3_2) ? ({(pre_metric3 + bm3_1),2'b10}) 
							   : ({(pre_metric3 + bm3_2),2'b01});							  
/*parameter start = 0, first2node = 1, second2node = 2, finish = 3;
reg [1:0] state, next_state;
// reg [1:0] hold;
always @(posedge clk or posedge rst) begin
	if (rst) 
		begin
			// reset
			state <= 0;
			// hold <= 0;
		end
	else
		begin
			state <= next_state;
		end
end

always @*
begin
	next_state = state;
	case (state)
		start:
			begin
				// done = 1'b0;
				// hold = 0;
				if(st)
					next_state = first2node;
				else 
					next_state = start;
				// done = 1'b0;
			end
		first2node:
			begin
				data0 = compute_metric_func(bm0_1, bm0_2, pre_metric0);
				data1 = compute_metric_func(bm1_1, bm1_2, pre_metric1);
				data2 = compute_metric_func(bm2_1, bm2_2, pre_metric2);
				data3 = compute_metric_func(bm3_1, bm3_2, pre_metric3);
				next_state = finish;
			end
		/*second2node:
			begin
				data2 = compute_metric_func(bm2_1, bm2_2, pre_metric2);
				data3 = compute_metric_func(bm3_1, bm3_2, pre_metric3);
				next_state = finish;
			end*/
/*		finish:
			begin
				// done = 1'b1;
				next_state = start;
				if (hold <= 2)
					next_state = finish;
				else 
					next_state = start;
				// hold = hold + 1;
			end
	endcase
end*/
// assign done = (state == finish) ? 1'b1 : 1'b0;*/

endmodule


