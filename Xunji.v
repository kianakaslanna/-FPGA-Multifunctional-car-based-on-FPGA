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
        if((track1==1'b1)&&(track2==1'b1))//Ѱ�����ߣ�����ֱ��ǰ��
            begin
                reg_left1=0;
                reg_left2=1;
                reg_right1=0;
                reg_right2=1;//����ǰ��
            end
        else if((track1==1'b1)&&(track2==1'b0))//�󴫸�Ѱ�����ߣ��Ҵ���δѰ�������ֶ�
            begin
                reg_left1=0;
                reg_left2=0;
                reg_right1=0;
                reg_right2=1;//�Һ���ǰ��
            end
        else if((track1==1'b0)&&(track2==1'b0))//�Ҵ���Ѱ�����ߣ��Ҵ���δѰ�������ֶ�
            begin
                reg_left1=0;
                reg_left2=1;
                reg_right1=0;
                reg_right2=0;//�����ǰ��
            end
               else if((track1==1'b0)&&(track2==1'b0))
            begin
                reg_left1=0;
                reg_left2=0;
                reg_right1=0;
                reg_right2=0;//��ֹ
            end
    end
endmodule
