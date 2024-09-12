#!/usr/bin/octave-cli --persist

## (C) 2021 Pablo Alvarado
## EL5857 Aprendizaje Automático
## Escuela de Ingeniería Electrónica
## Tecnológico de Costa Rica

## --------------------------------------------------------------------
## Linear Regression in interactive mode.
## Showsthe contours and the corresponding regressed line
##
## WITH NORMALIZATION AND DATA CENTERING
##
## Implementation of J and gradJ for the general linear case
## --------------------------------------------------------------------

pkg load optim;

## Data stored each sample in a row, where the last row is the label
D=load("escazu.dat");

## Construct the design matrix with a 1's column and the original area
Xo=[ones(rows(D),1),D(:,1)];

## normalizer_type="normal";
normalizer_type="minmax";

## Normalize the data
nx = normalizer(normalizer_type);
X = nx.fit_transform(Xo);

## The outputs vector with the original data
Yo=D(:,4);
ny = normalizer(normalizer_type);
Y = ny.fit_transform(Yo);

## Limits for plot of regressed lines
minArea = min(Xo(:,2));
maxArea = max(Xo(:,2));
minPrice = min(Yo);
maxPrice = max(Yo);

areas=linspace(minArea,maxArea,15); ## Some areas in the whole range
nareas=nx.transform([ones(length(areas),1) areas']); ## Normalized desired areas


## Objective function of the parameters theta
## Requires also the data X (in rows) and corresponding labels Y.
##
## This function is capable of evaluating several sets of theta, each
## one in a row of the given theta.  Hence the result res will have
## as much rows as theta.
function res=J(theta,X,Y)
  ## First compute the residuals for all sets of theta
  R=(X*theta'-Y*ones(1,rows(theta)));
  ## Now square and sum the residuals for each set of theta
  res=0.5*sum(R.*R,1)';
endfunction;

## Gradient of J.
## Analytical solution.
##
## Here we assume that theta has two components only.
## For each theta pair (assumed in a row of the theta matrix) it will
## compute also a row with the gradient: the first column is the partial
## derivative w.r.t theta_0 and the second w.r.t theta_1
function res=gradJ(theta,X,Y)
  res=(X'*(X*theta'-Y*ones(1,rows(theta))))';
endfunction;

## The following segment shows the error surface,
## which is possible only because in this case
## we have a 2D theta space [theta0 theta1] and
## nothing else

## Select the grid to plot the contours and gradients
th0=-1:0.05:1;   ## Value range for theta0
th1=-0.5:0.05:2; ## Value range for theta1
[tt0,tt1] = meshgrid(th0,th1);  ## The complete grid

## Recover the used region to ensure the proper plot
featSpace=[th0(1),th0(end),th1(1),th1(end)];

theta=[tt0(:) tt1(:)]; ## All theta value pairs in rows
jj=reshape(J(theta,X,Y),size(tt0)); ## J values for each pair

## Precompute the gradient for the chosen grid
g=gradJ(theta,X,Y);
gjx=reshape(g(:,1),size(tt0));
gjy=reshape(g(:,2),size(tt1));

## plot the contours in 2D
figure(1,"name","Contours");
hold off;
axis("manual","tight");
daspect([1,1,1]);

contour(tt0,tt1,jj);
xlabel('{\theta_0}');
ylabel('{\theta_1}');

## Learning rate
alpha = 0.075;

## Do the learning:

while(1)
  hold on;
 
  printf("Click on countours to set a starting point\n");
  fflush(stdout);

  figure(1,"name","Contours");
  daspect([1,1,1]);

  ## Wait for a mouse click and get the point (t0,t1) in the plot coordinate sys.
  [t0,t1,buttons] = ginput(1);
  t=[t0,t1];
  gt=gradJ(t,X,Y);

  ## Clean the previous plot 
  hold off;

  ## Paint first the contour lines
  contour(tt0,tt1,jj);
  hold on;

  ## Add the gradient
  quiver(tt0,tt1,gjx,gjy,0.7);
  daspect([1,1]);

  xlabel('{\theta_0}');
  ylabel('{\theta_1}');

  ## Print some information on the clicked starting point
  printf("J(%g,%g)=%g\n",t0,t1,J(t,X,Y));
  printf("  GradJ(%g,%g)=[%g,%g]\n",t0,t1,gt(1),gt(2));
  fflush(stdout);

  ## Show the clicked point
  plot([t0],[t1],"*r");

  ## Paint on a second figure the corresponding line
  figure(2);
  hold off;
  plot(Xo(:,2),Yo,"*b"); ## Input data as blue *
  hold on;
  
  ## Paint the original clicked one with black
  nprices = nareas * t'; ## Transform to normalized prices
  prices=ny.itransform(nprices);  ## Denormalize the prices
  
  plot(areas,prices,'k',"linewidth",3);
  
  ## Perform the gradient descent
  ts=t; # sequence of t's

  for i=[1:100] # max 100 iterations
    tc = ts(end,:); # Current position 
    gn = gradJ(tc,X,Y);  # Gradient at current position
    tn = tc - alpha * gn;# Next position
    ts = [ts;tn];

    ## Print some information on the next point
    printf("J(%g,%g)=%g\n",tc(1),tc(2),J(tc,X,Y));
    printf("  GradJ(%g,%g)=[%g,%g]\n",tc(1),tc(2),gn(1),gn(2));
    fflush(stdout);

    ## Paint the path on the contours
    figure(1,"name","Contours");
    plot([tc(1) tn(1)],[tc(2),tn(2)],"k-"); ## Draw the lines
    plot([tn(1)],[tn(2)],"ob");             ## Overlay each step
    axis(featSpace,"manual","tight");

    figure(2,"name","Regressed lines");
    hold on;

    ## We have to de-normalize the normalized estimation
    nprices = nareas * tn';
    prices=ny.itransform(nprices);

    plot(areas,prices,'r',"linewidth",1);
    axis([minArea maxArea minPrice maxPrice]);  

    if (norm(gn)<0.001) break; endif;
    
    figure(1);
    axis(featSpace,"manual","tight");

    waitforbuttonpress();
  endfor

  figure(2);
  ## Repaint the last one as green
  plot(areas,prices,'g',"linewidth",3);
  axis([minArea maxArea minPrice maxPrice]);  
  
  
endwhile;
