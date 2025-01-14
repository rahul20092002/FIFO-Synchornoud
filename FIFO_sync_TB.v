`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.12.2024 00:44:01
// Design Name: 
// Module Name: FIFO_sync_TB
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


module FIFO_sync_TB;

    // Inputs
    reg clock;
    reg reset;
    reg w_enable;
    reg r_enable;
    reg [7:0] write_data;

    // Outputs
    wire [7:0] read_data;
    wire full;
    wire empty;

    // Instantiate the FIFO module
    FIFO_sync uut (
        .clock(clock),
        .reset(reset),
        .w_enable(w_enable),
        .r_enable(r_enable),
        .write_data(write_data),
        .read_data(read_data),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // 10ns clock period
    end

    // Test logic
    integer i;

    initial begin
        // Initialize signals
        w_enable = 0;
        r_enable = 0;
        write_data = 0;
        reset = 1;
        i=0;

        // Apply reset
        #20 reset = 0;

        // Write data to the FIFO
        for (i = 0; i < 5; i = i + 1) begin
            @(posedge clock)
            w_enable = 1;
            write_data = i;
        end
        @(posedge clock)
        w_enable = 0;

        // Read 5 data values from the FIFO
        for (i = 0; i < 7; i = i + 1) begin
            @(posedge clock)
                r_enable = 1;
        end
        @(posedge clock)
        r_enable = 0;

        // Write 16 data values into the FIFO
        for (i = 0; i < 16; i = i + 1) begin
            @(posedge clock)
            if (!full) begin  // Check FIFO is not full
                w_enable = 1;
                write_data = i + 1;
            end
        end
        @(posedge clock)
        w_enable = 0;

        // Read 16 data values from the FIFO
        for (i = 0; i < 16; i = i + 1) begin
            @(posedge clock)
                r_enable = 1;
        end
        @(posedge clock)
        r_enable = 0;

        // Finish simulation
        #50 $stop;
    end

endmodule
