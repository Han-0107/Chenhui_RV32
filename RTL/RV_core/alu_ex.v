module alu_ex(
    //ALU Operation
    input           [4:0]    alu_ctl    ,

    //input Data
    input           [31:0]  data0       ,
    input           [31:0]  data1       ,
    input           [4:0]   shamt       ,

    //output 
    output  reg     [31:0]  ALU_result  ,
    output                  Zero        

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

wire    con_flag = (data0[31] == data1[31]) ? 1'b1 : 1'b0;

always @(*)begin
    case(alu_ctl)
        //add
        R_ADD, I_ADD : ALU_result = data0 + data1;
        //sub
        R_SUB, I_SUB : ALU_result = data0 - data1;
        //sll
        R_SLL : ALU_result = data0 << data1[4:0];
        I_SLL : ALU_result = data0 << shamt;
        //slt
        R_SLT, I_SLT : begin
                    if(con_flag == 1'b1) begin
                        if(data0[30:0] < data1[30:0])
                            ALU_result = 32'd1;
                        else
                            ALU_result = 32'd0;
                    end
                    else begin
                        if(data0[31] == 1'b1)
                            ALU_result = 32'd1;
                        else
                            ALU_result = 32'd0;
                    end
                end
        //sltu
        R_SLTU, I_SLTU : begin 
                    if(data0[31:0] < data1[31:0])
                        ALU_result = 32'd1;
                    else
                        ALU_result = 32'd0;
                end
        //xor
        R_XOR, I_XOR : ALU_result = data0 ^ data1;
        //srl
        R_SRL : ALU_result = data0 >> data1[4:0];
        I_SRL : ALU_result = data0 >> shamt;
        //sra
        R_SRA : ALU_result = ($signed(data0)) >> data1[4:0];
        I_SRA : ALU_result = ($signed(data0)) >> shamt;
        //or
        R_OR, I_OR : ALU_result = data0 | data1;
        //and
        R_AND, I_AND : ALU_result = data0 & data1;
    default : ALU_result = 32'd0;
    endcase
end

assign Zero = (ALU_result == 32'd0);

endmodule
