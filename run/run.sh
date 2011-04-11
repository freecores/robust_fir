#!/bin/bash

../../../robust ../src/base/fir.v ../src/base/def_fir_top.txt -od out -I ../src/gen -list firlist.txt -listpath -header

echo Completed RobustVerilog fir run - results in run/out/
