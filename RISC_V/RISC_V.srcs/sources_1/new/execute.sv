module execute (
    //Global signals 
    input logic clk,
    input logic rst, 
    
    //Data path signals
    input logic [31:0] PC_old_E_i,  
    input logic [31:0] PC_cur_E_i,  
    
    input logic [31:0] sign_ext_E_i, 
    
    input logic [31:0] RD1_E_i, 
    input logic [31:0] RD2_E_i,   
    
    
    //Control signals
    input logic [1:0]  data_sel_E_i,  

    input logic        WD3_en_E_i, 
    input logic [4:0]  A3_addr_E_i,

    input logic [9:0]  ALU_op_E_i,  //
    input logic        srcB_sel_E_i, //
    
    input logic        jump_E_i,   
    input logic        branch_E_i, 

    input logic        mem_rd_E_i, 
    input logic        mem_wr_E_i,  
    
    
    //Control output
    output logic [1:0]  data_sel_E_o,  

    output logic        WD3_en_E_o, 
    output logic [4:0]  A3_addr_E_o,
    
    output logic        jump_E_o,   
    output logic        branch_E_o, 

    output logic        mem_rd_E_o, 
    output logic        mem_wr_E_o,  
    
    output logic        c_status_E_o,    
    
   //Datapath output
    output logic [31:0] RD2_E_o,
    output logic [31:0] ALU_E_o,
    output logic [31:0] PC_cur_E_o,
    output logic [31:0] branch_target_E_o,
    
    //Hazard
    
    input logic  [1:0] RD1_sel_i,
    input logic  [1:0] RD2_sel_i,
    
    input logic  [31:0] ALU_E_i,
    input logic  [31:0] MEM_E_i
   
);

/*==================================================*/    
/*              logic instantiation                 */
/*==================================================*/   
    logic [31:0] SrcA_l;
    logic [31:0] SrcB_l;
    logic        c_status_l;
    logic [31:0] ALU_out_l;

    //Hazard
    logic [31:0]  RD2_E_l;
    logic [31:0]  RD1_E_l;
    
//ALU
    ALU ALU_inst(
    .ALU_op_i(ALU_op_E_i),
    .SrcA_i(SrcA_l),
    .SrcB_i(SrcB_l),
    .c_status_o(c_status_l), 
    .ALU_out_o(ALU_out_l)
    );


//RD1 Selection
always_comb begin
    case(RD1_sel_i)
    2'b00: RD1_E_l = RD1_E_i;
    2'b01: RD1_E_l = ALU_E_i;
    2'b10: RD1_E_l = MEM_E_i;
    default:RD1_E_l = RD1_E_i;
    
    endcase
end

//RD2 Selction
always_comb begin
    case(RD2_sel_i)
    2'b00: RD2_E_l = RD2_E_i;
    2'b01: RD2_E_l = ALU_E_i;
    2'b10: RD2_E_l = MEM_E_i;
    default: RD2_E_l = RD2_E_i;     
    endcase
end

assign SrcA_l = RD1_E_l;
assign SrcB_l = (srcB_sel_E_i) ? sign_ext_E_i : RD2_E_l;   //Assign 2nd inpput to either data from sign extend or register

//Branch Offset Adder 

assign branch_target_E_o = sign_ext_E_i + PC_old_E_i;

//Jump/Branch
assign jump_E_o = jump_E_i;
assign branch_E_o = branch_E_i;
assign c_status_E_o = c_status_l;
/*==================================================*/    
/*              Pipeline Logic                      */
/*==================================================*/


always_ff @(posedge clk) begin      
            data_sel_E_o <=  data_sel_E_i; 
            WD3_en_E_o  <= WD3_en_E_i;
            A3_addr_E_o <= A3_addr_E_i;       
            mem_rd_E_o  <= mem_rd_E_i;
            mem_wr_E_o  <=  mem_wr_E_i;
            RD2_E_o <=  RD2_E_l;
            ALU_E_o <= ALU_out_l;
            PC_cur_E_o <= PC_cur_E_i;
    end 
endmodule