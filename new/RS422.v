`timescale 1ns / 1ps

module RS422(
    input wire clk,
    input wire rst_n,
    input wire rx_1,
    input wire rx_2,
    output wire tx_1,
    output wire tx_2
    );
    
 rs232 rs422_1(
    .clk(clk),
    .rst_n(rst_n),
    .rx(rx_1),
    .tx(tx_1)
    );   
 
  rs232 rs422_2(
    .clk(clk),
    .rst_n(rst_n),
    .rx(rx_2),
    .tx(tx_2)
    );   
 ila_0 your_instance_name (
	.clk(clk), // input wire clk
	.probe0(rx_1), // input wire [0:0]  probe0  
	.probe1(rx_2), // input wire [0:0]  probe1 
	.probe2(tx_1), // input wire [0:0]  probe2 
	.probe3(tx_2) // input wire [0:0]  probe3
);

endmodule
