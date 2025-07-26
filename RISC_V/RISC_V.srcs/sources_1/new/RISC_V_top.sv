
module RISC_V_top(
    input logic clk,
    input logic rst


    );
    
/*==================================================*/    
/*              logic instantiation                 */
/*==================================================*/   
 
  //fetch  
  fetch fetch_inst (
    //Global Signals
    .clk(clk),
    .rst(rst), 
    
    //Datapath Singals
    .add_sel_i(add_sel_l),          // Multiplexer select
    .branch_target_i(branch_target_l),  // Branch calculation value
    .instr_i(instr_l),              // Instruction from memory
    .PC_old_F_o(PC_old_l),            // Old program counter output         //
    .PC_cur_F_o(PC_cur_l),            // Current PC value                   //
    .instr_F_o(instr_l)               // Instruction output                 //
  );

  //decode
    decode decode_inst (
    // Global Signals
    .clk(clk),
    .rst(rst),
    
    // Datapath Signals
    .instr_D_i(instr_l),          //Instruction input                       //
    .PC_old_D_i(PC_old_l),        //Old PC value input                      //
    .PC_cur_D_i(PC_cur_l),        //Current PC value input                  //
    .data_WB_i(data_WB_l),          //Written back data to register bank    
    
    .PC_old_D_o(PC_old_D_l),    //Old PC value output                       //
    .PC_cur_D_o(PC_cur_D_l),    //Current PC value output                   //
    .sign_ext_D_o(sign_ext_D_l),    //Sign extend value output              //
    .RD1_D_o(RD1_D_l),              //Register bank output 1                //
    .RD2_D_o(RD2_D_l),              //Register bank output 2                //
        
    // Control Signals
    .data_sel_D_o(data_sel_D_l),    //Select register bank writeback register   //
    .WD3_en_D_o(WD3_en_D_l),        //Register bank write enable            //
    .A3_addr_D_o(A3_addr_D_l),      //Data write selector                   //
    .ALU_op_D_o(ALU_op_D_l),        //ALU operation                         //
    .srcB_sel_D_o(srcB_sel_D_l),    // IMM or register select to ALU input  //
    .jump_D_o(jump_D_l),                                                    //
    .branch_D_o(branch_D_l),                                                //
    .mem_rd_D_o(mem_rd_D_l),        //data memory read enable               //
    .mem_wr_D_o(mem_wr_D_l)         //data memory write enable              //
);
    
    //Execute
    execute execute_inst (
    // Global signals
    .clk(clk),
    .rst(rst),
    
    // Data path signals
    .PC_old_E_i(PC_old_D_l),                                                //
    .PC_cur_E_i(PC_cur_D_l),                                                //
    .sign_ext_E_i(sign_ext_D_l),                                            //
    .RD1_E_i(RD1_D_l),                                                      //
    .RD2_E_i(RD2_D_l),                                                      //
    
    // Control signals
    .data_sel_E_i(data_sel_D_l),                                            //
    .WD3_en_E_i(WD3_en_D_l),                                                //
    .A3_addr_E_i(A3_addr_D_l),                                              //
    .ALU_op_E_i(ALU_op_D_l),                                                //
    .srcB_sel_E_i(srcB_sel_D_l),                                            //
    .jump_E_i(jump_D_l),                                                    //
    .branch_E_i(branch_D_l),                                                //
    .mem_rd_E_i(mem_rd_D_l),                                                //
    .mem_wr_E_i(mem_wr_D_l),                                                //
    
    // Control output
    .data_sel_E_o(data_sel_E_l),  
    .WD3_en_E_o(WD3_en_E_l), 
    .A3_addr_E_o(A3_addr_E_l),
    .jump_E_o(jump_E_l),   
    .branch_E_o(branch_E_l), 
    .mem_rd_E_o(mem_rd_E_l), 
    .mem_wr_E_o(mem_wr_E_l),  
    .c_status_E_o(c_status_E_l),    
    
    // Datapath output
    .RD2_E_o(RD2_E_l),
    .ALU_E_o(ALU_E_l),
    .PC_cur_E_o(PC_cur_E_l),
    .branch_target_E_o(branch_target_E_l)
);
    
    memory memory_inst (
        // Global signals
        .clk(clk),
        .rst(rst),
        
        // Control inputs (from execute)
        .data_sel_M_i(data_sel_E_l),
        .WD3_en_M_i(WD3_en_E_l),
        .A3_addr_M_i(A3_addr_E_l),
        .mem_rd_M_i(mem_rd_E_l),
        .mem_wr_M_i(mem_wr_E_l),
        
        // Datapath inputs (from execute)
        .RD2_M_i(RD2_E_l),
        .ALU_M_i(ALU_E_l),
        .PC_cur_M_i(PC_cur_E_l),
        .data_read_M_i(data_read_M_l),  // This connects to data memory output
        
        // Memory interface outputs
        .RD2_M_o(RD2_M_o_l),
        .address_M_o(address_M_o_l),
        .mem_rd_M_o(mem_rd_M_o_l),          
        .mem_wr_M_o(mem_wr_M_o_l),
        
        // Pipeline outputs (to writeback)
        .PC_cur_M_o(PC_cur_M_o_l),
        .ALU_M_o(ALU_M_o_l),
        .data_sel_M_o(data_sel_M_o_l),
        .WD3_en_M_o(WD3_en_M_o_l),
        .A3_addr_M_o(A3_addr_M_o_l),
        .data_read_M_o(data_read_M_o_l)
    );    
    
    
    
    
    
    
    
    
endmodule
