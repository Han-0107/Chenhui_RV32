module forward_unit(
    //input
    input       [4:0]   rs_reg1_addr        ,
    input       [4:0]   rs_reg2_addr        ,

    input       [4:0]   id_ex_rs_reg1_addr  ,
    input       [4:0]   id_ex_rs_reg2_addr  ,

    input       [4:0]   ex_mem_wb_addr      ,
    input       [4:0]   mem_wb_addr         ,
    
    input       [31:0]  ex_mem_alu_result   ,
    input       [31:0]  mem_wb_alu_result   ,

    input               ex_mem_reg_wr       ,
    input               mem_wb_reg_wr       ,
    
    input               ex_mem_mem_wr       ,
    //output    
    output  reg [1:0]   forwardA            ,
    output  reg [1:0]   forwardB            ,
    output  reg         forwardC            ,
    output  reg [1:0]   forwardD            

);

always @(*)begin
    if(ex_mem_reg_wr == 1'b1 && ex_mem_wb_addr != 5'd0 && ex_mem_wb_addr == id_ex_rs_reg1_addr)
        forwardA = 2'b10;
    else if(mem_wb_reg_wr == 1'b1 && mem_wb_addr != 5'd0 && 
          !(ex_mem_reg_wr == 1'b1 && (ex_mem_wb_addr != 5'd0) && (ex_mem_wb_addr == id_ex_rs_reg1_addr)) && 
          (mem_wb_addr == id_ex_rs_reg1_addr))
        forwardA = 2'b01;
    else
        forwardA = 2'b00;
end

always @(*)begin
    if(ex_mem_reg_wr == 1'b1 && ex_mem_wb_addr != 5'd0 && ex_mem_wb_addr == id_ex_rs_reg2_addr)
        forwardB = 2'b10;
    else if(mem_wb_reg_wr == 1'b1 && mem_wb_addr != 5'd0 && 
          !(ex_mem_reg_wr == 1'b1 && (ex_mem_wb_addr != 5'd0) && (ex_mem_wb_addr == id_ex_rs_reg2_addr)) && 
          (mem_wb_addr == id_ex_rs_reg2_addr))
        forwardB = 2'b01;
    else
        forwardB = 2'b00;
end

always @(*)begin
    if(ex_mem_mem_wr == 1'b1 && ex_mem_alu_result != 32'b0 && (ex_mem_alu_result == mem_wb_alu_result))
        forwardC = 1'b1;
    else
        forwardC = 1'b0;
end


always @(*)begin
    if(mem_wb_reg_wr == 1'b1 && mem_wb_addr != 5'd0)
        if(mem_wb_addr == rs_reg1_addr)
            forwardD = 2'b01;
        else if(mem_wb_addr == rs_reg2_addr)
            forwardD = 2'b10;
        else
            forwardD = 2'b00;
    else
        forwardD = 2'b00;
end

endmodule
