`timescale 1ns/1ps

module tb_course2;
    logic HCLK = 1'b0;
    logic HRESETn = 1'b0;
    logic HSEL = 1'b0;
    logic [31:0] HADDR = 32'd0;
    logic [1:0] HTRANS = 2'b00;
    logic HWRITE = 1'b0;
    logic [2:0] HSIZE = 3'b010;
    logic [31:0] HWDATA = 32'd0;
    logic HREADY;
    logic [31:0] HRDATA;
    logic HREADYOUT;
    logic HRESP;
    logic [7:0] pixel_rgb;
    logic pixel_valid;
    logic [4:0] pixel_x;
    logic [3:0] pixel_y;
    logic [3:0] uart_status;
    integer failures = 0;
    integer waited_cycles = 0;
    string scenario;

    assign HREADY = HREADYOUT;
    always #5 HCLK = ~HCLK;
    course2_soc dut (.*);

    task automatic ahb_write(input logic [31:0] address, input logic [31:0] data);
        @(negedge HCLK);
        HSEL <= 1'b1; HTRANS <= 2'b10; HWRITE <= 1'b1; HSIZE <= 3'b010; HADDR <= address;
        @(negedge HCLK);
        HWDATA <= data;
        while (!HREADYOUT) begin waited_cycles++; @(negedge HCLK); end
        HSEL <= 1'b0; HTRANS <= 2'b00; HWRITE <= 1'b0;
        @(posedge HCLK); #1;
    endtask

    task automatic ahb_read(input logic [31:0] address, output logic [31:0] data, output logic error);
        @(negedge HCLK);
        HSEL <= 1'b1; HTRANS <= 2'b10; HWRITE <= 1'b0; HSIZE <= 3'b010; HADDR <= address;
        @(negedge HCLK);
        while (!HREADYOUT) begin waited_cycles++; @(negedge HCLK); end
        data = HRDATA; error = HRESP;
        HSEL <= 1'b0; HTRANS <= 2'b00;
        @(posedge HCLK); #1;
    endtask

    task automatic expect_word(input logic [31:0] actual, input logic [31:0] expected, input string label);
        if (actual !== expected) begin $display("FAIL %s expected=%08x actual=%08x", label, expected, actual); failures++; end
        else $display("PASS %s value=%08x", label, actual);
    endtask

    task automatic run_ahb_transfer;
        logic [31:0] value; logic error;
        waited_cycles = 0;
        ahb_write(32'h2000_0000, 32'hA5C3_5A3C);
        ahb_read(32'h2000_0000, value, error);
        expect_word(value, 32'hA5C3_5A3C, "SRAM readback");
        expect_word({31'd0, error}, 32'd0, "mapped response");
        ahb_read(32'h5000_0000, value, error);
        expect_word({31'd0, error}, 32'd1, "unmapped error");
        if (waited_cycles < 2) begin $display("FAIL wait state not observed on read and write"); failures++; end
        else $display("PASS wait states observed=%0d", waited_cycles);
    endtask

    task automatic run_framebuffer;
        integer file; integer samples; integer red; integer green; integer blue;
        ahb_write(32'h4000_0000, 32'h0000_00E0);
        ahb_write(32'h4000_0004, 32'h0000_001C);
        ahb_write(32'h4000_0008, 32'h0000_0003);
        ahb_write(32'h4000_000C, 32'h0000_00FF);
        file = $fopen("framebuffer.ppm", "w");
        $fwrite(file, "P3\n16 12\n255\n");
        samples = 0;
        repeat (800) begin
            @(posedge HCLK); #1;
            if (pixel_valid && samples < 192) begin
                red = ((pixel_rgb >> 5) & 7) * 255 / 7;
                green = ((pixel_rgb >> 2) & 7) * 255 / 7;
                blue = (pixel_rgb & 3) * 255 / 3;
                $fwrite(file, "%0d %0d %0d\n", red, green, blue);
                samples++;
            end
        end
        $fclose(file);
        expect_word(samples, 192, "visible pixel count");
        if (pixel_x > 15 || pixel_y > 11) begin $display("FAIL raster position outside visible contract"); failures++; end
        else $display("PASS raster position x=%0d y=%0d", pixel_x, pixel_y);
        $display("PASS framebuffer evidence framebuffer.ppm");
    endtask

    task automatic run_uart_loopback;
        logic [31:0] value; logic error; integer log_file;
        ahb_write(32'h4000_1000, 32'h0000_0041);
        ahb_write(32'h4000_1000, 32'h0000_0042);
        repeat (8) @(posedge HCLK);
        ahb_read(32'h4000_1004, value, error);
        if (value[0]) begin $display("FAIL RX FIFO unexpectedly empty"); failures++; end
        else $display("PASS RX FIFO contains looped data");
        ahb_read(32'h4000_1000, value, error); expect_word(value, 32'h41, "first looped byte");
        log_file = $fopen("uart.log", "w"); $fwrite(log_file, "%c", value[7:0]);
        ahb_read(32'h4000_1000, value, error); expect_word(value, 32'h42, "second looped byte");
        $fwrite(log_file, "%c\n", value[7:0]); $fclose(log_file);
        $display("PASS UART evidence uart.log");
    endtask

    initial begin
        $dumpfile("trace.vcd");
        $dumpvars(0, tb_course2);
        if (!$value$plusargs("SCENARIO=%s", scenario)) scenario = "ahb-transfer";
        repeat (4) @(posedge HCLK);
        HRESETn <= 1'b1;
        repeat (2) @(posedge HCLK);
        if (scenario == "ahb-transfer") run_ahb_transfer();
        else if (scenario == "vga-framebuffer") run_framebuffer();
        else if (scenario == "uart-loopback") run_uart_loopback();
        else begin $display("FAIL unknown scenario %s", scenario); failures++; end
        if (failures == 0) $display("RESULT PASS scenario=%s", scenario);
        else begin $display("RESULT FAIL scenario=%s failures=%0d", scenario, failures); $fatal(1); end
        $finish;
    end
endmodule
