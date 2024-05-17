module Four_Wheel_Control (
  input wire clk,           // 系统时钟输入
  input wire reset,         // 复位按键输入
  input wire [4:0] mode,    // 运动模式输入（0-停止，1-前进，2-后退，3-左转，4-右转）
  input wire [7:0] pwm,     // PWM值输入（0-255范围）
  output wire motor_A_PWM,  // 电机A的PWM控制信号输出
  output wire motor_A_IN1,  // 电机A的IN1控制信号输出
  output wire motor_A_IN2,  // 电机A的IN2控制信号输出
  output wire motor_B_PWM,  // 电机B的PWM控制信号输出
  output wire motor_B_IN1,  // 电机B的IN1控制信号输出
  output wire motor_B_IN2,  // 电机B的IN2控制信号输出
  output wire motor_C_PWM,  // 电机C的PWM控制信号输出
  output wire motor_C_IN1,  // 电机C的IN1控制信号输出
  output wire motor_C_IN2,  // 电机C的IN2控制信号输出
  output wire motor_D_PWM,  // 电机D的PWM控制信号输出
  output wire motor_D_IN1,  // 电机D的IN1控制信号输出
  output wire motor_D_IN2   // 电机D的IN2控制信号输出
);

  wire direction_A, direction_B, direction_C, direction_D;

  // 方向控制逻辑
  assign direction_A = (mode == 1 || mode == 3) ? 0 : 1;  // 前进和左转为正向，其他为反向
  assign direction_B = (mode == 1 || mode == 3) ? 0 : 1;
  assign direction_C = (mode == 1 || mode == 4) ? 0 : 1;  // 前进和右转为正向，其他为反向
  assign direction_D = (mode == 1 || mode == 4) ? 0 : 1;

  // 实例化PWM分频模块
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

  // 输出电机方向和转向信号
  assign motor_A_IN1 = direction_A;
  assign motor_A_IN2 = ~direction_A;
  assign motor_B_IN1 = direction_B;
  assign motor_B_IN2 = ~direction_B;
  assign motor_C_IN1 = direction_C;
  assign motor_C_IN2 = ~direction_C;
  assign motor_D_IN1 = direction_D;
  assign motor_D_IN2 = ~direction_D;

endmodule