module xiaoche_avoidance(
    input wire clk,
    input wire reset,
    input wire Echo,
    output wire [3:0] led,
    output wire motor_A_PWM,
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

    reg [15:0] distance_reg;
    reg [8:0] pwm;
    juli_detect u0(
        .clk(clk),
        .reset(reset),
        .Echo(Echo),
        .distance(distance_reg)
    );

    localparam DISTANCE_THRESHOLD = 100; 

    reg [3:0]mode;


    always @(posedge clk) 
    begin
          pwm<=255;  
    end
    always @(posedge clk) begin
        if (reset) begin
            mode <= 0;
        end else begin
            if (distance_reg <= DISTANCE_THRESHOLD) begin
                   mode<=3;
            end else begin
                   mode<=1;
            end
        end
    end


endmodule
