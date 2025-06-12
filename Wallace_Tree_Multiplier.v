`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.06.2025 14:03:40
// Design Name: 
// Module Name: Wallace_Tree_Multiplier
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


module Wallace_Tree_Multiplier #(parameter width = 8)(

input [width - 1 : 0] multiplier,
input [width - 1 : 0] multiplicand,
output [width * 2 : 0] product
    );
wire [ (width**2) - 1 : 0] pp_sig;
wire [65:0] sum, carry;
genvar j, k;
generate
    for(j = 0 ; j < width ; j = j + 1)
        begin: outer_loop
            for(k = 0 ; k < width; k = k + 1)
                begin: inner_loop
                    assign pp_sig[8*j + k] = multiplier[j] & multiplicand[k];
                    end
                 end
       endgenerate
 //level_1_stage_1
 half_adder HA1_L1(
 pp_sig[0],
 pp_sig[8],
 sum[0],
 carry[0]
 );
generate    
    for(j = 0 ; j < 6 ; j = j + 1)
        begin: L1_S1
            full_adder FA1_L1(
            pp_sig[2+j],
            pp_sig[9 + j],
            pp_sig[16 + j],
            sum[1 + j],
            carry[1 + j]
            );
            end
     endgenerate
  half_adder HA2_L1(
  pp_sig[15],
  pp_sig[22],
  sum[7],
  carry[7]
  );
 
 //level_1_stage_2
 half_adder HA3_L1(
 pp_sig[25],
 pp_sig[32],
 sum[8],
 carry[8]
 );
generate    
    for(j = 0 ; j < 6 ; j = j + 1)
        begin: L1_S2
            full_adder FA1_L1(
            pp_sig[26 + j],
            pp_sig[33 + j],
            pp_sig[40 + j],
            sum[9 + j],
            carry[9 + j]
            );
            end
     endgenerate
  half_adder HA4_L1(
  pp_sig[39],
  pp_sig[46],
  sum[15],
  carry[15]
  );
  //level_2_stage_1
  half_adder HA1_L2(
  sum[1],
  carry[0],
  sum[16],
  carry[16]
  );
  full_adder FA1_L2(
  sum[2],
  carry[1],
  pp_sig[24],
  sum[17],
  carry[17]
  );
  generate
        for(j = 0 ; j < 5 ; j = j + 1)
            begin:L2_S1
              full_adder FA2_l2(
               sum[3 + j],
               carry[2 + j],
               sum[8 + j],
               sum[18 + j],
               carry[18 + j]
              ); 
              end 
     endgenerate
     full_adder FA3_L2(
     pp_sig[23],
     carry[7],
     sum[13],
     sum[23],
     carry[23]
     );
 //level_2_stage_2
 half_adder HA2_L2(
 carry[9],
 pp_sig[48],
 sum[24],
 carry[24]
 );
 generate
    for(j = 0 ; j < 6 ; j = j + 1 )
        begin: L2_S2
            full_adder  FA4_L2(
            carry[10 + j],
            pp_sig[49 + j],
            pp_sig[56 + j],
            sum[25 + j],
            carry[25 + j]
            );
            end
         endgenerate
    half_adder HA3_L2(
    pp_sig[55],
    pp_sig[62],
    sum[31],
    carry[31]
    );
 //level_3_stage_1
 half_adder HA1_L3(
 sum[17],
 carry[16],
 sum[32],
 carry[32]
    );
 half_adder HA2_L3(
 sum[18],
 carry[17],
 sum[33],
 carry[33]
 );
 full_adder FA1_L3(
 sum[19],
 carry[18],
 carry[8],
 sum[34],
 carry[34]
 );
 generate
    for(j = 0 ; j < 4 ; j = j + 1)
    begin:L3_s1
    full_adder FA2_L3(
    sum[20 +j],
    carry[19 + j],
    sum[24 + j],
    sum[35 + j],
    carry[35 + j]
    );
    end
   endgenerate
 full_adder FA3_L3(
 sum[14],
 carry[23],
 sum[28],
 sum[39],
 carry[39]
 );
   half_adder HA3_L3(
   sum[15],
   sum[29],
   sum[40],
   carry[40]
   );
   half_adder HA4_L3(
   pp_sig[47],
   sum[30],
   sum[41],
   carry[41]
   );
 //level_4_stage_1
 generate
    for(j = 0 ; j < 3 ; j = j + 1)
        begin: L4_S1
        half_adder HA1_L4(
        sum[33 + j],
        carry[32 + j ],
        sum[42 + j],
        carry[42 + j]
        );
        end
       endgenerate
 generate
    for(j = 0 ; j < 6 ; j = j + 1)
        begin:L4_S2
            full_adder FA1_L4(
            carry[24 + j],
            sum[36 + j],
            carry[35 + j],
            sum[45 + j],
            carry[45 + j]
            );
            end
    endgenerate
 full_adder FA2_L4(
 carry[30],
 sum[31],
 carry[41],
 sum[51],
 carry[51]
 );
 half_adder HA2_L4(
 carry[31],
 pp_sig[63],
 sum[52],
 carry[52]
 ); 
 assign product[0] = pp_sig[0];
 assign product[1] = sum[0];
 assign product[2] = sum[16];
 assign product[3] = sum[32];
 //level_5_stage_1
 assign product[4] = sum[42];
 half_adder HA1_L5(
 sum[43],
 carry[42],
 product[5],
 carry[53]
 );
 generate
    for(j = 0 ; j < 9 ; j = j + 1)
        begin:L5_S1
            full_adder FA1_L5(
            sum[44 + j],
            carry[43 + j],
            carry[53 + j],
            product[6 + j],
            carry[54 + j]
            
            );
end
endgenerate
half_adder HA2_L5(
carry[52],
carry[62],
product[15],
carry[63]
);
   
            
endmodule
