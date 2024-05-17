`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/08 10:27:58
// Design Name: 
// Module Name: sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sim();
    reg clk;
    reg reset;
    reg data_rx;
    wire [7:0] LED;
    
    uar_control a0(
    .clk(clk)
    ,.reset(reset)
    ,.rx(data_rx)
    ,.LED(LED)
    );
    
    parameter PERIOD1 = 4;
    parameter PERIOD2 = 208320;
    always begin
        clk = 1'b0;                  // 将时钟信号置零
        #(PERIOD1) 
        clk = 1'b1;      // 等待半个时钟周期，然后将时钟信号置一
        #(PERIOD1);                // 再等待半个时钟周期
    end
    
    initial begin
        reset=1'b1;
        #20
        reset=1'b0;
        #20

		data_rx = 1'b1;
		#PERIOD2
		
		data_rx = 1'b0;	//起始位：-1-0-
		#PERIOD2	//传输11001011 (倒序)
		
		data_rx = 1'b1;
		#PERIOD2
		
		data_rx = 1'b1;
		#PERIOD2
		
		data_rx = 1'b0;
		#PERIOD2
		
		data_rx = 1'b1;
		#PERIOD2
	
		data_rx = 1'b0;
		#PERIOD2
		
		data_rx = 1'b1;
        #PERIOD2
		
		data_rx = 1'b1;
		#PERIOD2
		
		data_rx = 1'b1;
		#PERIOD2 //结束位 -0-1-
		
		data_rx = 1'b0;
	    #PERIOD2
		
		data_rx = 1'b1;
		#PERIOD2

    $finish;
    end
endmodule
