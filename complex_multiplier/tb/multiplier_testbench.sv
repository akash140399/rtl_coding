`default_nettype none
`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Akash K R
// 
// Create Date: 20.05.2024
// Design Name:
// Module Name: multiplier_testbench
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
///////////////////////////////////////////////////////////////////////////

`include "multiplier_header.svh"

module multiplier_testbench();
    bit                                                                     clk;
    bit                                                                     rst_n;

    multiplier_interface                                                    intf0(clk, rst_n);

    always #5 clk = ~clk;

    initial
    begin
        rst_n = 1'b0;
        #25;
        rst_n = 1'b1;
    end

    multiplier_test
    complex_multiplier_test0
    (
        .intf0                                                              (intf0)
    );

    complex_multiplier
    #(
        .INTEGER_WIDTH                                                      (`INTEGER_WIDTH),
        .FRACTIONAL_WIDTH                                                   (`FRACTIONAL_WIDTH)
    )
    DUT
    (
        .clk                                                                (intf0.clk),
        .rst_n                                                              (intf0.rst_n),

        .input_a_tvalid                                                     (intf0.input_a_tvalid),
        .input_a_tready                                                     (intf0.input_a_tready),
        .input_a_tdata                                                      (intf0.input_a_tdata),

        .input_b_tvalid                                                     (intf0.input_b_tvalid),
        .input_b_tready                                                     (intf0.input_b_tready),
        .input_b_tdata                                                      (intf0.input_b_tdata),

        .output_prod_tvalid                                                 (intf0.output_prod_tvalid),
        .output_prod_tready                                                 (intf0.output_prod_tready),
        .output_prod_tdata                                                  (intf0.output_prod_tdata)
    );

    initial
    begin
        $dumpfile("dump.vcd");
        $dumpvars(0, multiplier_testbench);
    end
endmodule