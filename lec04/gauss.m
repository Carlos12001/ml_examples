1;

function y=N1(x,mu=0,sigma=1)
  y=1/sqrt(2*pi)/sigma*exp(-0.5*((x-mu)/sigma).^2);
endfunction

x=-4:0.1:6;
figure(1,"name","Univariada");
hold off;
plot(x,N1(x,1),'r','linewidth',2);
hold on;
plot(x,N1(x,1,2),'g','linewidth',2);
plot(x,N1(x,1,0.5),'b','linewidth',2);
grid;
xlabel('x')
ylabel('N(x;\mu,\sigma)')

legend('\sigma=1','\sigma=2','\sigma=1/2')

set(gca,'xtick',[-4:1:6]);

# Case 2D

Sigma=[2 0.5; 0.5 1];
Mu=[1;1];

function y=N2(x,Mu=[0;0],Sigma=eye(2))
  detS=det(Sigma);
  f=sqrt(1/(detS*(2*pi)^2));
  iS=inv(Sigma);
  v=x-(Mu*ones(1,columns(x)));
  y=f*exp(-0.5*(dot(v,iS*v,1)));
endfunction


figure(2,"name","Bivariada");
[XX,YY]=meshgrid(x,x);
D=[XX(:),YY(:)]';
y=N2(D,Mu,Sigma);
surf(XX,YY,reshape(y,size(XX)));
daspect ([1 1 0.05]);

xlabel('x_1')
ylabel('x_2')
zlabel('y')



figure(3,"name","Contornos de bivariada");
contour3(XX,YY,reshape(y,size(XX)));
daspect ([1 1 0.05]);
xlabel('x_1')
ylabel('x_2')
zlabel('y')
view(0,90);
