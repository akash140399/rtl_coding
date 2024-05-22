`default_nettype none
`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Akash K R
// 
// Create Date: 19.05.2024
// Design Name:
// Module Name: fixed_point_multiplier
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

module fixed_point_multiplier
#(
    parameter                                                           INTEGER_WIDTH = 3,
    parameter                                                           FRACTIONAL_WIDTH = 13
)
(
    input  wire signed             [INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0] input_a,
    input  wire signed             [INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0] input_b,
    output wire signed             [INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0] output_prod
);
    reg signed                 [2*(INTEGER_WIDTH+FRACTIONAL_WIDTH)-1:0] product;

    assign output_prod[INTEGER_WIDTH+FRACTIONAL_WIDTH-1] = product[2*(INTEGER_WIDTH+FRACTIONAL_WIDTH)-1];
    assign output_prod[INTEGER_WIDTH+FRACTIONAL_WIDTH-2:0] = product[INTEGER_WIDTH+2*FRACTIONAL_WIDTH-2:FRACTIONAL_WIDTH];

    always@(*)
        product = input_a * input_b;
endmodule