module top_modlue(
    input clk,//系统时钟
    input reset,//复位按键
    input rx,//蓝牙接收
    input wire [3:0] signal,//红外信号
    input wire Echo,//超声波接收
    input [3:0] track,//寻迹
    input [1:0] Light,
    output wire Trig,//超声波触发
    output [3:0] led,//led
    output wire motor_A_PWM,//电机
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
/******************************模块使用的变量**************************************/
    wire [7:0] datarece;//蓝牙接收的信息
    reg [7:0] data;//蓝牙信号
    wire [15:0] distance;//超声波测得距离
    reg [15:0] distance_reg;//超声波测得距离
    reg [3:0] mode;//模式选择(避障 寻迹 遥控)
    reg [3:0] ledout;//led输出
    reg [7:0] pwm;//pwm输出值
    reg Mode_Control;//遥控模式标志符
    reg [3:0] signal_reg;//红外信号
    reg [3:0] track_reg;
    reg [1:0] light_reg;
    assign led=ledout;//led连线
    localparam DISTANCE_THRESHOLD = 200; //超声波避障阈值
/********************************调用模块****************************************/
    //蓝牙模块
    uar_control bluetooth(
    .clk(clk),//输入 时钟
    .reset(reset),//输入 复位
    .rx(rx),//输入 信息
    .LED(datarece)//输出 信息
    );
    //超声波测距
    juli_detect u0(
        .clk(clk),//输入 时钟
        .reset(reset),//输入 复位
        .Echo(Echo),//输入 触发
        .Trig(Trig),
        .distance(distance)//输出 距离
    );
    //电机控制
    Four_Wheel_Control (
        .clk(clk),           // 输入 时钟
        .reset(reset),         // 输入 复位
        .mode(mode),    // 输入 模式（0-停止，2-前进，1-后退，4-右转，3-左转）
        .pwm(pwm),     // 输入 PWM值（0-255范围）
        .motor_A_PWM(motor_A_PWM),  // 电机A的PWM控制信号输出
        .motor_A_IN1(motor_A_IN1),  // 电机A的IN1控制信号输出
        .motor_A_IN2(motor_A_IN2),  // 电机A的IN2控制信号输出
        .motor_B_PWM(motor_B_PWM),  // 电机B的PWM控制信号输出
        .motor_B_IN1(motor_B_IN1),  // 电机B的IN1控制信号输出
        .motor_B_IN2(motor_B_IN2),  // 电机B的IN2控制信号输出
        .motor_C_PWM(motor_C_PWM),  // 电机C的PWM控制信号输出
        .motor_C_IN1(motor_C_IN1),  // 电机C的IN1控制信号输出
        .motor_C_IN2(motor_C_IN2),  // 电机C的IN2控制信号输出
        .motor_D_PWM(motor_D_PWM),  // 电机D的PWM控制信号输出
        .motor_D_IN1(motor_D_IN1),  // 电机D的IN1控制信号输出
        .motor_D_IN2(motor_D_IN2)   // 电机D的IN2控制信号输出
      );
/************************核心控制代码*********************************/   
//赋值模块
    always @(posedge clk) begin
      begin
       data<=datarece;//reg赋值
       distance_reg<=distance;//reg赋值
       light_reg<=Light;
       pwm<=128;//默认pwm最大值
       if(mode==0)pwm<=0;//接收停止指令时pwm赋0
      end
    end
//控制模块
    always@(posedge clk)begin
    //根据data的值来选择不同的模式
    //避障模式
       if(data==8'b11111110) begin
            ledout<=4'b0001;//亮一个LED
             Mode_Control<=0;//遥控模式标志符清零
            if (distance_reg <= DISTANCE_THRESHOLD) begin//如果距离小于阈值
                   mode<=1;//
            end else begin//如果距离大于阈值
                   mode<=0;//
                   end
            end
     //寻迹模式    
       else if(data==8'b11111000) begin
            ledout<=4'b0011;//亮两个LED
             Mode_Control<=0;//遥控模式标志符清零
            if((track[1]==1'b1)&&(track[2]==1'b1))//未寻到黑线，俩轮直接前进
                mode<=2;//直行T16
            else if((track[1]==1'b0)&&(track[2]==1'b1))//左传感寻到黑线，右传感未寻到，右轮动
                mode<=4;//右转
            else if((track[1]==1'b1)&&(track[2]==1'b0))//右传感寻到黑线，右传感未寻到，左轮动
                mode<=3;//左转
               else mode<=0;//两个黑线，不符要求，停止运行
            end
       //遥控模式     
       else if(data==8'b11100000) begin
            ledout<=4'b0111;//亮三个LED
            mode<=0;//默认状态停止
            Mode_Control<=1;//遥控模式标志符置高
            end
       //寻光模式 
       else if(data==8'b10000000) begin
            ledout<=4'b1111;//亮四个LED
            Mode_Control<=0;//遥控模式标志符置高
            if((Light[1]==1'b1)&&(Light[0]==1'b1))//同时感应光线
                mode<=2;//直行
            else if((Light[1]==1'b1)&&(Light[0]==1'b0))//左边感应到光线，右边没有感应到光线
                mode<=4;//左转
            else if((Light[1]==1'b0)&&(Light[0]==1'b1))//右边感应到光线，左边没有感应到光线
                mode<=3;//右转
               else mode<=0;//都没有感应到光线，停止运行
            end          
       //其他信号，亮四个LED，不执行命令
       else ledout<=4'b1111;
    //红外遥控指令
   if(Mode_Control==1)//如果遥控模式标志符置高
   begin
      if(signal==5'b0000)//停止
         mode<=0;
      if(signal==5'b0001)//前进
      
         mode<=2;
      if(signal==5'b0010)//后退
         mode<=1;
      if(signal==5'b0100)//左转
         mode<=3;
      if(signal==5'b1000)//右转
         mode<=4;
    end
    end

ila_0 your_instance_name (
	.clk(clk), // input wire clk


	.probe0(data) // input wire [7:0] probe0
);

endmodule
