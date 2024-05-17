module clk_diverse2(
    input clk,
    input reset,
    output clk_fenpin
    );
    
    parameter b=12500;
    reg [30:0] cnt;
    reg clk_fenpin_reg;
    
    always@(posedge clk)
    begin
        if(reset==1'b1)
        begin
             clk_fenpin_reg<=0;
            cnt<=0;
        end
        else if(cnt==b)
            begin        
                cnt<=0;
                 clk_fenpin_reg<=~ clk_fenpin_reg;
            end
        else cnt=cnt+1;       
   end
   assign clk_fenpin= clk_fenpin_reg;
endmodule
