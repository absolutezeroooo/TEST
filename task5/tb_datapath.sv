module tb_datapath();

logic err, key, clk, resetb, load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3;
wire [3:0] pcard3_out, pscore_out, dscore_out;
wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;


datapath DUT (key, clk, resetb, load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3,
              pcard3_out, pscore_out, dscore_out,
              HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);

//---------TASK---------------------------------------------------------------------------------------------------------
task dp_checker;
    input [3:0] expected_ps, expected_ds;
    input [20:0] hexp;
    input [20:0] hexd;
begin
    if(pscore_out !== expected_ps)begin
	err = 1'b1;
	$error("player score incorrect, expect %b, get %b", expected_ps, pscore_out);
    end
    if(dscore_out !== expected_ds)begin
	err = 1'b1;
	$error("dealer score incorrect, expect %b, get %b", expected_ds, dscore_out);
    end

    if(hexp !== {HEX0,HEX1,HEX2})begin
	err = 1'b1;
	$error("hex number incorrect, expected %b, get %b", hexp, {HEX0,HEX1,HEX2});
    end

   if(hexd !== {HEX3,HEX4,HEX5})begin
	err = 1'b1;
	$error("hex number incorrect, expected %b, get %b", hexd, {HEX3,HEX4,HEX5});
   end
end
endtask
//----------------------------------------------------------------------------------------------------------------------				
initial begin
  clk = 0; #5;
  forever begin
	clk = 1; #10;
	clk = 0; #10;
  end  //end of forever
end  //end of initial

initial begin
  err = 1'b0;

