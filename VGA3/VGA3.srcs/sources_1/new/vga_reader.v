`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2025 03:53:55 PM
// Design Name: 
// Module Name: vga_reader
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module vga_reader(
    (* X_INTERFACE_PARAMETER = "FREQ_HZ 25176678, PHASE 0.0, CLK_DOMAIN design_1_clk" *)
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
    input wire clk,
    input wire [15:0] addr,
    output wire[11:0] pixel,
    //BRAM interface
    output wire [31:0] bram_addr,
    input wire [31:0] bram_dout,
    output wire bram_en,
    output wire bram_rst            // add reset
    );
    assign bram_addr = {16'b0, addr};
    assign bram_en   = 1'b1;
    assign bram_rst = 1'b0;
    assign pixel     = bram_dout[11:0];
endmodule
