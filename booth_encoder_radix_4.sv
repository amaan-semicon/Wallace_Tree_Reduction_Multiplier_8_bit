`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.10.2025 16:22:39
// Design Name: 
// Module Name: booth_encoder_radix_4
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


module booth_encoder_radix_4(
    input  logic X, Y, Z,
    output logic [1:0] b,
    output logic sign_bit
);

   
    always_comb begin
        // Group the 3 bits to use in the case statement
        case ({X, Y, Z})
            // {Y[i+1], Y[i], Y[i-1]}
            3'b000: begin sign_bit = 1'b0; b = 2'b00; end // Operation: +0
            3'b001: begin sign_bit = 1'b0; b = 2'b01; end // Operation: +1*M
            3'b010: begin sign_bit = 1'b0; b = 2'b01; end // Operation: +1*M
            3'b011: begin sign_bit = 1'b0; b = 2'b10; end // Operation: +2*M
            3'b100: begin sign_bit = 1'b1; b = 2'b10; end // Operation: -2*M
            3'b101: begin sign_bit = 1'b1; b = 2'b01; end // Operation: -1*M
            3'b110: begin sign_bit = 1'b1; b = 2'b01; end // Operation: -1*M
            3'b111: begin sign_bit = 1'b0; b = 2'b00; end // Operation: +0
            
            
            default: begin sign_bit = 1'bx; b = 2'bxx; end
        endcase
    end
    
endmodule
