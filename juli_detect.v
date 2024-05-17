`timescale 1ns / 1ps
module juli_detect(clk, reset, Trig, Echo,distance);
input clk;
input reset;
input Echo;
output Trig;
output [15:0]distance;   // ���루��λMM��,5λʮ����,������λС��
wire [20:0] ec_time; // �ز��ߵ�ƽ����ʱ��ns
Trig_Signal u1(.clk(clk),.reset(reset),.trig(Trig));//��Ƶ��10hz�ź�
PosCounter u2(.clk(clk), .reset(reset),.echo(Echo),.echo_time(ec_time));
reg [15:0] distance_reg;
assign distance=distance_reg;
always@(posedge clk)
    begin
       distance_reg=(340*ec_time/1000000)/2;//mm    
    end

endmodule


