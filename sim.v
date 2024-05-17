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
        clk = 1'b0;                  // ��ʱ���ź�����
        #(PERIOD1) 
        clk = 1'b1;      // �ȴ����ʱ�����ڣ�Ȼ��ʱ���ź���һ
        #(PERIOD1);                // �ٵȴ����ʱ������
    end
    
    initial begin
        reset=1'b1;
        #20
        reset=1'b0;
        #20

		data_rx = 1'b1;
		#PERIOD2
		
		data_rx = 1'b0;	//��ʼλ��-1-0-
		#PERIOD2	//����11001011 (����)
		
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
		#PERIOD2 //����λ -0-1-
		
		data_rx = 1'b0;
	    #PERIOD2
		
		data_rx = 1'b1;
		#PERIOD2

    $finish;
    end
endmodule
