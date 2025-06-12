`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.06.2025 16:57:56
// Design Name: 
// Module Name: Wallace_Tree_Multiplier_tb
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


module Wallace_Tree_Multiplier_tb;

    localparam width = 8;
    reg [width - 1 : 0] multiplier;
    reg [width - 1 : 0] multiplicand;
    wire [(2 * width) - 1 : 0] product;

    // Instantiate the multiplier
    Wallace_Tree_Multiplier #(.width(width)) uut (
        .multiplier(multiplier),
        .multiplicand(multiplicand),
        .product(product)
    );

    initial 
    begin
        // Test case 1
        multiplier = 8'd15;
        multiplicand = 8'd10;
        #10;  // wait 10 time units

        // Test case 2
        multiplier = 8'd25;
        multiplicand = 8'd40;
        #10;

        // Test case 3
        multiplier = 8'd100;
        multiplicand = 8'd3;
        #10;

        // Test case 4
        multiplier = 8'd255;
        multiplicand = 8'd255;
        #10;

        // Test case 5 (edge case: multiplying by 0)
        multiplier = 8'd0;
        multiplicand = 8'd123;
        #10;

        $stop;  // stop simulation
    end

endmodule


