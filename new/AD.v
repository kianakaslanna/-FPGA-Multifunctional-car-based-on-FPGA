`timescale 1ns / 1ps

module AD
(
    input clk,
    input n_rst,
    
    input [7:0] AD_data_in,
    output adc_clk,
    output tx
    
);
wire locked;
reg [3:0]cnt;
reg [7:0] AD_data_out2;
reg [7:0] AD_data_out;
reg start_flag;

always @(negedge adc_clk) 
    begin
        AD_data_out<=AD_data_in;
    end
    
always @(negedge adc_clk) 
    begin
        if(cnt==0)
            begin
                start_flag<=1;
                AD_data_out2<=AD_data_out;
            end
        else
            begin
            cnt<=cnt+1;
            end
    end
    
  clk_wiz_0 instance_name
   (
    .clk_out1(adc_clk),     // output clk_out1
    .reset(!n_rst), // input reset
    .locked(locked),       // output locked
    .clk_in1(clk)
    );    
    
    Uart_TX AD_OUT(
    .clk(clk),
    .rst_n(n_rst),
    .data(AD_data_out),
    .start_flag(start_flag),
    .tx(tx)
    ); 
    
    ila_1 your_instance_name (
	.clk(clk), // input wire clk
	.probe0(AD_data_in), // input wire [7:0]  probe0  
	.probe1(cnt), // input wire [3:0]  probe1 
	.probe2(AD_data_out), // input wire [7:0]  probe2 
	.probe3(AD_data_out2), // input wire [7:0]  probe3 
	.probe4(tx) // input wire [0:0]  probe4
);
endmodule
