# -FPGA-Multifunctional-car-based-on-FPGA
基于FPGA的多功能小车 1、通过多传感器的数据融合可以实现智能小车的红外避障、循迹、寻光、红外遥控、无线蓝牙、超声波测距与避障的功能。整个系统可以分为FPGA控制模块、电机驱动模块、传感器检测模块、数码管显示模块。 实验中需要通过FPGA来控制两个直流电机的正反转，从而实现两个轮子的转向和转速。由于FPGA引脚的驱动能力很弱不能直接驱动电机.所以需要电机的驱动电路。驱动电路不仅有提升驱动能力的作用，还起到隔离保护的作用。 传感器检测模块包括:红外避障和循迹模块、寻光模块、红外遥控模块、无线蓝牙模块、超声波测距与避障模块。 用数字来显示智能小车当前处于何种模式，如1代表循迹功能等最后，将各个单元模块逐级连接起来,实现系统功能。 

设计总览：

![5746a402b43a4049a716149b60987012](https://github.com/kianakaslanna/-FPGA-Multifunctional-car-based-on-FPGA/assets/90885688/53100097-f74e-4fd0-ad97-a7608d7df9ab)

使用元器件：

![QQ截图20240517152202](https://github.com/kianakaslanna/-FPGA-Multifunctional-car-based-on-FPGA/assets/90885688/6ca75d0d-c958-4197-9ddf-016ee2b4a806)

编程平台：Vivado2018.3、Arduino IDE、OpenMV IDE、立创EDA

sim.v为仿真文件，TOP.xdc为约束文件，其他.v文件为资源文件。

代码仅供参考，具体结构如下：

![图片1](https://github.com/kianakaslanna/-FPGA-Multifunctional-car-based-on-FPGA/assets/90885688/737e2ffa-89da-4a3d-948d-be2b39119269)
