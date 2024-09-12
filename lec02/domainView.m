#!/usr/bin/octave-cli --persist

## (C) 2021 Pablo Alvarado
## EL5857 Aprendizaje Automático
## Escuela de Ingeniería Electrónica
## Tecnológico de Costa Rica

## --------------------------------------------------------------------
## Interactive mode, showing the contours and the corresponding LR line
##
## Implementation of J for the particular 1D case
## --------------------------------------------------------------------

## Data stored each sample in a row, where the last row is the label
D=load("escazu.dat");

## Rescue for now just the area and price columns
A=[D(:,1) D(:,4)];

## Objective function of the parameters theta, requires also the data A
## First create a matrix without the square, where the j-column has
## theta_0 + theta_1*x_1^(j)-y^(j).  Then, square all elements of that matrix
## and finally add up all elements in each row
function res=J(theta,A)
  res=0.5*sum((theta(:,1)*ones(1,rows(A)) +
               theta(:,2)*A(:,1)' -
               ones(rows(theta),1)*A(:,2)').^2,2);
endfunction;

th0=-300:10:600;
th1=-0.5:0.005:2;

[tt0,tt1] = meshgrid(th0,th1);

theta=[tt0(:) tt1(:)];
jj=reshape(J(theta,A),size(tt0));

## plot the contours in 2D

figure(1,"name","Curvas de nivel");
hold off;

levels= 4.11e+4*(1.3.^[-3:1:20]);

figure(1);
hold off;

contour(tt0,tt1,jj,levels);
xlabel('{\theta_0}');
ylabel('{\theta_1}');

while(1)
  hold on;
 
  printf("Haga click en contornos para ver línea correspondiente\n");
  fflush(stdout);

  figure(1);
  [x,y,buttons] = ginput(1);
  t=[x,y];

  hold off;
  
  contour(tt0,tt1,jj,levels);
  
  xlabel('{\theta_0}');
  ylabel('{\theta_1}');

  hold on;
  printf("  Error @ J(%g,%g)=%g\n",x,y,J(t,A));

  fflush(stdout);

  plot([x],[y],"*r");

  figure(2,"name","Regresión lineal");
  hold off;
  plot(A(:,1),A(:,2),"*b");
  hold on;
  xx=80:100:620;
  yy=x+y*xx;
  plot(xx,yy,'k',"linewidth",3);

  axis([80,620,180,820]);
endwhile;


