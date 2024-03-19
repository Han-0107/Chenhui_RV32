`timescale 1ns/1ps


module tbtop();

`define TB  tbtop
`define TB_IRAM `TB.U_CHIP_TOP.u_riscv_core.u_wrap_iram.u_ram_8192_32
`define TB_DRAM `TB.U_CHIP_TOP.u_riscv_core.u_wrap_dram.u_ram_8192_32

`define RAM_DEEP            4096

reg     d_sys_clk   ;
reg     d_sys_rst_n ;

initial begin
    
    d_sys_rst_n  = 0;
    #100;
    d_sys_rst_n = 1;
end
initial d_sys_clk=0;
always #20  d_sys_clk<=~d_sys_clk;

wire sys_clk   = d_sys_clk   ;
wire sys_rst_n = d_sys_rst_n ;


CHIP_TOP    U_CHIP_TOP(

    //system signal
    .sys_clk        (sys_clk        ),
    .sys_rst_n      (sys_rst_n      ),
    .led_test       (led_test       )
);

//------------------------------------------------------------------------------------------------
// Initial Instruction RAM
//------------------------------------------------------------------------------------------------

reg [7:0] imem [0:(`RAM_DEEP*8)-1];
reg [31:0] i;
initial begin :Init_IRAM
    for ( i=0;i<(`RAM_DEEP*8);i=i+1) begin
        imem[i] = 32'd0;
    end
    //$readmemh( "main.verilog", imem);
    $readmemh( "rv32uc-p-rvc.verilog", imem);
    for ( i=0;i<(`RAM_DEEP);i=i+1) begin
        `TB_IRAM.mem_array[i][00+7:00] = imem[i*4+0];
        `TB_IRAM.mem_array[i][08+7:08] = imem[i*4+1];
        `TB_IRAM.mem_array[i][16+7:16] = imem[i*4+2];
        `TB_IRAM.mem_array[i][24+7:24] = imem[i*4+3];
    end
        $display("\n");
        $display("*\tIDATA: 0x00: %h", `TB_IRAM.mem_array[8'h00]);
        $display("*\tIDATA: 0x04: %h", `TB_IRAM.mem_array[8'h01]);
        $display("*\tIDATA: 0x08: %h", `TB_IRAM.mem_array[8'h02]);
        $display("*\tIDATA: 0x0C: %h", `TB_IRAM.mem_array[8'h03]);
        $display("*\tIDATA: 0x10: %h", `TB_IRAM.mem_array[8'h04]);
        $display("*\tIDATA: 0x14: %h", `TB_IRAM.mem_array[8'h05]);
        $display("*\tIDATA: 0x18: %h", `TB_IRAM.mem_array[8'h06]);
        $display("*\tIDATA: 0x1C: %h", `TB_IRAM.mem_array[8'h07]);
        $display("*\tIDATA: 0x20: %h", `TB_IRAM.mem_array[8'h08]);
        $display("*\tIDATA: 0x24: %h", `TB_IRAM.mem_array[8'h09]);
        $display("*\tIDATA: 0x28: %h", `TB_IRAM.mem_array[8'h0A]);
        $display("*\tIDATA: 0x2C: %h", `TB_IRAM.mem_array[8'h0B]);
end


initial begin
    //TEST_PASS;
    $display("\n******** hello risc_v !!!! ******");
    #100000000;
    $stop();
end

endmodule
