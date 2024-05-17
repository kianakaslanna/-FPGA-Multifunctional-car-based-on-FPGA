module rs232(
    input wire clk,
    input wire rst_n,
    input wire rx,
    output wire tx
    );

wire rx_flag;
wire [7:0] rx_data;
wire [7:0] tx_data;

Uart_TX uart_tx(
    .clk(clk),
    .rst_n(rst_n),
    .data(rx_data),
    .start_flag(rx_flag),
    .tx(tx)
    );

Uart_RX uart_rx(
    .clk(clk),
    .rst_n(rst_n),
    .rx(rx),
    .rx_data(rx_data),
    .rx_flag(rx_flag)
    );
    
endmodule