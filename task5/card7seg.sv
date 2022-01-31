module card7seg(input [3:0] card, output logic[6:0] seg7);


    always_comb begin
	case (card)
	    4'b0001: seg7 = 7'b0001_000;
	    4'b0010: seg7 = 7'b0100_100;
	    4'b0011: seg7 = 7'b0110_000;
	    4'b0100: seg7 = 7'b0011_001;
	    4'b0101: seg7 = 7'b0010_010;
	    4'b0110: seg7 = 7'b0000_010;
	    4'b0111: seg7 = 7'b1111_000;
	    4'b1000: seg7 = 7'b0000_000;
	    4'b1001: seg7 = 7'b0010_000;
	    4'b1010: seg7 = 7'b1000_000;
	    4'b1011: seg7 = 7'b1100_001;
	    4'b1100: seg7 = 7'b0011_000;
	    4'b1101: seg7 = 7'b0001_001;
	    default: seg7 = 7'b1111_111;
	endcase
    end

endmodule

