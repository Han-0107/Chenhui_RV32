module ex_mem(
    //clk & rst
    input               clk                         ,
    input               rstn                        ,
    //Control signals
    input               reg_wr_line_in              ,
    input               mem2reg_sel_line_in         ,
    input               mem_wr_line_in              ,
    input               mem_rd_line_in              ,
    input       [2:0]   mem_op_line_in              ,
    //alu_imm
    //alu_ex
    input       [31:0]  alu_ex_result_line_in       ,
    //reg
    input       [31:0]  reg2_data_line_in           ,
    //reg write bank addr
    input       [4:0]   reg_wb_addr_line_in         ,
    //data output
    //Control signals
    output  reg         reg_wr_line_out             ,
    output  reg         mem2reg_sel_line_out        ,
    output  reg         mem_wr_line_out             ,
    output  reg         mem_rd_line_out             ,
    output  reg [2:0]   mem_op_line_out             ,
    //alu_ex
    output  reg [31:0]  alu_ex_result_line_out      ,
    //reg
    output  reg [31:0]  reg2_data_line_out          ,
    //reg write bank addr
    output  reg [4:0]   reg_wb_addr_line_out        
);

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        reg_wr_line_out     <= 1'd0;
        mem2reg_sel_line_out<= 1'd0;
        mem_wr_line_out     <= 1'd0;
        mem_rd_line_out     <= 1'd0;
        mem_op_line_out     <= 3'd0;
    end
    else begin
        reg_wr_line_out     <= reg_wr_line_in     ;
        mem2reg_sel_line_out<= mem2reg_sel_line_in;
        mem_wr_line_out     <= mem_wr_line_in     ;
        mem_rd_line_out     <= mem_rd_line_in     ;
        mem_op_line_out     <= mem_op_line_in     ;
    end
end


always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        alu_ex_result_line_out  <= 32'd0;
    end
    else begin
        alu_ex_result_line_out  <= alu_ex_result_line_in;
    end
end

always @(posedge clk or negedge rstn) begin
    if(!rstn)
        reg2_data_line_out <= 32'd0;
    else
        reg2_data_line_out <= reg2_data_line_in;
end

always @(posedge clk or negedge rstn) begin
    if(!rstn)
        reg_wb_addr_line_out <= 5'd0;
    else
        reg_wb_addr_line_out <= reg_wb_addr_line_in;
end

endmodule
