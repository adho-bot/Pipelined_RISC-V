
module RISC_V_top(
    input logic clk,
    input logic rst,
    
    
    //instruction memory signals 
    input logic [31:0] instr_i,
    output logic [31:0] instr_address_o,
    
    //data memory signals
    input logic [31:0] data_mem_out_M_i,
    output logic [31:0] RD2_M_o,
    output logic mem_wr_M_o,
    output logic mem_rd_M_o,
    output logic [31:0] address_M_o
    );
    
/*==================================================*/    
/*              logic instantiation                 */
/*==================================================*/  

// Fetch signals
logic add_sel_l;
logic [31:0] branch_target_E_l;
logic [31:0] PC_old_l;
logic [31:0] PC_cur_l;

// Decode signals
logic [31:0] instr_F_l;
logic [31:0] PC_old_D_l;
logic [31:0] PC_cur_D_l;
logic [31:0] sign_ext_D_l;
logic [31:0] RD1_D_l;
logic [31:0] RD2_D_l;
logic [1:0] data_sel_D_l;
logic WD3_en_D_l;
logic [4:0] A3_addr_D_l;
logic [9:0] ALU_op_D_l;
logic srcB_sel_D_l;
logic jump_D_l;
logic branch_D_l;
logic mem_rd_D_l;
logic mem_wr_D_l;

// Execute signals
logic [1:0] data_sel_E_l;
logic WD3_en_E_l;
logic [4:0] A3_addr_E_l;
logic jump_E_l;
logic branch_E_l;
logic mem_rd_E_l;
logic mem_wr_E_l;
logic c_status_E_l;
logic [31:0] RD2_E_l;
logic [31:0] ALU_E_l;
logic [31:0] PC_cur_E_l;
// Memory signals
logic [31:0] RD2_M_l;
logic [31:0] address_M_l;
logic mem_rd_M_l;
logic mem_wr_M_l;
logic [31:0] PC_cur_M_l;
logic [31:0] ALU_M_l;
logic [1:0] data_sel_M_l;
logic WD3_en_M_l;
logic [4:0] A3_addr_M_l;
logic [31:0] data_read_M_l;

// Writeback signals
logic [31:0] data_WB_l;
logic WD3_en_WB_l;
logic [4:0] A3_addr_WB_l;

 
 
/*==================================================*/    
/*                     Fetch                        */
/*==================================================*/   
  fetch fetch_inst (
        //Global Signals
        .clk(clk),
        .rst(rst), 
        
        //Datapath Singals
        .add_sel_i(add_sel_l),          // Multiplexer select                   //
        .branch_target_i(branch_target_E_l),  // Branch calculation value       //
        .instr_i(instr_i),              // Instruction from memory          <-
        .PC_old_F_o(PC_old_l),            // Old program counter output     <-    //
        .PC_cur_F_o(PC_cur_l),            // Current PC value                   //
        .instr_F_o(instr_F_l),          // Instruction output                 //
        .instr_address_o(instr_address_o)
  );
  
  //Jump/Branch decision logic
    assign add_sel_l = jump_E_l | (c_status_E_l & branch_E_l);
    

 /*
instruction_memory instruction_memory_inst(
    .clk(clk),
    .address_i(PC_old_l),
    .instruction_o(instr_l)
    );
*/
/*==================================================*/    
/*                     Decode                       */
/*==================================================*/   
    decode decode_inst (
        // Global Signals
        .clk(clk),
        .rst(rst),
        
        // Datapath Signals
        .instr_D_i(instr_F_l),            //Instruction input                       //
        .PC_old_D_i(PC_old_l),          //Old PC value input                      //
        .PC_cur_D_i(PC_cur_l),          //Current PC value input                  //
        .data_D_i(data_WB_l),           //Written back data to register bank      //
        .A3_addr_D_i(A3_addr_WB_l),     //Written back data to the RB             //
        .WD3_en_D_i(WD3_en_WB_l),       //Witten back data tot he RB              //
        
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
    
/*==================================================*/    
/*                     Execute                      */
/*==================================================*/  
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
    
    
/*==================================================*/    
/*                     Memory                       */
/*==================================================*/     
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
        .data_read_M_i(data_mem_out_M_i),  // This connects to data memory output <- 
        
        // Memory interface outputs
        .RD2_M_o(RD2_M_l),            //<- 
        .address_M_o(address_M_l),    //<- 
        .mem_rd_M_o(mem_rd_M_l),      //<-     
        .mem_wr_M_o(mem_wr_M_l),      //<-
        
        // Pipeline outputs (to writeback)
        .PC_cur_M_o(PC_cur_M_l),
        .ALU_M_o(ALU_M_l),
        .data_sel_M_o(data_sel_M_l),
        .WD3_en_M_o(WD3_en_M_l),
        .A3_addr_M_o(A3_addr_M_l),
        .data_read_M_o(data_read_M_l)  //data memory output pipelined
    );    
    
  assign RD2_M_o = RD2_M_l;
  assign mem_wr_M_o = mem_wr_M_l;
  assign mem_rd_M_o = mem_rd_M_l;
  assign address_M_o = address_M_l;
/*    
    data_memory data_memory_inst(
    .clk(clk),
    .address_i(address_M_l),  
    .data_i(RD2_M_l),     
    .data_wr(mem_wr_M_l),           
    .data_rd(mem_rd_M_l),         

    .data_o(data_mem_out_M_l)  
);
*/    
/*==================================================*/    
/*                     Writeback                    */
/*==================================================*/ 
  writeback writeback_inst (
        // Global signals
        .clk(clk),
        .rst(rst),
        
        // Inputs from memory stage
        .PC_cur_WB_i(PC_cur_M_l),
        .ALU_WB_i(ALU_M_l),
        .data_sel_WB_i(data_sel_M_l),
        .WD3_en_WB_i(WD3_en_M_l),
        .A3_addr_WB_i(A3_addr_M_l),
        .data_read_WB_i(data_read_M_l),
        
        // Outputs
        .data_WB_o(data_WB_l),
        .WD3_en_WB_o(WD3_en_WB_l),
        .A3_addr_WB_o(A3_addr_WB_l)
  );
    
    

endmodule
