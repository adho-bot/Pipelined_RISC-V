//some noes
//Stalling a pipeline just means insterting a bubble into fetch
// req: need to stop PC from incrementing, need to find a way to override instr mem and store a nop instruction

//Flush
// Change all registers to have a rst function to rst all current instructions in the pipeline

//3 modules, stural, data, control, including interlocking inside


module Hazard_unit(
    input logic clk,
    input logic rst,
    
    input logic [31:0]  instruction_D_i,
    input logic [31:0]  instruction_F_i,
    
    output logic [1:0] RD1_sel_o,
    output logic [1:0] RD2_sel_o,
    output logic       flush_E_o,
    output logic       stall_D_o

    );

logic [4:0] next_instr_rs2_l;
logic [4:0] next_instr_rs1_l;
logic [6:0] next_instr_op_l;
logic [6:0] prev_instr_op_l;
logic [4:0] prev_instr_rd_l;

logic [1:0] RD1_sel_l, RD2_sel_l;

Data_hazard data_hazard_inst (

    //Instruction reading 
    .next_instr_rs2_i(next_instr_rs2_l),
    .next_instr_rs1_i(next_instr_rs1_l),
    .next_instr_op_i(next_instr_op_l),
    .prev_instr_op_i(prev_instr_op_l),
    .prev_instr_rd_i(prev_instr_rd_l),
    
    //Hazard Control signals
    .stall_D_o(stall_D_o),
    .flush_E_o(flush_E_o),
    .RD1_sel_o(RD1_sel_l),
    .RD2_sel_o(RD2_sel_l)
);

//Data hazard instruction partioning
assign next_instr_rs2_l = instruction_F_i[24:20];
assign next_instr_rs1_l = instruction_F_i[19:15];
assign next_instr_op_l  = instruction_F_i[6:0];
assign prev_instr_op_l  = instruction_D_i[6:0];
assign prev_instr_rd_l  = instruction_D_i[11:7];

always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
        RD1_sel_o <= 2'hX;
        RD2_sel_o <= 2'hX;    
    end else begin
        RD1_sel_o <= RD1_sel_l;
        RD2_sel_o <= RD2_sel_l;
    end
end


endmodule

