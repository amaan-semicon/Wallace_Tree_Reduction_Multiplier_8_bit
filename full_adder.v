`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.06.2025 14:30:12
// Design Name: 
// Module Name: full_adder
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


// 1-bit Full Adder
module full_adder(
    input  a,
    input  b,
    input  cin,
    output sum,
    output carry
);
    wire t0, t1, t2;

    xor(t0, a, b);
    xor(sum, t0, cin);
    and(t1, t0, cin);
    and(t2, a, b);
    or(carry, t1, t2);
endmodule

