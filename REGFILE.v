module REGFILE( input wire[4:0] RA1, input wire[4:0] RA2,
		input wire[4:0] WA, input wire[31:0] WD, input wire WERF,
		output reg[31:0] RD1, output reg[31:0] RD2);
reg[31:0] mem[31:0];
always @ *
begin
RD1 = mem[RA1];
RD2 = mem[RA2];
end
always @ WERF
begin
mem[WA] = WD;
end
endmodule


module DATAMEM(input wire[31:0] MWD, input wire MWR, input wire MOE, input wire[31:0] MA, output reg[31:0] MRD);
reg[31:0] mem[0'hffffffff:0];	
always @ MOE
begin
MRD=mem[MA];
end
always @ MWR
begin
mem[MA] = MWD;
end
endmodule


module INSMEM(input wire[31:0] PC, output reg[31:0] INS, input wire CLK);
reg[31:0] mem[0'hffffffff:0];
always @ *
begin
INS = mem[PC];
end
endmodule