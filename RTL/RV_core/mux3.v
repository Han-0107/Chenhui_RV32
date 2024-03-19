module mux3(
    input           [1:0]   sel         ,
    input           [31:0]  data0_in    ,
    input           [31:0]  data1_in    ,
    input           [31:0]  data2_in    ,

    output  reg     [31:0]  data_out    
);

always @(*)begin
    case(sel)
        2'b00 : data_out = data0_in;
        2'b01 : data_out = data1_in;
        2'b10 : data_out = data2_in;
        default : data_out = 32'd0;
    endcase
end

endmodule