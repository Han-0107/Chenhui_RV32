module id_ex(
    //clk & rst
    input               clk                         ,
    input               rstn                        ,
    //data input
    //Control signals
    input               reg_wr_line_in              ,
    input               mem2reg_sel_line_in         ,
    input               mem_wr_line_in              ,
    input               mem_rd_line_in              ,
    input       [2:0]   mem_op_line_in              ,
    input       [1:0]   exAlu_op_line_in            ,
    input               exAlu_data1_sel_line_in     ,
    //PC
    //input       [31:0]  PC_line_in                  ,
    //reg
    input       [31:0]  reg1_data_line_in           ,
    input       [31:0]  reg2_data_line_in           ,
    //Imm gen
    input       [31:0]  imm_gen_data_line_in        ,
    //ALU Control
    input       [3:0]   instruct_alu_ctrl_line_in   ,
    //reg write bank addr

    input       [4:0]   reg_wb_addr_line_in         ,

    input       [4:0]   rs_reg1_addr_line_in        ,
    input       [4:0]   rs_reg2_addr_line_in        ,

    //data output
    //Control signals
    output  reg         reg_wr_line_out             ,
    output  reg         mem2reg_sel_line_out        ,
    output  reg         mem_wr_line_out             ,
    output  reg         mem_rd_line_out             ,
    output  reg [2:0]   mem_op_line_out             ,
    output  reg [1:0]   exAlu_op_line_out           ,
    output  reg         exAlu_data1_sel_line_out    ,
    //PC
    //output  reg [31:0]  PC_line_out                 ,
    //reg
    output      [31:0]  reg1_data_line_out          ,
    output      [31:0]  reg2_data_line_out          ,
    //Imm gen
    output  reg [31:0]  imm_gen_data_line_out       ,
    //ALU Control                              
    output  reg [3:0]   instruct_alu_ctrl_line_out  ,
    //reg write bank addr
    output  reg [4:0]   reg_wb_addr_line_out        ,
    
    output  reg [4:0]   rs_reg1_addr_line_out       ,
    output  reg [4:0]   rs_reg2_addr_line_out
);

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        reg_wr_line_out          <= 1'd0;
        mem2reg_sel_line_out     <= 1'd0;
        mem_wr_line_out          <= 1'd0;
        mem_rd_line_out          <= 1'd0;
        mem_op_line_out          <= 3'd0;
        exAlu_op_line_out        <= 2'd0;
        exAlu_data1_sel_line_out <= 1'd0;
    end
    else begin
        reg_wr_line_out         <= reg_wr_line_in         ;
        mem2reg_sel_line_out    <= mem2reg_sel_line_in    ;
        mem_wr_line_out         <= mem_wr_line_in         ;
        mem_rd_line_out         <= mem_rd_line_in         ;
        mem_op_line_out         <= mem_op_line_in         ;
        exAlu_op_line_out       <= exAlu_op_line_in       ;
        exAlu_data1_sel_line_out<= exAlu_data1_sel_line_in;
    end
end

assign reg1_data_line_out = reg1_data_line_in;
assign reg2_data_line_out = reg2_data_line_in;


always @(posedge clk or negedge rstn) begin
    if(!rstn)
        imm_gen_data_line_out <= 32'd0;
    else
        imm_gen_data_line_out <= imm_gen_data_line_in;
end

always @(posedge clk or negedge rstn) begin
    if(!rstn)
        instruct_alu_ctrl_line_out <= 4'd0;
    else
        instruct_alu_ctrl_line_out <= instruct_alu_ctrl_line_in;
end

always @(posedge clk or negedge rstn) begin
    if(!rstn)
        reg_wb_addr_line_out <= 5'd0;
    else
        reg_wb_addr_line_out <= reg_wb_addr_line_in;
end

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
       rs_reg1_addr_line_out <= 5'd0;
       rs_reg2_addr_line_out <= 5'd0;
    end
    else begin
       rs_reg1_addr_line_out <= rs_reg1_addr_line_in;
       rs_reg2_addr_line_out <= rs_reg2_addr_line_in;
    end
end

endmodule
