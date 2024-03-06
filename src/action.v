

`ifndef __ACTION__
`define __ACTION__



module action
#(
 parameter gs = 8, // optional parameter
 parameter cr = 2,  //change rate
 parameter beam_shemas = 56'b00111111_10011111_11001111_11100111_11110011_11111001_11111100

) (
 // define I /O ’ s of the module

	input wire clk_i ,
	
	input wire up_i,
	
	input wire down_i,
	
	input wire reset_i,
	input wire e_act_i,
	
	output wire [gs*gs-1:0] matrix_o, //flatten matrix
	output wire d_act_o
	//output dead_o
 	
);
	
	reg [(gs*gs-1):0] matrix; //output Matrix memory
	
	reg [(gs-1):0] bird_pos ; //bird position
	reg [(gs*gs)-1:0] beam_matrix; //beam matrix
	
		
	reg d_act; 		//used to disbale 
	integer i = 0;
	
	integer alive_counter ;				//how many beams are passed
	integer pos_counter ;
	reg [3:0] change_counter ;			//shift beams to the left when overflow
	reg [1:0] add_beam_counter ;		//add beam after 4 (overflow) beam shifts
	reg [4:0] random_counter = 0; 		//randdom counter to select beam-shema 
	
	reg dead;		//player is dead
	
	//assign dead_o = dead;				
	assign d_act_o = d_act;
	assign matrix_o = matrix;
	
	
	always @ (posedge clk_i) begin

		if(reset_i) begin
			dead <= 1'b1;
			d_act <= 1'b1;			
			//Spieler, beam_matrix, dead, d_act,  zurücksetzen
			beam_matrix <= 64'b0;
			bird_pos <= 8'b0;
			matrix <= 64'b0;
		end else begin	//Reset nicht gedrückt - Spieler bereit zu starten oder spielt
			if(e_act_i) begin
				if(dead) begin
					if(up_i) begin
						//startsequence
						bird_pos <= ({{( (gs/2)-1) {1'b0}} , 1'b1, {( (gs/2)) {1'b0}}});
						beam_matrix <= 64'b0;
						//matrix <= 64'b0;
						pos_counter <= 0;
						add_beam_counter <= 0;	
						change_counter <= 0;	
						dead <= 1'b0;
						alive_counter <= 0;					
					end else begin
						//Display calibration diagonal after reset
						bird_pos <= {(gs){1'b0}};
						beam_matrix <= 64'b10000000_01000000_00100000_00010000_00001000_00000100_00000010_00000001;
						
					end
					
				end else begin
					//in game
					
					//compute change of bird_pos
					if(down_i) begin
						if(bird_pos[0] != 1'b1) begin
							bird_pos <= bird_pos >> 1;
						end else begin
							dead <= 1'b1;
						end
					end
					
					if(up_i) begin
						if(bird_pos[gs-1] != 1'b1) begin
							bird_pos <= bird_pos << 1;
						end else begin
							dead <= 1'b1;
						end
					end
				

					
					//change beam_matrix & check if alive
					if (change_counter == 0) begin
						//timer has overflow -> change beam matrix
						for (i = 0; i < gs*(gs-1); i = i+1) begin
							beam_matrix[i] <= beam_matrix[i+gs];
						end
						//timer has overflow + 4 beam changes happend -> add_beam
						if (add_beam_counter == 0) begin
							for (i = 0; i < gs; i = i+1) begin
								beam_matrix[gs*(gs-1)+i] <= beam_shemas[i + gs * random_counter];
							end
							
							//check if bird_pos == beam -> dead == 1'b1 , else increas alive_counter 					
							for(i = 0; i < gs; i = i+1) begin
								if((bird_pos[i] == 1'b1) && (beam_matrix[i] == 1'b1)) begin
									dead <= 1'b1;
								end
							end
							if (dead == 1'b0) begin
								alive_counter <= alive_counter + 1;
							end
						end else begin						
							for (i = 0; i < gs; i = i+1) begin
								beam_matrix[gs*(gs-1)+i] <= 1'b0;
							end
						end
						add_beam_counter <= add_beam_counter + 1;
						
					end	
					change_counter <= change_counter + 1; // increase change_counter for beam_matrix							
						

				end

						
				// compute matrix for display
				for(i = 0 ; i < gs ; i = i+1) begin
					matrix[i] <= bird_pos[i] + beam_matrix[i];
				end
				for(i = gs ; i < gs*gs ; i = i+1) begin
					matrix[i] <= beam_matrix[i];
				end				
								
				d_act <= 1'b1;
			end else begin	//State not on display
				//pos_counter is counter to randomly generate beams
				if(random_counter >= 7) random_counter <=0;
				else random_counter <= random_counter + 1;
			end

		
		end

		
	
	end






	
	


endmodule // display

`endif
