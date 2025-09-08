// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vga_reader,Vivado 2024.1.2" *)
module design_1_vga_reader_0_3(clk, addr, pixel, bram_addr, bram_dout, bram_en, 
  bram_rst);
  input clk;
  input [15:0]addr;
  output [11:0]pixel;
  output [31:0]bram_addr;
  input [31:0]bram_dout;
  output bram_en;
  output bram_rst;
endmodule
