`timescale 1ns / 1ps
module uar_control(
    input clk,
    input reset,
    input rx,
    output reg[7:0] LED
    );

    reg [1:0] ack_output_buff=0;
    wire [7:0] output_rx_data;
    wire output_rx_rq;
    
    //ÊµÀý»¯UART
    driver_Uart UART0(
        .clk(clk),
        .reset(reset),
        .en_rx(1'b1),
        .set_baudrate(1'b1),
        .baudrate(31'd9600),
        .rx(rx),
        .output_rx_data(output_rx_data),
        .output_rx_rq(output_rx_rq)
    );
    always@(posedge clk)
        begin
            ack_output_buff<={ack_output_buff[0],output_rx_rq};
            if(ack_output_buff==2'b01)
                LED<=output_rx_data[7:0];
            else LED<=LED;
        end
endmodule

