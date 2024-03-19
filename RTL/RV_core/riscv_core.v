module riscv_core(
    //system signal
    input           sys_clk         ,
    input           sys_rst_n       ,

    output  reg     led_test        
);

//first level
reg     [31:0]  PC                          ;
wire    [31:0]  alu_add4_data               ; 
wire    [31:0]  pc_mux_data                 ;
wire    [31:0]  alu_imm_data                ;
wire    [31:0]  instruct_data               ;
//second level  IF_ID
wire    [31:0]  PC_line2_out                ;
wire    [31:0]  instruct_data_line2_out     ;

//third level ID_EX
wire    [6:0]   instruct_op                 ;
wire    [2:0]   instruct_func3              ;
//hazard
wire            ctrl_mux_sel                ;
wire            if_flush                    ;
wire            pc_mux_sel                  ;
wire            pc_stop                     ;

//ctrl

wire    [1:0]   imm_add_data0_sel           ;
wire    [1:0]   rd_data_sel                 ;
wire            rd_addr_sel                 ;
wire            reg_wr_imm                  ;
                                            
wire            reg_wr_wb                   ;
wire            mem2reg_sel                 ;
wire    [1:0]   exAlu_op                    ;
wire            mem_wr                      ;
wire            mem_rd                      ;
wire    [2:0]   mem_op                      ;
wire            exAlu_data1_sel             ;
//ctrl mux
wire            ctrl_mux_reg_wr             ;
wire            ctrl_mux_mem2reg_sel        ;
wire    [1:0]   ctrl_mux_exAlu_op           ;
wire            ctrl_mux_mem_wr             ;
wire            ctrl_mux_mem_rd             ;
wire    [2:0]   ctrl_mux_mem_op             ;
wire            ctrl_mux_exAlu_data1_sel    ;

wire    [4:0]   rs_reg1_addr                ;  
wire    [4:0]   rs_reg2_addr                ;  
wire    [31:0]  rs_reg1_rdata               ;
wire    [31:0]  rs_reg2_rdata               ;

wire    [31:0]  rd_wdata_mux                ;
wire    [4:0]   rd_addr_mux                 ;
wire            reg_wr_mux                  ;


wire    [31:0]  imm_gen_data                ;

wire    [3:0]   instruct_alu_ctrl           ;
wire    [4:0]   instruct_reg_wb_addr        ;

//id_ex output
wire            reg_wr_line3_out            ;
wire            mem2reg_sel_line3_out       ;
wire            mem_wr_line3_out            ;
wire            mem_rd_line3_out            ;
wire    [2:0]   mem_op_line3_out            ;
wire    [1:0]   exAlu_op_line3_out          ;
wire            exAlu_data1_sel_line3_out   ;

wire    [31:0]  reg1_data_line3_out         ;
wire    [31:0]  reg2_data_line3_out         ;
wire    [31:0]  imm_gen_data_line3_out      ;
wire    [3:0]   instruct_alu_ctrl_line3_out ;
wire    [4:0]   reg_wb_addr_line3_out       ;
wire    [4:0]   rs_reg1_addr_line3_out      ;
wire    [4:0]   rs_reg2_addr_line3_out      ;
//fourth level  EX_MEM
wire    [31:0]  forwardA_mux_out            ;
wire    [31:0]  forwardB_mux_out            ;
wire    [31:0]  alu_data2_mux               ;
wire    [31:0]  alu_ex_result               ;

wire    [4:0]   ALU_ctl                     ;

//ex/mem output
wire            reg_wr_line4_out            ;
wire            mem2reg_sel_line4_out       ;
wire            mem_wr_line4_out            ;
wire            mem_rd_line4_out            ;
wire    [2:0]   mem_op_line4_out            ;
wire    [31:0]  alu_ex_result_line4_out     ;
wire    [31:0]  reg2_data_line4_out         ;
wire    [4:0]   reg_wb_addr_line4_out       ;
//fifth level   MEM_WB
wire    [31:0]  ram_data_out                ;

//mem/wb output
wire            reg_wr_line5_out            ;
wire            mem2reg_sel_line5_out       ;
                                       
wire    [31:0]  ram_data_out_line5_out      ;
                                       
wire    [31:0]  alu_ex_result_line5_out     ;
                                       
