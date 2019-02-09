/*-----------------------------------------------
/ Components used in the design
/ 4x1 MUS used in the boolean unit in ALU - Design
/------------------------------------------------*/
module MUX4x1(input wire[3:0] in, input wire[1:0] sel, output wire out);
assign out = in[sel];
endmodule
/*-----------------------------------------------
/ Components used in the design
/ 4x1 MUS used in the boolean unit in ALU - Test Bench
/------------------------------------------------*/
module MUX4x1_TB;
reg[31:0] IN = 0'b10110110011010110110101010101011;
reg[31:0] SEL = 0'b11010101011111100101011010101011;
wire OUT; 
reg[5:0] i;
reg test;
initial 
begin
	$monitor ("Inputs = %b , Sel = %b , Output = %b, test = %b", IN[3:0], SEL[1:0], OUT, test);
	for ( i=0 ; i<32; i=i+1)
	begin
	#10
	if ( OUT == IN[SEL[1:0]] )
	begin
		test =1;
	end
	else
	begin
		test =0;
	end
	IN = IN >> 1;
	SEL = SEL >> 1;
	end
end

MUX4x1 myMUX(IN[3:0], SEL[1:0], OUT);
endmodule

