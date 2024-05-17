`timescale 1ns / 1ps

module Uart_TX(
    input wire clk,
    input wire rst_n,
    input wire [7:0] data,
    input wire start_flag,
    output wire tx
    );
    
/******************�ڲ�����**********************/
parameter N=13021; //N=ϵͳʱ��Ƶ��/�����ʣ�f=125Mhz,baud=9600����ʾN��ϵͳʱ��һ������λ
reg work_en;//����ʹ��
reg [31:0] baud_cnt;//���ؼ�����
reg bit_flag;//���ر�־
reg [3:0] bit_cnt;//����λ������0-8
reg tx_reg;
assign tx=tx_reg;
/******************����ʹ��**********************/
always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            work_en<=0;
        else if(start_flag==1)//��ʼ����һ��clk������ʹ��
            work_en<=1;
        else if((bit_cnt==4'd9)&&(bit_flag==1))
            work_en<=0;
        else
            work_en<=work_en;
    end
/*******************���ؼ�����**********************/
always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            baud_cnt<=0;
        else if((baud_cnt==N-1)||(work_en==0))
            baud_cnt<=0;
        else if(work_en==1)
            baud_cnt<=baud_cnt+1;
    end

/*******************���ر�־**********************/
always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            bit_flag<=0;
        else if(baud_cnt==1)
            bit_flag<=1;
        else
            bit_flag<=0;
    end

/*******************����λ����**********************/
always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            bit_cnt<=0;
        else if((bit_cnt==4'd9)&&(bit_flag==1))
            bit_cnt<=0;
        else if(bit_flag==1)
            bit_cnt<=bit_cnt+1;
    end

/*******************�������**********************/
always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            tx_reg<=1;
        else if(bit_flag==1) 
            case(bit_cnt)
                0:tx_reg<=0;
                1:tx_reg<=data[0];
                2:tx_reg<=data[1];
                3:tx_reg<=data[2];
                4:tx_reg<=data[3];
                5:tx_reg<=data[4];
                6:tx_reg<=data[5];
                7:tx_reg<=data[6];
                8:tx_reg<=data[7];
                9:tx_reg<=1;
                default:tx_reg<=1;
            endcase
    end
endmodule