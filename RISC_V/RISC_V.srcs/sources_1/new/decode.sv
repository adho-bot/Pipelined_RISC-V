module decode(
    input logic clk,
    input logic rst,
    input logic [31:0] instr_D_i,   //from fetch
    input logic [31:0] PC_old_D_i,  //from fetch
    input logic [31:0] PC_cur_D_i,   //from fetch
    
    input logic [31:0] data_WB_i,    //from writeback
    
    output logic [31:0] PC_old_D_o,  //to execute
    output logic [31:0] PC_cur_D_o,   //to execute
    
    output logic [31:0] sign_ext_D_o, //to execute
    
    output logic [31:0] RD1_D_o,  //to execute
    output logic [31:0] RD2_D_o   //to execute

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

    //Next Pipeline stage logic
    always_ff @(posedge clk) begin
        RD1_D_o <= RD1_l;
        RD2_D_o <= RD2_l;
        sign_ext_D_o <= sign_ext_o_l;
        PC_cur_D_o <= PC_old_D_i;
        PC_cur_D_o <= PC_cur_D_i;
    end

    //Control Unit Logic
    



endmodule 