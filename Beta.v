module Beta(input wire RESET, input wire IRQ);
reg CLK;
//PC_Signals
wire[31:0] INS;
wire[2:0] PCSEL;
wire[31:0] PC;
wire[31:0] PC_INC;
wire[31:0] PC_SXT; 
//CTL_Signalss
wire ASEL;
wire BSEL;
wire RA2SEL;
wire WASEL;
wire[1:0] WDSEL;
wire WEREF;
//REGFILE
wire[4:0] RA1 = INS[20:16] ; 
wire[4:0] RA2; 
wire[4:0] WA;	
wire[31:0] WD;
wire WERF;
wire[31:0] RD1;	
wire[31:0] RD2;	
//ALU
wire[5:0] FN;	 
wire[31:0] RA;	
wire[31:0] RB;	
wire[31:0] RC; 
wire Z;
//Beta_DATAMEM
wire[31:0] MWD;	
wire MWR;	
wire MOE;	 
wire[31:0]MA;	
wire[31:0] MRD;	

PC BetaPC ( 
	 RD1,		/*input wire[31:0]*/ 
	 INS[15:0], 		/*input wire[15:0]*/ 
	 PCSEL, 	/*input wire[3:0]*/ 
	 CLK,		/*input wire*/
	 RESET,		/*input wire*/
	 PC, 		/*output reg[31:0]*/ 	
	 PC_INC,	/*output reg[31:0]*/ 
	 PC_SXT 	/*output reg[31:0]*/
	 );

INSMEM BetaINSMEM(
	     	PC, 	//input wire[31:0]
	     	INS, 	//output reg[31:0] 
	     	CLK	//input wire 
		);

CTL BetaCTL(
	 INS, 	 //input wire[31:0] 
	 Z,	 //input wire
	 IRQ,	 //input wire
	 RESET,  //input wire
	 FN,  //output reg[5:0] 
	 ASEL,	 //output reg
	 BSEL,	 //output reg
	 MOE,	 //output reg 
	 MWR,	 //output reg
	 PCSEL,	 //output reg[2:0]
	 RA2SEL, //output reg
	 WASEL,	 //output reg
	 WDSEL,	 //output reg[1:0]
	 WEREF	 //output reg 
	);

assign RA2 = ( RA2SEL ) ? INS[25:21] : INS[15:11];
assign WA = ( WASEL ) ? 30 : INS[15:11];
assign RA = ( ASEL ) ? PC_SXT : RD1;  
assign RB = (BSEL) ? INS[15:0] : RD2;
assign WD = ( WDSEL[0] == 0 ) ? ( WDSEL[1] == 1 ) ? MRD : PC_INC : RC;


REGFILE BetaREGFILE( 
		  RA1,	//input wire[4:0] 
		  RA2, //input wire[4:0] 
		  WA,	//input wire[4:0]
		  WD,	//input wire[31:0]
		  WERF,	//input wire
		  RD1,	//output reg[31:0]
		  RD2	// output reg[31:0]
		);

ALU BetaALU(
	 FN,	//input wire[5:0] 
	 RA,	//input wire[31:0]
	 RB,	//input wire[31:0]
 	 RC,	//output wire[31:0] 
	 Z	//output wire
	);

DATAMEM Beta_DATAMEM(
		 RD2,	//input wire[31:0] 
		 MWR,	//input wire 
		 MOE,	//input wire 
		 RC,	//input wire[31:0] 
		 MRD	//output reg[31:0]
		);

endmodule