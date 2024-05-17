module Four_Wheel_Control (
  input wire clk,           // ϵͳʱ������
  input wire reset,         // ��λ��������
  input wire [4:0] mode,    // �˶�ģʽ���루0-ֹͣ��1-ǰ����2-���ˣ�3-��ת��4-��ת��
  input wire [7:0] pwm,     // PWMֵ���루0-255��Χ��
  output wire motor_A_PWM,  // ���A��PWM�����ź����
  output wire motor_A_IN1,  // ���A��IN1�����ź����
  output wire motor_A_IN2,  // ���A��IN2�����ź����
  output wire motor_B_PWM,  // ���B��PWM�����ź����
  output wire motor_B_IN1,  // ���B��IN1�����ź����
  output wire motor_B_IN2,  // ���B��IN2�����ź����
  output wire motor_C_PWM,  // ���C��PWM�����ź����
  output wire motor_C_IN1,  // ���C��IN1�����ź����
  output wire motor_C_IN2,  // ���C��IN2�����ź����
  output wire motor_D_PWM,  // ���D��PWM�����ź����
  output wire motor_D_IN1,  // ���D��IN1�����ź����
  output wire motor_D_IN2   // ���D��IN2�����ź����
);

  wire direction_A, direction_B, direction_C, direction_D;

  // ��������߼�
  assign direction_A = (mode == 1 || mode == 3) ? 0 : 1;  // ǰ������תΪ��������Ϊ����
  assign direction_B = (mode == 1 || mode == 3) ? 0 : 1;
  assign direction_C = (mode == 1 || mode == 4) ? 0 : 1;  // ǰ������תΪ��������Ϊ����
  assign direction_D = (mode == 1 || mode == 4) ? 0 : 1;

  // ʵ����PWM��Ƶģ��
  PWM_Divider pwm_A_divider (
    .clk(clk),
    .reset(reset),
    .duty(pwm),
    .pwm(motor_A_PWM)
  );

  PWM_Divider pwm_B_divider (
    .clk(clk),
    .reset(reset),
    .duty(pwm),
    .pwm(motor_B_PWM)
  );

  PWM_Divider pwm_C_divider (
    .clk(clk),
    .reset(reset),
    .duty(pwm),
    .pwm(motor_C_PWM)
  );

  PWM_Divider pwm_D_divider (
    .clk(clk),
    .reset(reset),
    .duty(pwm),
    .pwm(motor_D_PWM)
  );

  // �����������ת���ź�
  assign motor_A_IN1 = direction_A;
  assign motor_A_IN2 = ~direction_A;
  assign motor_B_IN1 = direction_B;
  assign motor_B_IN2 = ~direction_B;
  assign motor_C_IN1 = direction_C;
  assign motor_C_IN2 = ~direction_C;
  assign motor_D_IN1 = direction_D;
  assign motor_D_IN2 = ~direction_D;

endmodule