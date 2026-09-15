`timescale 1ns/1ps

// Course 2 starter. Complete only the three TODO sections described in
// docs/activities.md. The interface is deliberately small and simulator-first.
module course2_soc (
    input  logic        HCLK,
    input  logic        HRESETn,
    input  logic        HSEL,
    input  logic [31:0] HADDR,
    input  logic [1:0]  HTRANS,
    input  logic        HWRITE,
    input  logic [2:0]  HSIZE,
    input  logic [31:0] HWDATA,
    input  logic        HREADY,
    output logic [31:0] HRDATA,
    output logic        HREADYOUT,
    output logic        HRESP,
    output logic [7:0]  pixel_rgb,
    output logic        pixel_valid,
    output logic [4:0]  pixel_x,
    output logic [3:0]  pixel_y,
    output logic [3:0]  uart_status
);
    // Address contract used by the open testbench.
    localparam logic [31:0] SRAM_BASE = 32'h2000_0000;
    localparam logic [31:0] FB_BASE   = 32'h4000_0000;
    localparam logic [31:0] UART_BASE = 32'h4000_1000;

    // TODO(ahb-transfer): capture one valid word request, insert one wait cycle,
    // complete it exactly once, and implement SRAM plus unmapped-address errors.
    always_comb begin
        HRDATA = 32'h0000_0000;
        HREADYOUT = 1'b1;
        HRESP = 1'b0;
    end

    // TODO(vga-framebuffer): implement a 16 x 12 visible teaching raster and a
    // byte-per-pixel framebuffer reached through FB_BASE.
    always_ff @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn) begin
            pixel_x <= 5'd0;
            pixel_y <= 4'd0;
            pixel_rgb <= 8'd0;
            pixel_valid <= 1'b0;
        end else begin
            pixel_x <= pixel_x;
            pixel_y <= pixel_y;
            pixel_rgb <= pixel_rgb;
            pixel_valid <= pixel_valid;
        end
    end

    // TODO(uart-loopback): implement four-entry TX and RX FIFOs, ordered
    // loopback movement, data-register push/pop, and empty/full status.
    always_ff @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn)
            uart_status <= 4'b0101;
        else
            uart_status <= uart_status;
    end

    // Keep the starter warnings useful while the implementation is incomplete.
    logic _unused;
    always_comb _unused = HSEL ^ HADDR[0] ^ HTRANS[0] ^ HWRITE ^ HSIZE[0] ^ HWDATA[0] ^ HREADY ^ SRAM_BASE[0] ^ FB_BASE[0] ^ UART_BASE[0];
endmodule
