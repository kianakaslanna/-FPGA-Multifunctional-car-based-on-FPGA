`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/10 10:14:26
// Design Name: 
// Module Name: clk_division
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//·ÖÆµ1Mhz
module clk_division(
    input clk,
    input reset,
    output Uart_clk
    );
    
    parameter b=1086;
    reg [30:0] cnt;
    reg Uart_clk_reg;
    
    always@(posedge clk)
    begin
        if(reset==1'b1)
        begin
            Uart_clk_reg<=0;
            cnt<=0;
        end
        else if(cnt==b)
            begin        
                cnt<=0;
                Uart_clk_reg<=~Uart_clk_reg;
            end
        else cnt=cnt+1;       
   end
   assign Uart_clk=Uart_clk_reg;
endmodule
