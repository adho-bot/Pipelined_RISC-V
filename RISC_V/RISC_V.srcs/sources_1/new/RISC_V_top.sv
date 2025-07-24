
module RISC_V_top(
    input logic clk,
    input logic rst


    );
    
/*==================================================*/    
/*              logic instantiation                 */
/*==================================================*/    
    //fetch
    
    
    
  fetch fetch_inst (
    .clk(clk),
    .rst(rst), 
    .add_sel_i(add_sel_l),          // Multiplexer select
    .branch_target_i(branch_target_l),  // Branch calculation value
    .PC_en_i(PC_en_l),              // PC enable
    .instr_i(instr_l),              // Instruction from memory
    .PC_old_F_o(PC_old_l),            // Old program counter output
    .PC_cur_F_o(PC_cur_l),            // Current PC value 
    .instr_F_o(instr_l)               // Instruction output
  );

    
    
    
    
    
    
    
    
    
    
endmodule
