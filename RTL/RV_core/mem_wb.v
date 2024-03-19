module mem_wb(
    //clk & rst
    input               clk                         ,
    input               rstn                        ,
    //data input
    //Control signals
    input               reg_wr_line_in              ,
    input               mem2reg_sel_line_in         ,
    //data ram 
    input       [31:0]  ram_data_out_line_in        ,
    //alu_ex
    input       [31:0]  alu_ex_result_line_in       ,
    //reg write bank addr
    input       [4:0]   reg_wb_addr_line_in         ,

    //Control signals
    output  reg         reg_wr_line_out             ,
    output  reg         mem2reg_sel_line_out        ,
    //data ram 
    output  reg [31:0]  ram_data_out_line_out       ,
    //alu_ex
    output  reg [31:0]  alu_ex_result_line_out      ,
    //reg write bank addr
    output  reg [4:0]   reg_wb_addr_line_out        
);

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        reg_wr_line_out     <= 1'd0;
        mem2reg_sel_line_out<= 1'd0;
    end
    else begin
        reg_wr_line_out     <= reg_wr_line_in     ;
        mem2reg_sel_line_out<= mem2reg_sel_line_in;
    end
end

always @(*) begin
        ram_data_out_line_out <= ram_data_out_line_in;
end

always @(posedge clk or negedge rstn) begin
    if(!rstn)
        alu_ex_result_line_out <= 31'd0;
    else
        alu_ex_result_line_out <= alu_ex_result_line_in;
end

always @(posedge clk or negedge rstn) begin
    if(!rstn)
        reg_wb_addr_line_out <= 5'd0;
    else
        reg_wb_addr_line_out <= reg_wb_addr_line_in;
end

endmodule
