#!/usr/bin/octave-cli

1;

pkg load statistics;
graphics_toolkit("gnuplot"); # Without this no contour is saved!

# Parámetros de primera distribución
mu1=[0.7 0.7];

# Se=le => SE=EL => S=ELE'
e1=[sqrt(3)/2,1/2];
e2=[-e1(2),e1(1)];
E=[e1;e2]';
Sigma1=E*diag([0.1,0.01])*E';

# Parámetros de segunda distribución
mu2=[0,-0.1];

e1=[-sqrt(3)/2,1/2];
e2=[-e1(2),e1(1)];
E=[e1;e2]';
Sigma2=E*diag([0.02,0.04])*E';

# Parámetros de tercera distribución
mu3=[0.8,0.2];

e1=[1,0];
e2=[-e1(2),e1(1)];
E=[e1;e2]';
Sigma3=E*diag([0.05,0.005])*E';

N=100;
P1=mvnrnd(mu1,Sigma1,N);
P2=mvnrnd(mu2,Sigma2,N);
P3=mvnrnd(mu3,Sigma3,N);

P=[P1;P2;P3];

hold off;
plot(P(:,1),P(:,2),'xb');
axis([-0.5 1.5 -0.5 1.5]);
daspect([1,1,1])
grid;

print(gcf(),"gmm_dots_.pdf","-dpdf");

hold off;
plot(P1(:,1),P1(:,2),'s',"color",[0.5,0.0,0]);
hold on;
plot(P2(:,1),P2(:,2),'<',"color",[0,0.5,0]);
plot(P3(:,1),P3(:,2),'o',"color",[0,0,0.5]);

[X,Y]=meshgrid(-0.5:0.01:1.5, -0.5:0.01:1.5);
g1=reshape(0.333*mvnpdf([X(:) Y(:)],mu1,Sigma1),size(X));
contour(X,Y,g1,'r');

g2=reshape(0.333*mvnpdf([X(:) Y(:)],mu2,Sigma2),size(X));
contour(X,Y,g2,'g');

g3=reshape(0.333*mvnpdf([X(:) Y(:)],mu3,Sigma3),size(X));
contour(X,Y,g3,'b');

axis([-0.5 1.5 -0.5 1.5]);
daspect([1,1,1])
grid;

print(gcf(),"gmm_zi_.pdf","-dpdf");
