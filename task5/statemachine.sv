`define SP1 4'b0001
`define SD1 4'b0010
`define SP2 4'b0011
`define SD2 4'b0100
`define SP3 4'b0101
`define SD3 4'b0110
`define Scs 4'b0111
`define SPW 4'b1000
`define SDW 4'b1001
`define ST  4'b1010
`define Sr  4'b1111
`define SWa 4'b1110


module statemachine(input slow_clock, input resetb,
                    input [3:0] dscore, input [3:0] pscore, input [3:0] pcard3,
                    output logic load_pcard1, output logic load_pcard2,output logic load_pcard3,
                    output logic load_dcard1, output logic load_dcard2, output logic load_dcard3,
                    output logic player_win_light, output logic dealer_win_light);

reg [3:0] current_state;

always_ff @(posedge !slow_clock or posedge !resetb)begin

  if(resetb == 0) begin
	current_state <= `Sr; //when reset is pressed, goes to the reset state
//        {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light} = 8'b000_000_00; 
  end
  else begin
	case(current_state)
	  `Sr:  current_state <= `SP1; //player gets the first card if slow_clk is pressed
	  `SP1: current_state <= `SD1; //dealer then gets the first card
	  `SD1: current_state <= `SP2; //player second card
	  `SP2: current_state <= `SD2; //dealer second card
	  `SD2:	if(dscore == 4'd8 || dscore == 4'd9 ||pscore == 4'd8 || pscore == 4'd9) //if either of them has a score of 8 or 9
			current_state = `Scs;						//the game is over and socre is computed
		else begin                           //if none of them has a score of 8 or 9
			if(pscore <= 4'd5) 	     //if the player gets a score of 0-5
				current_state <= `SP3;	     //it gets the third card
			else begin			     //if the player gets a score of 6 or 7
				if(dscore <= 4'd5)           //if the dealer has a socre of 0-5, it gets the third card
				current_state <= `SD3;
				else current_state <= `Scs;   //otherwise go to the score computation state
			end
				
		end
	  `SP3: if(dscore == 4'd8 || dscore == 4'd9 ||pscore == 4'd8 || pscore == 4'd9) //if either of them has a score of 8 or 9
			current_state <= `Scs;	     //the game is over and socre is computed
	        else begin                           //if none of them has a score of 8 or 9, check if the dealer can get the third card
			if((dscore == 4'd6 && ((pcard3 == 4'd6) || (pcard3 == 4'd7))) || //banker's score from the previous two card is 6
			   (dscore == 4'd5 && ((pcard3 <= 4'd7) && (pcard3 >= 4'd4))) || //banker's score from the previous two card is 5
			   (dscore == 4'd4 && ((pcard3 <= 4'd7) && (pcard3 >= 4'd2))) || //banker's score from the previous two card is 4
			   (dscore == 4'd3 && ((pcard3 !== 4'd8))) ||			 //banker's score from the previous two card is 3
			   (dscore <= 4'd2))						 //banker's score from the previous two card is 0, 1 or 2
				current_state <= `SD3;
			else current_state <= `Scs;
		end
	  `SD3: current_state <= `Scs;  
	  `Scs: if(pscore > dscore)   //when pscore is higher, the player wins
			current_state <= `SPW;
		
		else if(pscore == dscore)   //if the scores are the same, they are tie
			current_state <= `ST;
		else current_state <= `SDW;  //else the dealer wins 
	  `SWa: current_state <= `SWa;
	  `SDW: current_state <= `SWa;
	  `SPW: current_state <= `SWa;
	    default: current_state <= `SWa;
	endcase
//--------------------------------------------------------------------------------------------------------------------------------

  end //end of if statement

end   //end of always   

/*
always_comb begin
    case(current_state)  //set the output
        `SP1: {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light} = 8'b000_100_00;  //loaded player card 1; load_d1 on
        `SD1: {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light} = 8'b010_000_00;  //loaded dealer card 1; load_p2 on
        `SP2: {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light} = 8'b000_010_00;  //loaded player card 2; load_d2 on
        `SD2: {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light} = 8'b001_000_00;  //loaded dealer card 2; load_p3 on
        `SP3: {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light} = 8'b000_001_00;  //loaded player card 3; load_d3 on
        `SD3: {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light} = 8'b000_000_00;  //loaded dealer card 3; all load off

        
        `Scs: {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light} = 8'b000_000_00;  //compute score
        `SPW: {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light} = 8'b000_000_10;  //player wins
        `SDW: {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light} = 8'b000_000_01;  //dealer wins
        `ST:  {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light} = 8'b000_000_11;  //tie
        `Sr:  {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light} = 8'b100_000_00;  //reset; load_p1 on
	`SWa: if(dscore > pscore) 		   {load_pcard1,load_pcard2,load_pcard3,load_dcard1,load_dcard2,load_dcard3,player_win_light,dealer_win_light} = 8'b000_000_01;
                        else if  (dscore < pscore) {load_pcard1,load_pcard2,load_pcard3,load_dcard1,load_dcard2,load_dcard3,player_win_light,dealer_win_light} = 8'b000_000_10;
                            else 		   {load_pcard1,load_pcard2,load_pcard3,load_dcard1,load_dcard2,load_dcard3,player_win_light,dealer_win_light} = 8'b000_000_11;
        
	default:  {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light} = 8'bxxx_xxx_xx;
    endcase
  end
*/
//======================================================


/*

always_comb begin
	case(current_state)  //set the output
		`SP1: {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light} = 8'b100_000_00;  //load player card 1
		`SD1: {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light} = 8'b000_100_00;  //load dealer card 1
		`SP2: {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light} = 8'b010_000_00;  //load player card 2
		`SD2: {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light} = 8'b000_010_00;  //load dealer card 2
		`SP3: {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light} = 8'b001_000_00;  //load player card 3
		`SD3: {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light} = 8'b000_001_00;  //load dealer card 3
		`Scs: {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light} = 8'b000_000_00;  //compute score
		`SPW: {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light} = 8'b000_000_10;  //player wins
		`SDW: {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light} = 8'b000_000_01;  //dealer wins
		`ST:  {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light} = 8'b000_000_11;  //tie
		`Sr:  {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light} = 8'b000_000_00;  //reset
	    	`SWa: if(dscore > pscore) 		   {load_pcard1,load_pcard2,load_pcard3,load_dcard1,load_dcard2,load_dcard3,player_win_light,dealer_win_light} = 8'b000_000_01;
                        else if  (dscore < pscore) {load_pcard1,load_pcard2,load_pcard3,load_dcard1,load_dcard2,load_dcard3,player_win_light,dealer_win_light} = 8'b000_000_10;
                            else 		   {load_pcard1,load_pcard2,load_pcard3,load_dcard1,load_dcard2,load_dcard3,player_win_light,dealer_win_light} = 8'b000_000_11;
        
	default:  {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light} = 8'b000_000_00;	endcase
  end

*/
endmodule

