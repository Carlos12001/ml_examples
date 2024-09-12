#!/usr/bin/octave

## (C) 2021 Pablo Alvarado
## EL5857 Aprendizaje Automático
## Escuela de Ingeniería Electrónica
## Tecnológico de Costa Rica

clear ; close all ; clc;
pkg load optim;

figure(1,"name","Superficie de error");

## We will be using the octave peaks function (lots of local extrema)
peaks;
hold on

figure(2,"name","Curvas de nivel");
[xx,yy,zz]=peaks();
contour(xx,yy,zz);
hold on

figure(3,"name","Error por iteración");

## Set here a learning rate
learningRate = 0.05
eps = 0.1

f = @(x) [3*(1-x(1))^2*exp(-x(1)^2 - (x(2)+1)^2) - 10*(x(1)/5 - x(1)^3 - x(2)^5)*exp(-x(1)^2-x(2)^2) - 1/3*exp(-(x(1)+1)^2 - x(2)^2)];


while(1)

  printf("\n\nHaga click en curvas de nivel para iniciar\n");
  fflush(stdout);

  figure(2);
  
  [x_init,y_init,buttons] = ginput(1);
  pos = [x_init y_init];
  plotoffset = 0.3; ## Raise the plot a little bit for the line to be
                    ## visible
  z = f(pos) + plotoffset;

  plot([x_init],[y_init],"*r");

  printf("Iniciando en (%g,%g)=%g\n",x_init,y_init,z-plotoffset);
  fflush(stdout);

  i = 0;
  J=[];
  it=[];

  figure 3
  hold off;
  
  figure 1
  while (i <= 100)

    ## 
    it=[it i];
    J =[J f(pos)];
    
    figure(3);
    plot(it,J,"ok","markerfacecolor","blue");
    hold on;
    plot(it,J,"b","linewidth",2);
    drawnow();
    
    figure(1);
    plot3(pos(1),pos(2),z,"r+","linewidth",5,"markersize",5);

    grad = jacobs(pos, f);
    fprintf('%i. grad([%f %f])=[%f %f]\n',i+1,pos(1),pos(2),grad(1),grad(2));
    
    npos = pos - learningRate * grad;
    newz = f(npos) + plotoffset;

    plot3([pos(1) npos(1)],
          [pos(2) npos(2)],
          [z newz],"k-","linewidth",5);

    figure(2);
    plot([pos(1) npos(1)],[pos(2) npos(2)],"k-");
    plot([npos(1)],[npos(2)],"or");
    
    mgrad=norm(grad);
    if (mgrad<0.05)
      fprintf("\n Fin \n Presione una tecla para reiniciar \n");
      pause();
      break;
    endif
    
    pos = npos;
    z=newz;

    fflush(stdout);
    b = waitforbuttonpress ();
    i=i+1;
  endwhile;
endwhile;
