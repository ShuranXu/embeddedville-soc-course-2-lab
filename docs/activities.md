# Course 2 activities

## AHB transfer

Implement the memory-mapped transfer contract in `rtl/course2_soc.sv`. A valid word request must capture address and control, insert one observable wait cycle, complete exactly once, preserve write data, return read data in the response phase, and raise an error for an unmapped address. Run `./lab test --scenario ahb-transfer`.

## VGA framebuffer

Implement the framebuffer window and scan counters. Bus writes must update byte-wide pixels, the raster must advance through the documented 16 × 12 teaching frame, and `pixel_valid` must identify visible positions. The test exports observed pixels to `framebuffer.ppm`. Run `./lab test --scenario vga-framebuffer`.

## UART loopback

Implement ordered transmit and receive queues behind the UART data and status offsets. Writes enqueue bytes, the loopback path moves the oldest transmit byte to receive storage, reads return and remove the oldest received byte, and status reports empty/full state. Run `./lab test --scenario uart-loopback`.

These are simulator activities. They do not synthesize an FPGA bitstream and do not claim to run on Basys 3, Vivado, Keil, a VGA monitor, or TeraTerm. Those are hardware-only extensions outside this workspace’s verified contract.
