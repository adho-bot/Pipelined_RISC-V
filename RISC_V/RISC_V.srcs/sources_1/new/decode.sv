module decode(
//Global Signals
    input logic clk,
    input logic rst,
    
//Datapath Signals
    input logic [31:0] instr_D_i,   //from fetch
    input logic [31:0] PC_old_D_i,  //from fetch
    input logic [31:0] PC_cur_D_i,   //from fetch
    
    input logic [31:0] data_WB_i,    //from writeback
    
    output logic [31:0] PC_old_D_o,  //to execute
    output logic [31:0] PC_cur_D_o,   //to execute
    
    output logic [31:0] sign_ext_D_o, //to execute
    
    output logic [31:0] RD1_D_o,  //to execute
    output logic [31:0] RD2_D_o,   //to execute
    
//Control Signals     

    output logic [1:0]  data_sel_D_o,

    output logic        WD3_en_D_o,
    output logic [4:0]  A3_addr_D_o,

    output logic [9:0]  ALU_op_D_o,
    output logic        srcB_sel_D_o,
    
    output logic        jump_D_o,   
    output logic        branch_D_o,

    output logic        mem_rd_D_o,
    output logic        mem_wr_D_o

);

/*==================================================*/    
/*              logic instantiation                 */
/*==================================================*/
    //Register Bank signals
    logic        WD3_en_l;           // Register file write enable
    logic [4:0]  A1_addr_l;          // rs1 read address
    logic [4:0]  A2_addr_l;          // rs2 read address
    logic [4:0]  A3_addr_l;          // rd write address
    logic [31:0] RD1_l;              // rs1 read data
    logic [31:0] RD2_l;              // rs2 read data
    
    // Sign Extender signals
    logic [6:0]  se_sel_l;      // Sign extension selection (opcode)
    logic [31:0] sign_ext_o_l;  // Sign extended output
    
    //Control unit signals
    logic [1:0]  data_sel_l;
    logic        WD3_en_l;
    logic [4:0]  A1_addr_l;
    logic [4:0]  A2_addr_l;
    logic [4:0]  A3_addr_l;
    logic [9:0]  ALU_op_l;
    logic        srcB_sel_l;
    logic        jump_l;  
    logic        branch_l;  
    logic        mem_rd_l;
    logic        mem_wr_l;

/*==================================================*/    
/*              Module Instantiations               */
/*==================================================*/

  Register_bank register_bank_inst (
    // Control signals
    .clk(clk),                // Keep direct connection for clock
    .rst(rst),                // Keep direct connection for reset
    
    // Data inputs
    .WD3_i(data_WB_i),            // Data to be written
    .WD3_en_i(WD3_en_l),      // Write enable
    
    // Address inputs
    .A1_addr_i(A1_addr_l),    // Read address 1 (rs1)
    .A2_addr_i(A2_addr_l),    // Read address 2 (rs2)
    .A3_addr_i(A3_addr_l),    // Write address (rd)
    
    // Data outputs
    .RD1_o(RD1_l),           // Read data 1 output
    .RD2_o(RD2_l)            // Read data 2 output
  );  

  Sign_extender sign_extender_inst (
    .se_sel_i(se_sel_l),      // Opcode-based control
    .sign_ext_i(instr_D_i), // Input to be extended
    .sign_ext_o(sign_ext_o_l)  // Sign-extended output
  );

    //Control Unit Logic
    
    Control_Unit control_unit_inst (
        // Inputs
        .instr_i(instr_D_i), 
        
        // Outputs
        .se_sel_o(se_sel_l),
        .data_sel_o(data_sel_l),
        .WD3_en_o(WD3_en_l),
        .A1_addr_o(A1_addr_l),
        .A2_addr_o(A2_addr_l),
        .A3_addr_o(A3_addr_l),
        .ALU_op_o(ALU_op_l),
        .srcB_sel_o(srcB_sel_l),
        .jump_o(jump_l), 
        .branch_o(branch_l),
        .mem_rd_o(mem_rd_l),
        .mem_wr_o(mem_wr_l)
    );


/*==================================================*/    
/*              Pipeline Logic                      */
/*==================================================*/

    always_ff @(posedge clk) begin
        //Datapath Signals 
        RD1_D_o <= RD1_l;
        RD2_D_o <= RD2_l;
        sign_ext_D_o <= sign_ext_o_l;
        PC_cur_D_o <= PC_old_D_i;
        PC_cur_D_o <= PC_cur_D_i;
        
        // Control Signals
        data_sel_D_o <= data_sel_l;
        WD3_en_D_o  <= WD3_en_l;
        A3_addr_D_o <= A3_addr_l;
        ALU_op_D_o  <= ALU_op_l;
        srcB_sel_D_o <= srcB_sel_l;
        jump_D_o <= jump_l; 
        branch_D_o <= branch_l;
        mem_rd_D_o  <= mem_rd_l;
        mem_wr_D_o  <= mem_wr_l;
        
        
    end

endmodule 