clc;clear;close all;

sine_div = 4096;
sine_maxv = hex2dec("7FFFFFFF");

result = zeros(sine_div, 1);

i = 1;
for theta = 0:(2*pi/sine_div):2*pi
    result(i) = sin(theta) * sine_maxv;
    i = i + 1;
end

% 取整,顺便截掉多出来的数字
result = round(result(1:sine_div));

% 画图
% plot(result);
% % stem(result);
% axis([0, sine_div - 1, -sine_maxv, sine_maxv]);

% signed 转 unsigned
for i = 1:sine_div
    if result(i) < 0
%         result(i) = sine_maxv + 1 - result(i); % 转换为原码
        result(i) = 2 * sine_maxv + 1 + result(i); % 转换为原码
    end
end

plot(result);
% axis([0, sine_div - 1, -sine_maxv, sine_maxv]);

% 保存到文件
write_file = fopen('sine_data.mif', 'w');
for i = 1:sine_div
    fprintf(write_file, "%08X\n", result(i));
end
fclose(write_file);


