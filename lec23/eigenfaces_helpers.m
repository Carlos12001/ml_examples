1;

% Lea todas las imágenes y déjelas en las filas de la matriz DATA
function DATA=loadimages(IMGS,SIZEIMG)
  % Cree matriz de datos (datos en las _filas_
  N=rows(IMGS);
  DATA=zeros(N,SIZEIMG);
  for i=[1:N]
    printf("Reading image %i/%i (%i%%)\r",i,N,round(100*i/N));
    fflush(stdout);
    ith=double(imread(char(IMGS(i))))/255;
    DATA(i,:)=ith(:);
  endfor
  printf("\n");
endfunction

% Optimal linear mapping
function y=olm(x)
  minval = min(x(:));
  maxval = max(x(:));

  m=1/(maxval-minval);
  b=-m*minval;

  y=m*x+b;
endfunction

% Muestre un vector fila como imagen
function showface(face)  
  a=reshape(face,64,64);
  imshow(a);
endfunction

% Muestre un vector fila como imagen
function showface0(face)  
  a=olm(reshape(face,64,64));
  imshow(a);
endfunction


% Muestre la i-ésima fila como imagen
function showiface(i,DATA)  
  showface(DATA(i,:));
endfunction

function showrndface(DATA)
  fc=round(unifrnd(1,rows(DATA)));
  printf("Face: %i\n",fc);
  showiface(fc,DATA);
endfunction

% Show a face with index i from the i-th row of DATA
function showiface0(i,DATA)
  showface0(DATA(i,:));
endfunction

% Calcule los coeficientes correspondientes a una cara
function coefs = coefface(face,meanface,V,n)
  % elimine promedio
  face0=face(:)-meanface(:);
  % coeficientes necesarios (column vector)
  coefs=V(:,1:min(n,columns(V)))'*face0;
endfunction

% Sintetice una cara usando los coeficientes dados
function face = synthface(coefs,meanface,V)
  n=length(coefs);
  % reconstruya con solo los coeficientes
  face = meanface(:) + V(:,1:min(n,columns(V)))*coefs;
endfunction

% Function aprox. face with few components
% face: vector fila representando la cara
% meanface: vector fila representando la media de todas las caras entrenadas
% V: eigenvectores
% n: cuántos eigenvectores deben usarse para la aproximación
% Retorna vector columna con nueva cara
function newface = aproxface(face,meanface,V,n)
  % encuentre los coeficientes
  coefs = coefface(face,meanface,V,n);

  % reconstruya con solo los coeficientes
  newface = synthface(coefs,meanface,V);

  % Medir error:
  diff = face(:)-newface(:);
  printf("MSE: %i%%\n",100*diff'*diff/rows(diff));
endfunction

% Recalcule la varianza a partir de la proyección sobre el (eigen)vector
function sigma2 =facesvar(vct,DATA)
  proj=DATA*vct;
  sigma2=sqrt(var(proj));
endfunction


% Muestre variación de un eigenvector
function tira=eigenfaces1(vct,lambda,meanface)
  num=15;
  sigma=sqrt(lambda);
  step=6*sigma/(num-1);

  tira=[];
  
  for i=-3*sigma:step:3*sigma
    cface=reshape(meanface(:)+i*vct(:),64,64);
    tira=horzcat(tira,cface/max(cface(:)));
  endfor
endfunction

% Muestre variaciones de los primeros n eigenvectores
function showeigenfaces(V,DATA,meanface,n)
  efs=[];
  for i=1:n
    tira=eigenfaces1(V(:,i),facesvar(V(:,i),DATA),meanface);
    efs=vertcat(efs,tira);
  endfor
  imshow(efs);
endfunction