//``````````````````CHECK RESET```````````````````````````````````````````````````````````````````````````

  resetb = 1'b0;  //set reset to 0, which is the state pressed
  key = 1'b1;
  {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3} = 6'b000_000;  //set all load to 0
  #10;
  if(tb_datapath.DUT.pc1 !== 4'b0000)
  $error("p card 1 is incorrect");
  if(tb_datapath.DUT.pc2 !== 4'b0000)
  $error("p card 2 is incorrect");
  if(pcard3_out !== 4'b0000)
  $error("p card 3 is incorrect");
  if(tb_datapath.DUT.dc1 !== 4'b0000)
  $error("d card 1 is incorrect");
  if(tb_datapath.DUT.dc2 !== 4'b0000)
  $error("d card 2 is incorrect");
  if(tb_datapath.DUT.dc3 !== 4'b0000)
  $error("d card 3 is incorrect"); 
  dp_checker(4'b0, 4'b0, 21'b111_1111_111_1111_111_1111, 21'b111_1111_111_1111_111_1111);
  resetb = 1'b1; //release reset
  #10;

//```````````````````````````````````````````````````````````````````````````````````````````````````````````````
//check load are all 1, with reset, check if they are all 0
//```````````````````````````````````````````````````````````````````````````````````````````````````````````````
  resetb = 1'b0;  //set reset to 0, which is the state pressed
  key = 1'b1;
  {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3} = 6'b111_111;  //set all load to 0
  #10;
  if(tb_datapath.DUT.pc1 !== 4'b0000)
  $error("p card 1 is incorrect");
  if(tb_datapath.DUT.pc2 !== 4'b0000)
  $error("p card 2 is incorrect");
  if(pcard3_out !== 4'b0000)
  $error("p card 3 is incorrect");
  if(tb_datapath.DUT.dc1 !== 4'b0000)
  $error("d card 1 is incorrect");
  if(tb_datapath.DUT.dc2 !== 4'b0000)
  $error("d card 2 is incorrect");
  if(tb_datapath.DUT.dc3 !== 4'b0000)
  $error("d card 3 is incorrect"); 
  dp_checker(4'b0, 4'b0, 21'b111_1111_111_1111_111_1111, 21'b111_1111_111_1111_111_1111);
  resetb = 1'b1; //release reset
  #10;

//```````````````````````````````````````````````````````````````````````````````````````````````````````````````
//check load p1
//```````````````````````````````````````````````````````````````````````````````````````````````````````````````
  key = 1'b0; //press
  {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3} = 6'b100_000;  //set all load to 0
  #10;
  if((tb_datapath.DUT.pc1 == 4'b0000)||(tb_datapath.DUT.pc1 >= 4'b1110)) //card should be loaded now
  $error("p card 1 is incorrect");
  if(tb_datapath.DUT.pc2 !== 4'b0000)
  $error("p card 2 is incorrect");
  if(pcard3_out !== 4'b0000)
  $error("p card 3 is incorrect");
  if(tb_datapath.DUT.dc1 !== 4'b0000)
  $error("d card 1 is incorrect");
  if(tb_datapath.DUT.dc2 !== 4'b0000)
  $error("d card 2 is incorrect");
  if(tb_datapath.DUT.dc3 !== 4'b0000)
  $error("d card 3 is incorrect"); 
  if(HEX0 == 7'b1111_111)
  $error("hex0 display is incorrect");
  if(dscore_out !== 4'b0)
  $error("dscore is incorrect");
  if(pscore_out >= 4'b1010)
  $error("pscore is incorrect");  
  key = 1'b1;
  #10;

//```````````````````````````````````````````````````````````````````````````````````````````````````````````````
//check load d1
//```````````````````````````````````````````````````````````````````````````````````````````````````````````````
  key = 1'b0; //press
  {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3} = 6'b000_100;  //set all load to 0
  #10;

  if((tb_datapath.DUT.pc1 == 4'b0000)||(tb_datapath.DUT.pc1 >= 4'b1110)) begin //card should remain its value
  $error("p card 1 is incorrect");
  err = 1'b1;
  end

  if(tb_datapath.DUT.pc2 !== 4'b0000) begin
  $error("p card 2 is incorrect");
  err = 1'b1;
  end

  if(pcard3_out !== 4'b0000) begin
  $error("p card 3 is incorrect");
  err = 1'b1;
  end

  if((tb_datapath.DUT.dc1 == 4'b0000)||(tb_datapath.DUT.dc1 >= 4'b1110)) begin //card should be loaded now
  $error("d card 1 is incorrect");
  err = 1'b1;
  end

  if(tb_datapath.DUT.dc2 !== 4'b0000) begin
  $error("d card 2 is incorrect");
  err = 1'b1;
  end

  if(tb_datapath.DUT.dc3 !== 4'b0000) begin
  $error("d card 3 is incorrect"); 
  err = 1'b1;
  end

  if(HEX0 == 7'b1111_111) begin
  $error("hex0 display is incorrect");
  err = 1'b1;
  end

  if(HEX3 == 7'b1111_111) begin
  $error("hex3 display is incorrect");
  err = 1'b1;
  end

  if(dscore_out >= 4'b1010) begin
  $error("dscore is incorrect");
  err = 1'b1;
  end

  if(pscore_out >= 4'b1010) begin
  $error("pscore is incorrect");  
  err = 1'b1;
  end

  key = 1'b1;
  #10;

//```````````````````````````````````````````````````````````````````````````````````````````````````````````````
//check load p2
//```````````````````````````````````````````````````````````````````````````````````````````````````````````````
  key = 1'b0; //press
  {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3} = 6'b010_000;  //set all load to 0
  #10;

  if((tb_datapath.DUT.pc1 == 4'b0000)||(tb_datapath.DUT.pc1 >= 4'b1110)) begin //card should remain its value
  $error("p card 1 is incorrect");
  err = 1'b1;
  end

  if((tb_datapath.DUT.pc2 == 4'b0000)||(tb_datapath.DUT.pc2 >= 4'b1110)) begin //card should be loaded
  $error("p card 2 is incorrect");
  err = 1'b1;
  end

  if(pcard3_out !== 4'b0000) begin
  $error("p card 3 is incorrect");
  err = 1'b1;
  end

  if((tb_datapath.DUT.dc1 == 4'b0000)||(tb_datapath.DUT.dc1 >= 4'b1110)) begin //card should remain its value
  $error("d card 1 is incorrect");
  err = 1'b1;
  end

  if(tb_datapath.DUT.dc2 !== 4'b0000) begin
  $error("d card 2 is incorrect");
  err = 1'b1;
  end

  if(tb_datapath.DUT.dc3 !== 4'b0000) begin
  $error("d card 3 is incorrect"); 
  err = 1'b1;
  end

  if(HEX0 == 7'b1111_111) begin
  $error("hex0 display is incorrect");
  err = 1'b1;
  end

  if(HEX1 == 7'b1111_111) begin
  $error("hex1 display is incorrect");
  err = 1'b1;
  end

  if(HEX3 == 7'b1111_111) begin
  $error("hex3 display is incorrect");
  err = 1'b1;
  end

  if(dscore_out >= 4'b1010) begin
  $error("dscore is incorrect");
  err = 1'b1;
  end

  if(pscore_out >= 4'b1010) begin
  $error("pscore is incorrect");  
  err = 1'b1;
  end

  key = 1'b1;
  #10;


//```````````````````````````````````````````````````````````````````````````````````````````````````````````````
//check reset interuption
//```````````````````````````````````````````````````````````````````````````````````````````````````````````````
  resetb = 1'b0;  //set reset to 0, which is the state pressed
  key = 1'b1;
  {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3} = 6'b000_000;  //set all load to 0
  #10;
  if(tb_datapath.DUT.pc1 !== 4'b0000)
  $error("p card 1 is incorrect");
  if(tb_datapath.DUT.pc2 !== 4'b0000)
  $error("p card 2 is incorrect");
  if(pcard3_out !== 4'b0000)
  $error("p card 3 is incorrect");
  if(tb_datapath.DUT.dc1 !== 4'b0000)
  $error("d card 1 is incorrect");
  if(tb_datapath.DUT.dc2 !== 4'b0000)
  $error("d card 2 is incorrect");
  if(tb_datapath.DUT.dc3 !== 4'b0000)
  $error("d card 3 is incorrect"); 
  dp_checker(4'b0, 4'b0, 21'b111_1111_111_1111_111_1111, 21'b111_1111_111_1111_111_1111);
  resetb = 1'b1; //release reset
  #10;

  $display("DONE");
  $stop;
end  //end of the second initial



endmodule

