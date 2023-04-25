clc;clear;close all;
cic = dsp.CICInterpolator(8, 1, 2); % 创建CIC Interpolator对象
% 第一个参数 2 表示插值因子（InterpolationFactor）被设置为 2。
% 第二个参数 1 表示滤波器组合部分的差分延迟（DifferentialDelay）被设置为 1。
% 第三个参数 2 表示积分器和组合部分的数量（NumSections）被设置为 2。


% 指定输入数据类型为定点数，具有 16 位字长和 15 位小数位数
% CIC = dsp.CICInterpolator;
% CIC.FullPrecisionOverride = false;
% CIC.OutputWordLength = 16;
% CIC.OutputFracLength = 15;


% cic.InputDataType = numerictype()


nt = numerictype(1, 32, 31);
generatehdl(cic, ...
    "InputDataType", nt, ...
    "TargetLanguage", "Verilog", ...
    'Name', 'CIC_Interpolator8', ...
    'TargetDirectory', 'CIC_Interpolator8', ...
    "GenerateHDLTestbench", 'on'); % 生成HDL代码



