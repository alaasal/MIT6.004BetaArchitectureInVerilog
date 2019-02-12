module PC ( 
	input wire[31:0] JT,
	input wire[15:0] SXT, //make sure of the width
	input wire[3:0] PCSEL,
	input wire CLK,
	input wire RESET,
	output reg[31:0] PC, 
	output reg[31:0] PC_INC,
	output reg[31:0] PC_SXT );
initial
begin
PC = 0;
PC_INC=0;
PC_SXT=0;
end


always @(posedge CLK)
begin
if ( RESET == 1)
begin 
	PC <= 'h80000000;
end
else
begin
	if( PCSEL == 0'b000 ) 
	begin 
		PC = PC_INC; 
		PC_INC <= PC + 4; 
	end
	else if ( PCSEL == 0'b001 ) 
	begin 
		PC = PC_INC + 4 + 4 * SXT;
		PC_INC <= PC + 4;
	end 
	else if ( PCSEL == 0'b010 ) 
	begin 
		PC = JT;
		PC_INC <= PC + 4;
	end 
	else if ( PCSEL == 0'b011 ) 
	begin 
		PC = 'h80000004;
		PC_INC <= PC + 4;
	end 
	else if ( PCSEL == 0'b100 ) 
	begin 
		PC = 'h80000008;
		PC_INC <= PC + 4;
	end
end 
end
endmodule



module PC_TB;
reg[31:0] JT;
reg[31:0] Branch_PC;
reg[15:0] SXT; //make sure of the width
reg[3:0] PCSEL;
reg CLK;
reg RESET;
wire[31:0] PC;
wire[31:0] PC_INC;
wire[31:0] PC_SXT;
reg[5:0] i;

initial
begin
CLK=0;
#20
for(i=0; i < 20; i=i+1)
begin
#3
CLK <= CLK ^ 1;
end
end

initial
begin
JT=0;
Branch_PC=0;
SXT=0; //make sure of the width
PCSEL=0;
RESET=0;
$monitor ("PC = %b , PC_NEXT = %b , SEL= %b , CLK = %b , RESET = %b", PC, PC_INC, PCSEL, CLK, RESET);
#27
JT=1;
Branch_PC=2;
SXT=3; //make sure of the width
PCSEL=0;
RESET=0;
#4
JT=1;
Branch_PC=2;
SXT=3; //make sure of the width
PCSEL=2;
RESET=0;
#4
JT=1;
Branch_PC=2;
SXT=3; //make sure of the width
PCSEL=4;
RESET=1;
end

PC PC_test ( 
	JT,
	Branch_PC,
	SXT, //make sure of the width
	PCSEL,
	CLK,
	RESET,
	PC, 
	PC_INC,
	PC_SXT );
endmodule


