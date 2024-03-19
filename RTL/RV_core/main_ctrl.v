module  main_ctrl(
    //input data
    input       [6:0]   instruct_op         ,
    input       [2:0]   instruct_func3      ,
    //output data

    output  reg [1:0]   imm_add_data0_sel   ,
    output  reg [1:0]   rd_data_sel         ,
    output  reg         rd_addr_sel         ,
    output  reg         reg_wr_imm          ,

    output  reg         reg_wr_wb           ,
    output  reg         mem2reg_sel         ,
    output  reg [1:0]   exAlu_op            ,
    output  reg         mem_wr              ,
    output  reg         mem_rd              ,
    output  reg [2:0]   mem_op              ,
    output  reg         exAlu_data1_sel     
);

localparam      R_OP        = 7'b0110011    ;
localparam      LD_OP       = 7'b0000011    ;
localparam      I_OP        = 7'b0010011    ;
localparam      S_OP        = 7'b0100011    ;
localparam      B_OP        = 7'b1100011    ;
localparam      JAL_OP      = 7'b1101111    ;
localparam      JALR_OP     = 7'b1100111    ;
localparam      LUI_OP      = 7'b0110111    ;
localparam      AUIPC_OP    = 7'b0010111    ;

always @(instruct_op) begin
    case(instruct_op)
        R_OP :  begin
            reg_wr_imm        = 1'b0;
            imm_add_data0_sel = 2'b00;
            rd_data_sel       = 2'b00;
            rd_addr_sel       = 1'b0;

            reg_wr_wb         = 1'b1;
            mem2reg_sel       = 1'b1;
            exAlu_op          = 2'b10;
            mem_wr            = 1'b0;
            mem_rd            = 1'b0;
            exAlu_data1_sel   = 1'b0;
        end
        LD_OP : begin
            reg_wr_imm        = 1'b0;
            imm_add_data0_sel = 2'b00;
            rd_data_sel       = 2'b00;
            rd_addr_sel       = 1'b0;

            reg_wr_wb         = 1'b1;
            mem2reg_sel       = 1'b0;
            exAlu_op          = 2'b00;
            mem_wr            = 1'b0;
            mem_rd            = 1'b1;
            exAlu_data1_sel   = 1'b1;
        end
        I_OP : begin
            reg_wr_imm        = 1'b0;
            imm_add_data0_sel = 2'b00;
            rd_data_sel       = 2'b00;
            rd_addr_sel       = 1'b0;

            reg_wr_wb         = 1'b1;
            mem2reg_sel       = 1'b1;
            exAlu_op          = 2'b11;
            mem_wr            = 1'b0;
            mem_rd            = 1'b0;
            exAlu_data1_sel   = 1'b1;
        end
        S_OP : begin
            reg_wr_imm        = 1'b0;
            imm_add_data0_sel = 2'b00;
            rd_data_sel       = 2'b00;
            rd_addr_sel       = 1'b0;

            reg_wr_wb         = 1'b0;
            mem2reg_sel       = 1'b0;
            exAlu_op          = 2'b00;
            mem_wr            = 1'b1;
            mem_rd            = 1'b0;
            exAlu_data1_sel   = 1'b1;
        end
        B_OP : begin
            reg_wr_imm        = 1'b0;
            imm_add_data0_sel = 2'b00;
            rd_data_sel       = 2'b00;
            rd_addr_sel       = 1'b0;

            reg_wr_wb         = 1'b0;
            mem2reg_sel       = 1'b0;
            exAlu_op          = 2'b01;
            mem_wr            = 1'b0;
            mem_rd            = 1'b0;
            exAlu_data1_sel   = 1'b0;
        end
        JAL_OP : begin
            reg_wr_imm        = 1'b1;
            imm_add_data0_sel = 2'b00;
            rd_data_sel       = 2'b01;
            rd_addr_sel       = 1'b1;

            reg_wr_wb         = 1'b0;
            mem2reg_sel       = 1'b0;
            exAlu_op          = 2'b00;
            mem_wr            = 1'b0;
            mem_rd            = 1'b0;
            exAlu_data1_sel   = 1'b0;
        end
        JALR_OP : begin
            reg_wr_imm        = 1'b1;
            imm_add_data0_sel = 2'b10;
            rd_data_sel       = 2'b01;
            rd_addr_sel       = 1'b1;

            reg_wr_wb         = 1'b0;
            mem2reg_sel       = 1'b0;
            exAlu_op          = 2'b00;
            mem_wr            = 1'b0;
            mem_rd            = 1'b0;
            exAlu_data1_sel   = 1'b0;
        end
        LUI_OP : begin
            reg_wr_imm        = 1'b1;
            imm_add_data0_sel = 2'b01;
            rd_data_sel       = 2'b10;
            rd_addr_sel       = 1'b1;

            reg_wr_wb         = 1'b0;
            mem2reg_sel       = 1'b0;
            exAlu_op          = 2'b00;
            mem_wr            = 1'b0;
            mem_rd            = 1'b0;
            exAlu_data1_sel   = 1'b0;
        end
        AUIPC_OP : begin
            reg_wr_imm        = 1'b1;
            imm_add_data0_sel = 2'b00;
            rd_data_sel       = 2'b10;
            rd_addr_sel       = 1'b1;

            reg_wr_wb         = 1'b0;
            mem2reg_sel       = 1'b0;
            exAlu_op          = 2'b00;
            mem_wr            = 1'b0;
            mem_rd            = 1'b0;
            exAlu_data1_sel   = 1'b0;
        end
        default : begin
            reg_wr_imm        = 1'b0;
            imm_add_data0_sel = 2'b00;
            rd_data_sel       = 2'b00;
            rd_addr_sel       = 1'b0;
            reg_wr_wb         = 1'b0;
            mem2reg_sel       = 1'b0;
            exAlu_op          = 2'b00;
            mem_wr            = 1'b0;
            mem_rd            = 1'b0;
            exAlu_data1_sel   = 1'b0;
        end
    endcase
end


always @(*)begin
    case(instruct_op)
        LD_OP,S_OP : mem_op = instruct_func3;
        default : mem_op = 3'd0;
    endcase
    
end

endmodule
