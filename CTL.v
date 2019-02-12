/*-------------------------------------------------------------------------------------------------------------
Control     | 				| RESET | IRQ   | OP  | OPC | LD  | LDR | ST |   JMP   | BEQ    | BNE   | IL  |
-----------------------------------------------------------------------------------------------------------------------
ALUFN[5:0]  |	Alu Function    	|   --  |   --  |  op |  op |  +  |  A  |  + |    --   |  --    |  --   | --  |    
-----------------------------------------------------------------------------------------------------------------------
ASEL	    |	ALU Operand A		|   --  |   --  |  0  |  0  |  0  |  1  |  0 |   --    |  --    |  --   | --  |    
-----------------------------------------------------------------------------------------------------------------------
BSEL	    |	ALU Operand B		|   --  |   --  |  0  |  1  |  1  |  -- |  1 |   --    |  --    |  --   | --  |    
-----------------------------------------------------------------------------------------------------------------------
MOE	    |	Memory Load En		|   --  |   --  |  -- |  -- |  1  |  1  |  0 |   --    |  --    |  --   |  0  |    
-----------------------------------------------------------------------------------------------------------------------
MWR	    |	Meomory Store EN	|   0   |   0   |  0  |  0  |  0  |  0  |  1 |    0    |  0     |  0    |  0   |    
-----------------------------------------------------------------------------------------------------------------------
PCSEL	    |	Program Counter SEl	|   --  |   4   |  0  |  0  |  0  |  0  |  0 |    2    | z?1:0  | z?0:1 |  3   |    
-----------------------------------------------------------------------------------------------------------------------
RA2SEL	    |	RA2 Memory SEl		|   --  |   --  |  0  | --  |  -- |  -- |  1 |   --    |  --    |  --   |  --  |    
-----------------------------------------------------------------------------------------------------------------------
WASEL	    |	RA1 Memoery Sel		|   --  |   1	|  0  |  0  |  0  |  0  | -- |    0    |  0     |  0    |   1  |    
-----------------------------------------------------------------------------------------------------------------------
WDSEL[1:0]  |	Write Back Data Sel	|   --  |   0	|  1  |  1  |  2  |  2  |--  |    0    |  0     |  0    |   0  |    
-----------------------------------------------------------------------------------------------------------------------
WERF	    |	Memory Write Back EN	|   --  |   1	|  1  |   1 |  1  |  1  |  0 |    1    |  1     |  1   |    1  |    
----------------------------------------------------------------------------------------------------------------------*/

/*Operation| 10-OP Code	|			|				|
-------------------------------------------------
ADD	   | 10-0000    |	plus		|
-------------------------------------------------
SUB	   | 10-0001	|	minus		|
-------------------------------------------------	
MUL	   | 10-0010	|	multiply	| //Not implemented
-------------------------------------------------
DIV	   | 10-0011	|	divide		| //Not implemented
-------------------------------------------------
AND	   | 10-0100	|	and		|
-------------------------------------------------
OR	   | 10-0101	|	or		|
-------------------------------------------------
XOR	   | 10-0110    | 	xor		|
-------------------------------------------------
XNOR	   | 10-0111	|	xnor		|	
-------------------------------------------------
CMPEQ	   | 10-1000    |	equal		|
-------------------------------------------------
CMPLT	   | 10-1001    |	less than	|
-------------------------------------------------
CMPLE	   | 10-1010    |   less than or equal	|
-------------------------------------------------
SHL	   | 10-1011    |	left shift	|
-------------------------------------------------
SHR	   | 10-1100    |	right shift	|
-------------------------------------------------
SRA 	   | 10-1101	|    right shift w/ sig	|
-----------------------------------------------*/
/* ----------------------------------------------------
# The op code for operations with constants are the same
# with changeing most significat two bit with 11 
------------------------------------------------------*/

module CTL(
	input wire[31:0] INS,
	input wire Z,
	input wire IRQ,
	input wire RESET,
	output reg[5:0] ALUFN,
	output reg ASEL,
	output reg BSEL,
	output reg MOE,
	output reg MWR,
	output reg[2:0] PSEL,
	output reg RA2SEL,
	output reg WASEL,
	output reg[1:0] WDSEL,
	output reg WEREF);

//add reset and IRQ 
always@ *
begin
if(RESET == 1)
begin
	ALUFN = 0; 
	ASEL = 0;
	BSEL = 0;
	MOE = 0;
	MWR = 0;
	PSEL = 0;  
	RA2SEL = 0;
	WASEL = 0;
	WDSEL = 0;
	WEREF = 0;
end
else if(IRQ == 1)
begin
	ALUFN = 0;
	ASEL = 0;
	BSEL = 0;
	MOE = 0;
	MWR = 0;
	PSEL = 0;
	RA2SEL = 4;
	WASEL = 1;
	WDSEL = 0;
	WEREF = 1;
end
else
begin
case(INS[31:30])

	0'b10: //OP
