ITER DX DELAY

OUTFILE prgen_NAME.v
INCLUDE def_delayN.txt

module prgen_NAME(PORTS);
   parameter          WIDTH = 1;
   
   input 		      clk;
   input 		      reset;
IF CLKEN  input 		      clken;
   
   input [WIDTH-1:0]  din;
IFDEF PARALLEL
   output [WIDTH*DELAY-1:0] dout;
ELSE PARALLEL
   output [WIDTH-1:0] dout;
ENDIF PARALLEL
   
   
   wire [WIDTH-1:0]   din_d0;
   reg [WIDTH-1:0] 	  din_dEXPR(DX+1);
   
   assign din_d0 = din;
   
   always @(posedge clk or posedge reset)
     if (reset)
	   begin
         din_dEXPR(DX+1) <= #FFD {WIDTH{1'b0}};
	   end
     else
IFDEF CLKEN
	 STOMP NEWLINE
	 if (clken)
ENDIF CLKEN
	   begin
         din_dEXPR(DX+1) <= #FFD din_dDX;
	   end
	   

IFDEF PARALLEL
  assign              dout = {CONCAT.REV(din_dDX ,)};
ELSE PARALLEL
   assign 		      dout = din_dDELAY;
ENDIF PARALLEL
   
   
endmodule


   



