`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.12.2024 22:56:38
// Design Name: 
// Module Name: FIFO_sync
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


module FIFO_sync(
    input clock,
    input reset,
    input w_enable,
    input r_enable,
    input [7:0] write_data,      // Changed to conventional [7:0] format
    output reg [7:0] read_data,  // Changed to conventional [7:0] format
    output wire full,
    output wire empty
);
    reg [7:0]  memory[15:0];
    reg [4:0]FIFO_counter=0;
    reg [3:0]wrpt=0;
    reg [3:0]rpt=0;
    assign empty=(FIFO_counter==0);
    assign full=(FIFO_counter==16);
    
    always@(posedge clock or posedge reset)
    begin
        if(reset)
        begin
        wrpt<=0;
        FIFO_counter<=0;
        end 
        else if(w_enable && !full) 
        begin
        memory[wrpt]<=write_data;
        wrpt<=(wrpt+1)%16;
        FIFO_counter<=(FIFO_counter+1);
        end
    end
    
    always@(posedge clock or posedge reset)
    begin
        if(reset)begin
        rpt<=0;
        read_data<=0;
        end 
        else if(r_enable && !empty)
        begin
        read_data<=memory[rpt];
        rpt<=(rpt+1)%16;
        FIFO_counter<=(FIFO_counter-1);
        end 
    end
    
endmodule