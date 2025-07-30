

module RISC_V_Board(
    input clk,   //need to change to fit constraints later. right now i need to do verification
    input rst

    );
    
/*==================================================*/    
/*              logic instantiation                 */
/*==================================================*/     
    
logic [31:0] instr_l;          // Instruction from instruction memory
logic [31:0] instr_address_o;         // PC address to instruction memory

// Data memory interface signals
logic [31:0] data_read_M_l;    // Data read from data memory
logic [31:0] RD2_M_l;          // Data to write to data memory
logic mem_wr_M_l;              // Data memory write enable
logic mem_rd_M_l;              // Data memory read enable
logic [31:0] address_M_l;      // Address for data memory access
    
RISC_V_top risc_v_top_inst (
    // Global signals
    .clk(clk),
    .rst(rst),
    
    // Instruction memory interface
    .instr_i(instr_l),        
    .instr_address_o(instr_address_o),       
    
    // Data memory interface
    .data_mem_out_M_i(data_read_M_l),  
    .RD2_M_o(RD2_M_l),         
    .mem_wr_M_o(mem_wr_M_l),    
    .mem_rd_M_o(mem_rd_M_l),   
    .address_M_o(address_M_l)  
);
    
instruction_memory instruction_memory_inst(
    .clk(clk),
    .address_i(instr_address_o),
    .instruction_o(instr_l)
);
    
    
data_memory data_memory_inst(
    .clk(clk),
    .address_i(address_M_l),  
    .data_i(RD2_M_l),     
    .data_wr(mem_wr_M_l),           
    .data_rd(mem_rd_M_l),         
    
    .data_o(data_read_M_l)  
);
    
    
    
    
    
    
endmodule
