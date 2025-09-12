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
    (* X_INTERFACE_PARAMETER = "FREQ_HZ 25022644, PHASE 0.0, CLK_DOMAIN design_1_clk" *)
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
    input wire clk,
    //input wire [15:0] addr,
    output reg[11:0] pixel,
    //BRAM interface
    output wire [31:0] bram_addr,
    input wire [31:0] bram_dout,
    output wire bram_en,
    output wire bram_rst            // add reset
    );
    
    assign bram_addr = 32'h00000000;
    assign bram_en   = 1'b1;
    assign bram_rst = 1'b0;
    
    always @(posedge clk) begin
        case(bram_dout)
            32'h00000000: pixel <= 12'h00f;
            32'h00000001: pixel <= 12'hf00;
            32'h00000002: pixel <= 12'h0f0;
            default: pixel <= 12'hff0;
        endcase
    end
endmodule
