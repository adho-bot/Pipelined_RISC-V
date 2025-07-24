`include "Definitions.sv" 
module ALU(
    input logic  [9:0]  ALU_op,
    input logic  [31:0] SrcA,
    input logic  [31:0] SrcB,
    output logic 	c_status, 
    output logic [31:0] ALU_out
    );
    //logic type is by default unsigned
    always_comb begin
        case(ALU_op)
            `ADD:begin						//Add
                ALU_out = SrcA + SrcB;
             	c_status = 0;
             end   
            `SUB:begin						//Subtract
                ALU_out = SrcA + ~SrcB + 1;
             	c_status = 0; 
             end                  
            `SLL:begin						//Shift left logical
                ALU_out = SrcA << SrcB;     
             	c_status = 0;                  
             end
            `XORR:begin						//XOR
                ALU_out = SrcA ^ SrcB;  
             	c_status = 0;
             end                    
            `SRL:begin						//Shift right logical
                ALU_out = SrcA >> SrcB; 
             	c_status = 0;
             end                      
            `SRA:begin						//Shift right arithmetic     >>> does arith shift of UNSIGNED value. need to cast Srca to signed type. 
                ALU_out = $signed(SrcA) >>> SrcB; 
             	c_status = 0;
             end                         
            `ORR:begin						//OR
                ALU_out = SrcA | SrcB;
             	c_status = 0;
             end                  
            `ANDD: begin						//AND
                ALU_out = SrcA & SrcB; 
             	c_status = 0;
             end                       
            `BEQ: begin						//Branch if equal
                ALU_out = SrcA + ~SrcB + 1;
                c_status = (ALU_out == 0) ? 1 : 0; 
            end 
            `BNE: begin 					//Branch if not equal
                ALU_out = SrcA + ~SrcB + 1;
                c_status = (ALU_out != 0) ? 1 : 0;       
            end
            `BLT: begin 					//Branch if SrcA < SrcB
                ALU_out = SrcA + ~SrcB + 1;
                c_status = (ALU_out[31] == 1) ? 1 : 0;
            end
            `BGE: begin						//Branch if SrcA >= SrcB
                ALU_out = SrcA + ~SrcB + 1;
                c_status = (ALU_out >= 0) ? 1 : 0;               
            end
            default: begin
                ALU_out = 32'b0; 
                c_status = 1'bX;
            end 
        endcase              
    end
         
endmodule