wire    [4:0]   reg_wb_addr_line5_out       ;
wire    [31:0]  mem2reg_data_back           ;

//forward unit
wire    [1:0]   forwardA                    ;
wire    [1:0]   forwardB                    ;
wire            forwardC                    ;
wire    [1:0]   forwardD                    ;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        led_test <= 1'b1  ;
    else if(PC == 32'h1000)
        led_test <= ~led_test  ;
end

//-------------------------------------------------------------------------------------
//The first level of the pipeline
//-------------------------------------------------------------------------------------

mux2     u_mux_imm(
    .sel                        ( pc_mux_sel                    ),
    .data0_in                   ( alu_add4_data                 ),
    .data1_in                   ( alu_imm_data                  ),

    .data_out                   ( pc_mux_data                   )
);

//PC
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        PC <= 32'd0;
    //else if(pc_stop == 1'b1)
    //    PC <= PC;
    else
        PC <= pc_mux_data;
end

//-------------------------------------------------------------------------------------
//The second level of the pipeline  IF_ID
//-------------------------------------------------------------------------------------


alu_add     u_alu_add_4(
    //input Data
    .data0                      ( 32'd4                         ),
    .data1                      ( PC                            ),
    //output 
    .ALU_result                 ( alu_add4_data                 )
);

//Instruction RAM
wrap_iram   u_wrap_iram(
    //system signals
    .sclk                       ( sys_clk                       ),
    //.rstn                       ( sys_rst_n                     ),
    //control signals
    .mem_wr                     ( 1'b0                          ),
    .mem_rd                     ( !if_flush                     ),
    .addr                       ( PC                            ),
    .wdata                      ( 32'd0                         ),
    .rdata                      ( instruct_data                 )
);



if_id       u_if_id(
    //clk & rst
    .clk                        ( sys_clk                       ),
    .rstn                       ( sys_rst_n                     ),
    //flush
    .if_flush                   ( if_flush                      ),
    //data input
    .PC_line_in                 ( PC                            ),
    .instruct_data_line_in      ( instruct_data                 ),
    //data output
    .PC_line_out                ( PC_line2_out                  ),
    .instruct_data_line_out     ( instruct_data_line2_out       )    
);


//-------------------------------------------------------------------------------------
//The third level of the pipeline   ID_EX
//-------------------------------------------------------------------------------------
wire    [31:0]  imm_add_mux_data    ;        

hazard_detec        u_hazard_detec(
    //clk & rst
    //.clk                        ( sys_clk                       ),
    //.rstn                       ( sys_rst_n                     ),
    //input 
    .rs_reg1_rdata              ( rs_reg1_rdata                 ),
    .rs_reg2_rdata              ( rs_reg2_rdata                 ),

    .instruct_data_in           ( instruct_data_line2_out       ),
    //output
    .ctrl_mux_sel               ( ctrl_mux_sel                  ),
    .if_flush                   ( if_flush                      ),
    .pc_mux_sel                 ( pc_mux_sel                    ),
    .pc_stop                    ( pc_stop                       )
);


mux3        u_mux_imm_add(
    .sel                        ( imm_add_data0_sel             ),
    .data0_in                   ( PC_line2_out                  ),
    .data1_in                   ( 32'd0                         ),
    .data2_in                   ( rs_reg1_rdata                 ),

    .data_out                   ( imm_add_mux_data              )

);

alu_add     u_alu_add_imm(
    //input Data
    .data0                      ( imm_add_mux_data              ),
    .data1                      ( imm_gen_data                  ),
    //output 
    .ALU_result                 ( alu_imm_data                  )
);

assign  instruct_op = instruct_data_line2_out[6:0];
assign  instruct_func3 = instruct_data_line2_out[14:12];

main_ctrl    u_main_ctrl(
    //input data
    .instruct_op                ( instruct_op                   ),
    .instruct_func3             ( instruct_func3                ),
    //output data

    .imm_add_data0_sel          ( imm_add_data0_sel             ),
    .rd_data_sel                ( rd_data_sel                   ),
    .rd_addr_sel                ( rd_addr_sel                   ),
    .reg_wr_imm                 ( reg_wr_imm                    ),

    .reg_wr_wb                  ( reg_wr_wb                     ),
    .mem2reg_sel                ( mem2reg_sel                   ),
    .exAlu_op                   ( exAlu_op                      ),
    .mem_wr                     ( mem_wr                        ),
    .mem_rd                     ( mem_rd                        ),
    .mem_op                     ( mem_op                        ),
    .exAlu_data1_sel            ( exAlu_data1_sel               ) 
);

wire    [31:0]  ctrl_mux_data0_in   = {22'd0,reg_wr_wb, mem2reg_sel, exAlu_op, mem_wr, mem_rd, mem_op, exAlu_data1_sel};
wire    [31:0]  ctrl_mux_data_out   ;
mux2 u_crtl_mux(
    .sel                        ( ctrl_mux_sel                  ),
    .data0_in                   ( ctrl_mux_data0_in             ),
    .data1_in                   ( 32'd0                         ),

    .data_out                   ( ctrl_mux_data_out             )
);

assign ctrl_mux_reg_wr           = ctrl_mux_data_out[9]  ;
assign ctrl_mux_mem2reg_sel      = ctrl_mux_data_out[8]  ;
assign ctrl_mux_exAlu_op         = ctrl_mux_data_out[7:6];
assign ctrl_mux_mem_wr           = ctrl_mux_data_out[5]  ;
assign ctrl_mux_mem_rd           = ctrl_mux_data_out[4]  ;
assign ctrl_mux_mem_op           = ctrl_mux_data_out[3:1];
assign ctrl_mux_exAlu_data1_sel  = ctrl_mux_data_out[0]  ;

//register bank addr
assign rs_reg1_addr = instruct_data_line2_out[19:15];
assign rs_reg2_addr = instruct_data_line2_out[24:20];



mux3     u_mux_rd_data(
    .sel                        ( rd_data_sel               ),
    .data0_in                   ( mem2reg_data_back         ),
    .data1_in                   ( PC                        ),
    .data2_in                   ( alu_imm_data              ),

    .data_out                   ( rd_wdata_mux              )
);


assign rd_addr_mux = rd_addr_sel ? instruct_reg_wb_addr : reg_wb_addr_line5_out;


assign  reg_wr_mux = reg_wr_imm || reg_wr_line5_out;


regfile     u_regfile(
   //system clock
   .clk                         ( sys_clk                       ),
   .rst_n                       ( sys_rst_n                     ),
   //WR Control
   .wr_reg_en                   ( reg_wr_mux                    ),
   .wr_reg_addr                 ( rd_addr_mux                   ),
   .wr_wdata                    ( rd_wdata_mux                  ),
    //forward 
   .forwardD                    ( forwardD                      ),
   //RD Control
   .rs_reg1_addr                ( rs_reg1_addr                  ),
   .rs_reg2_addr                ( rs_reg2_addr                  ),
   .rs_reg1_rdata               ( rs_reg1_rdata                 ),
   .rs_reg2_rdata               ( rs_reg2_rdata                 )
);

imm_gen     u_imm_gen(
    .data_in                    (instruct_data_line2_out        ),
    .data_out                   (imm_gen_data                   )
);

assign  instruct_alu_ctrl   = {instruct_data_line2_out[30], instruct_data_line2_out[14:12]};
assign  instruct_reg_wb_addr= instruct_data_line2_out[11:7];

id_ex       u_id_ex(
    //clk & rst
    .clk                        ( sys_clk                       ),
    .rstn                       ( sys_rst_n                     ),
    //data input
    //Control signals
    .reg_wr_line_in             ( ctrl_mux_reg_wr               ),
    .mem2reg_sel_line_in        ( ctrl_mux_mem2reg_sel          ),
    .mem_wr_line_in             ( ctrl_mux_mem_wr               ),
    .mem_rd_line_in             ( ctrl_mux_mem_rd               ),
    .mem_op_line_in             ( ctrl_mux_mem_op               ),
    .exAlu_op_line_in           ( ctrl_mux_exAlu_op             ),
    .exAlu_data1_sel_line_in    ( ctrl_mux_exAlu_data1_sel      ),
    //reg
    .reg1_data_line_in          ( rs_reg1_rdata                 ),
    .reg2_data_line_in          ( rs_reg2_rdata                 ),
    //Imm gen
    .imm_gen_data_line_in       ( imm_gen_data                  ),
    //ALU Control
    .instruct_alu_ctrl_line_in  ( instruct_alu_ctrl             ),
    //reg write bank addr
    .reg_wb_addr_line_in        ( instruct_reg_wb_addr          ),
    .rs_reg1_addr_line_in       ( rs_reg1_addr                  ),
    .rs_reg2_addr_line_in       ( rs_reg2_addr                  ),
    //data output
    //Control signals
    .reg_wr_line_out            ( reg_wr_line3_out              ),
    .mem2reg_sel_line_out       ( mem2reg_sel_line3_out         ),
    .mem_wr_line_out            ( mem_wr_line3_out              ),
    .mem_rd_line_out            ( mem_rd_line3_out              ),
    .mem_op_line_out            ( mem_op_line3_out              ),
    .exAlu_op_line_out          ( exAlu_op_line3_out            ),
    .exAlu_data1_sel_line_out   ( exAlu_data1_sel_line3_out     ),
    //reg
    .reg1_data_line_out         ( reg1_data_line3_out           ),
    .reg2_data_line_out         ( reg2_data_line3_out           ),
    //Imm gen
    .imm_gen_data_line_out      ( imm_gen_data_line3_out        ),
    //ALU Control
    .instruct_alu_ctrl_line_out ( instruct_alu_ctrl_line3_out   ),
    //reg write bank addr
    .reg_wb_addr_line_out       ( reg_wb_addr_line3_out         ),
    .rs_reg1_addr_line_out      ( rs_reg1_addr_line3_out        ),
    .rs_reg2_addr_line_out      ( rs_reg2_addr_line3_out        )
);

//-------------------------------------------------------------------------------------
//The fourth level of the pipeline          EX_MEM
//-------------------------------------------------------------------------------------
wire    [4:0]   shamt_data = rs_reg2_addr_line3_out ;



mux3    u_forwardA_mux(
    .sel                        ( forwardA                  ),
    .data0_in                   ( reg1_data_line3_out       ),
    .data1_in                   ( mem2reg_data_back         ),
    .data2_in                   ( alu_ex_result_line4_out   ),

    .data_out                   ( forwardA_mux_out          )
);

mux3    u_forwardB_mux(
    .sel                        ( forwardB                  ),
    .data0_in                   ( reg2_data_line3_out       ),
    .data1_in                   ( mem2reg_data_back         ),
    .data2_in                   ( alu_ex_result_line4_out   ),

    .data_out                   ( forwardB_mux_out          )
);

mux2     u_mux_alu_d2(
    .sel                        ( exAlu_data1_sel_line3_out ),
    .data0_in                   ( forwardB_mux_out          ),
    .data1_in                   ( imm_gen_data_line3_out    ),

    .data_out                   ( alu_data2_mux             )
);

alu_ctrl u_alu_ctrl(
    .data_in                    ( instruct_alu_ctrl_line3_out   ),
    .ALUOp                      ( exAlu_op_line3_out            ),
    .ALU_ctl                    ( ALU_ctl                       )
);

alu_ex     u_alu_ex(
    //ALU Operation
    .alu_ctl                    ( ALU_ctl                   ),
    //input Data
    .data0                      ( forwardA_mux_out          ),
    .data1                      ( alu_data2_mux             ),
    .shamt                      ( shamt_data                ),
    //output 
    .ALU_result                 ( alu_ex_result             ),
    .Zero                       (       )
);


ex_mem      u_ex_mem(
    //clk & rst
    .clk                        ( sys_clk                   ),
    .rstn                       ( sys_rst_n                 ),
    //data input
    //Control signals
    .reg_wr_line_in             ( reg_wr_line3_out          ),
    .mem2reg_sel_line_in        ( mem2reg_sel_line3_out     ),
    .mem_wr_line_in             ( mem_wr_line3_out          ),
    .mem_rd_line_in             ( mem_rd_line3_out          ),
    .mem_op_line_in             ( mem_op_line3_out          ),
    //alu_ex
    .alu_ex_result_line_in      ( alu_ex_result             ),
    //reg
    .reg2_data_line_in          ( reg2_data_line3_out       ),
    //reg write bank addr
    .reg_wb_addr_line_in        ( reg_wb_addr_line3_out     ),

    //data output
    //Control signals
    .reg_wr_line_out            ( reg_wr_line4_out          ),
    .mem2reg_sel_line_out       ( mem2reg_sel_line4_out     ),
    .mem_wr_line_out            ( mem_wr_line4_out          ),
    .mem_rd_line_out            ( mem_rd_line4_out          ),
    .mem_op_line_out            ( mem_op_line4_out          ),
    //alu_ex
    .alu_ex_result_line_out     ( alu_ex_result_line4_out   ),
    //reg
    .reg2_data_line_out         ( reg2_data_line4_out       ),
    //reg write bank addr
    .reg_wb_addr_line_out       ( reg_wb_addr_line4_out     )
);

//-------------------------------------------------------------------------------------
//The fifth level of the pipeline       MEM_WB
//-------------------------------------------------------------------------------------
//Data RAM

wire    [31:0]      dram_wdata_mux  ;

mux2     u_mux_dram_wdata(
    .sel                        ( forwardC                  ),
    .data0_in                   ( reg2_data_line4_out       ),
    .data1_in                   ( mem2reg_data_back         ),

    .data_out                   ( dram_wdata_mux            )
);



wrap_dram   u_wrap_dram(
    //system signals
    .sclk                       ( sys_clk                   ),
    .rstn                       ( sys_rst_n                 ),
    //control signals
    .mem_wr                     ( mem_wr_line4_out          ),
    .mem_rd                     ( mem_rd_line4_out          ),
    .mem_op                     ( mem_op_line4_out          ),
    .addr                       ( alu_ex_result_line4_out   ),
    .wdata                      ( dram_wdata_mux            ),
    .rdata                      ( ram_data_out              )
);


mem_wb  u_mem_wb(
    //clk & rst
    .clk                        ( sys_clk                   ),
    .rstn                       ( sys_rst_n                 ),

    //data input
    //Control signals
    .reg_wr_line_in             ( reg_wr_line4_out          ),
    .mem2reg_sel_line_in        ( mem2reg_sel_line4_out     ),
    //data ram 
    .ram_data_out_line_in       ( ram_data_out              ),
    //alu_ex
    .alu_ex_result_line_in      ( alu_ex_result_line4_out   ),
    //reg write bank addr
    .reg_wb_addr_line_in        ( reg_wb_addr_line4_out     ),

    //data output
    //Control signals
    .reg_wr_line_out            ( reg_wr_line5_out          ),
    .mem2reg_sel_line_out       ( mem2reg_sel_line5_out     ),
    //data ram 
    .ram_data_out_line_out      ( ram_data_out_line5_out    ),
    //alu_ex
    .alu_ex_result_line_out     ( alu_ex_result_line5_out   ),
    //reg write bank addr
    .reg_wb_addr_line_out       ( reg_wb_addr_line5_out     )
);


mux2     u_mux_mem2reg(
    .sel                        ( mem2reg_sel_line5_out     ),
    .data0_in                   ( ram_data_out_line5_out    ),
    .data1_in                   ( alu_ex_result_line5_out   ),

    .data_out                   ( mem2reg_data_back         )
);

//-------------------------------------------------------------------------------------
//Forwarding unit
//-------------------------------------------------------------------------------------
forward_unit    u_forward_unit(
    //input
    .rs_reg1_addr               ( rs_reg1_addr              ),
    .rs_reg2_addr               ( rs_reg2_addr              ),
    .id_ex_rs_reg1_addr         ( rs_reg1_addr_line3_out    ),
    .id_ex_rs_reg2_addr         ( rs_reg2_addr_line3_out    ),
    .ex_mem_wb_addr             ( reg_wb_addr_line4_out     ),
    .mem_wb_addr                ( reg_wb_addr_line5_out     ),
    .ex_mem_alu_result          ( alu_ex_result_line4_out   ),
    .mem_wb_alu_result          ( alu_ex_result_line5_out   ),

    .ex_mem_reg_wr              ( reg_wr_line4_out          ),
    .mem_wb_reg_wr              ( reg_wr_line5_out          ),
    .ex_mem_mem_wr              ( mem_wr_line4_out          ),
    //output
    .forwardA                   ( forwardA                  ),
    .forwardB                   ( forwardB                  ),
    .forwardC                   ( forwardC                  ),
    .forwardD                   ( forwardD                  )

);
endmodule
