clc;clear;close all;


% 计算分频方案

f_in = 11.05926 * 1e6;
psc = 8;
sine_data_total = 4096;


f_samples = f_in / psc; % 采样



fprintf("晶振频率: %f MHz\n", f_in / 1e6);
fprintf("分频系数: %d\n", psc);
fprintf("sine模块输入时钟频率: %f KHz\n", f_samples / 1e3);
fprintf("sine模块一个周期保存的数据点数: %d\n", sine_data_total);

data = zeros(floor(sine_data_total / 3), 1);

for my_step = 1:(sine_data_total / 3)
    f_sine = f_samples / (sine_data_total / my_step);
    fprintf("Step = %d  ", my_step);
    fprintf("Sine_Freq = %.3f K\n", f_sine/1e3);
    data(my_step) = f_sine;
end

data = round(data);

% 生成freq2step代码
gencode = 1;
if(gencode)

    unitfreq = data(1);
    currfreq = 1.5 * unitfreq;
    fprintf("\n\nassign step = \n");
    for my_step = 1:(sine_data_total / 3)

        fprintf("freq < 16'd%5d ? 10'd%4d : \n", currfreq, my_step);

        currfreq = currfreq + unitfreq;
        if(currfreq > 65536 || my_step > 1023)
            break;
        end
    end

end

