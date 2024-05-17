`timescale 1ns / 1ps


//10us触发信号
module Trig_Signal(
    input clk, //系统自身时钟
    input reset,
    output trig    
    );
    
    reg reg_trig;
    reg [25:0] jishu_cnt;
    parameter a=12500000;//100ms
    
    always@(posedge clk)
    begin
        if(reset==1'b1)
        begin
            reg_trig<=0;
            jishu_cnt<=0;
        end
        else if(jishu_cnt==((a/2)-1))
            begin        
                jishu_cnt<=0;
                reg_trig<=~reg_trig;
            end
        else jishu_cnt=jishu_cnt+1;       
   end
   assign trig=reg_trig;
endmodule
