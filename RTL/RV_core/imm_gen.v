module imm_gen(
    input       [31:0]      data_in     ,
    output  reg [31:0]      data_out    
);

localparam  I_TYPE  = 7'b0010011    ;
localparam  ID_TYPE = 7'b0000011    ;   //I Load
localparam  S_TYPE  = 7'b0100011    ;   //S Store
localparam  U_TYPE  = 7'b0110111    ;   //U LUI
localparam  UA_TYPE = 7'b0010111    ;   //U AUIPC
localparam  B_TYPE  = 7'b1100011    ;
localparam  J_TYPE  = 7'b1101111    ;   //JAL
localparam  JR_TYPE = 7'b1100111    ;   //JALR

wire    [6:0]   opcode  ;

assign opcode = data_in[6:0];

always  @(*) begin
    case (opcode)
        I_TYPE, ID_TYPE : data_out = {{20{data_in[31]}}, data_in[31:20] };
        S_TYPE          : data_out = {{20{data_in[31]}}, data_in[31:25], data_in[11:7]};
        U_TYPE, UA_TYPE : data_out = {data_in[31:12], 12'd0};
        B_TYPE          : data_out = {{19{data_in[31]}}, data_in[31], data_in[7], data_in[30:25], data_in[11:8], 1'b0};
        J_TYPE          : data_out = {{11{data_in[31]}}, data_in[31], data_in[19:12],  data_in[20], data_in[30:21], 1'b0};
        JR_TYPE         : data_out = {{20{data_in[31]}}, data_in[31:20] };
        default : data_out = 32'd0;
    endcase
end

endmodule
