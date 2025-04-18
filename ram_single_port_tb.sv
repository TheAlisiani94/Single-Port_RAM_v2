// Testbench for the single-port RAM module with synchronous read/write.
module ram_single_port_tb;
    // Testbench signals
    reg [7:0] data;            // 8-bit input data
    reg [5:0] read_addr;       // 6-bit read address
    reg [5:0] write_addr;      // 6-bit write address
    reg we;                    // Write enable
    reg clk;                   // Clock
    wire [7:0] q;              // 8-bit output data

    // Instantiate the RAM module (unit under test)
    ram_single_port uut (
        .q(q),
        .data(data),
        .read_addr(read_addr),
        .write_addr(write_addr),
        .we(we),
        .clk(clk)
    );

    // Clock generation: 10 time units period (5 units high, 5 units low)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus process
    initial begin
        // Initialize inputs
        data = 8'b0;
        read_addr = 6'b0;
        write_addr = 6'b0;
        we = 1'b0;

        // Monitor inputs and outputs
        $monitor("Time=%0t clk=%b we=%b write_addr=%h data=%h read_addr=%h read_addr_reg=%h q=%h",
                 $time, clk, we, write_addr, data, read_addr, uut.read_addr_reg, q);

        // Test sequence
        #10; // Wait for initial stabilization

        // Test 1: Write to address 0
        @(negedge clk);
        we = 1; write_addr = 6'h00; data = 8'hAA;
        @(negedge clk);
        we = 0;

        // Test 2: Read from address 0 (expect 0xAA after one cycle)
        @(negedge clk);
        read_addr = 6'h00;
        @(negedge clk); // Wait one cycle for read_addr_reg to update
        // q should be 0xAA

        // Test 3: Write to address 63
        @(negedge clk);
        we = 1; write_addr = 6'h3F; data = 8'h55;
        @(negedge clk);
        we = 0;

        // Test 4: Read from address 63 (expect 0x55 after one cycle)
        @(negedge clk);
        read_addr = 6'h3F;
        @(negedge clk); // Wait one cycle
        // q should be 0x55

        // Test 5: Write to multiple addresses
        @(negedge clk);
        we = 1;
        write_addr = 6'h01; data = 8'h11;
        @(negedge clk);
        write_addr = 6'h02; data = 8'h22;
        @(negedge clk);
        we = 0;

        // Test 6: Read from multiple addresses
        @(negedge clk);
        read_addr = 6'h01;
        @(negedge clk); // Wait one cycle (expect 0x11)
        read_addr = 6'h02;
        @(negedge clk); // Wait one cycle (expect 0x22)

        // Test 7: Simultaneous write and read (write to addr 10, read from addr 0)
        @(negedge clk);
        we = 1; write_addr = 6'h0A; data = 8'hFF; read_addr = 6'h00;
        @(negedge clk);
        we = 0;
        @(negedge clk); // Wait one cycle (expect q = 0xAA from addr 0)

        // Test 8: Read from address 10
        @(negedge clk);
        read_addr = 6'h0A;
        @(negedge clk); // Wait one cycle (expect 0xFF)

        // End simulation
        #20 $finish;
    end
endmodule
