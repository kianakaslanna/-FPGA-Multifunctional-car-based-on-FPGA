module PWM_Divider (
  input wire clk,        // 系统时钟输入
  input wire reset,      // 复位按键输入
  input wire [7:0] duty, // 占空比输入（0-255范围）
  output reg pwm         // PWM输出
);

  reg [7:0] counter;

  always @(posedge clk or posedge reset) begin
    if (reset)
      counter <= 0;
    else if (counter >= 255)
      counter <= 0;
    else
      counter <= counter + 1;
  end

  always @(posedge clk) begin
    if (reset)
      pwm <= 0;
    else if (counter < duty)
      pwm <= 1;
    else
      pwm <= 0;
  end

endmodule
