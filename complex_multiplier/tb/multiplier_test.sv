`default_nettype none
`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Akash K R
// 
// Create Date: 22.05.2024
// Design Name:
// Module Name: multiplier_test
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

program multiplier_test
(
    multiplier_interface                                                    intf0
);
    multiplier_environment                                                  env0;

    initial
    begin
        env0 = new(.vi_intf0(intf0));

        env0.gen0.num_transactions = $urandom_range(10, 28);
        $display("Number of transactions = %0d", env0.gen0.num_transactions);
        env0.run();
    end
endprogram