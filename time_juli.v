`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module PosCounter(clk, reset, echo, echo_time); // 检测回波高电平持续时间
input clk;
input reset;
input echo;
output [40:0] echo_time;//回响信号持续时间

parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10; // 状态定义 S0:闲置, S1:开始测距计数, S2:结束测距计数
reg[1:0] curr_state, next_state;
reg echo_reg1, echo_reg2;//两个回响信号寄存器
reg [19:0] count, dis_reg;
reg [40:0] reg_echo_time; //echo回响信号输出时间
wire start;
wire finish;
assign start = echo_reg1&~echo_reg2;  //检测posedge
assign finish = ~echo_reg1&echo_reg2; //检测negedge

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
        echo_reg1 <= echo;          // 当前
        echo_reg2 <= echo_reg1;     // 后一个
        case(curr_state)
        S0:begin
                if (start) // 检测到上升沿
                    curr_state <= next_state; //S1
                else
                    count <= 0;
                end
        S1:begin
                if (finish) // 检测到下降沿
                    curr_state <= next_state; //S2
                else
                    begin
                        count <= count + 1;
                    end
            end
        S2:begin
                dis_reg <= count; // 缓存计数结果
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
        reg_echo_time=(dis_reg*8);//返回echo时间(ns)
    end
assign echo_time=reg_echo_time;

endmodule

