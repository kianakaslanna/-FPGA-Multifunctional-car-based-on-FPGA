`timescale 1ns / 1ps

module Uart_RX(
    input wire clk,
    input wire rst_n,
    input wire rx,
    output reg [7:0] rx_data,
    output reg rx_flag
    );

/******************内部变量**********************/
parameter N=13021; //N=系统时钟频率/波特率；f=125Mhz,baud=9600。表示N个系统时钟一个数据位
reg rx_reg1;//打排数据
reg rx_reg2;//打排数据
reg rx_reg3;//打排数据
reg start_flag;//起始标志
reg work_en;//工作使能
reg [31:0] baud_cnt;//波特计数器
reg bit_flag;//比特标志
reg [3:0] bit_cnt;//数据位计数，0-8
reg [7:0] rx_data_reg;//数据寄存器
reg rx_flag_reg;//数据标识符寄存器

/*******************数据打拍**********************/
//数据打拍，避免亚稳态
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

/*******************起始标志**********************/
always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            start_flag<=0;
        else if((rx_reg3==1)&&(rx_reg2==0)&&(work_en==0))//迟滞reg3一个clk
            start_flag<=1;
        else 
            start_flag<=0;
    end

/*******************工作使能**********************/
always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            work_en<=0;
        else if(start_flag==1)//开始迟滞一个clk，工作使能
            work_en<=1;
        else if((bit_cnt==8)&&(bit_flag==1))
            work_en<=0;
        else
            work_en<=work_en;
    end

/*******************波特计数器**********************/
always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            baud_cnt<=0;
        else if((baud_cnt==N-1)||(work_en==0))
            baud_cnt<=0;
        else
            baud_cnt<=baud_cnt+1;
    end

/*******************比特标志**********************/
always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            bit_flag<=0;
        else if(baud_cnt==(N/2-1))
            bit_flag<=1;
        else
            bit_flag<=0;
    end

/*******************数据位计数**********************/
always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            bit_cnt<=0;
        else if((bit_cnt==8)&&(bit_flag==1))
            bit_cnt<=0;
        else if(bit_flag==1)
            bit_cnt<=bit_cnt+1;
    end
        
/*******************数据寄存器**********************/
always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            rx_data_reg<=0;
        else if((bit_cnt>=1)&&(bit_cnt<=8)&&(bit_flag==1))
            rx_data_reg<={rx_reg3,rx_data_reg[7:1]};
    end
    
/*******************数据标识符寄存器**********************/
always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            rx_flag_reg<=0;
        else if((bit_cnt==8)&&(bit_flag==1))
            rx_flag_reg<=1;
        else 
            rx_flag_reg<=0;
    end

/*******************数据输出**********************/
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

