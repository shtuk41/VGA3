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
    input wire clk,              // 50 MHz clock
    output reg [11:0] pixel,    // VGA pixel
    // BRAM interface
    output reg [31:0] bram_addr,
    input wire [31:0] bram_dout,
    output wire bram_en,
    output wire bram_rst,
    output reg [31:0] bram_dinb,
    output reg [3:0] bram_web,
    // LEDs
    output reg [3:0] leds
);

    assign bram_en  = 1'b1;
    assign bram_rst = 1'b0;

    // Synchronized read
    reg [31:0] bram_dout_sync;
    always @(posedge clk) bram_dout_sync <= bram_dout;

    // Color and timing
    reg [31:0] color = 0;
    reg [25:0] counter = 0;  // Enough for ~50M cycles (1 second at 50MHz)

    always @(posedge clk) begin
        bram_addr <= 0;      // always write to address 0

        // Counter for ~1 second timing
        if (counter == 50_000_000-1) begin
            counter <= 0;
            color <= (color < 2) ? color + 1 : 0;

            // Write color to BRAM
            bram_web <= 4'b1111;
            bram_dinb <= color;
        end else begin
            counter <= counter + 1;
            bram_web <= 4'b0000;
        end

        // Update pixel and LEDs based on BRAM content
        case (bram_dout_sync)
            32'h0:  begin pixel <= 12'h00f; leds <= 4'b1101; end
            32'h1:  begin pixel <= 12'hf00; leds <= 4'b0010; end
            32'h2:  begin pixel <= 12'h0f0; leds <= 4'b0100; end
            default: begin pixel <= 12'hff0; leds <= 4'b1001; end
        endcase
    end

endmodule
