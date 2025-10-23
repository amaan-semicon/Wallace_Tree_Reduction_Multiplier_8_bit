`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.10.2025 14:50:19
// Design Name: 
// Module Name: Wallace_Tree_Reduction
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


module Wallace_Tree_Reduction (
    input  logic [15:0] A, B, C, D,
    output logic [15:0] Z
);

    // Registers to compress 4 16-bit streams down to two 16-bit streams
    logic [15:0] X, Y;

    // --- Carry Wires for all stages ---
    // We need two carry signals propagating "horizontally" across the stages.
    logic [15:0] C0_pipe; // Carries from the first FA of each stage
    logic [15:0] C1_pipe; // Carries from the second FA of each stage

    //************************************************
    // Irregular Stages (0-6) - Unrolled Logic
    //************************************************

    // --- Stage 00 (Column 0) ---
    // Inputs: A[0]
    assign X[0] = A[0];
    assign Y[0] = 'b0;
    assign C0_pipe[0] = 'b0; // No carry out
    assign C1_pipe[0] = 'b0; // No carry out

    // --- Stage 01 (Column 1) ---
    // Inputs: A[1]
    assign X[1] = A[1];
    assign Y[1] = 'b0;
    assign C0_pipe[1] = 'b0; // No carry out
    assign C1_pipe[1] = 'b0; // No carry out

    // --- Stage 02 (Column 2) ---
    // Inputs: A[2], B[0]
    assign X[2] = A[2];
    assign Y[2] = B[0];
    assign C0_pipe[2] = 'b0; // No carry out
    assign C1_pipe[2] = 'b0; // No carry out

    // --- Stage 03 (Column 3) ---
    // Inputs: A[3], B[1]
    assign X[3] = A[3];
    assign Y[3] = B[1];
    assign C0_pipe[3] = 'b0; // No carry out
    assign C1_pipe[3] = 'b0; // No carry out

    // --- Stage 04 (Column 4) ---
    // Inputs: A[4], B[2], C[0]
    // 3:2 compression (1 HA)
    half_adder HA_S4_0 (.X(A[4]), .Y(B[2]), .Sum(X[4]), .Carry(C0_pipe[4]));
    assign Y[4] = C[0];
    assign C1_pipe[4] = 'b0; // No second carry

    // --- Stage 05 (Column 5) ---
    // Inputs: A[5], B[3], C[1], C0_pipe[4] (from col 4)
    // 4:2 compression (1 FA)
    full_adder FA_S5_0 (.X(A[5]), .Y(B[3]), .Cin(C[1]), .Sum(X[5]), .Carry(C0_pipe[5]));
    assign Y[5] = C0_pipe[4];
    assign C1_pipe[5] = 'b0; // No second carry

    // --- Stage 06 (Column 6) ---
    // Inputs: A[6], B[4], C[2], D[0], C0_pipe[5] (from col 5)
    // 5:2 compression (1 FA, 1 HA)
    full_adder FA_S6_0 (.X(A[6]), .Y(B[4]), .Cin(C[2]), .Sum(X[6]), .Carry(C0_pipe[6]));
    half_adder HA_S6_0 (.X(D[0]), .Y(C0_pipe[5]), .Sum(Y[6]), .Carry(C1_pipe[6]));
    // This stage is the first to feed BOTH carry pipes into stage 7.

    //************************************************
    // Regular Stages (7-15) - Generated Logic
    //
    // Each stage from here is a 6:2 compressor:
    // Inputs: A[i], B[i-2], C[i-4], D[i-6], C0_pipe[i-1], C1_pipe[i-1]
    // Outputs: X[i], Y[i], C0_pipe[i], C1_pipe[i]
    //************************************************
    genvar i;
    generate
        for (i = 7; i <= 15; i = i + 1) begin : gen_6_to_2_compressor
            
            // First Full Adder
            full_adder FA_0 (
                .X   ( A[i]         ), // PP0 bit
                .Y   ( B[i-2]       ), // PP1 bit
                .Cin ( C[i-4]       ), // PP2 bit
                .Sum ( X[i]         ), // Sum 0
                .Carry( C0_pipe[i] ) // Carry-out 0
            );

            // Second Full Adder
            full_adder FA_1 (
                .X   ( D[i-6]       ), // PP3 bit
                .Y   ( C0_pipe[i-1] ), // Carry-in 0
                .Cin ( C1_pipe[i-1] ), // Carry-in 1
                .Sum ( Y[i]         ), // Sum 1
                .Carry( C1_pipe[i] ) // Carry-out 1
            );
            
        end
    endgenerate

    // --- Final Carry Propagate Adder ---
    // Sums the two remaining vectors (X and Y) to get the final 16-bit product
    // Note: The final carries C0_pipe[15] and C1_pipe[15] are discarded (overflow).
    assign Z = X + Y;
    
endmodule
