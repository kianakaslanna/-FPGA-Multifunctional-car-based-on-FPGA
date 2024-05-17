module PWM_Divider (
  input wire clk,        // ϵͳʱ������
  input wire reset,      // ��λ��������
  input wire [7:0] duty, // ռ�ձ����루0-255��Χ��
  output reg pwm         // PWM���
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
