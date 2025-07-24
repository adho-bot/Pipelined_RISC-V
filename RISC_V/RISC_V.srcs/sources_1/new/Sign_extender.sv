/*
Complete RISC-V Sign Extender
I type  -> extend IR[31:20]                           		3'b000
S type  -> extend IR[31:25] && IR[11:7]               		3'b001 <-  
U type  -> extend IR[31:12] (LUI, AUIPC)             		3'b010
B type  -> extend IR[31], IR[7], IR[30:25], IR[11:8] 		3'b011
J type  -> extend IR[31], IR[19:12], IR[20], IR[30:21] (JAL) 	3'b100
*/
module Sign_extender (
    input logic  [6:0]  se_sel_i,    //  based on opcode
    input logic  [31:0] sign_ext_i,
    output logic [31:0] sign_ext_o
);

always_comb begin
    case(se_sel_i) 
        7'b0010011:  sign_ext_o = {{20{sign_ext_i[31]}}, sign_ext_i[31:20]};  // I
        7'b0000011:  sign_ext_o = {{20{sign_ext_i[31]}}, sign_ext_i[31:20]};  // lw
        7'b0100011:  sign_ext_o = {{20{sign_ext_i[31]}}, sign_ext_i[31:25], sign_ext_i[11:7]};  // S
        7'b0110111:  sign_ext_o = {sign_ext_i[31:12], 12'b0};  // U
        7'b1100011:  sign_ext_o = {{18{sign_ext_i[31]}}, sign_ext_i[31], sign_ext_i[7], sign_ext_i[30:25], sign_ext_i[11:8], 1'b0};  // B
        7'b1101111:  sign_ext_o = {{11{sign_ext_i[31]}}, sign_ext_i[19:12], sign_ext_i[20], sign_ext_i[30:21], 1'b0};  // J
        default: sign_ext_o = 32'b0; 
    endcase
end

endmodule
