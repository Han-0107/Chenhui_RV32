module regfile(
   //system clock
   input                    clk             ,
   input                    rst_n           ,
   //Write rd
   input                    wr_reg_en       ,
   input            [4:0]   wr_reg_addr     ,
   input            [31:0]  wr_wdata        ,
    //forward
   input            [1:0]   forwardD        ,
   //Read  rs1 rs2
   input            [4:0]   rs_reg1_addr    ,
   input            [4:0]   rs_reg2_addr    ,
   output   reg     [31:0]  rs_reg1_rdata   ,
   output   reg     [31:0]  rs_reg2_rdata   
);

reg [31:0]  reg_bank    [0:31]  ;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        reg_bank[0] <= 32'd0;
        reg_bank[1] <= 32'd0;
        reg_bank[2] <= 32'd0;
        reg_bank[3] <= 32'd0;
        reg_bank[4] <= 32'd0;
        reg_bank[5] <= 32'd0;
        reg_bank[6] <= 32'd0;
        reg_bank[7] <= 32'd0;
        reg_bank[8] <= 32'd0;
        reg_bank[9] <= 32'd0;
        reg_bank[10] <= 32'd0;
        reg_bank[11] <= 32'd0;
        reg_bank[12] <= 32'd0;
        reg_bank[13] <= 32'd0;
        reg_bank[14] <= 32'd0;
        reg_bank[15] <= 32'd0;
        reg_bank[16] <= 32'd0;
        reg_bank[17] <= 32'd0;
        reg_bank[18] <= 32'd0;
        reg_bank[19] <= 32'd0;
        reg_bank[20] <= 32'd0;
        reg_bank[21] <= 32'd0;
        reg_bank[22] <= 32'd0;
        reg_bank[23] <= 32'd0;
        reg_bank[24] <= 32'd0;
        reg_bank[25] <= 32'd0;
        reg_bank[26] <= 32'd0;
        reg_bank[27] <= 32'd0;
        reg_bank[28] <= 32'd0;
        reg_bank[29] <= 32'd0;
        reg_bank[30] <= 32'd0;
        reg_bank[31] <= 32'd0;
    end
    else if (wr_reg_en == 1'b1)begin
        case(wr_reg_addr)
            5'd0 : reg_bank[0] <= wr_wdata;
            5'd1 : reg_bank[1] <= wr_wdata;
            5'd2 : reg_bank[2] <= wr_wdata;
            5'd3 : reg_bank[3] <= wr_wdata;
            5'd4 : reg_bank[4] <= wr_wdata;
            5'd5 : reg_bank[5] <= wr_wdata;
            5'd6 : reg_bank[6] <= wr_wdata;
            5'd7 : reg_bank[7] <= wr_wdata;
            5'd8 : reg_bank[8] <= wr_wdata;
            5'd9 : reg_bank[9] <= wr_wdata;
            5'd10 : reg_bank[10] <= wr_wdata;
            5'd11 : reg_bank[11] <= wr_wdata;
            5'd12 : reg_bank[12] <= wr_wdata;
            5'd13 : reg_bank[13] <= wr_wdata;
            5'd14 : reg_bank[14] <= wr_wdata;
            5'd15 : reg_bank[15] <= wr_wdata;
            5'd16 : reg_bank[16] <= wr_wdata;
            5'd17 : reg_bank[17] <= wr_wdata;
            5'd18 : reg_bank[18] <= wr_wdata;
            5'd19 : reg_bank[19] <= wr_wdata;
            5'd20 : reg_bank[20] <= wr_wdata;
            5'd21 : reg_bank[21] <= wr_wdata;
            5'd22 : reg_bank[22] <= wr_wdata;
            5'd23 : reg_bank[23] <= wr_wdata;
            5'd24 : reg_bank[24] <= wr_wdata;
            5'd25 : reg_bank[25] <= wr_wdata;
            5'd26 : reg_bank[26] <= wr_wdata;
            5'd27 : reg_bank[27] <= wr_wdata;
            5'd28 : reg_bank[28] <= wr_wdata;
            5'd29 : reg_bank[29] <= wr_wdata;
            5'd30 : reg_bank[30] <= wr_wdata;
            5'd31 : reg_bank[31] <= wr_wdata;
        endcase
    end
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        rs_reg1_rdata <= 32'd0;
    end
    else if(forwardD == 2'd1)
        rs_reg1_rdata <= wr_wdata;
    else
        rs_reg1_rdata <= reg_bank[rs_reg1_addr];
end

always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        rs_reg2_rdata <= 32'd0;
    end
    else if(forwardD == 2'd2)
        rs_reg2_rdata <= wr_wdata;
    else
        rs_reg2_rdata <= reg_bank[rs_reg2_addr];
end

endmodule
