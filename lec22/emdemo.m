#!/usr/bin/octave-cli

## (C) 2021 Pablo Alvarado
## Escuela de Ing. Electrónica
## Tecnológico de Costa Rica
## Curso: EL5857 Aprendizaje Automático


## Ejemplo de Expectation-Maximization con GMM

1;

pkg load statistics;
%graphics_toolkit("gnuplot"); # Without this no contour is saved!


function showGMM(X,Mus,Sigmas,Phis,w)
  colors=[1  ,0  ,0   ;
          0  ,0.5,0   ;
          0  ,0  ,0.75;
          0.2,0.2,0.2;
          0  ,0.5,0.5;
          0.5,0  ,0.5;
          0.5,0.5,0];
  [xx,yy]=meshgrid(-0.5:0.01:1.5, -0.5:0.01:1.5);
  k=rows(Mus);
  scatter(X(:,1),X(:,2),32,w,"filled");
  hold on;
  g=zeros(size(xx));
  for j=1:k
    cg=reshape(Phis(j)*mvnpdf([xx(:),yy(:)],Mus(j,:),Sigmas(:,:,j)),size(xx));
    ##contour(xx,yy,cg,colors(mod(j-1,7)+1));
    contour(xx,yy,cg,"linecolor",colors(mod(j-1,7)+1,:));
    g=g+cg;
  endfor;
  %contour(xx,yy,g,'b');
  axis([-0.5 1.5 -0.5 1.5]);
  daspect([1,1,1])
  grid;
endfunction;
  

% emsteps
% X: input vectors, each one in a row
% k: number of gaussian distributions
function w=emsteps(X,k)
  m=rows(X);
  n=columns(X);
  Sigmas=repmat(0.005*eye(n,n),1,1,k);
  Mus=[];

  %% Random initialization
  randomInit=true;
  if (randomInit)
    mins=min(X);
    maxs=max(X);
    deltas=maxs-mins;
    Mus=rand(k,n).*deltas + mins;
  else
    [idx,centers,sumd,dist]=kmeans(X,k);
    Mus=centers;
  endif
  
  %% For now, all distributions are equiprobable
  
  Phis=ones(1,k);
  Phis=Phis/sum(Phis);

  w=zeros(m,k);
  lastLlh=-realmax();
  for iter=1:500
    % E Step
    for j=1:k
      w(:,j)=mvnpdf(X,Mus(j,:),Sigmas(:,:,j))*Phis(j);
    endfor;
    w = w./sum(w,2);

    % M Step
    Phis = sum(w)/m;

    epsilon=0.0001;
    for j=1:k
      Denom=max(epsilon,sum(w(:,j)));
      Mus(j,:)=sum(X.*w(:,j))/Denom;
      Sigmas(:,:,j)=(X.*w(:,j))'*X/Denom;

      %% Evite que Sigma se haga singular
      Sigmas(:,:,j)+=eye(size(Sigmas(:,:,j)))*epsilon;
    endfor;

    % Calcule la verosimilitud para evaluar covergencia
    ell=zeros(m,1);
    for j=1:k
      ell += w(:,j).*log( (mvnpdf(X,Mus(j,:),Sigmas(:,:,j))*Phis(j))./w(:,j) );
    endfor;

    llh=sum(ell);
    delta=abs(llh-lastLlh);
    lastLlh=llh;
    hold off;
    printf("Iteracion %i: log likelyhood %f (delta %f)\n",iter,llh,delta);
    showGMM(X,Mus,Sigmas,Phis,w);
    fflush(stdout);
    pause(0.1);
    if (delta<1e-5) break; endif;
  endfor;
  
endfunction;

# Genere datos a partir de 3 distribuciones gaussianas

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

N=75;
P1=mvnrnd(mu1,Sigma1,N);
P2=mvnrnd(mu2,Sigma2,N);
P3=mvnrnd(mu3,Sigma3,N);

P=[P1;P2;P3];

hold off;


w=emsteps(P,3);
