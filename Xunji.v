module xunji(
    input reset,
    input clk,
    input track1,
    input track2,
    output left1,
    output left2,
    output right1,
    output reght2   
    );
    reg reg_left1;
    reg reg_left2;
    reg reg_right1;
    reg reg_right2;
    
    reg clk_fenpin;
    clk_diverse2(.clk(clk),.reset(reset),.clk_fenpin(clk_fenpin));
    
    always@(posedge clk_fenpin)
    begin
        if((track1==1'b1)&&(track2==1'b1))//寻到黑线，俩轮直接前进
            begin
                reg_left1=0;
                reg_left2=1;
                reg_right1=0;
                reg_right2=1;//俩轮前进
            end
        else if((track1==1'b1)&&(track2==1'b0))//左传感寻到黑线，右传感未寻到，右轮动
            begin
                reg_left1=0;
                reg_left2=0;
                reg_right1=0;
                reg_right2=1;//右后轮前进
            end
        else if((track1==1'b0)&&(track2==1'b0))//右传感寻到黑线，右传感未寻到，左轮动
            begin
                reg_left1=0;
                reg_left2=1;
                reg_right1=0;
                reg_right2=0;//左后轮前进
            end
               else if((track1==1'b0)&&(track2==1'b0))
            begin
                reg_left1=0;
                reg_left2=0;
                reg_right1=0;
                reg_right2=0;//静止
            end
    end
endmodule
