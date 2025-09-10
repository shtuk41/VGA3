`timescale 1ns / 1ps

module top(
    input  wire CLK_I,       // board input clock (125 MHz)
    output wire VGA_HS_O,
    output wire VGA_VS_O,
    output wire [3:0] VGA_R,
    output wire [3:0] VGA_G,
    output wire [3:0] VGA_B
);

wire clk_148_5;   // Clock from Clock Wizard
wire pll_locked;

// Optional synchronous reset using PLL lock
wire reset_sync = ~pll_locked;

// Instantiate Clock Wizard
clk_wiz_0 u_clk_wiz (
    .clk_in1(CLK_I),
    .clk_out1(clk_148_5),
    .reset(1'b0),
    .locked(pll_locked)
);

// Instantiate VGA renderer
vga_renderer u_vga (
    .CLK_I(clk_148_5),       // connect Clock Wizard output
    .VGA_HS_O(VGA_HS_O),
    .VGA_VS_O(VGA_VS_O),
    .VGA_R(VGA_R),
    .VGA_G(VGA_G),
    .VGA_B(VGA_B)
);

endmodule
