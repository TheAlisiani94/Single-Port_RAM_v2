# Single-Port RAM with Synchronous Read/Write in Verilog

This project implements a single-port RAM in Verilog with a 64x8 configuration (64 locations, 8-bit data width). The RAM supports synchronous write and synchronous read operations, where the read address is registered to introduce a one-cycle delay for read data. A testbench is included to verify the RAM’s functionality through various write and read operations.

## Project Overview

The single-port RAM allows writing an 8-bit data value to a 6-bit address when the write enable (`we`) signal is high, synchronized to the rising clock edge. The read operation is synchronous, with the output data (`q`) reflecting the data at the read address provided in the previous clock cycle. This design is suitable for FPGA or ASIC implementation, typically mapping to a block RAM with synchronous read behavior.

### Files in the Project

- **`ram_single_port.sv`**: The main Verilog module implementing the single-port RAM. It defines a 64x8 memory array, handles synchronous writes, and registers the read address for synchronous reads.

- **`ram_single_port_tb.sv`**: The testbench for the RAM module. It tests write and read operations across multiple addresses, including edge cases and simultaneous read/write scenarios, accounting for the one-cycle read delay.

- **`README.md`**: This file, providing documentation and instructions for the project.
