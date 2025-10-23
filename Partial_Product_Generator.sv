`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.10.2025 16:35:00
// Design Name: 
// Module Name: Partial_Product_Generator
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


module Partial_Product_Generator(
    input  logic [7:0] A, B,             // A: Multiplicand, B: Multiplier
    output logic [15:0] W, X, Y, Z       // 4x 16-bit PPs
);

    // --- 1. Prepare Multiplicand Values (Sign-extended to 16 bits) ---
    logic [15:0] A_1x, A_2x, A_neg1x, A_neg2x;

    // 1x A (Sign-extended from 8 bits to 16 bits)
    assign A_1x = {{8{A[7]}}, A};
    
    // 2x A (Shift left by 1, sign-extended)
    assign A_2x = {{7{A[7]}}, A, 1'b0};

    // -1x A (2's complement of A_1x)
    assign A_neg1x = ~A_1x + 1;

    // -2x A (2's complement of A_2x)
    assign A_neg2x = ~A_2x + 1;

    // 2. Booth Encoding (using a generate loop) 
    
    // Extend the multiplier B with a '0' on the right for Y[-1]
    logic [8:0] b_temp;
    assign b_temp = {B, 1'b0}; // b_temp[8:0] = {B[7]...B[0], 1'b0}

    // Wires for the 4 encoders
    logic [1:0] B_new[4];
    logic       sign_bit[4];

    // This 'generate' block creates 4 copies of the encoder
    genvar i;
    generate
        for(i = 0; i < 4; i++) begin : gen_encoders
            
            booth_encoder_radix_4 encoder_inst (
                .X      ( b_temp[2*i + 2] ),
                .Y      ( b_temp[2*i + 1] ),
                .Z      ( b_temp[2*i]     ),
                .b      ( B_new[i]        ),
                .sign_bit( sign_bit[i]     )
            );
        end
    endgenerate

    //  3. Partial Product Muxes (Selection) 
    
    // Now use an always_comb block to select the right PP
    // This part *is* behavioral and belongs in an always_comb.
    always_comb begin
        // --- PP0 (W) ---
        case ({sign_bit[0], B_new[0]})
            3'b0_01: W = A_1x;
            3'b0_10: W = A_2x;
            3'b1_01: W = A_neg1x;
            3'b1_10: W = A_neg2x;
            default:  W = 16'b0;
        endcase
        
        // --- PP1 (X) ---
        case ({sign_bit[1], B_new[1]})
            3'b0_01: X = A_1x;
            3'b0_10: X = A_2x;
            3'b1_01: X = A_neg1x;
            3'b1_10: X = A_neg2x;
            default:  X = 16'b0;
        endcase

        // --- PP2 (Y) ---
        case ({sign_bit[2], B_new[2]})
            3'b0_01: Y = A_1x;
            3'b0_10: Y = A_2x;
            3'b1_01: Y = A_neg1x;
            3'b1_10: Y = A_neg2x;
            default:  Y = 16'b0;
        endcase

        // --- PP3 (Z) ---
        case ({sign_bit[3], B_new[3]})
            3'b0_01: Z = A_1x;
            3'b0_10: Z = A_2x;
            3'b1_01: Z = A_neg1x;
            3'b1_10: Z = A_neg2x;
            default:  Z = 16'b0;
        endcase
    end
    
endmodule
