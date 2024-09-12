#!/usr/bin/octave-cli --persist

## (C) 2021 Pablo Alvarado
## EL5857 Aprendizaje Automático
## Escuela de Ingeniería Electrónica
## Tecnológico de Costa Rica

## --------------------------------------------------------------------
## Just show the objective function J(theta) in 3D and with 3D contours
## --------------------------------------------------------------------

## Data stored each sample in a row, where the last row is the label
D=load("escazu.dat");

## Rescue for now just the area and price columns
A=[D(:,1) D(:,4)];

## Objective function of the parameters theta, requires also the data A
## First create a matrix without the square, where the j-column has
## theta_0 + theta_1*x_1^(j)-y^(j).  Then, square all elements of that matrix
## and finally add up all elements in each row
J=@(theta) 0.5*sum((theta(:,1)*ones(1,rows(A)) +
                    theta(:,2)*A(:,1)' -
                    ones(rows(theta),1)*A(:,2)').^2,2);

th0=-200:10:400;
th1=0.0:0.05:2;

[tt0,tt1] = meshgrid(th0,th1);

theta=[tt0(:) tt1(:)];
jj=reshape(J(theta),size(tt0));

## Plot the error surface

figure(1,"name","Superficie de error");
hold off;
surf(tt0,tt1,jj);
xlabel('{\theta_0}');
ylabel('{\theta_1}');
zlabel('J({\bf \theta})');

## Plot the contours in 3D

figure(2,'name','Curvas de nivel');
levels= 4.11e+4*(1.3.^[0:1:15]);
contour3(tt0,tt1,jj,levels,"linewidth",3);
xlabel('{\theta_0}');
ylabel('{\theta_1}');
zlabel('J({\bf \theta})');

view(0,90);

