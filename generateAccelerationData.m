%生成加速度矩阵
function [a] = generateAccelerationData(N)
x=0;
y=0;
for i=1:N
    x=(rand-0.5)*0.5;
    y=(rand-0.5)*0.5;
    a(:,i)=[x;y];
end