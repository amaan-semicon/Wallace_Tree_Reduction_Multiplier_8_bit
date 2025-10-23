`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.10.2025 14:43:12
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


module full_adder(
input logic X,
input logic Y,
input logic Cin,
output logic Sum,
output logic Carry
    );
 
 logic x, y, z;
 
 half_adder H0(.X(X), .Y(Y), .Sum(x), .Carry(y));
 half_adder H1(.X(x), .Y(Cin), .Sum(Sum), .Carry(z));
 
 assign Carry = y | z;
 
 
    
 
endmodule
