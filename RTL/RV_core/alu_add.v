module alu_add(
    //input Data
    input           [31:0]  data0       ,
    input           [31:0]  data1       ,
    //output 
    output          [31:0]  ALU_result  

);

assign  ALU_result = data0 + data1;

endmodule
