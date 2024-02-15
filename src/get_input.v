/*
 Simple counter with generic bitwidth .
*/

`default_nettype none
`ifndef __COUNTER__
`define __COUNTER__

module get_input
#(
 parameter cr = 4 // counter range
) (
 // define I /O ’ s of the module
 	input clk_i , // clock
 	//input rst_i , // reset
 	input e_inp, // enable input
 	
 	input right_i ,
 	input left_i ,
	
	output right_o ,
 	output left_o ,
 	
 	
 	//output rst_o ,
 	
 	
 	output d_inp_o 
);

	// start the module implementation
	// register to store the counter value

	//reg rst ; // clock
 	reg left ;
 	reg right ;
 	reg d_inp ;
	
	reg [cr-1:0] left_cr = 0;
	reg [cr-1:0] right_cr = 0;
	//reg [cr-1:0] rst_cr =0 ;
	
	// assign the counter value to the output
	assign left_o = left;
	assign right_o = right;
	//assign rst_o = rst;
	assign d_inp_o = d_inp;

	
	always @ (posedge clk_i) begin		
		if (e_inp) begin
			if(left_cr == 0) begin
				if(left_i) begin
					left <= 1'b1;
					left_cr <= left_cr + 1;
				end else left <= 1'b0;
			end else begin
				left <= 1'b0;
				left_cr <= left_cr + 1;
			end
		
			if(right_cr == 0) begin
				if(right_i) begin
					right <= 1'b1;
					right_cr <= right_cr + 1;
				end else right <= 1'b0;
			end else begin
				right_cr <= right_cr + 1;
				right <= 1'b0;
			end
			/*
			if(rst_cr == 0) begin
				if(rst_i) begin
					rst <= 1'b1;
					rst_cr <= 1;
				end else rst <= 1'b0;
			end else begin
				rst_cr <= rst_cr + 1;
				rst <= 1'b0;
			end
			*/
			d_inp <= 1'b1;
		end else begin
			left <= 1'b0;
			right <= 1'b0;
			//rst <= 1'b0;
			d_inp <= 1'b0;
		end
	end
				

endmodule // input

`endif
`default_nettype wire
