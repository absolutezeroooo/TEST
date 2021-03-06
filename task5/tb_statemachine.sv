
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

module tb_statemachine();

reg slow_clock, resetb;
reg [3:0] dscore, pscore, pcard3;
wire load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light;

statemachine DUT (slow_clock, resetb, dscore, pscore, pcard3,
       		  load_pcard1, load_pcard2, load_pcard3, load_dcard1, 
		  load_dcard2, load_dcard3, player_win_light, dealer_win_light);
wire [7:0] out = {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light};

//------------------------------------------------------------------------------------------------------------------------
task fsm_checker;
  input [3:0] expected_state;
  input [7:0] expected_output;

begin
  if(expected_state !== tb_statemachine.DUT.current_state)
	$error("ERROR: state is %b, expectedstate is %b",tb_statemachine.DUT.current_state , expected_state);
  if(expected_output !== out)
	$error("ERROR: output is %b, expected output is %b :[pc1, pc2, pc3, dc1, dc2, dc3, pwl, dwl]", out, expected_output);
end
endtask
//----------------------------------------------------------------------------------------------------------------------------

initial begin
  //check reset
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b0_1_0110_0010_0001; //reset is pressed, entering reset state
  #10;
  fsm_checker(`Sr, 8'b000_000_00);
  resetb = 1'b1;  //set reset back to 1(unpressed)
  #10;

  //check SP1
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0010_0000; //slow_clock is pressed, enters to state SP1
  #10;
  fsm_checker(`SP1, 8'b100_000_00);  //pload1 is set to 1 here
  slow_clock = 1'b1;
  #10;

  //check SD1
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0010_0000; //slow_clock is pressed, enters to state SD1
  #10;
  fsm_checker(`SD1, 8'b000_100_00);  //dload1 is set to 1 here
  slow_clock = 1'b1;
  #10;

  //check SP2
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0010_0000; //slow_clock is pressed, enters to state SP2
  #10;
  fsm_checker(`SP2, 8'b010_000_00);  //pload2 is set to 1 here
  slow_clock = 1'b1;
  #10;

  //check SD2
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0010_0000; //slow_clock is pressed, enters to state SD2
  #10;
  fsm_checker(`SD2, 8'b000_010_00);  //dload2 is set to 1 here
  slow_clock = 1'b1;
  #10;

  //check player's score is from 0-5 after they both have 2 cards, score is both 2
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0010_0010; //slow_clock is pressed, enters to state SP3
  #10;
  fsm_checker(`SP3, 8'b001_000_00);  //pload3 is set to 1 here
  slow_clock = 1'b1;
  #10;

  //check if the dealer gets the third card
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0010_0010_0010; //slow_clock is pressed, enters to state SD3
  #10;
  fsm_checker(`SD3, 8'b000_001_00);  //dload3 is set to 1 here
  slow_clock = 1'b1;
  #10;

  //check Scs
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0010_0010_0010; //slow_clock is pressed, enters to state Scs
  #10;
  fsm_checker(`Scs, 8'b000_000_00);  //score computation state
  slow_clock = 1'b1;
  #10;

  //check Tie
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0010_0010_0010; //slow_clock is pressed, enters to state Scs
  #10;
  fsm_checker(`ST, 8'b000_000_11);  //score computation state
  slow_clock = 1'b1;
  #10;
  
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  //check reset pressed at the middle of the game
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  //check reset
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b0_1_0000_0000_0000; //reset is pressed, entering reset state
  #10;
  fsm_checker(`Sr, 8'b000_000_00);
  resetb = 1'b1;  //set reset back to 1(unpressed)
  #10;

  //check SP1
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0010_0000; //slow_clock is pressed, enters to state SP1
  #10;
  fsm_checker(`SP1, 8'b100_000_00);  //pload1 is set to 1 here
  slow_clock = 1'b1;
  #10;

  //check SD1
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0010_0000; //slow_clock is pressed, enters to state SD1
  #10;
  fsm_checker(`SD1, 8'b000_100_00);  //dload1 is set to 1 here
  slow_clock = 1'b1;
  #10;

  //check reset
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b0_1_0000_0000_0000; //reset is pressed, entering reset state directly
  #10;
  fsm_checker(`Sr, 8'b000_000_00);
  resetb = 1'b1;  //set reset back to 1(unpressed)
  #10;

  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  //check a scored 8 or 9 is appeared after they both have 2 cards and the player wins
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  //check SP1
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0010_0000; //slow_clock is pressed, enters to state SP1
  #10;
  fsm_checker(`SP1, 8'b100_000_00);  //pload1 is set to 1 here
  slow_clock = 1'b1;
  #10;

  //check SD1
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0010_0000; //slow_clock is pressed, enters to state SD1
  #10;
  fsm_checker(`SD1, 8'b000_100_00);  //dload1 is set to 1 here
  slow_clock = 1'b1;
  #10;

  //check SP2
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0010_0000; //slow_clock is pressed, enters to state SP2
  #10;
  fsm_checker(`SP2, 8'b010_000_00);  //pload2 is set to 1 here
  slow_clock = 1'b1;
  #10;

  //check SD2
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0010_0000; //slow_clock is pressed, enters to state SD2
  #10;
  fsm_checker(`SD2, 8'b000_010_00);  //dload2 is set to 1 here
  slow_clock = 1'b1;
  #10;

  //check score
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0010_1000_0000; //slow_clock is pressed, enters to state Scs
  #10;
  fsm_checker(`Scs, 8'b000_000_00);  
  slow_clock = 1'b1;
  #10;

  //check the result--->player wins
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0010_1000_0000; //slow_clock is pressed, enters to state SPW
  #10;
  fsm_checker(`SPW, 8'b000_000_10);  //player win light
  slow_clock = 1'b1;
  #10;

  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  //check a scored 8 or 9 is appeared after they both have 2 cards and the dealer wins
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  //check reset
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b0_1_0000_0000_0000; //reset is pressed, entering reset state directly
  #10;
  fsm_checker(`Sr, 8'b000_000_00);
  resetb = 1'b1;  //set reset back to 1(unpressed)
  #10;

  //check SP1
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0010_0000; //slow_clock is pressed, enters to state SP1
  #10;
  fsm_checker(`SP1, 8'b100_000_00);  //pload1 is set to 1 here
  slow_clock = 1'b1;
  #10;

  //check SD1
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0010_0000; //slow_clock is pressed, enters to state SD1
  #10;
  fsm_checker(`SD1, 8'b000_100_00);  //dload1 is set to 1 here
  slow_clock = 1'b1;
  #10;

  //check SP2
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0010_0000; //slow_clock is pressed, enters to state SP2
  #10;
  fsm_checker(`SP2, 8'b010_000_00);  //pload2 is set to 1 here
  slow_clock = 1'b1;
  #10;

  //check SD2
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0010_0000; //slow_clock is pressed, enters to state SD2
  #10;
  fsm_checker(`SD2, 8'b000_010_00);  //dload2 is set to 1 here
  slow_clock = 1'b1;
  #10;

  //check score
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_1001_1000_0000; //slow_clock is pressed, enters to state Scs
  #10;
  fsm_checker(`Scs, 8'b000_000_00);  
  slow_clock = 1'b1;
  #10;

  //check the result--->player wins
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_1001_1000_0000; //slow_clock is pressed, enters to state SDW
  #10;
  fsm_checker(`SDW, 8'b000_000_01);  //dealer win light is set to 1 here
  slow_clock = 1'b1;
  #10;

  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  //check a scored 8 or 9 is appeared after they both have 2 cards and it is a tie
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  //check reset
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b0_1_0000_0000_0000; //reset is pressed, entering reset state directly
  #10;
  fsm_checker(`Sr, 8'b000_000_00);
  resetb = 1'b1;  //set reset back to 1(unpressed)
  #10;

  //check SP1
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0010_0000; //slow_clock is pressed, enters to state SP1
  #10;
  fsm_checker(`SP1, 8'b100_000_00);  //pload1 is set to 1 here
  slow_clock = 1'b1;
  #10;

  //check SD1
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0010_0000; //slow_clock is pressed, enters to state SD1
  #10;
  fsm_checker(`SD1, 8'b000_100_00);  //dload1 is set to 1 here
  slow_clock = 1'b1;
  #10;

  //check SP2
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0010_0000; //slow_clock is pressed, enters to state SP2
  #10;
  fsm_checker(`SP2, 8'b010_000_00);  //pload2 is set to 1 here
  slow_clock = 1'b1;
  #10;

  //check SD2
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0010_0000; //slow_clock is pressed, enters to state SD2
  #10;
  fsm_checker(`SD2, 8'b000_010_00);  //dload2 is set to 1 here
  slow_clock = 1'b1;
  #10;

  //check score
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_1001_0000_0000; //slow_clock is pressed, enters to state Scs
  #10;
  fsm_checker(`Scs, 8'b000_000_00);  
  slow_clock = 1'b1;
  #10;

  //check the result--->player wins
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_1001_1001_0000; //slow_clock is pressed, enters to state ST
  #10;
  fsm_checker(`ST, 8'b000_000_11);  //both light is set to 1 here
  slow_clock = 1'b1;
  #10;

  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  //check the state when they all have three cards, D_a, DW
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  resetb = 1'b0; //reset is pressed, entering reset state directly
  #10;
  resetb = 1'b1;  //set reset back to 1(unpressed)
  #10;
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0000_0000; //slow_clock is pressed, enters to state SP1
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SD1
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SP2
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SD2
  #10;
  slow_clock = 1'b1;
  #10;
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0111_0100_0000; //player score is between 0-5, enters SP3
  #10;
  slow_clock = 1'b1;
  #10;
  //check SD3, no card
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0111_0100_0001; //slow_clock is pressed, enters to state Scs
  #10;
  fsm_checker(`Scs, 8'b000_000_00); 
  slow_clock = 1'b1;
  #10;
  //the dealer wins
  slow_clock = 1'b0; //enter SD2
  #10;
  fsm_checker(`SDW, 8'b000_000_01);
  slow_clock = 1'b1;
  #10;

  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  //check the state when they all have three cards, D_b
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  resetb = 1'b0; //reset is pressed, entering reset state directly
  #10;
  resetb = 1'b1;  //set reset back to 1(unpressed)
  #10;
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0000_0000; //slow_clock is pressed, enters to state SP1
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SD1
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SP2
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SD2
  #10;
  slow_clock = 1'b1;
  #10;
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0110_0010_0000; //player score is between 0-5, enters SP3
  #10;
  slow_clock = 1'b1;
  #10;
  //check SD3, card
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0110_0010_0110; //slow_clock is pressed, enters to state SD3
  #10;
  fsm_checker(`SD3, 8'b000_001_00); 
  slow_clock = 1'b1;
  #10;

  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  //check the state when they all have three cards, D_c
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  resetb = 1'b0; //reset is pressed, entering reset state directly
  #10;
  resetb = 1'b1;  //set reset back to 1(unpressed)
  #10;
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0000_0000; //slow_clock is pressed, enters to state SP1
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SD1
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SP2
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SD2
  #10;
  slow_clock = 1'b1;
  #10;
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0101_0010_0000; //player score is between 0-5, enters SP3
  #10;
  slow_clock = 1'b1;
  #10;
  //check SD3, card
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0101_0010_0100; //slow_clock is pressed, enters to state SD3
  #10;
  fsm_checker(`SD3, 8'b000_001_00); 
  slow_clock = 1'b1;
  #10;

  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  //check the state when they all have three cards, D_d
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  resetb = 1'b0; //reset is pressed, entering reset state directly
  #10;
  resetb = 1'b1;  //set reset back to 1(unpressed)
  #10;
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0000_0000; //slow_clock is pressed, enters to state SP1
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SD1
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SP2
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SD2
  #10;
  slow_clock = 1'b1;
  #10;
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0100_0011_0011; //player score is between 0-5, enters SP3
  #10;
  slow_clock = 1'b1;
  #10;
  //check SD3, card
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0100_0010_0011; //slow_clock is pressed, enters to state SD3
  #10;
  fsm_checker(`SD3, 8'b000_001_00); 
  slow_clock = 1'b1;
  #10;

  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  //check the state when they all have three cards, D_e
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  resetb = 1'b0; //reset is pressed, entering reset state directly
  #10;
  resetb = 1'b1;  //set reset back to 1(unpressed)
  #10;
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0000_0000; //slow_clock is pressed, enters to state SP1
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SD1
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SP2
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SD2
  #10;
  slow_clock = 1'b1;
  #10;
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0011_0000_1001; //player score is between 0-5, enters SP3
  #10;
  slow_clock = 1'b1;
  #10;
  //check SD3, card
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0011_0000_1001; //slow_clock is pressed, enters to state SD3
  #10;
  fsm_checker(`SD3, 8'b000_001_00); 
  slow_clock = 1'b1;
  #10;

  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  //check the state when they all have three cards, D_f
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  resetb = 1'b0; //reset is pressed, entering reset state directly
  #10;
  resetb = 1'b1;  //set reset back to 1(unpressed)
  #10;
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0000_0000; //slow_clock is pressed, enters to state SP1
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SD1
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SP2
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SD2
  #10;
  slow_clock = 1'b1;
  #10;
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0010_0011; //player score is between 0-5, enters SP3
  #10;
  slow_clock = 1'b1;
  #10;
  //check SD3, card
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0010_0011; //slow_clock is pressed, enters to state SD3
  #10;
  fsm_checker(`SD3, 8'b000_001_00); 
  slow_clock = 1'b1;
  #10;

  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  //check the state when they all have three cards, D_d, no card
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  resetb = 1'b0; //reset is pressed, entering reset state directly
  #10;
  resetb = 1'b1;  //set reset back to 1(unpressed)
  #10;
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0000_0000; //slow_clock is pressed, enters to state SP1
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SD1
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SP2
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SD2
  #10;
  slow_clock = 1'b1;
  #10;
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0100_0011_0001; //player score is between 0-5, enters SP3
  #10;
  slow_clock = 1'b1;
  #10;
  //check SD3, card
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0100_0011_0001; //slow_clock is pressed, no card
  #10;
  fsm_checker(`Scs, 8'b000_000_00); 
  slow_clock = 1'b1;
  #10;

  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  //check no P3, dealer has the third card
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  resetb = 1'b0; //reset is pressed, entering reset state directly
  #10;
  resetb = 1'b1;  //set reset back to 1(unpressed)
  #10;
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0000_0000; //slow_clock is pressed, enters to state SP1
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SD1
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SP2
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SD2
  #10;
  slow_clock = 1'b1;
  #10;
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0100_0111_0000; //player score is not between 0-5, dealer score is between 0-5, enters SD3
  #10;
  fsm_checker(`SD3, 8'b000_001_00); 
  slow_clock = 1'b1;
  #10;
  //check Scs
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0101_0111_0000; 
  #10;
  fsm_checker(`Scs, 8'b000_000_00); 
  slow_clock = 1'b1;
  #10;
  //check SPW
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0101_0111_0000; 
  #10;
  fsm_checker(`SPW, 8'b000_000_10); 
  slow_clock = 1'b1;
  #10;

  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  //check no P3, no D3
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  resetb = 1'b0; //reset is pressed, entering reset state directly
  #10;
  resetb = 1'b1;  //set reset back to 1(unpressed)
  #10;
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0000_0000; //slow_clock is pressed, enters to state SP1
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SD1
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SP2
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SD2
  #10;
  slow_clock = 1'b1;
  #10;
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0110_0110_0000; //player score is not between 0-5, dealer score is not between 0-5, enters Scs
  #10;
  fsm_checker(`Scs, 8'b000_000_00); 
  slow_clock = 1'b1;
  #10;
  //check ST
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0110_0110_0000; 
  #10;
  fsm_checker(`ST, 8'b000_000_11); 
  slow_clock = 1'b1;
  #10;

  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  //check the state when P has the third card and got a score of 9
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  resetb = 1'b0; //reset is pressed, entering reset state directly
  #10;
  resetb = 1'b1;  //set reset back to 1(unpressed)
  #10;
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0000_0000_0000; //slow_clock is pressed, enters to state SP1
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SD1
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SP2
  #10;
  slow_clock = 1'b1;
  #10;
  slow_clock = 1'b0; //enter SD2
  #10;
  slow_clock = 1'b1;
  #10;
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0100_0011_0110; //player score is between 0-5, enters SP3
  #10;
  slow_clock = 1'b1;
  #10;
  //check game done
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0100_1001_0110; //slow_clock is pressed, the game is over
  #10;
  fsm_checker(`Scs, 8'b000_000_00); 
  slow_clock = 1'b1;
  #10;
  //check player win
  {resetb, slow_clock, dscore, pscore, pcard3} = 14'b1_0_0100_1001_0110; //slow_clock is pressed, the game is over
  #10;
  fsm_checker(`SPW, 8'b000_000_10); 
  slow_clock = 1'b1;
  #10;

$display("done");
$stop;
end  //end initial

endmodule

