`timescale 1ns / 1ps

module Uart_TX(
    input wire clk,
    input wire rst_n,
    input wire [7:0] data,
    input wire start_flag,
    output wire tx
    );
    
/******************内部变量**********************/
parameter N=13021; //N=系统时钟频率/波特率；f=125Mhz,baud=9600。表示N个系统时钟一个数据位
reg work_en;//工作使能
reg [31:0] baud_cnt;//波特计数器
reg bit_flag;//比特标志
reg [3:0] bit_cnt;//数据位计数，0-8
reg tx_reg;
assign tx=tx_reg;
/******************工作使能**********************/
always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            work_en<=0;
        else if(start_flag==1)//开始迟滞一个clk，工作使能
            work_en<=1;
        else if((bit_cnt==4'd9)&&(bit_flag==1))
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
        else if(work_en==1)
            baud_cnt<=baud_cnt+1;
    end

/*******************比特标志**********************/
always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            bit_flag<=0;
        else if(baud_cnt==1)
            bit_flag<=1;
        else
            bit_flag<=0;
    end

/*******************数据位计数**********************/
always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            bit_cnt<=0;
        else if((bit_cnt==4'd9)&&(bit_flag==1))
            bit_cnt<=0;
        else if(bit_flag==1)
            bit_cnt<=bit_cnt+1;
    end

/*******************数据输出**********************/
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