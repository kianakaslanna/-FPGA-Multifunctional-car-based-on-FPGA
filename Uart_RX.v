`timescale 1ns / 1ps

module Uart_RX(
    input clk,                          //系统时钟
    input clk_UART,                     //UART传输时钟
    input reset,                        //Reset signal, low reset
    input en,                           //接收使能
    input rx,                           //串口接收数据
    output [7:0]output_data,            //输出数据
    output output_ack                    //虚拟接收请求信号(fpga向蓝牙模块)
);
    localparam ST_IDLE=2'd0; //闲置
    localparam ST_START=2'd1;
    localparam ST_END=2'd2;
    
    //状态机
    reg[1:0]state_current=0;
    reg[1:0]state_next=0;
    
    
    //计数
    reg[2:0]data_cnt=0;
    
    //缓存
    reg [1:0]clk_uart_buff=0;
    reg rx_reg=1;
    reg en_reg=0;
   
    
    //输出
    reg [7:0]data_reg=0;
    reg ack_reg=0;
    reg [7:0]data_reg2=0;
    //输出连线
    assign output_ack=ack_reg;
    assign output_data=data_reg;
    
   
    
    //状态机(更新下一状态)
    always@(*)begin
        case(state_current)
            ST_IDLE:begin//蓝牙模块闲置
                ack_reg<=0;
                if(rx_reg==1'b0&en_reg==1'b1)state_next<=ST_START;             //如果串口接收信号被拉低且接收使能信号为高，则进入接收状态
                else state_next<=ST_IDLE;
            end
            ST_START:begin//蓝牙模块工作
                ack_reg<=0;
                if(data_cnt==3'd7)state_next<=ST_END;   //如果数据传输完成，则进入结束状态（停止位）
                else state_next<=ST_START; 
            end
            ST_END:begin
                state_next<=ST_IDLE;
                ack_reg<=1;//传输完成，输出接收请求
            end
            default:begin
                state_next<=ST_IDLE;
                ack_reg<=0;
            end
        endcase
    end
        
    //状态赋值（下一状态赋值给当前状态）
    always@(posedge clk)
    begin
        if(reset==1)
            begin
                state_current<=ST_IDLE;
            end 
        else if(clk_uart_buff==2'b01) //clk_uart为高电平
            begin
                state_current<=state_next;
            end 
        else 
            begin
                state_current<=state_current;
            end
    end
    
    //接收数据
    always@(posedge clk)
    begin
        if(reset==1)
            begin
                data_reg<=8'b0;
            end 
        else if(state_current==ST_START&clk_uart_buff==2'b01)begin
            data_reg<={rx_reg,data_reg[7:1]};
        end else begin
            data_reg<=data_reg;
        end
    end
    
//   localparam NUM0=8'b00000000;
//   localparam NUM1=8'b00000001;
//   localparam NUM2=8'b00000010;
//   localparam NUM3=8'b00000011;
//   localparam NUM4=8'b00000100;
//   always@(posedge clk)
//   begin
//        case(data_reg)
//        NUM0:data_reg2<=NUM0;
//        NUM1:data_reg2<=NUM1;
//        NUM2:data_reg2<=NUM2;
//        NUM3:data_reg2<=NUM3;
//        NUM4:data_reg2<=NUM4;
//        endcase
//   end
    
    //接收数据位计数
    always@(posedge clk)
    begin
        if(reset==1)
            begin
                data_cnt<=0;
            end 
        else if(state_current==ST_START&clk_uart_buff==2'b01)
            begin
                data_cnt<=data_cnt+1;
            end 
       else if(clk_uart_buff==2'b01)
            begin
                data_cnt<=0;
            end 
      else 
            begin
                data_cnt<=data_cnt;
            end
    end
    
     
    
    //缓存信号
     always@(posedge clk )begin
        if(reset==1)
        begin
            clk_uart_buff<=2'd0;
            rx_reg<=1'b1;
            en_reg<=1'b0;
        end else begin
            clk_uart_buff<={clk_uart_buff[0],clk_UART};
            rx_reg<=rx;
            en_reg<=en;
        end
     end
endmodule
