/* ALU Arithmetic and Logic Operations
----------------------------------------------------
FN[5:0]	| Operation	    		| Output value Y[31:0]
----------------------------------------------------------------------
00-011	| CMPEQ	            		| Y = (A == B)
----------------------------------------------------------------------
00-101	| CMPLT	            		| Y = (A < B)
----------------------------------------------------------------------
00-111	| CMPLE	            		| Y = (A ? B)
----------------------------------------------------------------------
01-000	| 		    		| Y = A
----------------------------------------------------------------------
01-001	| 		  		| Y = A +1
-----------------------------------------------------------------
01-010	| 32-bit Adder   		| Y = A + B
----------------------------------------------------------------------
01-011	| 32-bit Adder with carry   	| Y = A + B + 1
----------------------------------------------------------------------
01-100	| 32-bit SUBTRACT    		| Y = A - B - 1
----------------------------------------------------------------------
01-101	| 32-bit SUBTRACT   		| Y = A - B
----------------------------------------------------------------------
01-110	| 32-bit SUBTRACT   		| Y = A - 1
----------------------------------------------------------------------
01-111	| 		   		| Y = A 
----------------------------------------------------------------------
10abcd	| Bit-wise Boolean  		| Y[i] = Fabcd(A[i],B[i])
----------------------------------------------------------------------
11--00	| Logical Shift left (SHL)	| Y = A << B
----------------------------------------------------------------------
11--01	| Logical Shift right (SHR)	| Y = A >> B
----------------------------------------------------------------------
11--11	| Arithmetic Shift right (SRA)	| Y = A >> B (sign extended)
----------------------------------------------------------------------*/
/*------------------------------------------------------------------
/ ALU TOP LEVEL MODULE
/-------------------------------------------------------------------*/
module ALU (input wire[5:0] FN,input wire[31:0] RA,input wire[31:0] RB,output wire[31:0] RC, output wire Z);
wire[31:0] RESULT1;
wire[31:0] RESULT2;
wire[31:0] RESULT3;
wire[31:0] RESULT4;
wire[2:0] ZVN;
assign Z=ZVN[2];
BOOLunit Bool(FN[3:0], RA, RB, RESULT2);
ARITH Arith(FN[2:0], RA, RB, RESULT3, ZVN);
CMP Comp(FN[2:1], ZVN, RESULT4);
SHIFT Shift(FN[1:0], RA, RB[4:0], RESULT1);
genvar j;
for(j=0;j<32;j=j+1)
begin
MUX4x1 RESULT({RESULT1[j], RESULT2[j], RESULT3[j], RESULT4[j]},FN[5:4], RC[j]);
end
endmodule

/*----------------------------------------------------------------
/ ALU Test Bench
/----------------------------------------------------------------*/
module ALU_TB;
reg[31:0] RA;
reg[31:0] RB;
reg[5:0] FN;
wire[31:0] RC;
initial 
begin
 FN = 0'b101000; //AND
 RA= 0'b0101;
 RB= 0'b1111;
	$monitor ("FN = %b , RA = %b , RB = %b, RC = %b", FN[5:0], RA, RB,RC);
#20
FN = 0'b010010;	//32-bit ADD	    		| 
#20
FN= 0'b110011;	//Arithmetic Shift right (SRA)
end
ALU test(FN,RA,RB,RC);
endmodule


/*------------------------------------------------------------------
/ BOOlean unit that perform boolean functions
/------------------------------------------------------------------*/

module BOOLunit(input wire[3:0] FN, input wire[31:0] RA, input wire[31:0] RB, output wire[31:0] RC);
genvar i;
for(i=0;i<32;i=i+1)
begin
MUX4x1 BOOL1(FN,{RA[i],RB[i]}, RC[i]);
end
endmodule

/*-----------------------------------------------------------
/ Boolean unit Test Bench
/-----------------------------------------------------------*/

module BOOLunit_tb;
reg[3:0] FN;
reg[31:0] RA;
reg[31:0] RB;
wire[31:0] RC;
initial 
begin
FN = 0'b1000;
RA= 0'b10110110011010110110101010101011;
RB= 0'b11010101011111100101011010101011;
	$monitor ("FN = %b , RA = %b , RB = %b, RC = %b", FN, RA, RB,RC);
