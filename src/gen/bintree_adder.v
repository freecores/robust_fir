
OUTFILE bintree_adder_INPUT_NUM.v
INCLUDE def_bintree_adder.txt

ITER TX INPUT_NUM
ITER SX ADD_STAGES

module bintree_adder_INPUT_NUM(PORTS);

	parameter BITS = 0;

	input  clk;
	input  reset;
	input [BITS-1:0] data_inTX;
	output [BITS-1+ADD_STAGES:0] data_out;
	input valid_in;
	output valid_out;
	
	
	LOOP EX INPUT_NUM EXPR(2^LOG2(INPUT_NUM))
	wire [BITS-1:0] data_inEX = {BITS{1'b0}}; //complete power of 2 input data
	ENDLOOP EX
	STOMP LINE
		
	wire [BITS-1:0] sum_stageADD_STAGES_TX;

	LOOP TX EXPR(2^LOG2(INPUT_NUM))
	assign sum_stageADD_STAGES_TX = data_inTX;
	ENDLOOP TX
	
	
LOOP SX ADD_STAGES
  ITER AX EXPR(2^SX)
	reg [BITS-1+EXPR(ADD_STAGES-SX):0] sum_stageSX_AX;
  ENDITER AX
ENDLOOP SX
	
	wire valid_dSX;
    CREATE prgen_delayN.v def_delayN.txt DEFCMD(SWAP DELAY 1)
	prgen_delay1 #(1) delay_validSX(clk, reset, valid_dSX, valid_dEXPR(SX+1));
	assign valid_d0 = valid_in;
	assign valid_out = valid_dADD_STAGES;
	
LOOP SX ADD_STAGES
  ITER AX EXPR(2^SX)
	always @(posedge clk or posedge reset)
	  if (reset)
	    begin
	        sum_stageSX_AX <= #FFD {BITS+EXPR(ADD_STAGES-SX){1'b0}};
		end
	  else
	  STOMP NEWLINE
	  if (valid_dEXPR(ADD_STAGES-SX-1))
	    begin
	        sum_stageSX_AX <= #FFD sum_stageEXPR(SX+1)_EXPR(2*AX) + sum_stageEXPR(SX+1)_EXPR(2*AX+1);
		end
  ENDITER AX
  
ENDLOOP SX
	
	assign data_out = sum_stage0_0;
	
endmodule


		