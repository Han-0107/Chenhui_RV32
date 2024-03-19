module hazard_detec(
    //input 
    input   [31:0]  rs_reg1_rdata       ,
    input   [31:0]  rs_reg2_rdata       ,

    input   [31:0]  instruct_data_in    ,

    //output
    output  reg     ctrl_mux_sel        ,
    output  reg     if_flush            ,
    output  reg     pc_mux_sel          ,
    output  reg     pc_stop             
);

localparam      J_TYPE  = 7'b1101111    ;
localparam      B_TYPE  = 7'b1100011    ;

localparam      BEQ     = 3'b000        ;
localparam      BNE     = 3'b001        ;
localparam      BLT     = 3'b100        ;
localparam      BGE     = 3'b101        ;
localparam      BLTU    = 3'b110        ;
localparam      BGEU    = 3'b111        ;

always @(*)begin
    if(instruct_data_in[6:0] == B_TYPE)begin
        case(instruct_data_in[14:12])
            BEQ : if(rs_reg1_rdata == rs_reg2_rdata)    begin
                ctrl_mux_sel = 1'b1;
                if_flush     = 1'b1;
                pc_mux_sel   = 1'b1;
                pc_stop      = 1'b1; 
            end
            else begin
                ctrl_mux_sel = 1'b0;
                if_flush     = 1'b0;
                pc_mux_sel   = 1'b0;
                pc_stop      = 1'b0;
            end
            BNE : if(rs_reg1_rdata != rs_reg2_rdata)    begin
                ctrl_mux_sel = 1'b1;
                if_flush     = 1'b1;
                pc_mux_sel   = 1'b1;
                pc_stop      = 1'b1;
            end
            else begin
                ctrl_mux_sel = 1'b0;
                if_flush     = 1'b0;
                pc_mux_sel   = 1'b0;
                pc_stop      = 1'b0;

            end
            BLT : if(rs_reg1_rdata < rs_reg2_rdata)    begin
                ctrl_mux_sel = 1'b1;
                if_flush     = 1'b1;
                pc_mux_sel   = 1'b1;
                pc_stop      = 1'b1;
            end
            else begin
                ctrl_mux_sel = 1'b0;
                if_flush     = 1'b0;
                pc_mux_sel   = 1'b0;
                pc_stop      = 1'b0;
            end
            BGE : if(rs_reg1_rdata > rs_reg2_rdata)    begin
                ctrl_mux_sel = 1'b1;
                if_flush     = 1'b1;
                pc_mux_sel   = 1'b1;
                pc_stop      = 1'b1;
            end
            else begin
                ctrl_mux_sel = 1'b0;
                if_flush     = 1'b0;
                pc_mux_sel   = 1'b0;
                pc_stop      = 1'b0;
            end
            BLTU : if(rs_reg1_rdata < rs_reg2_rdata)    begin
                ctrl_mux_sel = 1'b1;
                if_flush     = 1'b1;
                pc_mux_sel   = 1'b1;
                pc_stop      = 1'b1;
            end
            else begin
                ctrl_mux_sel = 1'b0;
                if_flush     = 1'b0;
                pc_mux_sel   = 1'b0;
                pc_stop      = 1'b0;
            end
            BGEU : if(rs_reg1_rdata > rs_reg2_rdata)    begin
                ctrl_mux_sel = 1'b1;
                if_flush     = 1'b1;
                pc_mux_sel   = 1'b1;
                pc_stop      = 1'b1;
            end
            else begin
                ctrl_mux_sel = 1'b0;
                if_flush     = 1'b0;
                pc_mux_sel   = 1'b0;
                pc_stop      = 1'b0;
            end
            default :  begin
                ctrl_mux_sel = 1'b0;
                if_flush     = 1'b0;
                pc_mux_sel   = 1'b0;
                pc_stop      = 1'b0;
            end
        endcase
    end
    else if(instruct_data_in[6:0] == J_TYPE ) begin
        ctrl_mux_sel = 1'b1;
        if_flush     = 1'b1;
        pc_mux_sel   = 1'b1;
        pc_stop      = 1'b1;
    end
    else begin
        ctrl_mux_sel = 1'b0;
        if_flush     = 1'b0;
        pc_mux_sel   = 1'b0;
        pc_stop      = 1'b0;
    end
end

endmodule
