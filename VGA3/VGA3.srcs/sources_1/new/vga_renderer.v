`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Converted from Digilent 1080p VHDL
//////////////////////////////////////////////////////////////////////////////////

module vga_renderer(
    input  wire CLK_I,
    input wire [11:0] pixel,
    output reg  VGA_HS_O,
    output reg  VGA_VS_O,
    output reg [3:0] VGA_R,
    output reg [3:0] VGA_G,
    output reg [3:0] VGA_B
);

    // 1920x1080 @ 60Hz timing constants
    localparam H_VISIBLE = 1920;
    localparam H_FRONT   = 88;
    localparam H_SYNC    = 44;
    localparam H_BACK    = 148; // H_TOTAL - H_VISIBLE - H_FRONT - H_SYNC
    localparam H_TOTAL   = H_VISIBLE + H_FRONT + H_SYNC + H_BACK;

    localparam V_VISIBLE = 1080;
    localparam V_FRONT   = 4;
    localparam V_SYNC    = 5;
    localparam V_BACK    = 36;  // V_TOTAL - V_VISIBLE - V_FRONT - V_SYNC
    localparam V_TOTAL   = V_VISIBLE + V_FRONT + V_SYNC + V_BACK;

    // Moving box
    localparam BOX_WIDTH   = 8;
    localparam BOX_CLK_DIV = 1000000;
    localparam BOX_X_MAX   = 512 - BOX_WIDTH;
    localparam BOX_Y_MAX   = V_VISIBLE - BOX_WIDTH;
    localparam BOX_X_MIN   = 0;
    localparam BOX_Y_MIN   = 256;
    localparam [11:0] BOX_X_INIT = 12'h000;
    localparam [11:0] BOX_Y_INIT = 12'h190;

    // Counters
    reg [11:0] h_count = 0;
    reg [11:0] v_count = 0;

    // Box registers
    reg [11:0] box_x_reg = BOX_X_INIT;
    reg [11:0] box_y_reg = BOX_Y_INIT;
    reg box_x_dir = 1'b1;
    reg box_y_dir = 1'b1;
    reg [24:0] box_cntr_reg = 0;
    wire update_box = (box_cntr_reg == BOX_CLK_DIV-1);
    wire pixel_in_box = (h_count >= box_x_reg) && (h_count < box_x_reg+BOX_WIDTH) &&
                        (v_count >= box_y_reg) && (v_count < box_y_reg+BOX_WIDTH);

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

    // Sync signals
    always @(*) begin
        VGA_HS_O = ~((h_count >= H_VISIBLE + H_FRONT) && (h_count < H_VISIBLE + H_FRONT + H_SYNC));
        VGA_VS_O = ~((v_count >= V_VISIBLE + V_FRONT) && (v_count < V_VISIBLE + V_FRONT + V_SYNC));
    end


    // Box counter
    always @(posedge CLK_I) begin
        if (box_cntr_reg == BOX_CLK_DIV-1)
            box_cntr_reg <= 0;
        else
            box_cntr_reg <= box_cntr_reg + 1;
    end

    // Move the box
    always @(posedge CLK_I) begin
        if (update_box) begin
            if (box_x_dir)
                box_x_reg <= box_x_reg + 1;
            else
                box_x_reg <= box_x_reg - 1;

            if (box_y_dir)
                box_y_reg <= box_y_reg + 1;
            else
                box_y_reg <= box_y_reg - 1;

            if ((box_x_dir && box_x_reg == BOX_X_MAX-1) || (!box_x_dir && box_x_reg == BOX_X_MIN+1))
                box_x_dir <= ~box_x_dir;

            if ((box_y_dir && box_y_reg == BOX_Y_MAX-1) || (!box_y_dir && box_y_reg == BOX_Y_MIN+1))
                box_y_dir <= ~box_y_dir;
        end
    end

    // Active video
    wire active = (h_count < H_VISIBLE) && (v_count < V_VISIBLE);

    // Drive VGA outputs with test pattern + moving box
    always @(*) begin
        if (active) begin
            if (pixel_in_box) begin
                VGA_R = 4'b0000;
                VGA_G = 4'b1111;
                VGA_B = 4'b0000;
            end else begin
                VGA_R = pixel[11:8];
                VGA_G = pixel[7:4];
                VGA_B = pixel[3:0];
            end
        end else begin
            VGA_R = 4'b0000;
            VGA_G = 4'b0000;
            VGA_B = 4'b0000;
        end
    end

endmodule
