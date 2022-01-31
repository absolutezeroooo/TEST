module scorehand(input logic[3:0] card1, input logic[3:0] card2, input logic[3:0] card3, output logic[3:0] total);

// The code describing scorehand will go here.  Remember this is a combinational
// block. The function is described in the handout.  Be sure to review the section
// on representing numbers in the lecture notes.
reg [3:0] c1, c2, c3;
reg [5:0] num;
always_comb begin
    if(card1 >= 4'b1010)
	c1 = 4'b0000;
    else
	c1 = card1;

    if(card2 >= 4'b1010)
	c2 = 4'b0000;
    else
	c2 = card2;

    if(card3 >= 4'b1010)
	c3 = 4'b0000;
    else
	c3 = card3;

num = (c1 + c2 + c3)%6'd10;
total = num[3:0];

end
endmodule

