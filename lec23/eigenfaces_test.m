1;

pkg load statistics;
eigenfaces_helpers;

% Lea el eigensistema entrenado
load -binary eigspace.mat V LAMBDA meanface;

% Carge datos como base de prueba

% Bajar LFWcrop de http://conradsanderson.id.au/lfwcrop/
IMGS=glob("lfwcrop_grey/faces/*_0002.pgm");
N=rows(IMGS);

% image size
foo=imread(char(IMGS(1)));
IMROWS=rows(foo);
IMCOLS=columns(foo);
SIZEIMG=IMROWS*IMCOLS;

if (!exist("TDATA"))
  TDATA=loadimages(IMGS,SIZEIMG);
else
  printf("Reutilizando datos ya cargados.\n");
  fflush(stdout);
endif

% Reste la media de todas las filas
TDATA0 = TDATA - repmat(meanface,rows(TDATA),1);

figure(4,"name","Eigenfaces");
showeigenfaces (V,TDATA0,meanface,10);

fc=1;
components=250;
while(1)
  face=TDATA(fc,:);

  figure(2,"name","Selected (original) eigenface");
  clf;
  showface0(face);

  figure(3,"name","Compressed face");
  showface0(aproxface(face,meanface,V,components));

  printf("Press a key for next random face (u,d,U,D change components)\n");
  fflush(stdout);
  drawnow();

  k=uint8(kbhit());
  switch (k)
    ## Up with U
    case 85
      components+=25;
    ## Down with D
    case 68
      components-=25;
    ## Key u 
    case 117
      components+=1;
    ## Key d 
    case 100
      components-=1;
    otherwise
      ## Tome una imagen al azar y reconstrúyala
      fc=round(unifrnd(1,rows(TDATA)));
  endswitch

  if (components<1)
    components=1;
  elseif (components>columns(TDATA))
    components=columns(TDATA);
  endif

  printf("Approximating image %i with %i components.\n",fc,components);
  
endwhile;

