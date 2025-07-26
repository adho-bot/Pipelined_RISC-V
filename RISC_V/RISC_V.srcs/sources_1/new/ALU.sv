`include "Definitions.sv" 
module ALU(
    input logic  [9:0]  ALU_op_i,
    input logic  [31:0] SrcA_i,
    input logic  [31:0] SrcB_i,
    output logic 	c_status_o, 
    output logic [31:0] ALU_out_o
    );
    //logic type is by default unsigned
    always_comb begin
        case(ALU_op_i)
            `ADD:begin						//Add
                ALU_out_o = SrcA_i + SrcB_i;
             	c_status_o = 0;
             end   
            `SUB:begin						//Subtract
                ALU_out_o = SrcA_i + ~SrcB_i + 1;
             	c_status_o = 0; 
             end                  
            `SLL:begin						//Shift left logical
                ALU_out_o = SrcA_i << SrcB_i;     
             	c_status_o = 0;                  
             end
            `XORR:begin						//XOR
                ALU_out_o = SrcA_i ^ SrcB_i;  
             	c_status_o = 0;
             end                    
            `SRL:begin						//Shift right logical
                ALU_out_o = SrcA_i >> SrcB_i; 
             	c_status_o = 0;
             end                      
            `SRA:begin						//Shift right arithmetic     >>> does arith shift of UNSIGNED value. need to cast Srca to signed type. 
                ALU_out_o = $signed(SrcA_i) >>> SrcB_i; 
             	c_status_o = 0;
             end                         
            `ORR:begin						//OR
                ALU_out_o = SrcA_i | SrcB_i;
             	c_status_o = 0;
             end                  
            `ANDD: begin						//AND
                ALU_out_o = SrcA_i & SrcB_i; 
             	c_status_o = 0;
             end                       
            `BEQ: begin						//Branch if equal
                ALU_out_o = SrcA_i + ~SrcB_i + 1;
                c_status_o = (ALU_out_o == 0) ? 1 : 0; 
            end 
            `BNE: begin 					//Branch if not equal
                ALU_out_o = SrcA_i + ~SrcB_i + 1;
                c_status_o = (ALU_out_o != 0) ? 1 : 0;       
            end
            `BLT: begin 					//Branch if SrcA < SrcB
                ALU_out_o = SrcA_i + ~SrcB_i + 1;
                c_status_o = (ALU_out_o[31] == 1) ? 1 : 0;
            end
            `BGE: begin						//Branch if SrcA >= SrcB
                ALU_out_o = SrcA_i + ~SrcB_i + 1;
                c_status_o = (ALU_out_o >= 0) ? 1 : 0;               
            end
            default: begin
                ALU_out_o = 32'b0; 
                c_status_o = 1'bX;
            end 
        endcase              
    end
         
endmodule

