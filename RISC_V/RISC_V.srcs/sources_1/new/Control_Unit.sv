`include "Definitions.sv"

module Control_Unit(
    input  logic [31:0] instr_i,


    // Datapath controls
    output logic [6:0]  se_sel_o,
    output logic [1:0]  data_sel_o,

    // Register control
    output logic        WD3_en_o,
    output logic [4:0]  A1_addr_o,
    output logic [4:0]  A2_addr_o,
    output logic [4:0]  A3_addr_o,
    
    //Branch/Jump control
    output logic        jump_o,     //signals a jump instr
    output logic        branch_o,   //signals a brnach instruction

    // ALU control
    output logic [9:0]  ALU_op_o,
    output logic        srcB_sel_o,
    // Memory control
    output logic        mem_rd_o,
    output logic        mem_wr_o
);

    // Instruction fields
    logic [6:0]  opcode; 
    logic [4:0]  rs1;    
    logic [4:0]  rs2;   
    logic [4:0]  rd;     
    logic [2:0]  funct3;
    logic [6:0]  funct7;

    always_comb begin
        //Instruction field assignment
        opcode = instr_i[6:0];
        rs1    = instr_i[19:15];
        rs2    = instr_i[24:20];
        rd     = instr_i[11:7];
        funct3 = instr_i[14:12];
        funct7 = instr_i[31:25];
    
        // Default control signal values
        
        // Register file controls
        A1_addr_o     = rs1;
        A2_addr_o     = rs2;
        A3_addr_o     = rd;
        WD3_en_o      = 1'b0;  // Default no writeback
        
        // ALU controls
        srcB_sel_o    = 1'bX;  // Default rs2
        
        // Memory controls
        mem_rd_o      = 1'b0;
        mem_wr_o      = 1'b0;
        
        // Sign extension
        se_sel_o      = opcode;
        
        // Data selection
        data_sel_o    = 2'bXX; // Default ALU result
        
        //Jump/Branch
        jump_o = 1'b0;   
        branch_o = 1'b0;  

        // Instruction decoding
        case(opcode)
            // R-type instructions
            7'b0110011: begin
                ALU_op_o = {funct7, funct3};
                WD3_en_o = 1'b1;
                srcB_sel_o = 1'b0;
                data_sel_o = 2'b00;
            end
            
            // I-type arithmetic
            7'b0010011: begin
                ALU_op_o = {7'b0000000, funct3};
                WD3_en_o = 1'b1;
                srcB_sel_o = 1'b1;
                data_sel_o = 2'b00;
            end
            
            // Load instructions
            7'b0000011: begin
                ALU_op_o = {7'b0000000, 3'b000};    // ADD
                srcB_sel_o = 1'b1;                  // Use offset
                mem_rd_o = 1'b1;                    // Read
                data_sel_o = 2'b01;                 // Memory data
                WD3_en_o = 1'b1;
            end
            
            // Store instructions
            7'b0100011: begin
                ALU_op_o = {7'b0000000, 3'b000};  // ADD
                srcB_sel_o = 1'b1;  // Use offset
                mem_wr_o = 1'b1;
            end
            
            // Branch instructions
            7'b1100011: begin
                ALU_op_o = {7'b1111111, funct3}; 
                branch_o = 1'b1; 
            end
            
            // JAL
            7'b1101111: begin
                WD3_en_o = 1'b1;     //Writeback enabled
                data_sel_o = 2'b10;  //PC+4
                jump_o = 1'b1;  
            end
            
            default: begin
                // Default control signal values
                
                // Register file controls
                A1_addr_o     = rs1;
                A2_addr_o     = rs2;
                A3_addr_o     = rd;
                WD3_en_o      = 1'b0;  // Default no writeback
                
                // ALU controls
                srcB_sel_o    = 1'bX;  // Default rs2
                
                // Memory controls
                mem_rd_o      = 1'b0;
                mem_wr_o      = 1'b0;
                
                // Sign extension
                se_sel_o      = opcode;
                
                // Data selection
                data_sel_o    = 2'bXX; // Default ALU result
                
                //Branch/Jump
                jump_o = 1'b0;   
                branch_o = 1'b0; 
            end
        endcase
    end
endmodule