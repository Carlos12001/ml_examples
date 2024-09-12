#!/usr/bin/octave-cli --persist

## (C) 2021 Pablo Alvarado
## EL5857 Aprendizaje Automático
## Escuela de Ingeniería Electrónica
## Tecnológico de Costa Rica

## Show why the normalization is necessary by means of a strongly 
## correlated surface 

close all;
%% For the surface
global xx yy;
x=-1:0.01:1;
[xx,yy]=meshgrid(x,x);

%% For quiver
qxt=-1:0.1:1;
global qx qy;
[qx,qy]=meshgrid(qxt,qxt);

global azimuth   = -37.500;
global elevation =  30;

%% Callback function called by slider event
%% Also in file myplot.m (i.e. a subfunction)
function plotstuff (h, event)
  global xx yy;
  n = get (h, 'value')/1000;
  hold off;
  %% Compute covariance matrix (changing with the slider)
  M=[n 0;0 1];
  angle=0;
  ca=cos(deg2rad(angle));
  sa=sin(deg2rad(angle));
  R=[ca sa;-sa ca];
  
  S=pinv(R*M*R');
  
  %% Compute the error function J
  xy=[xx(:) yy(:)]';  
  zz = reshape( sum(xy .* (S*xy),1) , size(xx) );
  
  %% rescue current view
  global azimuth elevation;
  [azimuth,elevation]=view();
  
  contour3(xx,yy,zz,[0:0.25:4],"linewidth",3);
  hold on;
  
  %% Compute the gradient vectors for quiver
  global qx qy;
  qxy=[qx(:) qy(:)]';
  grad = -2*S*qxy;
  qz = reshape(sum(qxy .* (S*qxy),1) , size(qx) );
  u = reshape(grad(1,:),size(qx));
  v = reshape(grad(2,:),size(qx));
  quiver(qx,qy,u,v);
  %%w = reshape(-(sum(grad.^2,1)) , size(qx) );
  %%quiver3(qx,qy,qz,u,v,w);

  axis([-1 1 -1 1 0 4]);
  xlabel('w_1');
  ylabel('w_2');
  zlabel('J(w_1,w_2)');
  view(azimuth,elevation);
  daspect([1,1,4]);
  set(gca, 'cameraviewanglemode', 'manual');
  
end

%% Create initial figure and spiral plot
axes ('position', [0.1, 0.3, 0.8, 0.6]);

%% Add ui 'slider' element      
hslider = uicontrol (                        ...
           'style', 'slider',                ...
           'Units', 'normalized',            ...
           'position', [0.1, 0.1, 0.8, 0.1], ...
           'min', 1,                         ...
           'max', 1000,                      ...
           'value', 10,                      ...
           'callback', {@plotstuff}          ...
          );
          

figure(1,"name","Error function");
hold off;
view(azimuth,elevation);
plotstuff(hslider,""); %% Plot the first try
