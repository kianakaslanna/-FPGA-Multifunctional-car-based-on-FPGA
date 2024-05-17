`timescale 1ns / 1ps


module driver_Uart(
    input clk,
    input reset,
    input en_rx,//����ʹ���ź�
    input set_baudrate,//���ò������ź�
    input [30:0] baudrate,//����������ֵ
    input rx,//���ڽ�������
    output [7:0]output_rx_data,//rx�������
    output output_rx_rq        //��������
    );
    //Ĭ�ϲ�����
    parameter Default_BaudRate=115200;
    parameter CLK_Freq_MHZ='d125;
    localparam Default_Factor=CLK_Freq_MHZ*('d1000_000)/Default_BaudRate;
    
    //UART clock
    wire clk_UART;
    reg [30:0]clk_mode=Default_Factor; //�����ʼĴ���
    
    
    //����
    reg [1:0]set_baudrate_reg=0;
    reg [30:0]baudrate_reg=Default_BaudRate;
    
    //��־
    reg flg_set_baudrate=0;
  
    //���ò�����
    always@(posedge clk)
        begin
            if(reset==1)
                begin
                    clk_mode<=Default_Factor;
                end  
        else if(flg_set_baudrate)begin
            clk_mode<=CLK_Freq_MHZ*('d1000_000)/baudrate_reg;
        end
        else begin
            clk_mode<=clk_mode;
        end
    end

    //��Ƶ�õ�UARTʱ��
    clk_division UART_CLK(.clk(clk),.reset(reset),.Uart_clk(clk_UART));
    
    Uart_RX UART_Rx0(
        .clk(clk),              //Clock signal
        .clk_UART(clk_UART),      //Clock signal
        .reset(reset),              //Reset signal, low reset
        .en(en_rx),             //Enable signal, active high
        .rx(rx),                //Rx
        .output_data(output_rx_data),         //Receive data output
        .output_ack(output_rx_rq)             //Interrupt signal, whether it is received
    );

    //�����ؼ��
    always@(posedge clk)
        begin
            if(reset==1)
                begin
                    flg_set_baudrate<=0;
                end  
             else 
                begin
                    flg_set_baudrate<=(set_baudrate_reg==2'b01);
                end
    end
    //�źŻ���
    always@(posedge clk)
        begin
            if(reset==1)
                begin
                    set_baudrate_reg<=0;
                    baudrate_reg<=Default_BaudRate;
            end  
        else begin
            set_baudrate_reg<={set_baudrate_reg[0],set_baudrate};
            baudrate_reg<=baudrate;
        end
    end
endmodule

