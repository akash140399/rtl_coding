`default_nettype none
`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Akash K R
// 
// Create Date: 20.05.2024
// Design Name:
// Module Name: multiplier_transaction
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

class multiplier_transaction
#(
    parameter                                                               INTEGER_WIDTH = 3,
    parameter                                                               FRACTIONAL_WIDTH = 13
);
    bit                            [2*(INTEGER_WIDTH+FRACTIONAL_WIDTH)-1:0] input_a;
    bit                            [2*(INTEGER_WIDTH+FRACTIONAL_WIDTH)-1:0] input_b;
    bit                            [2*(INTEGER_WIDTH+FRACTIONAL_WIDTH)-1:0] output_prod;
    bit                            [2*(INTEGER_WIDTH+FRACTIONAL_WIDTH)-1:0] ref_output_prod;

    function new();
        bit signed                     [INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0] real_value;
        bit signed                     [INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0] imag_value;
        bit signed                 [2*(INTEGER_WIDTH+FRACTIONAL_WIDTH)-1:0] product_temp00;
        bit signed                 [2*(INTEGER_WIDTH+FRACTIONAL_WIDTH)-1:0] product_temp01;
        bit signed                 [2*(INTEGER_WIDTH+FRACTIONAL_WIDTH)-1:0] product_temp02;
        bit signed                 [2*(INTEGER_WIDTH+FRACTIONAL_WIDTH)-1:0] product_temp03;
        bit signed                     [INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0] product_temp10;
        bit signed                     [INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0] product_temp11;
        bit signed                     [INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0] product_temp12;
        bit signed                     [INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0] product_temp13;
        bit signed                     [INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0] sum_real;
        bit signed                     [INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0] sum_imag;

        real_value = $signed($urandom_range(1 << INTEGER_WIDTH+FRACTIONAL_WIDTH-2, 1 << FRACTIONAL_WIDTH-4)) * ($urandom%2 ? 1 : -1);
        imag_value = $signed($urandom_range(1 << INTEGER_WIDTH+FRACTIONAL_WIDTH-2, 1 << FRACTIONAL_WIDTH-4)) * ($urandom%2 ? 1 : -1);
        this.input_a = {imag_value, real_value};

        real_value = $signed($urandom_range(1 << INTEGER_WIDTH+FRACTIONAL_WIDTH-2, 1 << FRACTIONAL_WIDTH-4)) * ($urandom%2 ? 1 : -1);
        imag_value = $signed($urandom_range(1 << INTEGER_WIDTH+FRACTIONAL_WIDTH-2, 1 << FRACTIONAL_WIDTH-4)) * ($urandom%2 ? 1 : -1);
        this.input_b = {imag_value, real_value};

        product_temp00 =   $signed(input_a[INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0])
                         * $signed(input_b[INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0]);

        product_temp10[INTEGER_WIDTH+FRACTIONAL_WIDTH-1] = product_temp00[2*(INTEGER_WIDTH+FRACTIONAL_WIDTH)-1];
        product_temp10[INTEGER_WIDTH+FRACTIONAL_WIDTH-2:0] = product_temp00[INTEGER_WIDTH+2*FRACTIONAL_WIDTH-2:FRACTIONAL_WIDTH];

        product_temp01 =   $signed(input_a[2*(INTEGER_WIDTH+FRACTIONAL_WIDTH)-1:INTEGER_WIDTH+FRACTIONAL_WIDTH])
                         * $signed(input_b[2*(INTEGER_WIDTH+FRACTIONAL_WIDTH)-1:INTEGER_WIDTH+FRACTIONAL_WIDTH]);

        product_temp11[INTEGER_WIDTH+FRACTIONAL_WIDTH-1] = product_temp01[2*(INTEGER_WIDTH+FRACTIONAL_WIDTH)-1];
        product_temp11[INTEGER_WIDTH+FRACTIONAL_WIDTH-2:0] = product_temp01[INTEGER_WIDTH+2*FRACTIONAL_WIDTH-2:FRACTIONAL_WIDTH];

        product_temp02 =   $signed(input_a[INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0])
                         * $signed(input_b[2*(INTEGER_WIDTH+FRACTIONAL_WIDTH)-1:INTEGER_WIDTH+FRACTIONAL_WIDTH]);

        product_temp12[INTEGER_WIDTH+FRACTIONAL_WIDTH-1] = product_temp02[2*(INTEGER_WIDTH+FRACTIONAL_WIDTH)-1];
        product_temp12[INTEGER_WIDTH+FRACTIONAL_WIDTH-2:0] = product_temp02[INTEGER_WIDTH+2*FRACTIONAL_WIDTH-2:FRACTIONAL_WIDTH];

        product_temp03 =   $signed(input_a[2*(INTEGER_WIDTH+FRACTIONAL_WIDTH)-1:INTEGER_WIDTH+FRACTIONAL_WIDTH])
                         * $signed(input_b[INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0]);
    
        product_temp13[INTEGER_WIDTH+FRACTIONAL_WIDTH-1] = product_temp03[2*(INTEGER_WIDTH+FRACTIONAL_WIDTH)-1];
        product_temp13[INTEGER_WIDTH+FRACTIONAL_WIDTH-2:0] = product_temp03[INTEGER_WIDTH+2*FRACTIONAL_WIDTH-2:FRACTIONAL_WIDTH];

        sum_real = $signed(product_temp10) - $signed(product_temp11);
        sum_imag = $signed(product_temp12) + $signed(product_temp13);

        this.ref_output_prod = {sum_imag, sum_real};
    endfunction

    function void display
    (
        input  string                                                       name
    );
        $display("%s", {100{"="}});
        $display("%s", name);
        $display("%s", {100{"="}});
        $display("input_a = %0f + 1i*%0f, input_b = %0f + 1i*%0f output_prod = %0f + 1i*%0f, ref_output_prod = %0f + 1i*%0f",
                 $itor($signed(input_a[INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0])) / 2**FRACTIONAL_WIDTH,
                 $itor($signed(input_a[2*(INTEGER_WIDTH+FRACTIONAL_WIDTH)-1:INTEGER_WIDTH+FRACTIONAL_WIDTH])) / 2**FRACTIONAL_WIDTH,
                 $itor($signed(input_b[INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0])) / 2**FRACTIONAL_WIDTH,
                 $itor($signed(input_b[2*(INTEGER_WIDTH+FRACTIONAL_WIDTH)-1:INTEGER_WIDTH+FRACTIONAL_WIDTH])) / 2**FRACTIONAL_WIDTH,
                 $itor($signed(output_prod[INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0])) / 2**FRACTIONAL_WIDTH,
                 $itor($signed(output_prod[2*(INTEGER_WIDTH+FRACTIONAL_WIDTH)-1:INTEGER_WIDTH+FRACTIONAL_WIDTH])) / 2**FRACTIONAL_WIDTH,
                 $itor($signed(ref_output_prod[INTEGER_WIDTH+FRACTIONAL_WIDTH-1:0])) / 2**FRACTIONAL_WIDTH,
                 $itor($signed(ref_output_prod[2*(INTEGER_WIDTH+FRACTIONAL_WIDTH)-1:INTEGER_WIDTH+FRACTIONAL_WIDTH])) / 2**FRACTIONAL_WIDTH);
        $display("%s", {100{"="}});
    endfunction
endclass