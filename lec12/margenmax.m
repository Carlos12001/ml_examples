#!/usr/bin/octave

## Copyright (C) 2020 Pablo Alvarado
## EL5852 Introducción al Reconocimiento de Patrones
## Escuela de Ingeniería Electrónica
## Tecnológico de Costa Rica

## Create some random separable data

N=20;

## Rotate them by 60 degrees
theta=deg2rad(60);
R=[cos(theta) sin(theta);-sin(theta) cos(theta)];
t=[1.5 1.6];

Xp = [rand(N,1)*4-2  rand(N,1)+0.5]*R' + t; # Right points
Xm = [rand(N,1)*4-2 -rand(N,1)-0.5]*R' + t; # Left points

X = [Xp;Xm];
Y = [ones(N,1);-ones(N,1)]; # 1 for right, -1 for left


do

  ## Plot the data
  plot(Xp(:,1),Xp(:,2),"o","markersize",10,"markerfacecolor",[0.5,0,0],"markeredgecolor",[0.25,0,0]);
  plot(Xm(:,1),Xm(:,2),"s","markersize",8,"markerfacecolor",[0,0.5,0],"markeredgecolor",[0,0.25,0]);

  daspect([1,1,1]);
  axis([-1,4,-1,4]);
  
  fflush(stdout);
  drawnow();
  
  [x,y,buttons] = ginput(1)

  n = sqrt(x^2+y^2)
  w = [x;y]/n;

  hold off;
  plot([0,x],[0,y],"b");
  hold on;
  
  plot([0,w(1)],[0,w(2)],"b","linewidth",3);
  
  ## Find the closest point of each class to the line
  dip = Xp*w;
  [mindp,idp]=min(dip);
  pp = Xp(idp,:);
  plot(pp(1),pp(2),"o","markersize",20,"markerfacecolor",[1,1,0],"markeredgecolor",[1,1,0.5]);



  dim = Xm*w;
  [maxdm,idm]=max(dim);
  pm = Xm(idm,:);
  plot(pm(1),pm(2),"o","markersize",20,"markerfacecolor",[1,1,0],"markeredgecolor",[1,1,0.5]);

  ## Distance between the closest positive and the line
  dp = pp*w - n
  qp = pp - dp*w';  ## Closest point in the line 
  plot([pp(1) qp(1)],[pp(2) qp(2)],"color",[0.5,0.5,0.5]);
  plot(qp(1),qp(2),"o","markersize",6,"markerfacecolor",[0.75,0.5,0.5],"markeredgecolor",[0.5,0.5,0.5]);

  ## Distance between the closest negative and the line
  dm = n - pm*w
  qm = pm + dm*w'; ## Closest point in the line 
  plot([pm(1) qm(1)],[pm(2) qm(2)],"color",[0.5,0.5,0.5]);
  plot(qm(1),qm(2),"o","markersize",6,"markerfacecolor",[0.5,0.75,0.5],"markeredgecolor",[0.5,0.5,0.5]);

  ## Calculate color
  valid=0;
  if ( (dp>0) && (dm>0) )
    margincolor=[0,0.7,0];
    valid=1;

    geometric_margin = min(dp,dm);
    functional_margin = geometric_margin/n;

    printf("Geometric margin: %f\n",geometric_margin);
    printf("Functional margin: %f\n",functional_margin);

  else
    margincolor=[0.7,0,0];
    valid=0;
  endif

  
  if (abs(x)>=abs(y))
    b=n/w(1);
    m=-w(2)/w(1);

    plot([-m+b,m*4+b],[-1,4],"linewidth",3,"color",margincolor);

    if (valid)
      bp=(pp*w)/w(1);
      bm=(pm*w)/w(1);

      fill([-m+bp,m*4+bp,m*4+bm,-m+bm],[-1,4,4,-1],[1,1,0.95]);
      
      plot([-m+bp,m*4+bp],[-1,4],"linewidth",2,"color",[1 0.75 0.75]);
      plot([-m+bm,m*4+bm],[-1,4],"linewidth",2,"color",[0.75 1 0.75]);

      b2=(bm+bp)/2;
      plot([-m+b2,m*4+b2],[-1,4],"linewidth",1,"color",[0.5 0.5 0.5]);
      
    endif

  else
    b=n/w(2);
    m=-w(1)/w(2);

    plot([-1,4],[-m+b,m*4+b],"g","linewidth",3,"color",margincolor);

    if (valid)
      bp=(pp*w)/w(2);
      bm=(pm*w)/w(2);

      fill([-1,4,4,-1],[-m+bp,m*4+bp,m*4+bm,-m+bm],[1,1,0.95]);
      
      plot([-1,4],[-m+bp,m*4+bp],"g","linewidth",3,"color",[1 0.75 0.75]);     
      plot([-1,4],[-m+bm,m*4+bm],"g","linewidth",3,"color",[0.75 1 0.75]);

      b2=(bm+bp)/2;
      plot([-1,4],[-m+b2,m*4+b2],"g","linewidth",1,"color",[0.5 0.5 0.5]);


    endif
    
  endif
  
until (buttons==3);
