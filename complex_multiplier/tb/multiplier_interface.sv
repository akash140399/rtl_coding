`default_nettype none
`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Akash K R
// 
// Create Date: 20.05.2024
// Design Name:
// Module Name: multiplier_interface
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
interface multiplier_interface
(
    input  wire                                                             clk,
    input  wire                                                             rst_n
);
    logic                                                                   input_a_tvalid;
    logic                                                                   input_a_tready;
    logic                        [2*(`INTEGER_WIDTH+`FRACTIONAL_WIDTH)-1:0] input_a_tdata;

    logic                                                                   input_b_tvalid;
    logic                                                                   input_b_tready;
    logic                        [2*(`INTEGER_WIDTH+`FRACTIONAL_WIDTH)-1:0] input_b_tdata;

    logic                                                                   output_prod_tvalid;
    logic                                                                   output_prod_tready;
    logic                        [2*(`INTEGER_WIDTH+`FRACTIONAL_WIDTH)-1:0] output_prod_tdata;
endinterface