`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.10.2025 17:05:12
// Design Name: 
// Module Name: booth_multiplier_top_module
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


module booth_multiplier_top_module(
    input  logic [7:0] A, B,     // A: Multiplicand, B: Multiplier
    output logic [15:0] data_out // 16-bit Product
);

    // Wires to connect the two stages
    logic [15:0] W, X, Y, Z;

    
    // Instantiate the generator
    Partial_Product_Generator pp_gen_unit (
        .A(A),        // Multiplicand
        .B(B),        // Multiplier
        .W(W),        // PP0
        .X(X),        // PP1
        .Y(Y),        // PP2
        .Z(Z)         // PP3
    );

    //  Stage 2: Wallace Tree Reduction 
    
    Wallace_Tree_Reduction wallace_tree_unit (
        .A(W),        // PP0
        .B(X),        // PP1
        .C(Y),        // PP2
        .D(Z),        // PP3
        .Z(data_out)  // Final 16-bit Product
    );
    
endmodule

