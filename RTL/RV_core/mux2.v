module mux2(
    input           sel         ,
    input   [31:0]  data0_in    ,
    input   [31:0]  data1_in    ,

    output  [31:0]  data_out    
);

assign  data_out = (sel == 1'b1) ? data1_in : data0_in;  

endmodule