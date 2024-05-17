`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module PosCounter(clk, reset, echo, echo_time); // ���ز��ߵ�ƽ����ʱ��
input clk;
input reset;
input echo;
output [40:0] echo_time;//�����źų���ʱ��

parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10; // ״̬���� S0:����, S1:��ʼ������, S2:����������
reg[1:0] curr_state, next_state;
reg echo_reg1, echo_reg2;//���������źżĴ���
reg [19:0] count, dis_reg;
reg [40:0] reg_echo_time; //echo�����ź����ʱ��
wire start;
wire finish;
assign start = echo_reg1&~echo_reg2;  //���posedge
assign finish = ~echo_reg1&echo_reg2; //���negedge

always@(posedge clk)
begin
    if(reset==1)
    begin
        echo_reg1 <= 0;
        echo_reg2 <= 0;
        count <= 0;
        dis_reg <= 0;
        curr_state <= S0;
    end
    
    else
    begin
        echo_reg1 <= echo;          // ��ǰ
        echo_reg2 <= echo_reg1;     // ��һ��
        case(curr_state)
        S0:begin
                if (start) // ��⵽������
                    curr_state <= next_state; //S1
                else
                    count <= 0;
                end
        S1:begin
                if (finish) // ��⵽�½���
                    curr_state <= next_state; //S2
                else
                    begin
                        count <= count + 1;
                    end
            end
        S2:begin
                dis_reg <= count; // ����������
                count <= 0;
                curr_state <= next_state; //S0
            end
        endcase
    end
end

always@(curr_state)
begin
    case(curr_state)
    S0:next_state <= S1;
    S1:next_state <= S2;
    S2:next_state <= S0;
    endcase
end

always@(posedge clk)
    begin
        reg_echo_time=(dis_reg*8);//����echoʱ��(ns)
    end
assign echo_time=reg_echo_time;

endmodule

