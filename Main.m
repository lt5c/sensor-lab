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

%���ɼ��ٶȾ���.
%u=generateAccelerationData(N); 
u=dlmread('data.txt');

%������ʵ·��
real_pos=getRealPosition(u,N,t);

%�������� 
w=0.01*randn(4,N); 

%����(�й���������)״̬ת��
for k=2:N
x(:,k)=a*x(:,k-1)+b*u(:,k)+w(:,k-1);
end

%�۲�����
v=randn(2,N);

%����(�й۲�������)�۲�ֵ
d=getTOADistance(X,real_pos,v,N);
%d=getNoErrorTOA(X,real_pos,v,N);

Xa=X(1,1); Ya=X(2,1);
Xb=X(1,2); Yb=X(2,2);
%����h
h=[(Xa+Xb)*(-2),(Ya+Yb)*(-2),0,0];

%����y
%y=(dA^2-dB^2)-Xa^2-Ya^2+Xb^2+Yb^2
dD=d(1,:).^2-d(2,:).^2;
real_dD=d(3,:).^2-d(4,:).^2;
y=dD-Xa.^2-Ya.^2+Xb.^2+Yb.^2;

%����������Э����
%Rww=[1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1]; 
%Rww=[0,0,0,0;0,0,0,0;0,0,0,0;0,0,0,0]; 
Rww=cov(w.');
%�۲�������Э����
Rvv=cov(dD-real_dD);  


%����ֵ
p(:,:,1)=[0,0,0,0;
   		  0,0,0,0;
  		  0,0,0,0;
  		  0,0,0,0];
s(:,1)=[0;0;0;0];
%��ʼѭ��,ִ��5��ʽ��
for k=2:N;
ss(:,k)=a*s(:,k-1)+b*u(:,k);
pp(:,:,k)=a*p(:,:,k-1)*a.'+Rww;
Kg(:,k)=(pp(:,:,k)*h.')/(h*pp(:,:,k)*h.'+Rvv);
s(:,k)=ss(:,k)+Kg(:,k)*(y(k)-h*ss(:,k));
p(:,:,k)=(eye(4)-Kg(:,k)*h)*pp(:,:,k);
end
plot(real_pos(1,:),real_pos(2,:),'r',s(1,:),s(2,:),'b',x(1,:),x(2,:),'g')
