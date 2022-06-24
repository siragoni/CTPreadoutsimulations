// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Fri Jun 24 13:52:45 2022
// Host        : DESKTOP-T9I20SI running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub {C:/Users/Simone
//               Ragoni/alice/CTPv15/ctp3-fw-ctpreadout-simulations/project_1.runs/dc_fifo_gbt2olt_synth_1/dc_fifo_gbt2olt_stub.v}
// Design      : dc_fifo_gbt2olt
// Purpose     : Stub declaration of top-level module interface
// Device      : xcku060-ffva1156-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_3,Vivado 2018.3" *)
module dc_fifo_gbt2olt(rst, wr_clk, rd_clk, din, wr_en, rd_en, dout, full, 
  empty, wr_rst_busy, rd_rst_busy)
/* synthesis syn_black_box black_box_pad_pin="rst,wr_clk,rd_clk,din[85:0],wr_en,rd_en,dout[85:0],full,empty,wr_rst_busy,rd_rst_busy" */;
  input rst;
  input wr_clk;
  input rd_clk;
  input [85:0]din;
  input wr_en;
  input rd_en;
  output [85:0]dout;
  output full;
  output empty;
  output wr_rst_busy;
  output rd_rst_busy;
endmodule
