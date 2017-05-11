#!/bin/bash
if [ ! -d "work" ]; then
  echo "**** Making /work ****"
  vlib work
  sh comp_lib   
fi

if [ -s "mult_othermod.sv" ]; then
  echo "**** Compiling mult_othermod.sv ****"
  vlog mult_othermod.sv
fi

if [ -s "mult_ctl.sv" ]; then
  echo "**** Compiling mult_ctl.sv ****"
  vlog mult_ctl.sv
fi

if [ -s "mult.sv" ]; then
  echo "**** Compiling mult.sv ****"
  vlog mult.sv
fi

if [ -s "mult.do" ]; then
  echo "**** Running vsim ****"
  vsim -novopt mult -do mult.do
fi

if [ -s "syn_mult" ]; then
  design_vision-xg -f syn_mult
fi

if [ -s "mult.gate.v" ]; then
   echo "**** Compiling mult.gate.v ****"
   vlog mult.gate.v
fi

if [ ! -s "work/_info" ]; then
  synop_lib="/nfs/guille/a1/cadlibs/synop_lib/SAED_EDK90nm/Digital_Standard_Cell_Library/verilog"
  vlog $synop_lib/* -work/work
fi
