%获取两个观察值dA,dB,已经加上观察误差
function [d] = getNoErrorTOA(X,y,v,N)
Xa=X(1,1);
Ya=X(2,1);
Xb=X(1,2);
Yb=X(2,2);
for i=1:N
    d(1,i)= sqrt((Xa-y(1,i))^2+(Ya-y(2,i))^2);
    d(2,i)= sqrt((Xb-y(1,i))^2+(Yb-y(2,i))^2);
end
