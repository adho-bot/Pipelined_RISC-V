
module fetch(
    input logic         clk,
    input logic         rst, 
    input logic         add_sel_i,          //Multiplexer select
    input logic  [31:0] branch_target_i,       //Branch calculation value
    input logic  [31:0] instr_i,            //insturction from memory
    output logic [31:0] PC_old_F_o,           //Old program counter output   PC -> Instruction memory
    output logic [31:0] PC_cur_F_o,           //Current PC value 
    output logic [31:0] instr_F_o,         //Instruction output
    output logic [31:0] instr_address_o,
    
    
    // Hazard implementation
    input logic         stall_D_i
    );
    
/*==================================================*/    
/*              logic instantiation                 */
/*==================================================*/
    //Program Counter
    logic [31:0] PC_i_l;
    logic [31:0] PC_o_l;
    
    logic        PC_stall_l;
    
    //Datapath
    logic [31:0] PC_cur_l;
    
/*==================================================*/    
/*              Module instantiation                */
/*==================================================*/    
Register PC(
    .clk_i(clk),     
    .rst_i(rst),
    .enable_i(!PC_stall_l),	  //PC enable signal
    .reg_i(PC_i_l),        //Input to PC
    .reg_o(PC_o_l)         //Output from PC
 );
    
    //PC stall
    assign PC_stall_l = stall_D_i;
    
    //Insturction memory address
    assign instr_address_o = PC_o_l;
    
    //Adder output
    assign PC_cur_l = PC_o_l + 32'd4;
    
    //Multiplexer Select Output
    assign PC_i_l = (add_sel_i) ?  branch_target_i : PC_cur_l;
    
    always_ff @(posedge clk or posedge rst or posedge stall_D_i) begin
        if(rst)  begin
            PC_old_F_o <= 32'hX;
            PC_cur_F_o <= 32'hX;
            instr_F_o <= 32'hX;
        end else if (stall_D_i) begin
            PC_old_F_o <= PC_old_F_o;
            PC_cur_F_o <= PC_cur_F_o;
            instr_F_o <= instr_F_o;        
        end else begin
            //PC_output to address
            PC_old_F_o <= PC_o_l;
            PC_cur_F_o <= PC_cur_l;
            //Assign insturction in to insturction out
            instr_F_o <= instr_i;
        end
    end

    
endmodule
