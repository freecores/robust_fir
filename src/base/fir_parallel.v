OUTFILE fir_parallel_TOPO.v

ITER OX ORDER
ITER CX COEFF_NUM
ITER SX ADD_STAGES

//  Built In Parameters:
//  
//    Filter Order             = ORDER
//    Input Precision          = DIN_BITS
//    Coefficient Precision    = COEFF_BITS
//    Sum of Products Latency  = LATENCY
//    Number of multiplayers   = COEFF_NUM

module fir_parallel_TOPO (PORTS);
			
	input  clk;
	input  reset;
	input  clken;
	input  [EXPR(COEFF_BITS-1):0] kCX;
	input  [EXPR(DIN_BITS-1):0] data_in;
	output [EXPR(DOUT_BITS-1):0] data_out;
	output valid_out;

	wire [EXPR(DIN_BITS-1):0] data_in_d0;
	wire [EXPR(DIN_BITS-1):0] data_in_dEXPR(OX+1);
	reg [EXPR(MULT_BITS-1):0] multCX;
	
	//delay inputs per multiplayer
    assign data_in_d0 = data_in;
    CREATE prgen_delayN.v DEFCMD(SWAP DELAY 1) DEFCMD(DEFINE CLKEN)
    prgen_delay1_en #(DIN_BITS) delay_dinOX (clk, reset, clken, data_in_dOX, data_in_dEXPR(OX+1));
		
	always @(posedge clk or posedge reset)
	  if (reset)
	    begin
		  multCX <= #FFD {MULT_BITS{1'b0}};
	    end
      else if (clken)
	    begin
		  multCX <= #FFD kCX * data_in_dCX;
	    end

	//Pipline the output additions
	CREATE bintree_adder.v DEFCMD(SWAP INPUT_NUM COEFF_NUM)
	bintree_adder_COEFF_NUM #(MULT_BITS) bintree_adder(
		.clk(clk),
		.reset(reset),
		.data_inCX(multCX),
		.data_out(data_out),
		.valid_in(clken),
		.valid_out(valid_out)
	);

endmodule


		
		