

module wrap_iram(
    //system signals
    input                   sclk        ,
    //input                   rstn        ,
    //control signals
    input                   mem_wr      ,
    input                   mem_rd      ,
    input           [31:0]  addr        ,
    input           [31:0]  wdata       ,
    output          [31:0]  rdata       
);

wire            ram_cs      ;
wire    [3:0]   ram_we      ;
wire    [3:0]   ram_wen     ;
wire    [11:0]  ram_addr    ;
wire    [31:0]  ram_wdata   ;
wire    [31:0]  ram_rdata   ;

wire            RAM_CLK     ;
wire            RAM_CEN     ;
wire            RAM_WEN     ;
wire    [31:0]  RAM_BWEN    ;
wire    [12:0]  RAM_ADDR    ;
wire    [31:0]  RAM_WDATA   ;
wire    [31:0]  RAM_RDATA   ;

assign  ram_cs  = mem_wr | mem_rd;
assign  ram_addr= addr[13:2];
assign  ram_we  = 4'b0000   ;
assign  rdata   = ram_rdata ;
assign ram_wdata = 32'd0;





ram_bfm #(
        .DATA_WHITH     ( 32            ),
        .DATA_SIZE      ( 8             ),
        .ADDR_WHITH     ( 13            ),
        .RAM_DEPTH      ( 8192          )
    )
    u_ram_8192_32(
    //system signals
    .clk                        ( sclk              ),
    //RAM Control signals
    .cs                         ( ram_cs            ),
    .we                         ( ram_we            ),
    .addr                       ( ram_addr          ),
    .wdata                      ( ram_wdata         ),
    .rdata                      ( ram_rdata         )
);

endmodule
