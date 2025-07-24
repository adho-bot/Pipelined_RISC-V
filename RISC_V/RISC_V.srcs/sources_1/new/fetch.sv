`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/24/2025 05:06:26 AM
// Design Name: 
// Module Name: fetch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fetch(
    input logic         clk,
    input logic         rst, 
    input logic         add_sel_i,          //Multiplexer select
    input logic  [31:0] branch_target_i,       //Branch calculation value
    input logic         PC_en_i,            //PC enable\
    input logic  [31:0] instr_i,            //insturction from memory
    output logic [31:0] PC_old_F_o,           //Old program counter output   PC -> Instruction memory
    output logic [31:0] PC_cur_F_o,           //Current PC value 
    output logic [31:0] instr_F_o             //Instruction output
    );
    
/*==================================================*/    
/*              logic instantiation                 */
/*==================================================*/
    //Program Counter
    logic [31:0] PC_i_l;
    logic [31:0] PC_o_l;
    
    //Datapath
    logic [31:0] PC_cur_l;
    
/*==================================================*/    
/*              Module instantiation                */
/*==================================================*/    
Register PC(
    .clk_i(clk),     
    .rst_i(rst),
    .enable_i(PC_en_i),	  //PC enable signal
    .reg_i(PC_i_l),        //Input to PC
    .reg_o(PC_o_l)         //Output from PC
 );
    
   
    
    //Adder output
    assign PC_cur_l = PC_o_l + 32'd4;
    
    //Multiplexer Select Output
    assign PC_i_l = (add_sel_i) ?  branch_target_i : PC_cur_l;
    
    always_ff @(posedge clk) begin
        //PC_output to address
        PC_old_F_o <= PC_o_l;
        PC_cur_F_o <= PC_cur_l;
        
        //Assign insturction in to insturction out
        instr_F_o <= instr_i;
    end

    
endmodule
