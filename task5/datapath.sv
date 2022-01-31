module datapath(input slow_clock, input fast_clock, input resetb,
                input load_pcard1, input load_pcard2, input load_pcard3,
                input load_dcard1, input load_dcard2, input load_dcard3,
                output [3:0] pcard3_out,
                output [3:0] pscore_out, output [3:0] dscore_out,
                output[6:0] HEX5, output[6:0] HEX4, output[6:0] HEX3,
                output[6:0] HEX2, output[6:0] HEX1, output[6:0] HEX0);

logic [3:0] pc1, pc2, pc3, dc1, dc2, dc3, nc;
assign pcard3_out = pc3;
dealcard newcard(fast_clock, resetb, nc);

reg4 P1(slow_clock, nc, resetb, load_pcard1, pc1);
reg4 P2(slow_clock, nc, resetb, load_pcard2, pc2);
reg4 P3(slow_clock, nc, resetb, load_pcard3, pc3);
reg4 D1(slow_clock, nc, resetb, load_dcard1, dc1);
reg4 D2(slow_clock, nc, resetb, load_dcard2, dc2);
reg4 D3(slow_clock, nc, resetb, load_dcard3, dc3);

scorehand player_score(pc1, pc2, pc3, pscore_out);
scorehand dealer_score(dc1, dc2, dc3, dscore_out);
card7seg p1(pc1, HEX0);
card7seg p2(pc2, HEX1);
card7seg p3(pc3, HEX2);
card7seg d1(dc1, HEX3);
card7seg d2(dc2, HEX4);
card7seg d3(dc3, HEX5);
					
endmodule

module reg4(clk, in, reset, load, out);
  parameter n = 4;
  input clk, reset, load;
  input [n-1:0] in;
  output [n-1:0] out;
  reg [n-1:0] out;

always_ff @(posedge !clk or posedge !reset) begin //or posedge !reset
	if(reset == 0)
	out <= 4'b0;
	else
	out <= load ? in : out;
end
endmodule
	
