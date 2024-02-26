
`ifndef __DISPLAY__
`define __DISPLAY__



module display
#(
 parameter gs = 8 // optional parameter
) (
 // define I /O ’ s of the module

	input wire clk_i ,
	input wire [(gs*gs-1):0] matrix_i,
	input wire e_disp ,

	output wire [gs-1:0] col_val_o,
	output wire [gs-1:0] row_val_o,
	output wire d_disp_o
	//output [gs:0] row_d_o 
 	
);

	reg [gs-1:0] col_val;
	reg [gs-1:0] row_val;
	reg d_disp;
	reg [gs:0] row_d;
	reg [11:0] clk_new;
	integer i = 0;
	

	// assign the counter value to the output
	assign col_val_o = col_val;
	assign row_val_o = row_val;
	assign d_disp_o = d_disp;

	
	
	always @ (posedge clk_i) begin

		if (e_disp) begin
			d_disp <= 0;	
			//$display(row_d);
			if(clk_new == 12'b0 ) begin
				if(row_d == 8) begin
					d_disp <= 1;
				end else begin
					for(i = 0; i < gs; i= i+1)  begin
						col_val[i] <= matrix_i[gs*row_d + i];
					end
					
					
					if(row_d == 0) begin
						row_val <= ({{{( gs-1) {1'b1}} , 1'b0}});
					end else begin
						row_val <= {row_val[6:0], 1'b1};
					end

					row_d <= row_d + 1;
				end
			end

			clk_new <= clk_new + 1;	
		end else begin
			col_val <= {{( gs) {1'b0}}};
			row_val <= 8'b0;
			d_disp <= 0;
			row_d <= 0;
			clk_new <= 0;
		end


	end
	


endmodule // display

`endif

