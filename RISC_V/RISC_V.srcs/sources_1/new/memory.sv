module memory (
    input               clk,
    input               rst,

    input logic [1:0]  data_sel_M_i,  

    input logic        WD3_en_M_i, 
    input logic [4:0]  A3_addr_M_i, 

    input logic        mem_rd_M_i, 
    input logic        mem_wr_M_i,  
    
    input logic [31:0] data_read_M_i,

    
    // Datapath inputs
    input logic [31:0] RD2_M_i,
    input logic [31:0] ALU_M_i,
    input logic [31:0] PC_cur_M_i,

    //Datapath outputs
    output logic [31:0] RD2_M_o,
    output logic [31:0] address_M_o,
    
    //Control outputs
    output logic        mem_rd_M_o, 
    output logic        mem_wr_M_o,
    
    //pipeline output
    output logic [31:0] PC_cur_M_o,
    output logic [31:0] ALU_M_o,

    output logic [1:0]  data_sel_M_o,  

    output logic        WD3_en_M_o, 
    output logic [4:0]  A3_addr_M_o,
    
    output logic [31:0] data_read_M_o
);


    //To data memory
    assign RD2_M_o = RD2_M_i;
    assign address_M_o = ALU_M_i;
    assign mem_rd_M_o = mem_rd_M_i;
    assign mem_wr_M_o = mem_wr_M_i;
    
    //Pipeline logic
    
    always_ff @(posedge clk) begin
    PC_cur_M_o <= PC_cur_M_i;
    ALU_M_o <= ALU_M_i;
    data_sel_M_o <= data_sel_M_i;
    WD3_en_M_o <= WD3_en_M_i;
    A3_addr_M_o <= A3_addr_M_i;
    data_read_M_o <= data_read_M_i;
    end 




endmodule