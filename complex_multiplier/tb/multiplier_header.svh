//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Akash K R
// 
// Create Date: 22.05.2024
// Design Name:
// Module Name: multiplier_header
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

`define                                                                     INTEGER_WIDTH 3
`define                                                                     FRACTIONAL_WIDTH 13

`include "multiplier_interface.sv"
`include "multiplier_transaction.sv"
`include "multiplier_generator.sv"
`include "multiplier_driver.sv"
`include "multiplier_monitor.sv"
`include "multiplier_scoreboard.sv"
`include "multiplier_environment.sv"
`include "multiplier_test.sv"