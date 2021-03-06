module tb_card7seg();

reg [3:0] SW;
reg err;
wire [6:0] HEX0;

card7seg DUT(SW, HEX0);

task my_checker;
 input [6:0] hexnumber;
 input [6:0] expectednum;

begin
 if(hexnumber !== expectednum)begin
	$display("ERROR: hexnumber is %b, expectednum is %b", hexnumber, expectednum);
	err = 1'b1;

 end
end
endtask

initial begin

//checking no inputs
SW = 4'b0000;
err = 1'b0;
#10

$display("checking 0---");
my_checker(HEX0, 7'b1111_111);
//-------------------------------------

//checking A
SW = 4'b0001;
#10
$display("checking A---");
my_checker(HEX0, 7'b0001_000); //A
//-------------------------------------

//checking 2
SW = 4'b0010;
#10
$display("checking 2---");
my_checker(HEX0, 7'b0100_100); //2
//-------------------------------------

//checking 3
SW = 4'b0011;
#10
$display("checking 3---");
my_checker(HEX0, 7'b0110_000); //3
//-------------------------------------

//checking 4
SW = 4'b0100;
#10
$display("checking 4---");
my_checker(HEX0, 7'b0011_001); //4
//-------------------------------------

//checking 5
SW = 4'b0101;
#10
$display("checking 5---");
my_checker(HEX0, 7'b0010_010); //5
//-------------------------------------

//checking 6
SW = 4'b0110;
#10
$display("checking 6---");
my_checker(HEX0, 7'b0000_010); //6
//-------------------------------------

//checking 7
SW = 4'b0111;
#10
$display("checking 7---");
my_checker(HEX0, 7'b1111_000); //7
//-------------------------------------

//checking 8
SW = 4'b1000;
#10
$display("checking 8---");
my_checker(HEX0, 7'b0000_000); //8
//-------------------------------------

//checking 9
SW = 4'b1001;
#10
$display("checking 9---");
my_checker(HEX0, 7'b0010_000); //9
//-------------------------------------

//checking 10
SW = 4'b1010;
#10
$display("checking 10---");
my_checker(HEX0, 7'b1000_000); //10
//-------------------------------------

//checking J
SW = 4'b1011;
#10
$display("checking J---");
my_checker(HEX0, 7'b1100_001); //J
//-------------------------------------

//checking Q
SW = 4'b1100;
#10
$display("checking Q---");
my_checker(HEX0, 7'b0011_000); //Q
//-------------------------------------

//checking K
SW = 4'b1101;
#10
$display("checking K---");
my_checker(HEX0, 7'b0001_001); //K
//-------------------------------------

//checking other situations
SW = 4'b1110;
#10
$display("checking other situations:1110");
my_checker(HEX0, 7'b1111_111); //other situations
//-------------------------------------

//checking other situations
SW = 4'b1111;
#10
$display("checking other situations:1111");
my_checker(HEX0, 7'b1111_111); //other situations
//-------------------------------------
$stop;
end

						
endmodule