#20
FN = 0'b1110;
end
BOOLunit test(FN,RA,RB,RC);
endmodule

/*--------------------------------------------
/ Arthimetic Unit
/--------------------------------------------*/
module ARITH(input wire[2:0] FN, input wire[31:0] RA, input wire[31:0] RB, output wire[31:0] RC, output wire[2:0] ZVN);
reg[31:0] ALU_Result;
assign RC = ALU_Result;
wire[31:0] RBB;
wire[31:0] T1;
wire[31:0] T2;
wire[31:0] T3;
genvar y;
for(y=0;y<32;y=y+1)
begin
assign T1[y]= ~( FN[2] & ~(RB[y]) ); 
assign T2[y]= ~( FN[1] & RB[y] ); 
assign RBB[y] = ~( T1[y] & T2[y]	 );
end
always @(*)
begin
           ALU_Result = RA + RBB + FN[0] ; 
end
endmodule 
/*-------------------------------------------------
/ Arthimetic Unit Test Bench
/-------------------------------------------------*/
module ARITH_TB;
reg[5:0] FN;
reg[31:0] RA;
reg[31:0] RB;
wire[31:0] RC;
initial 
begin
FN = 0'b010010;//A+B
RA= 0'b1101;
RB= 0'b1001;
	$monitor ("FN = %b , RA = %b , RB = %b, RC = %b", FN, RA, RB,RC);
#20
FN = 0'b011110; //A-1
end
ARITH test(FN[2:0],RA,RB,RC);
endmodule

/*--------------------------------------------------------
/ Comparison unit 
/-----------------------------------------------------------*/
module CMP(input wire[1:0] FN,input wire[2:0]ZVN, output wire[31:0] RC);
reg[31:0] ALU_Result;
assign RC = ALU_Result;
always @(*)
begin
        case(FN)
	0'b01: ALU_Result = (ZVN[2] == 1)? 0'b1 : 0'b0;
	0'b10: ALU_Result = ((ZVN[0] ^ ZVN[1]) == 1 )? 0'b1 : 0'b0;
	0'b11: ALU_Result = ((ZVN[2] + ZVN[0] ^ ZVN[1]) == 1 )? 0'b1 : 0'b0;
	endcase
end
endmodule
/*-------------------------------------------------------------
/ Comparison unit - Test Bench
/--------------------------------------------------------------*/
module CMP_TB;
reg[3:0] FN;
reg[2:0] ZVN;
wire[31:0] RC;
initial 
begin
ZVN=101;
FN = 0'b11010;
	$monitor ("FN = %b , ZVN=%b, RC = %b", FN[2:1],ZVN,RC);
#20
FN = 0'b11111;
#20
FN= 0'b1100;
end
CMP test(FN[2:1],ZVN,RC);
endmodule
//-----------------------------------------------------------


/*--------------------------------------------------------
/ Shift unit 
/-----------------------------------------------------------*/
module SHIFT(input wire[1:0]FN, input wire[31:0] RA, input wire[4:0] RB, output wire[31:0] RC);
reg[31:0] ALU_Result;
assign RC = ALU_Result;
always @(*)
begin
        case(FN)
	0'b00: ALU_Result = RA << RB;
	0'b01: ALU_Result = RA >> RB;
	0'b11: ALU_Result = RA >>> RB;
	endcase
end
endmodule
/*-------------------------------------------------------------
/ Shift unit - Test Bench
/--------------------------------------------------------------*/
module Shift_TB;
reg[3:0] FN;
reg[31:0] RA;
reg[4:0] RB;
wire[31:0] RC;
initial 
begin
 FN = 0'b1101;
 RA= 0'b111111111111111111111111111000;
 RB= 0'b11;
	$monitor ("FN = %b , RA = %b , RB = %b, RC = %b", FN[1:0], RA, RB,RC);
#20
FN = 0'b11111;
#20
FN= 0'b1100;
end
SHIFT test(FN[1:0],RA,RB,RC);
endmodule
//-------------------------------