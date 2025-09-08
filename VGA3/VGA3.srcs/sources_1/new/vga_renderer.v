`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2025 05:28:10 PM
// Design Name: 
// Module Name: vga_renderer
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


module vga_renderer(
    input  wire CLK_I,
    output reg  VGA_HS_O,
    output reg  VGA_VS_O,
    output reg [3:0] VGA_R,
    output reg [3:0] VGA_G,
    output reg [3:0] VGA_B,
    
    output wire [15:0] pixel_addr,  //address to read from BRAM
    input wire [11:0] pixel         //pixel value from BRAM
);

 // VGA timing constants
    localparam H_VISIBLE = 640;
    localparam H_FRONT   = 16;
    localparam H_SYNC    = 96;
    localparam H_BACK    = 48;
    localparam H_TOTAL   = H_VISIBLE + H_FRONT + H_SYNC + H_BACK;

    localparam V_VISIBLE = 480;
    localparam V_FRONT   = 10;
    localparam V_SYNC    = 2;
    localparam V_BACK    = 33;
    localparam V_TOTAL   = V_VISIBLE + V_FRONT + V_SYNC + V_BACK;

    reg [10:0] h_count = 0;
    reg [9:0]  v_count = 0;

    // Counters
    always @(posedge CLK_I) begin
        if (h_count == H_TOTAL-1) begin
            h_count <= 0;
            if (v_count == V_TOTAL-1)
                v_count <= 0;
            else
                v_count <= v_count + 1;
        end else begin
            h_count <= h_count + 1;
        end
    end

    // Generate sync signals (active low)
    always @(*) begin
        VGA_HS_O = ~((h_count >= H_VISIBLE + H_FRONT) && (h_count < H_VISIBLE + H_FRONT + H_SYNC));
        VGA_VS_O = ~((v_count >= V_VISIBLE + V_FRONT) && (v_count < V_VISIBLE + V_FRONT + V_SYNC));
    end

    // Compute BRAM address for current pixel
    assign pixel_addr = v_count * H_VISIBLE + h_count;

    // Drive VGA outputs from BRAM pixel
    always @(*) begin
        if (h_count < H_VISIBLE && v_count < V_VISIBLE) begin
            VGA_R = pixel[11:8];
            VGA_G = pixel[7:4];
            VGA_B = pixel[3:0];
        end else begin
            VGA_R = 4'h0;
            VGA_G = 4'h0;
            VGA_B = 4'h0;
        end
    end

endmodule

