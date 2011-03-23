OUTFILE fir_NAME.v
INCLUDE def_fir.txt

ITER CX COEFF_NUM

##  Expected RobustVerilog parameters:
##  SWAP ORDER val       - order of FIR
##  SWAP COEFF_BITS val  - precision of coeeficients (bit num)
##  SWAP DIN_BITS val    - precision of input data (bit num)
##  SWAP MAC_NUM val     - number of multiplayers (determines architecture)

//  Built In Parameters:
//  
//    Filter Order              = ORDER
//    Input Precision           = DIN_BITS
//    Coefficient Precision     = COEFF_BITS
//    Number of serial FIR sons = MAC_NUM
//    Number of multiplayers    = MAC_NUM
//    Architecture              = ARCH
//    Sum of Products Latency   = LATENCY

module fir_NAME (PORTS);
			
	input  clk;
	input  reset;
	input  [EXPR(COEFF_BITS-1):0] kCX;
	input  [EXPR(DIN_BITS-1):0] data_in;
	output [EXPR(DOUT_BITS-1):0] data_out;
    input  valid_in;
	output valid_out;

	
IFDEF TRUE(MAC_NUM==1)
  CREATE fir_serial.v def_fir_basic.txt DEFCMD(SWAP CONST(ORDER) ORDER) DEFCMD(SWAP CONST(COEFF_BITS) COEFF_BITS) DEFCMD(SWAP CONST(DIN_BITS) DIN_BITS)
  fir_serial_TOPO fir(clk, reset, valid_in, CONCAT.REV(kCX ,), data_in, data_out, valid_out);
  
ELSE TRUE(MAC_NUM==1)
  IFDEF TRUE(COEFF_NUM==MAC_NUM)
  CREATE fir_parallel.v def_fir_basic.txt DEFCMD(SWAP CONST(ORDER) ORDER) DEFCMD(SWAP CONST(COEFF_BITS) COEFF_BITS) DEFCMD(SWAP CONST(DIN_BITS) DIN_BITS)
  fir_parallel_TOPO fir(clk, reset, valid_in, CONCAT.REV(kCX ,), data_in, data_out, valid_out);
  
  ELSE TRUE(COEFF_NUM==MAC_NUM)
  CREATE fir_Nserial.v def_fir_Nserial.txt DEFCMD(SWAP CONST(ORDER) ORDER) DEFCMD(SWAP CONST(COEFF_BITS) COEFF_BITS) DEFCMD(SWAP CONST(DIN_BITS) DIN_BITS) DEFCMD(SWAP CONST(MAC_NUM) MAC_NUM)
  fir_MAC_NUMserial_TOPO fir(clk, reset, valid_in, CONCAT.REV(kCX ,), data_in, data_out, valid_out);
  
  ENDIF TRUE(COEFF_NUM==MAC_NUM)
ENDIF TRUE(MAC_NUM==1)
  	
	
endmodule
