%通过加速度矩阵,获取真实路径
function [y] = getRealPositio(a,N,t)
y(:,1)=[0;0];
x=[0;0];
v=[0;0];
dt=[t,0;0,t];
for i=1:N
    x=x+dt*v+0.5*(dt.^2)*a(:,i);
    y(:,i)=x;
    v=v+dt*a(:,i);
end

    
