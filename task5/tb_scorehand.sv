module tb_scorehand();

// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 10,000 ticks (equivalent to "initial #10000 $finish();").

reg [3:0] card1, card2, card3;
wire [3:0] score;

scorehand DUT(card1, card2, card3, score);

//--------------------------------------------------------------------------------------------------------
task fs_checker;
 input [3:0] scorenumber;
 input [3:0] expectednum;

  if(scorenumber !== expectednum)begin
	$error("ERROR: scorenumber is %b, expectednum is %b", scorenumber, expectednum);
  end
endtask

//--------------------------------------------------------------------------------------------------------
initial begin

//all 3 cards 0
card1 = 4'd0;
card2 = 4'd0;
card3 = 4'd0;
#10
fs_checker(score, 4'd0);
#10


//one card A, the other two 0
card1 = 4'd0;
card2 = 4'd1;
card3 = 4'd0;
#10
fs_checker(score, 4'd1);

#10
//one card 2, the other two 0
card1 = 4'd0;
card2 = 4'd0;
card3 = 4'd2;
#10
fs_checker(score, 4'd2);

#10
//3 + 2 + 4
card1 = 4'd3;
card2 = 4'd2;
card3 = 4'd4;
#10
fs_checker(score, 4'd9);

#10
//1 + 9 + 0
card1 = 4'd1;
card2 = 4'd9;
card3 = 4'd0;
#10
fs_checker(score, 4'd0);

#10
//9 + 1 + 2
card1 = 4'd9;
card2 = 4'd1;
card3 = 4'd2;
#10
fs_checker(score, 4'd2);

#10
//10 + 10 + 10
card1 = 4'd10;
card2 = 4'd10;
card3 = 4'd10;
#10
fs_checker(score, 4'd0);

#10
//1 + 10 + 12
card1 = 4'd1;
card2 = 4'd10;
card3 = 4'd12;
#10
fs_checker(score, 4'd1);

#10
//15 + 15 + 15
card1 = 4'd15;
card2 = 4'd15;
card3 = 4'd15;
#10
fs_checker(score, 4'd0);

#10
//13 + 13 + 13
card1 = 4'd13;
card2 = 4'd13;
card3 = 4'd13;
#10
fs_checker(score, 4'd0);

#10
//7 + 8 + 6
card1 = 4'd7;
card2 = 4'd8;
card3 = 4'd6;
#10
fs_checker(score, 4'd1);

#10
//0 + 13 + 13
card1 = 4'd0;
card2 = 4'd13;
card3 = 4'd13;
#10
fs_checker(score, 4'd0);

#10
//9 + 9 + 9
card1 = 4'd9;
card2 = 4'd9;
card3 = 4'd9;
#10
fs_checker(score, 4'd7);


#10
//13 + 1 + 6
card1 = 4'd13;
card2 = 4'd1;
card3 = 4'd6;
#10
fs_checker(score, 4'd7);

#10
//12 + 11 + 9
card1 = 4'd12;
card2 = 4'd11;
card3 = 4'd9;
#10
fs_checker(score, 4'd9);

#10
$stop;
end	
				
endmodule

