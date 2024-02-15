/*
 Simple counter with generic bitwidth .
*/

`default_nettype none
`ifndef __DISPLAY__
`define __DISPLAY__



module display
#(
 parameter gs = 8 // optional parameter
) (
 // define I /O ’ s of the module

	input clk_i ,
	input [(gs*gs-1):0] matrix_i,
	input wire e_disp ,

	output [gs-1:0] col_val_o,
	output [gs-1:0] row_val_o,
	output d_disp_o
	//output [gs:0] row_d_o 
 	
);

	reg [gs-1:0] col_val;
	reg [gs-1:0] row_val;
	reg d_disp;
	reg [gs:0] row_d;

	
	
	
	// assign the counter value to the output
	assign col_val_o = col_val;
	assign row_val_o = row_val;
	assign d_disp_o = d_disp;

	
	
	always @ (posedge clk_i) begin
		if (e_disp) begin
			d_disp <= 0;	
			//$display(row_d);

			for(integer i =0; i < gs; i= i+1) begin
				col_val[i] <= matrix_i[gs*row_d + i];
			end
			
			
			if(row_d == 0) begin
				row_val <= ({{{( gs-1) {1'b0}} , 1'b1}});
			end else begin
				row_val <= row_val << 1;
			end
			
			if(row_d == 7) begin
				d_disp <= 1;
			end
			row_d <= row_d + 1;
			
			
		end else begin
			col_val <= {{( gs) {1'b0}}};
			row_val <= {{( gs) {1'b0}}};
			d_disp <= 0;
			row_d <= 0;
		end

	end
	


endmodule // display

`endif
`default_nettype wire
