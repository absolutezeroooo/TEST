module tb_task5();
logic clk, err;
logic [3:0] KEY, dscore, pscore;
logic [9:0] LEDR;
wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
logic reset, control, pwl, dwl;
logic [5:0] load;


task5 DUT(clk, KEY,
 	  LEDR, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);

assign KEY[2:1] = 2'b0;
assign load = {tb_task5.DUT.load_pcard1,tb_task5.DUT.load_pcard2,tb_task5.DUT.load_pcard3,
	       tb_task5.DUT.load_dcard1,tb_task5.DUT.load_dcard2,tb_task5.DUT.load_dcard3};
assign KEY[3] = reset;
assign KEY[0] = control;
assign {dwl,pwl,dscore,pscore} = LEDR;
initial begin
  clk = 0; #10;
  forever begin
	clk = 1; #10;
	clk = 0; #10;
  end  //end of forever
end  //end of initial

initial begin
  err = 1'b0;
  #10

//-----TEST RESET----------------------------------------------------------------------------------------------
  reset = 1'b0; control = 1'b1;
  #10
  if(load !== 6'b100_000) begin  //all load should be 0 if reset is pressed
	$error("load is incorrect, expected 100000, the value is %b", load);
	err = 1'b1;
  end

  if({HEX5,HEX4,HEX3} !== 21'b111_1111_111_1111_111_1111) begin  //none of the LED should display
	$error("the dealer hex display is incorrect");
	err = 1'b1;
  end

  if({HEX2,HEX1,HEX0} !== 21'b111_1111_111_1111_111_1111) begin  //none of the LED should display
	$error("the player hex display is incorrect");
	err = 1'b1;
  end

  if(LEDR !== 10'b0) begin
	$error("The LED is incorrect");
	err = 1'b1;	
  end

  if((tb_task5.DUT.pscore !== 4'b0) || (tb_task5.DUT.dscore !== 4'b0) || (tb_task5.DUT.pcard3) !== 0) begin
  	$error("The scores/pcard3 is incorrect");
	err = 1'b1;	
  end
  reset = 1'b1;
  #10
//-------------------------------------------------------------------------------------------------------------


//-------------------------------------TEST P1--------------------------------------------------------------
  control = 1'b0;  //press key
  #10
  if(load !== 6'b100_000) begin  //the first load should be setted to 1 now
	$error("load is incorrect, expected 000100, the value is %b", load);
	err = 1'b1;
  end

  if({HEX5,HEX4,HEX3} !== 21'b111_1111_111_1111_111_1111) begin  //none of the LED should display
	$error("the dealer hex display is incorrect");
	err = 1'b1;
  end

  if({HEX2,HEX1,HEX0} == 21'b111_1111_111_1111_111_1111) begin  //the LED should display something now
	$error("the player hex display is incorrect");
	err = 1'b1;
  end

  if(pscore !== tb_task5.DUT.pscore) begin
	$error("Pscore is incorrect");
	err = 1'b1;	
  end

  if(dscore !== tb_task5.DUT.dscore) begin
	$error("Dscore is incorrect");
	err = 1'b1;	
  end

  if(pwl !== 1'b0) begin
	$error("The player LED is incorrect");
	err = 1'b1;	
  end

  if(dwl !== 1'b0) begin
	$error("The dealer LED is incorrect");
	err = 1'b1;	
  end

  if((tb_task5.DUT.pscore >= 4'b1010) || (tb_task5.DUT.dscore !== 4'b0) || (tb_task5.DUT.pcard3) !== 0) begin
  	$error("The scores/pcard3 is incorrect");
	err = 1'b1;	
  end

  control = 1'b1;
  #10
//-------------------------------------------------------------------------------------------------------------

//-------------------------------------TEST D1--------------------------------------------------------------
  control = 1'b0;  //press key
  #10
  if(load !== 6'b000_100) begin  //the first load should be setted to 1 now
	$error("load is incorrect, expected 010000, the value is %b", load);
	err = 1'b1;
  end

  if({HEX5,HEX4,HEX3} == 21'b111_1111_111_1111_111_1111) begin  //the LED should display something now
	$error("the dealer hex display is incorrect");
	err = 1'b1;
  end

  if({HEX2,HEX1,HEX0} == 21'b111_1111_111_1111_111_1111) begin  //the LED should display something now
	$error("the player hex display is incorrect");
	err = 1'b1;
  end

  if(pscore !== tb_task5.DUT.pscore) begin
	$error("Pscore is incorrect");
	err = 1'b1;	
  end

  if(dscore !== tb_task5.DUT.dscore) begin
	$error("Dscore is incorrect");
	err = 1'b1;	
  end

  if(pwl !== 1'b0) begin
	$error("The player LED is incorrect");
	err = 1'b1;	
  end

  if(dwl !== 1'b0) begin
	$error("The dealer LED is incorrect");
	err = 1'b1;	
  end

  if((tb_task5.DUT.pscore >= 4'b1010) || (tb_task5.DUT.dscore >= 4'b1010) || (tb_task5.DUT.pcard3) !== 0) begin
  	$error("The scores/pcard3 is incorrect");
	err = 1'b1;	
  end

  control = 1'b1;
  #10
//-------------------------------------------------------------------------------------------------------------

//-------------------------------------TEST P2--------------------------------------------------------------
  control = 1'b0;  //press key
  #10
  if(load !== 6'b010_000) begin  //the first load should be setted to 1 now
	$error("load is incorrect, expected 000010, the value is %b", load);
	err = 1'b1;
  end

  if({HEX5,HEX4,HEX3} == 21'b111_1111_111_1111_111_1111) begin  //the LED should display something now
	$error("the dealer hex display is incorrect");
	err = 1'b1;
  end

  if({HEX2,HEX1,HEX0} == 21'b111_1111_111_1111_111_1111) begin  //the LED should display something now
	$error("the player hex display is incorrect");
	err = 1'b1;
  end

  if(pscore !== tb_task5.DUT.pscore) begin
	$error("Pscore is incorrect");
	err = 1'b1;	
  end

  if(dscore !== tb_task5.DUT.dscore) begin
	$error("Dscore is incorrect");
	err = 1'b1;	
  end

  if(pwl !== 1'b0) begin
	$error("The player LED is incorrect");
	err = 1'b1;	
  end

  if(dwl !== 1'b0) begin
	$error("The dealer LED is incorrect");
	err = 1'b1;	
  end

  if((tb_task5.DUT.pscore >= 4'b1010) || (tb_task5.DUT.dscore >= 4'b1010) || (tb_task5.DUT.pcard3) !== 0) begin
  	$error("The scores/pcard3 is incorrect");
	err = 1'b1;	
  end

  control = 1'b1;
  #10
//-------------------------------------------------------------------------------------------------------------

//-------------------------------------TEST D2--------------------------------------------------------------
  control = 1'b0;  //press key
  #10
  if(load !== 6'b000_010) begin  //the first load should be setted to 1 now
	$error("load is incorrect, expected 001000, the value is %b", load);
	err = 1'b1;
  end

  if({HEX5,HEX4,HEX3} == 21'b111_1111_111_1111_111_1111) begin  //the LED should display something now
	$error("the dealer hex display is incorrect");
	err = 1'b1;
  end

  if({HEX2,HEX1,HEX0} == 21'b111_1111_111_1111_111_1111) begin  //the LED should display something now
	$error("the player hex display is incorrect");
	err = 1'b1;
  end

  if(pscore !== tb_task5.DUT.pscore) begin
	$error("Pscore is incorrect");
	err = 1'b1;	
  end

  if(dscore !== tb_task5.DUT.dscore) begin
	$error("Dscore is incorrect");
	err = 1'b1;	
  end

  if(pwl !== 1'b0) begin
	$error("The player LED is incorrect");
	err = 1'b1;	
  end

  if(dwl !== 1'b0) begin
	$error("The dealer LED is incorrect");
	err = 1'b1;	
  end

  if((tb_task5.DUT.pscore >= 4'b1010) || (tb_task5.DUT.dscore >= 4'b1010) || (tb_task5.DUT.pcard3) !== 0) begin
  	$error("The scores/pcard3 is incorrect");
	err = 1'b1;	
  end

  control = 1'b1;
  #10
//-------------------------------------------------------------------------------------------------------------

//---------------------------TEST PLAYER/DEALER WIN LIGHT------------------------------------------------------
control = 1'b0;
#10
control = 1'b1;
#10
control = 1'b0;
#10
control = 1'b1;
#10
control = 1'b0;
#10
control = 1'b1;  //since after the game ends, the system will do nothing untill reset is pressed
#10              //this step is to make sure that it has entered the ending state

  if(load !== 6'b000_000) begin  //the first load should be setted to 1 now
	$error("load is incorrect, expected 000000, the value is %b", load);
	err = 1'b1;
  end

  if({HEX5,HEX4,HEX3} == 21'b111_1111_111_1111_111_1111) begin  //the LED should display something now
	$error("the dealer hex display is incorrect");
	err = 1'b1;
  end

  if({HEX2,HEX1,HEX0} == 21'b111_1111_111_1111_111_1111) begin  //the LED should display something now
	$error("the player hex display is incorrect");
	err = 1'b1;
  end

  if(pscore !== tb_task5.DUT.pscore) begin
	$error("Pscore is incorrect");
	err = 1'b1;	
  end

  if(dscore !== tb_task5.DUT.dscore) begin
	$error("Dscore is incorrect");
	err = 1'b1;	
  end

  if({pwl,dwl} == 2'b00) begin  //at least one light should be 1
	$error("The LED is incorrect");
	err = 1'b1;	
  end


  if((tb_task5.DUT.pscore >= 4'b1010) || (tb_task5.DUT.dscore >= 4'b1010) || (tb_task5.DUT.pcard3) >= 4'b1010) begin
  	$error("The scores/pcard3 is incorrect");
	err = 1'b1;	
  end
  control = 1'b1;
  #10
//---------------------------------------------------------------------------------------------------------------



//-----TEST RESET----------------------------------------------------------------------------------------------
  reset = 1'b0; control = 1'b1;
  #10
  if(load !== 6'b100_000) begin  //all load should be 0 if reset is pressed
	$error("load is incorrect, expected 000000, the value is %b", load);
	err = 1'b1;
  end

  if({HEX5,HEX4,HEX3} !== 21'b111_1111_111_1111_111_1111) begin  //none of the LED should display
	$error("the dealer hex display is incorrect");
	err = 1'b1;
  end

  if({HEX2,HEX1,HEX0} !== 21'b111_1111_111_1111_111_1111) begin  //none of the LED should display
	$error("the player hex display is incorrect");
	err = 1'b1;
  end

  if(LEDR !== 10'b0) begin
	$error("The LED is incorrect");
	err = 1'b1;	
  end

  if((tb_task5.DUT.pscore !== 4'b0) || (tb_task5.DUT.dscore !== 4'b0) || (tb_task5.DUT.pcard3) !== 0) begin
  	$error("The scores/pcard3 is incorrect");
	err = 1'b1;	
  end
  reset = 1'b1;
  #10
//-------------------------------------------------------------------------------------------------------------
  $display("DONE");

  $stop;
end				
endmodule