begin 
	case(INS[29:26])
	0000: ALUFN = 0'b010010;
	0001: ALUFN = 0'b010101;
	0010: ALUFN = 0'b000000;
	0011: ALUFN = 0'b000000;
	0100: ALUFN = 0'b101000;
	0101: ALUFN = 0'b101110;
	0110: ALUFN = 0'b100110;
	0111: ALUFN = 0'b101001;
	1000: ALUFN = 0'b000011;
	1001: ALUFN = 0'b000101;
	1010: ALUFN = 0'b000111;
	1011: ALUFN = 0'b110000;
	1100: ALUFN = 0'b110001;
	1101: ALUFN = 0'b110011;
	endcase
	
	ASEL = 0;
	BSEL = 0; 
	MOE = 0;
	MWR = 0;
	PSEL = 0;
	RA2SEL = 0;
	WASEL = 0;
	WDSEL = 1;
	WEREF = 1;
end

	0'b11: //OPC
begin 
	case(INS[29:26])
	0000: ALUFN = 0'b010010;
	0001: ALUFN = 0'b010101;
	0010: ALUFN = 0'b000000;
	0011: ALUFN = 0'b000000;
	0100: ALUFN = 0'b101000;
	0101: ALUFN = 0'b101110;
	0110: ALUFN = 0'b100110;
	0111: ALUFN = 0'b101001;
	1000: ALUFN = 0'b000011;
	1001: ALUFN = 0'b000101;
	1010: ALUFN = 0'b000111;
	1011: ALUFN = 0'b110000;
	1100: ALUFN = 0'b110001;
	1101: ALUFN = 0'b110011;
	endcase
	ASEL = 0;
	BSEL = 1;
	MOE = 0;
	MWR = 0;
	PSEL = 0;
	RA2SEL = 0;
	WASEL = 0;
	WDSEL = 1;
	WEREF = 1;
end

	0'b01: 
begin
case(INS[29:26])
	0'b0000: //ld
	begin 
	ALUFN = 0'b010010;//Summm
	ASEL = 0;
	BSEL = 1;
	MOE = 1;
	MWR = 0;
	PSEL = 0;
	RA2SEL = 0;
	WASEL = 0;
	WDSEL = 2;
	WEREF = 1;
	end

	0'b0001: //LDR
	begin 
	ALUFN = 0'b010000;//A
	ASEL = 1;
	BSEL = 0;
	MOE = 1;
	MWR = 0; 
	PSEL = 0;
	RA2SEL = 0;
	WASEL = 0;
	WDSEL = 2;
	WEREF = 1;
	end

	0'b0010: //ST
	begin 
	ALUFN = 0'b010010; //Sum
	ASEL = 0;
	BSEL = 1;
	MOE = 0;
	MWR = 1;
	PSEL =0;
	RA2SEL = 1;
	WASEL = 0;
	WDSEL = 0;
	WEREF = 0;
	end

	0'b0011: //JMP
	begin 
	ALUFN = 0;
	ASEL = 0;
	BSEL = 0;
	MOE = 0;
	MWR = 0;
	PSEL =2;
	RA2SEL = 0;
	WASEL = 0;
	WDSEL = 0;
	WEREF = 1;
	end

	0'b0100: //BEQ
	begin 
	ALUFN = 0;
	ASEL = 0;
	BSEL = 0;
	MOE = 0;
	MWR = 0;
	PSEL = Z ? 1 : 0;
	RA2SEL = 0;
	WASEL = 0;
	WDSEL = 0;
	WEREF = 1;
	end

	0'b0101: //BNE
	begin 
	ALUFN = 0;
	ASEL = 0;
	BSEL = 0;
	MOE = 0;
	MWR = 0;
	PSEL = Z ? 0 : 1;
	RA2SEL = 0;
	WASEL = 0;
	WDSEL = 0;
	WEREF = 1;
	end
endcase
end
	default: //ILLOP
begin 
	ALUFN = 0;
	ASEL = 0;
	BSEL = 0;
	MOE = 0;
	MWR = 0;
	PSEL = 3;
	RA2SEL = 0;
	WASEL = 1;
	WDSEL = 0;
	WEREF = 1;
end
endcase
end

end

endmodule 



module CTL_TB;
reg[31:0] INS;
reg Z;
reg IRQ;
reg RESET;
wire[5:0] ALUFN;
wire ASEL;
wire BSEL;
wire MOE;
wire MWR;
wire[2:0] PSEL;
wire RA2SEL;
wire WASEL;
wire[1:0] WDSEL;
wire WEREF;

initial 
begin
$monitor( "INS = %b , INS[31:30] =  %b ,IS[29:26] = %b,ALUFN = %b || ASEL = %b  || BSEL = %b || MOE = %b || MWR = %b || PSEL = %b || RA2SEL = %b || WASEL = %b || WDSEL = %b || WEREF = %b" , INS, INS[31:30], INS[29:26] ,ALUFN , ASEL , BSEL , MOE , MWR , PSEL , RA2SEL , WASEL , WDSEL , WEREF );
#5
INS=0'b10000000011111000010000000000000;
Z=0;
IRQ=0;
end
CTL test(
	INS,
	 Z,
	IRQ,
	RESET,
	ALUFN,
	ASEL,
	BSEL,
	MOE,
	MWR,
	PSEL,
	RA2SEL,
	WASEL,
	WDSEL,
	WEREF);
endmodule