`include "Definitions.sv"
//LW two cycle latency, with forwarding, have to stall 1 cycle
//R/I dont have to stall with fwding


module Data_hazard(
    input logic [4:0] next_instr_rs2_i,  // register 2 from next instruction (in Decode)
    input logic [4:0] next_instr_rs1_i,  // register 1 from next instruction (in Decode)
    input logic [6:0] next_instr_op_i,   // next instruction opcode (in Decode)
    
    input logic [6:0] prev_instr_op_i,   // previous instruction opcode (in Execute)
    input logic [4:0] prev_instr_rd_i,   // previous instruction destination register
    
    input logic       stall_en_i,       // To check if lw is in action
        
    output logic stall_D_o,
    output logic flush_E_o,
     
    output logic [1:0] RD1_sel_o,
    output logic [1:0] RD2_sel_o
);

always_comb begin
    // Default outputs
    stall_D_o = 1'b0;
    flush_E_o = 1'b0;
    RD1_sel_o = 2'b00;
    RD2_sel_o = 2'b00;
    
    
    if ((prev_instr_op_i == `OP_R_TYPE) || (prev_instr_op_i == `OP_I_TYPE) || (prev_instr_op_i == `OP_LOAD)) begin    //0
        // Check if next instruction uses the destination register of previous instruction
        if (next_instr_op_i != `OP_JAL) begin  //jal is the only one without rs1 and rs2(will add more insturctions like this in the future
            // Check for RS1 dependency (for instructions with rs1)
            if (next_instr_rs1_i == prev_instr_rd_i && next_instr_rs1_i != 0) begin //2
                if (prev_instr_op_i == `OP_LOAD && stall_en_i) begin //4
                    // Load-Use Hazard: Need to stall
                    stall_D_o = 1'b1;
                    flush_E_o = 1'b1;
                    RD1_sel_o = 2'b10;
                end else begin
                    // Forward from Execute to Decode for RS1
                    RD1_sel_o = 2'b01;
                end //4
            end //2
            
            // Check for RS2 dependency (only for instructions with rs2 as well)
            if ((next_instr_op_i == `OP_R_TYPE || next_instr_op_i == `OP_B_TYPE || next_instr_op_i == `OP_STORE ) && (next_instr_rs2_i == prev_instr_rd_i) && (next_instr_rs2_i != 0)) begin //3 //check for RD2 dependency in R type
                if (prev_instr_op_i == `OP_LOAD && stall_en_i) begin //5
                    // Load-Use Hazard: Need to stall
                    stall_D_o = 1'b1;
                    flush_E_o = 1'b1;
                    RD2_sel_o = 2'b10;
                end else begin
                    // Forward from Execute to Decode for RS2
                    RD2_sel_o = 2'b01;
                end //5
            end //3
        end //1
    end //0
end

endmodule