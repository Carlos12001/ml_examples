#!/usr/bin/octave-cli --persist

## (C) 2020 Pablo Alvarado
## EL5852 Introducción al Reconocimiento de Patrones
## Escuela de Ingeniería Electrónica
## Tecnológico de Costa Rica

## --------------------------------------------------------------------
## Polynomial regression
##
## WITH NORMALIZATION AND DATA CENTERING
##
## Implementation of J and gradJ for the general linear case
## --------------------------------------------------------------------

pkg load optim;

% Evaluate the hypothesis with all x given
function y=evalhyp(x,theta)
  XX=bsxfun(@power,x,0:length(theta)-1);
  y=XX*theta;
endfunction;

function theta=regress(D,O)
  # Construct the design matrix with the original data
  Xo=bsxfun(@power,D(:,1),(0:O));

  # The outputs vector with the original data
  Yo=D(:,4);

  # Normal equations
  theta=pinv(Xo)*Yo;
endfunction;

# Data stored each sample in a row, where the last row is the label
D=load("escazu.dat");

## Limits for plot of regressed lines
minArea = min(D(:,1));
maxArea = max(D(:,1));
minPrice= min(D(:,4));
maxPrice= max(D(:,4));

areas=linspace(minArea,maxArea,250)';

figure(1,"name","Regression on raw data");
hold off;
plot(D(:,1),D(:,4),"ob","markersize",10,"markerfacecolor",[1,0.7,0.1]); ## Original data points
hold on;

plot(areas,evalhyp(areas,regress(D,1)),'k;n=1;','linewidth',3);
plot(areas,evalhyp(areas,regress(D,3)),'g;n=3;','linewidth',3);
plot(areas,evalhyp(areas,regress(D,5)),'r;n=5;','linewidth',3);
plot(areas,evalhyp(areas,regress(D,9)),'b;n=9;','linewidth',3);

axis([minArea maxArea minPrice maxPrice]);  
xlabel('{x_1=area}');
ylabel("precio");
grid
