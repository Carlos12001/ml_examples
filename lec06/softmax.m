#!/usr/bin/octave-cli

## (C) 2020 Pablo Alvarado
## Logistic regression example

close all;
pkg load statistics;

##################################
## Construct some training data ##
##################################

k=3;   ## Number of classes
mk=20; ## Number of training points per class
m=k*mk;

rand("seed",123);
centers = 2*rand(k,2) - 1; ## Centers of each class

## Compute distances between all centers
dm = squareform( pdist(centers) ) + eye(k,k)*100;
mdm = min(dm);

X = [];
y = [];
for i=1:k ## For each class 
  X = [X;mvnrnd(centers(i,:),eye(2,2)*(mdm(i)/3)^2,mk)]; ## Concat new points
  y = [y;ones(mk,1)*i]; ## and label them with the corresponding class
endfor

X = [ones(rows(X),1) X]; ## Prefix them with the bias term (ones)

## Plot the data
figure(1,"name","All classes"); hold off;

colors={"r";"g";"b";"m";"c";"k"};
markers={"o";"s";"v";"*";"x";"+"};

scatter(X(y==1,2),X(y==1,3),colors{1},markers{1},"filled");
hold on;
for kk=2:k
  scatter(X(y==kk,2),X(y==kk,3),colors{kk},markers{kk},"filled");
endfor

grid on;
daspect([1,1,1]);
axis([-2,2,-2,2]);
xlabel("x");
ylabel("y");

####################################################
## Softmax regression with batch gradient descent ##
####################################################

## Now to the logistic regression with (batch) gradient descent
## X design matrix with data in its rows
## Theta parameter matrix, with parameters for each class in its columns
function val = hypothesis(X,Theta)
  val=exp( Theta'*X' );
  nor=sum(val) + ones(1,columns(val)); ## the ones 'cause exp(0) for k
  val = val ./ nor;
endfunction

threshold=0.00001; ## Stop criterion
delta=1;
if (~exist("Theta","var") || ~prod(size(Theta) == [3,k-1]) )
  Theta=zeros(3,k-1); ## For simplicity we will carry the k-th
endif

Theta
fflush(stdout);

## column
  
alpha = 0.00015/m;

allT=eye(k-1,k);

iteration=0;
while(delta>threshold)
  h = hypothesis(X,Theta); ## Hypothesis
  grad = [ (allT(:,y)-h)*X ]; ## Gradient estimation
  last = Theta;
  Theta = last + alpha * grad'; ## Step
  delta = sqrt(max(sum((Theta-last).^2))); ## worst class defines the error

  if (mod(iteration,2000)==0) 
    printf("[%i] delta: %d   \r",iteration,delta);
    fflush(stdout);
  endif
  
  ++iteration;
endwhile
printf("delta: %d              \n",delta);

## Create an image, where the color of the pixel is created by
## combining a bunch of colors representing each class, and the
## mixture is made with the probabilities.

x=linspace(-1,1,256);
[GX,GY]=meshgrid(x,x);
FX = [ones(size(GX(:)),1) GX(:) GY(:)];
FZ = hypothesis(FX,Theta);
FZ = [FZ; ones(1,columns(FZ))-sum(FZ)]; ## Append the last probability

## A figure with the winners
[maxprob,maxk]=max(FZ);

figure(k+2,"name","Winner classes");

winner=flip(uint8(reshape(maxk,size(GX))),1);
cmap = [0,0,0; 1,0,0; 0,1,0; 0,0,1; 0.5,0,0.5; 0,0.5,0.5; 0.5,0.5,0.0];
wimg=ind2rgb(winner,cmap);
imshow(wimg);

## A figure with the weighted winners
figure(k+3,"name","Softmax classes");
ccmap = cmap(2:1+k,:)
cwimg = ccmap'*FZ;

redChnl   = reshape(cwimg(1,:),size(GX));
greenChnl = reshape(cwimg(2,:),size(GX));
blueChnl  = reshape(cwimg(3,:),size(GX));

mixed = flip(cat(3,redChnl,greenChnl,blueChnl),1);
imshow(mixed);


## Show the output probability for each class separately
for (kk=1:k)
  figure(kk+1,"name",cstrcat("Class ",num2str(kk)));
  hold off;

  x=-1.5:0.05:1;
  [GX,GY]=meshgrid(x,x);
  FX = [ones(size(GX(:)),1) GX(:) GY(:)];
  FZ = hypothesis(FX,Theta);
  FZ = [FZ; ones(1,columns(FZ))-sum(FZ)]; ## Add the last probability
  GZ = reshape(FZ(kk,:),size(GX));
  surface(GX,GY,GZ);
  daspect([1,1,1]);
  hold on;
  
  scatter3(X(y==kk,2),X(y==kk,3),y(y==kk)/kk,
           [],colors{kk},markers{kk},"filled");
  scatter3(X(y!=kk,2),X(y!=kk,3),y(y!=kk)*0,
           [],"k","+","filled");

  xlabel("x");
  ylabel("y");
endfor;
