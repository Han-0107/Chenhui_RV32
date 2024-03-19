module  alu_ctrl(
    input           [3:0]   data_in     ,
    input           [1:0]   ALUOp       ,
    output  reg     [4:0]   ALU_ctl     
);

localparam  ALU_ADD     = 4'b0000   ; 
localparam  ALU_SUB     = 4'b1000   ; 
localparam  ALU_SLL     = 4'b0001   ; 
localparam  ALU_SLT     = 4'b0010   ; 
localparam  ALU_SLTU    = 4'b0011   ; 
localparam  ALU_XOR     = 4'b0100   ; 
localparam  ALU_SRL     = 4'b0101   ; 
localparam  ALU_SRA     = 4'b1101   ; 
localparam  ALU_OR      = 4'b0110   ; 
localparam  ALU_AND     = 4'b0111   ; 

localparam  R_ADD       = 5'b00000  ; 
localparam  R_SUB       = 5'b01000  ; 
localparam  R_SLL       = 5'b00001  ; 
localparam  R_SLT       = 5'b00010  ; 
localparam  R_SLTU      = 5'b00011  ; 
localparam  R_XOR       = 5'b00100  ; 
localparam  R_SRL       = 5'b00101  ; 
localparam  R_SRA       = 5'b01101  ; 
localparam  R_OR        = 5'b00110  ; 
localparam  R_AND       = 5'b00111  ; 

localparam  I_ADD       = 5'b10000  ; 
localparam  I_SUB       = 5'b11000  ; 
localparam  I_SLL       = 5'b10001  ; 
localparam  I_SLT       = 5'b10010  ; 
localparam  I_SLTU      = 5'b10011  ; 
localparam  I_XOR       = 5'b10100  ; 
localparam  I_SRL       = 5'b10101  ; 
localparam  I_SRA       = 5'b11101  ; 
localparam  I_OR        = 5'b10110  ; 
localparam  I_AND       = 5'b10111  ; 

always @(*) begin
    case(ALUOp)
        2'b00 : ALU_ctl = ALU_ADD;
        2'b01 : ALU_ctl = ALU_SUB;
        2'b10 : begin
                    if      (data_in == ALU_ADD ) ALU_ctl = R_ADD ;
                    else if (data_in == ALU_SUB ) ALU_ctl = R_SUB ;
                    else if (data_in == ALU_SLL ) ALU_ctl = R_SLL ;
                    else if (data_in == ALU_SLT ) ALU_ctl = R_SLT ;
                    else if (data_in == ALU_SLTU) ALU_ctl = R_SLTU;
                    else if (data_in == ALU_XOR ) ALU_ctl = R_XOR ;
                    else if (data_in == ALU_SRL ) ALU_ctl = R_SRL ;
                    else if (data_in == ALU_SRA ) ALU_ctl = R_SRA ;
                    else if (data_in == ALU_OR  ) ALU_ctl = R_OR  ;
                    else if (data_in == ALU_AND ) ALU_ctl = R_AND ;
                    else ALU_ctl = 4'd0;
        end
        2'b11 : begin
                    if      (data_in == ALU_ADD ) ALU_ctl = I_ADD ;
                    else if (data_in == ALU_SLL ) ALU_ctl = I_SLL ;
                    else if (data_in == ALU_SLT ) ALU_ctl = I_SLT ;
                    else if (data_in == ALU_SLTU) ALU_ctl = I_SLTU;
                    else if (data_in == ALU_XOR ) ALU_ctl = I_XOR ;
                    else if (data_in == ALU_SRL ) ALU_ctl = I_SRL ;
                    else if (data_in == ALU_SRA ) ALU_ctl = I_SRA ;
                    else if (data_in == ALU_OR  ) ALU_ctl = I_OR  ;
                    else if (data_in == ALU_AND ) ALU_ctl = I_AND ;
                    else ALU_ctl = 4'd0;
        end
        default : ALU_ctl = 4'd0;
    endcase
end

endmodule
