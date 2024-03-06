`ifndef __TT_UM_FLAPPY_BIRD__
`define __TT_UM_FLAPPY_BIRD__

`default_nettype none
`include "../src/get_input.v"
`include "../src/action.v"
`include "../src/display.v"





module tt_um_flappy_bird 
(

    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);



    // use bidirectionals as outputs
    assign uio_oe = 8'b11111111;
	
	parameter gs = 8;
	parameter cr = 14;	//wie schnell wird geshiftet
	
	
	//reg
	reg e_inp = 1'b0;
	reg e_act = 1'b0;
	reg e_disp = 1'b0;
	reg tReset;			
	//wires
	wire up;
 	wire down;
 	wire d_inp;
 	wire [gs*gs-1:0] matrix;
 	wire d_act;
	wire [gs-1:0] col_val;
	wire [gs-1:0] row_val;

 	wire d_disp;
	
	//assign
	assign uo_out = col_val;
	assign uio_out = row_val;
		

	 
	
	//DUT - Defenitions
	get_input
		#(cr)
		get_input_dut (
			.clk_i ( clk ) ,
			//.rst_i ( ! rst_n ) ,
			.e_inp (e_inp) ,
			.right_i(ui_in[0]), //right == up
			.left_i(ui_in[1]),  //left == down		
			.right_o(up) ,
			.left_o(down) ,
			.d_inp_o(d_inp) 
		);
	
	action
		#(gs, cr)
		action_dut (
			.clk_i ( clk) ,
			.up_i ( up ),
			.down_i ( down ),
			.reset_i ( ~rst_n ),
			.e_act_i (e_act ),
			.matrix_o (matrix),
			.d_act_o(d_act)
		);
		
	display
		#(gs)
		display_dut (
			.clk_i ( clk ) ,
			.matrix_i(matrix) ,
			.e_disp(e_disp) ,	
			.col_val_o(col_val) ,
			.row_val_o(row_val) ,
			.d_disp_o(d_disp)
		);
	
	
	
	// States for State Machine
    reg [1:0]State;
	localparam Input_s = 2'b01;
	localparam Action_s = 2'b11;
	localparam Display_s = 2'b10;

    // external clock is 10MHz, so need 24 bit counter
    
    

    // if external inputs are set then use that as compare count
    // otherwise use the hard coded MAX_COUNT
    
	
    always @(negedge clk) begin

	if(ena) begin
		tReset <= ~rst_n;
		if(tReset) begin
			e_inp <= 1'b1;
			State <= Input_s;
		end else begin
			case(State)
				Input_s: begin
					if (d_inp == 1'b1)  begin
						e_inp<= 1'b0;
						e_act <= 1'b1;
						State <= Action_s;
					end
				end
				Action_s: begin
					if (d_act == 1'b1)  begin
						e_act <= 1'b0;
						e_disp <= 1'b1;
						State <= Display_s;
					end
				end
				Display_s: begin
					if (d_disp == 1'b1)  begin
						e_disp <= 1'b0;
						e_inp <= 1'b1;
						State <= Input_s;
					end
				end
				
				default:;
			endcase
		end
	end
 
		
	
		

	

		
    end

    
endmodule
`endif
