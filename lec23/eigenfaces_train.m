1;

eigenfaces_helpers;

% Lea nombres de los archivos
% Bajar LFWcrop de http://conradsanderson.id.au/lfwcrop/
IMGS=glob("lfwcrop_grey/faces/*_000*.pgm");
N=rows(IMGS);

% image size
foo=imread(char(IMGS(1)));
IMROWS=rows(foo);
IMCOLS=columns(foo);
SIZEIMG=IMROWS*IMCOLS;

if (!exist("DATA"))
  DATA=loadimages(IMGS,SIZEIMG);
else
  printf("Reutilizando datos ya cargados.\n");
  fflush(stdout);
endif

printf("Calculando media...\n");
fflush(stdout);

meanface = sum(DATA)/rows(DATA);
imshow(olm(reshape(meanface,64,64)));

% Reste la media de todas las filas
DATA0 = DATA - repmat(meanface,rows(DATA),1);

% Matriz de covarianza (4096x4096)
printf("Calculando matriz de covarianza...\n");
fflush(stdout);
COVAR = DATA0'*DATA0/rows(DATA0);

NE=4096;
% Eigenvectores (solo se calculan los primeros NE/4096)
printf("Calculando eigensistema...\n");
fflush(stdout);

if (!exist("V"))
  V=[];
endif

if (size(V)!=[NE,NE])
  tic();
  [V,LAMBDA]=eigs(COVAR,NE,"la");
  toc()
else
  printf("Reutilizando eigenvectores y valores calculados antes...\n");
endif

printf("Salvando eigensistema...\n");
fflush(stdout);
save -binary eigspace.mat V LAMBDA meanface;

figure(1,"name","Eigenvalues as spectrum");
hold off;
EIGVALS=diag(LAMBDA);
plot(EIGVALS,"b","linewidth",3);

figure(2,"name","Accumulated spectrum S_k");
hold off;
plot(cumsum(EIGVALS)/sum(EIGVALS),'r;S_k;',"linewidth",3);
