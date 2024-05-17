`timescale 1ns / 1ps

module Uart_RX(
    input clk,                          //ϵͳʱ��
    input clk_UART,                     //UART����ʱ��
    input reset,                        //Reset signal, low reset
    input en,                           //����ʹ��
    input rx,                           //���ڽ�������
    output [7:0]output_data,            //�������
    output output_ack                    //������������ź�(fpga������ģ��)
);
    localparam ST_IDLE=2'd0; //����
    localparam ST_START=2'd1;
    localparam ST_END=2'd2;
    
    //״̬��
    reg[1:0]state_current=0;
    reg[1:0]state_next=0;
    
    
    //����
    reg[2:0]data_cnt=0;
    
    //����
    reg [1:0]clk_uart_buff=0;
    reg rx_reg=1;
    reg en_reg=0;
   
    
    //���
    reg [7:0]data_reg=0;
    reg ack_reg=0;
    reg [7:0]data_reg2=0;
    //�������
    assign output_ack=ack_reg;
    assign output_data=data_reg;
    
   
    
    //״̬��(������һ״̬)
    always@(*)begin
        case(state_current)
            ST_IDLE:begin//����ģ������
                ack_reg<=0;
                if(rx_reg==1'b0&en_reg==1'b1)state_next<=ST_START;             //������ڽ����źű������ҽ���ʹ���ź�Ϊ�ߣ���������״̬
                else state_next<=ST_IDLE;
            end
            ST_START:begin//����ģ�鹤��
                ack_reg<=0;
                if(data_cnt==3'd7)state_next<=ST_END;   //������ݴ�����ɣ���������״̬��ֹͣλ��
                else state_next<=ST_START; 
            end
            ST_END:begin
                state_next<=ST_IDLE;
                ack_reg<=1;//������ɣ������������
            end
            default:begin
                state_next<=ST_IDLE;
                ack_reg<=0;
            end
        endcase
    end
        
    //״̬��ֵ����һ״̬��ֵ����ǰ״̬��
    always@(posedge clk)
    begin
        if(reset==1)
            begin
                state_current<=ST_IDLE;
            end 
        else if(clk_uart_buff==2'b01) //clk_uartΪ�ߵ�ƽ
            begin
                state_current<=state_next;
            end 
        else 
            begin
                state_current<=state_current;
            end
    end
    
    //��������
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
    
    //��������λ����
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
    
     
    
    //�����ź�
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
