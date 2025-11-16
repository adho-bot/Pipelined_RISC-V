module Direction_predictor(
input logic i_clk,
input logic i_update,
input logic i_actual_taken,
input logic [9:0] i_pc_index,   //lower PC bits for index
output logic o_predict_taken
);

logic [1:0] BHT [0:1024];

//2 bit width(4 counter values)
// 1024 differnt PC indexes 

assign predict_taken = BHT[i_pc_index][1];  //probes the msb of the counter


always_ff@(posedge i_clk) begin
    if(i_update) begin
        if(i_actual_taken && BHT[i_pc_index] != 2'b11)    //prevents overflow
            BHT[i_pc_index] <= BHT[i_pc_index] + 1;
        else if(!i_actual_taken && BHT[i_pc_index] != 2'b00)
            BHT[i_pc_index] <= BHT[i_pc_index] + 1;            
    end
end

endmodule
