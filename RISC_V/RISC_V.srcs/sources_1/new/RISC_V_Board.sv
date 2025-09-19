

module RISC_V_Board(
    input logic CLK_50MHZ_R,  //need to change to fit constraints later. right now i need to do verification
//    input logic rst

    output logic debug_clk 

    );
    
/*==================================================*/    
/*              logic instantiation                 */
/*==================================================*/     
    
logic rst, locked, clk;    
    
logic [31:0] instr_l;          // Instruction from instruction memory
logic [31:0] instr_address_o;         // PC address to instruction memory

// Data memory  signals
logic [31:0] data_read_M_l;    // Data read from data memory
logic [31:0] RD2_M_l;          // Data to write to data memory
logic mem_wr_M_l;              // Data memory write enable
logic mem_rd_M_l;              // Data memory read enable
logic [31:0] address_M_l;      // Address for data memory access
    
//Hazard signals    
logic [1:0] RD1_sel_l;  
logic [1:0] RD2_sel_l;  
logic       flush_E_l;  
logic       stall_D_l; 
logic       stall_en_l;
    
    
logic [31:0] instr_DH_o, instr_FH_o;    
    
//debug
assign debug_clk = clk;    
    
clk_wiz_0 clk_inst
   (
    // Clock out ports
    .clk_out1(clk),     // output clk_out1
    // Status and control signals
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(CLK_50MHZ_R)      // input clk_in1
);    
    
assign rst = !locked;
    
RISC_V_top risc_v_top_inst (
    // Global signals
    .clk(clk),
    .rst(rst),
    
    // Instruction memory interface
    .instr_i(instr_l),                      //From instruction memory
    .instr_address_o(instr_address_o),      //To instruction memory
    .instr_DH_o(instr_DH_o),                  //to Hazard
    .instr_FH_o(instr_FH_o),                  //to Hazard 
    
    // Data memory interface
    .data_mem_out_M_i(data_read_M_l),  
    .RD2_M_o(RD2_M_l),         
    .mem_wr_M_o(mem_wr_M_l),    
    .mem_rd_M_o(mem_rd_M_l),   
    .address_M_o(address_M_l),  
    
    //Hazard
    .RD1_sel_i(RD1_sel_l),  
    .RD2_sel_i(RD2_sel_l),  
    .flush_E_i(flush_E_l),  
    .stall_D_i(stall_D_l),
    .stall_en_o(stall_en_l)  
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
    
//Hazard Unit
Hazard_unit hazard_unit_inst (

    .clk(clk),
    .rst(rst),

    .instruction_D_i(instr_DH_o),            //From RISCV top
    .instruction_F_i(instr_FH_o),            //FRom RISCV top
    .stall_en_i(stall_en_l),


    .RD1_sel_o(RD1_sel_l),  
    .RD2_sel_o(RD2_sel_l),  
    .flush_E_o(flush_E_l),  
    .stall_D_o(stall_D_l)  
);    
    
    
    
    
endmodule
