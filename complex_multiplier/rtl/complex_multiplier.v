`default_nettype none
`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Akash K R
// 
// Create Date: 19.05.2024
// Design Name:
// Module Name: complex_multiplier
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

`include "fixed_point_multiplier.v"

module complex_multiplier
#(
    parameter                                                               INTEGER_WIDTH = 3,
    parameter                                                               FRACTIONAL_WIDTH = 13
)
(
    input  wire                                                             clk,
    input  wire                                                             rst_n,

    input  wire                                                             input_a_tvalid,
    output wire                                                             input_a_tready,
    input  wire                    [2*(INTEGER_WIDTH+FRACTIONAL_WIDTH)-1:0] input_a_tdata,

    input  wire                                                             input_b_tvalid,
    output wire                                                             input_b_tready,
    input  wire                    [2*(INTEGER_WIDTH+FRACTIONAL_WIDTH)-1:0] input_b_tdata,

    output reg                                                              output_prod_tvalid,
    input  wire                                                             output_prod_tready,
    output wire                    [2*(INTEGER_WIDTH+FRACTIONAL_WIDTH)-1:0] output_prod_tdata
);
    localparam                                                              MUL_STATE = 2'b00;
    localparam                                                              ADD_STATE = 2'b01;
    localparam                                                              WRITE_STATE = 2'b10;

    wire signed                        [INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0] input_a_real;
    wire signed                        [INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0] input_a_imag;
    wire signed                        [INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0] input_b_real;
    wire signed                        [INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0] input_b_imag;

    reg signed                         [INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0] prod_real1;
    reg signed                         [INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0] prod_real2;
    reg signed                         [INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0] prod_imag1;
    reg signed                         [INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0] prod_imag2;

    wire signed                        [INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0] prod_real1_wire;
    wire signed                        [INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0] prod_real2_wire;
    wire signed                        [INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0] prod_imag1_wire;
    wire signed                        [INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0] prod_imag2_wire;

    reg signed                         [INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0] prod_real;
    reg signed                         [INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0] prod_imag;

    wire                                                                    input_valid;
    reg                                                                     input_ready;
    reg                                                               [1:0] state;

    assign input_a_real = input_a_tdata[INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0];
    assign input_a_imag = input_a_tdata[2*(INTEGER_WIDTH+FRACTIONAL_WIDTH)-1:INTEGER_WIDTH+FRACTIONAL_WIDTH];

    assign input_b_real = input_b_tdata[INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0];
    assign input_b_imag = input_b_tdata[2*(INTEGER_WIDTH+FRACTIONAL_WIDTH)-1:INTEGER_WIDTH+FRACTIONAL_WIDTH];

    assign input_a_tready = rst_n & input_ready;
    assign input_b_tready = rst_n & input_ready;
    assign input_valid = input_a_tvalid & input_b_tvalid;

    assign output_prod_tdata[INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0] = prod_real;
    assign output_prod_tdata[2*(INTEGER_WIDTH+FRACTIONAL_WIDTH)-1:INTEGER_WIDTH+FRACTIONAL_WIDTH] = prod_imag;

    always@(posedge clk)
    begin
        if(rst_n == 1'b0)
        begin
            output_prod_tvalid <= 1'b0;
            input_ready <= 1'b1;
            prod_real1 <=  'h0;
            prod_real2 <=  'h0;
            prod_imag1 <=  'h0;
            prod_imag2 <=  'h0;
            prod_real <=  'h0;
            prod_imag <=  'h0;
            state <= MUL_STATE;
        end

        else
        begin
            case(state)
                MUL_STATE  :    begin
                                    if(input_ready & input_valid)
                                    begin
                                        prod_real1 <= prod_real1_wire;
                                        prod_real2 <= prod_real2_wire;
                                        prod_imag1 <= prod_imag1_wire;
                                        prod_imag2 <= prod_imag2_wire;
                                        input_ready <= 1'b0;
                                        state <= ADD_STATE;
                                    end

                                    else
                                        state <= MUL_STATE;
                                end

                ADD_STATE   :   begin
                                    output_prod_tvalid <= 1'b1;
                                    prod_real <= prod_real1 - prod_real2;
                                    prod_imag <= prod_imag1 + prod_imag2;
                                    state <= WRITE_STATE;
                                end

                WRITE_STATE :   begin
                                    if(output_prod_tready == 1'b1)
                                    begin
                                        output_prod_tvalid <= 1'b0;
                                        input_ready <= 1'b1;
                                        state <= MUL_STATE;
                                    end

                                    else
                                        state <= WRITE_STATE;
                                end
            endcase
        end
    end

    fixed_point_multiplier
    #(
        .INTEGER_WIDTH                                                      (INTEGER_WIDTH),
        .FRACTIONAL_WIDTH                                                   (FRACTIONAL_WIDTH)
    )
    multiplier0
    (
        .input_a                                                            (input_a_real),
        .input_b                                                            (input_b_real),
        .output_prod                                                        (prod_real1_wire)
    );

    fixed_point_multiplier
    #(
        .INTEGER_WIDTH                                                      (INTEGER_WIDTH),
        .FRACTIONAL_WIDTH                                                   (FRACTIONAL_WIDTH)
    )
    multiplier1
    (
        .input_a                                                            (input_a_imag),
        .input_b                                                            (input_b_imag),
        .output_prod                                                        (prod_real2_wire)
    );

    fixed_point_multiplier
    #(
        .INTEGER_WIDTH                                                      (INTEGER_WIDTH),
        .FRACTIONAL_WIDTH                                                   (FRACTIONAL_WIDTH)
    )
    multiplier2
    (
        .input_a                                                            (input_a_real),
        .input_b                                                            (input_b_imag),
        .output_prod                                                        (prod_imag1_wire)
    );

    fixed_point_multiplier
    #(
        .INTEGER_WIDTH                                                      (INTEGER_WIDTH),
        .FRACTIONAL_WIDTH                                                   (FRACTIONAL_WIDTH)
    )
    multiplier3
    (
        .input_a                                                            (input_a_imag),
        .input_b                                                            (input_b_real),
        .output_prod                                                        (prod_imag2_wire)
    );
endmodule