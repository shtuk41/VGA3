// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vga_renderer,Vivado 2024.1.2" *)
module design_1_vga_renderer_1_1(CLK_I, VGA_HS_O, VGA_VS_O, VGA_R, VGA_G, VGA_B, 
  pixel_addr, pixel);
  input CLK_I /* synthesis syn_isclock = 1 */;
  output VGA_HS_O;
  output VGA_VS_O;
  output [3:0]VGA_R;
  output [3:0]VGA_G;
  output [3:0]VGA_B;
  output [15:0]pixel_addr;
  input [11:0]pixel;
endmodule
