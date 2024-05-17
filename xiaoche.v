module top_modlue(
    input clk,//ϵͳʱ��
    input reset,//��λ����
    input rx,//��������
    input wire [3:0] signal,//�����ź�
    input wire Echo,//����������
    input [3:0] track,//Ѱ��
    input [1:0] Light,
    output wire Trig,//����������
    output [3:0] led,//led
    output wire motor_A_PWM,//���
    output wire motor_A_IN1,
    output wire motor_A_IN2,
    output wire motor_B_PWM,
    output wire motor_B_IN1,
    output wire motor_B_IN2,
    output wire motor_C_PWM,
    output wire motor_C_IN1,
    output wire motor_C_IN2,
    output wire motor_D_PWM,
    output wire motor_D_IN1,
    output wire motor_D_IN2
);
/******************************ģ��ʹ�õı���**************************************/
    wire [7:0] datarece;//�������յ���Ϣ
    reg [7:0] data;//�����ź�
    wire [15:0] distance;//��������þ���
    reg [15:0] distance_reg;//��������þ���
    reg [3:0] mode;//ģʽѡ��(���� Ѱ�� ң��)
    reg [3:0] ledout;//led���
    reg [7:0] pwm;//pwm���ֵ
    reg Mode_Control;//ң��ģʽ��־��
    reg [3:0] signal_reg;//�����ź�
    reg [3:0] track_reg;
    reg [1:0] light_reg;
    assign led=ledout;//led����
    localparam DISTANCE_THRESHOLD = 200; //������������ֵ
/********************************����ģ��****************************************/
    //����ģ��
    uar_control bluetooth(
    .clk(clk),//���� ʱ��
    .reset(reset),//���� ��λ
    .rx(rx),//���� ��Ϣ
    .LED(datarece)//��� ��Ϣ
    );
    //���������
    juli_detect u0(
        .clk(clk),//���� ʱ��
        .reset(reset),//���� ��λ
        .Echo(Echo),//���� ����
        .Trig(Trig),
        .distance(distance)//��� ����
    );
    //�������
    Four_Wheel_Control (
        .clk(clk),           // ���� ʱ��
        .reset(reset),         // ���� ��λ
        .mode(mode),    // ���� ģʽ��0-ֹͣ��2-ǰ����1-���ˣ�4-��ת��3-��ת��
        .pwm(pwm),     // ���� PWMֵ��0-255��Χ��
        .motor_A_PWM(motor_A_PWM),  // ���A��PWM�����ź����
        .motor_A_IN1(motor_A_IN1),  // ���A��IN1�����ź����
        .motor_A_IN2(motor_A_IN2),  // ���A��IN2�����ź����
        .motor_B_PWM(motor_B_PWM),  // ���B��PWM�����ź����
        .motor_B_IN1(motor_B_IN1),  // ���B��IN1�����ź����
        .motor_B_IN2(motor_B_IN2),  // ���B��IN2�����ź����
        .motor_C_PWM(motor_C_PWM),  // ���C��PWM�����ź����
        .motor_C_IN1(motor_C_IN1),  // ���C��IN1�����ź����
        .motor_C_IN2(motor_C_IN2),  // ���C��IN2�����ź����
        .motor_D_PWM(motor_D_PWM),  // ���D��PWM�����ź����
        .motor_D_IN1(motor_D_IN1),  // ���D��IN1�����ź����
        .motor_D_IN2(motor_D_IN2)   // ���D��IN2�����ź����
      );
/************************���Ŀ��ƴ���*********************************/   
//��ֵģ��
    always @(posedge clk) begin
      begin
       data<=datarece;//reg��ֵ
       distance_reg<=distance;//reg��ֵ
       light_reg<=Light;
       pwm<=128;//Ĭ��pwm���ֵ
       if(mode==0)pwm<=0;//����ָֹͣ��ʱpwm��0
      end
    end
//����ģ��
    always@(posedge clk)begin
    //����data��ֵ��ѡ��ͬ��ģʽ
    //����ģʽ
       if(data==8'b11111110) begin
            ledout<=4'b0001;//��һ��LED
             Mode_Control<=0;//ң��ģʽ��־������
            if (distance_reg <= DISTANCE_THRESHOLD) begin//�������С����ֵ
                   mode<=1;//
            end else begin//������������ֵ
                   mode<=0;//
                   end
            end
     //Ѱ��ģʽ    
       else if(data==8'b11111000) begin
            ledout<=4'b0011;//������LED
             Mode_Control<=0;//ң��ģʽ��־������
            if((track[1]==1'b1)&&(track[2]==1'b1))//δѰ�����ߣ�����ֱ��ǰ��
                mode<=2;//ֱ��T16
            else if((track[1]==1'b0)&&(track[2]==1'b1))//�󴫸�Ѱ�����ߣ��Ҵ���δѰ�������ֶ�
                mode<=4;//��ת
            else if((track[1]==1'b1)&&(track[2]==1'b0))//�Ҵ���Ѱ�����ߣ��Ҵ���δѰ�������ֶ�
                mode<=3;//��ת
               else mode<=0;//�������ߣ�����Ҫ��ֹͣ����
            end
       //ң��ģʽ     
       else if(data==8'b11100000) begin
            ledout<=4'b0111;//������LED
            mode<=0;//Ĭ��״ֹ̬ͣ
            Mode_Control<=1;//ң��ģʽ��־���ø�
            end
       //Ѱ��ģʽ 
       else if(data==8'b10000000) begin
            ledout<=4'b1111;//���ĸ�LED
            Mode_Control<=0;//ң��ģʽ��־���ø�
            if((Light[1]==1'b1)&&(Light[0]==1'b1))//ͬʱ��Ӧ����
                mode<=2;//ֱ��
            else if((Light[1]==1'b1)&&(Light[0]==1'b0))//��߸�Ӧ�����ߣ��ұ�û�и�Ӧ������
                mode<=4;//��ת
            else if((Light[1]==1'b0)&&(Light[0]==1'b1))//�ұ߸�Ӧ�����ߣ����û�и�Ӧ������
                mode<=3;//��ת
               else mode<=0;//��û�и�Ӧ�����ߣ�ֹͣ����
            end          
       //�����źţ����ĸ�LED����ִ������
       else ledout<=4'b1111;
    //����ң��ָ��
   if(Mode_Control==1)//���ң��ģʽ��־���ø�
   begin
      if(signal==5'b0000)//ֹͣ
         mode<=0;
      if(signal==5'b0001)//ǰ��
      
         mode<=2;
      if(signal==5'b0010)//����
         mode<=1;
      if(signal==5'b0100)//��ת
         mode<=3;
      if(signal==5'b1000)//��ת
         mode<=4;
    end
    end

ila_0 your_instance_name (
	.clk(clk), // input wire clk


	.probe0(data) // input wire [7:0] probe0
);

endmodule
