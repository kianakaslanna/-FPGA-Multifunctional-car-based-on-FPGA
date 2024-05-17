`timescale 1ns / 1ps

module Uart_RX(
    input wire clk,
    input wire rst_n,
    input wire rx,
    output reg [7:0] rx_data,
    output reg rx_flag
    );

/******************�ڲ�����**********************/
parameter N=13021; //N=ϵͳʱ��Ƶ��/�����ʣ�f=125Mhz,baud=9600����ʾN��ϵͳʱ��һ������λ
reg rx_reg1;//��������
reg rx_reg2;//��������
reg rx_reg3;//��������
reg start_flag;//��ʼ��־
reg work_en;//����ʹ��
reg [31:0] baud_cnt;//���ؼ�����
reg bit_flag;//���ر�־
reg [3:0] bit_cnt;//����λ������0-8
reg [7:0] rx_data_reg;//���ݼĴ���
reg rx_flag_reg;//���ݱ�ʶ���Ĵ���

/*******************���ݴ���**********************/
//���ݴ��ģ���������̬
always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            rx_reg1<=1;
        else
            rx_reg1<=rx;
    end

always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            rx_reg2<=1;
        else
            rx_reg2<=rx_reg1;
    end

always@(posedge clk or negedge rst_n)
    begin
        if(rst_n==0)
            rx_reg3<=1;
        else
            rx_reg3<=rx_reg2;
    end

/*******************��ʼ��־**********************/
always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            start_flag<=0;
        else if((rx_reg3==1)&&(rx_reg2==0)&&(work_en==0))//����reg3һ��clk
            start_flag<=1;
        else 
            start_flag<=0;
    end

/*******************����ʹ��**********************/
always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            work_en<=0;
        else if(start_flag==1)//��ʼ����һ��clk������ʹ��
            work_en<=1;
        else if((bit_cnt==8)&&(bit_flag==1))
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
        else
            baud_cnt<=baud_cnt+1;
    end

/*******************���ر�־**********************/
always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            bit_flag<=0;
        else if(baud_cnt==(N/2-1))
            bit_flag<=1;
        else
            bit_flag<=0;
    end

/*******************����λ����**********************/
always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            bit_cnt<=0;
        else if((bit_cnt==8)&&(bit_flag==1))
            bit_cnt<=0;
        else if(bit_flag==1)
            bit_cnt<=bit_cnt+1;
    end
        
/*******************���ݼĴ���**********************/
always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            rx_data_reg<=0;
        else if((bit_cnt>=1)&&(bit_cnt<=8)&&(bit_flag==1))
            rx_data_reg<={rx_reg3,rx_data_reg[7:1]};
    end
    
/*******************���ݱ�ʶ���Ĵ���**********************/
always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            rx_flag_reg<=0;
        else if((bit_cnt==8)&&(bit_flag==1))
            rx_flag_reg<=1;
        else 
            rx_flag_reg<=0;
    end

/*******************�������**********************/
always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            rx_data<=0;
        else if(rx_flag_reg==1)
            rx_data<=rx_data_reg;
    end

always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            rx_flag<=0;
        else
            rx_flag<=rx_flag_reg;
    end
    
endmodule

