function [] = Main(X)

N=2000;
t=0.1;

x(:,1)=[0;0;0;0];
a=[1,0,t,0;
   0,1,0,t;
   0,0,1,0;
   0,0,0,1];
b=[0.5*t.^2,   0;
       0   , 0.5*t.^2;
	   t   ,   0;
	   0   ,   t];

%生成加速度矩阵.
%u=generateAccelerationData(N); 
u=dlmread('data.txt');

%计算真实路径
real_pos=getRealPosition(u,N,t);

%过程噪声 
w=0.01*randn(4,N); 

%计算(有过程噪声的)状态转换
for k=2:N
x(:,k)=a*x(:,k-1)+b*u(:,k)+w(:,k-1);
end

%观察噪声
v=randn(2,N);

%计算(有观察噪声的)观察值
d=getTOADistance(X,real_pos,v,N);
%d=getNoErrorTOA(X,real_pos,v,N);

Xa=X(1,1); Ya=X(2,1);
Xb=X(1,2); Yb=X(2,2);
%计算h
h=[(Xa+Xb)*(-2),(Ya+Yb)*(-2),0,0];

%计算y
%y=(dA^2-dB^2)-Xa^2-Ya^2+Xb^2+Yb^2
dD=d(1,:).^2-d(2,:).^2;
real_dD=d(3,:).^2-d(4,:).^2;
y=dD-Xa.^2-Ya.^2+Xb.^2+Yb.^2;

%过程噪声的协方差
%Rww=[1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1]; 
%Rww=[0,0,0,0;0,0,0,0;0,0,0,0;0,0,0,0]; 
Rww=cov(w.');
%观察噪声的协方差
Rvv=cov(dD-real_dD);  


%赋初值
p(:,:,1)=[0,0,0,0;
   		  0,0,0,0;
  		  0,0,0,0;
  		  0,0,0,0];
s(:,1)=[0;0;0;0];
%开始循环,执行5个式子
for k=2:N;
ss(:,k)=a*s(:,k-1)+b*u(:,k);
pp(:,:,k)=a*p(:,:,k-1)*a.'+Rww;
Kg(:,k)=(pp(:,:,k)*h.')/(h*pp(:,:,k)*h.'+Rvv);
s(:,k)=ss(:,k)+Kg(:,k)*(y(k)-h*ss(:,k));
p(:,:,k)=(eye(4)-Kg(:,k)*h)*pp(:,:,k);
end
plot(real_pos(1,:),real_pos(2,:),'r',s(1,:),s(2,:),'b',x(1,:),x(2,:),'g')
