1;

function showAssignments(X,assignments)
  centmarkers={'o','p','s','d','^','v','<','>','*','h'};
  centcolors=[1,0,0;
              0,1,0;
              0.6,0.5,0;
              0,0.5,0.5;
              0.5,0,0.6;
              1,0,0.5];
  C=max(assignments(:));
  pos=find(assignments==0);
  hold off;
  plot(X(pos,1),X(pos,2),'bx');
  hold on;
  
  for i_=1:C
    pos=find(assignments==i_);
    col=mod(i_-1,rows(centcolors))+1;
    mar=mod(i_-1,length(centmarkers))+1;
    eval(["plot(X(pos,1),X(pos,2),'" centmarkers{mar} "',\"color\"," mat2str(centcolors(col,:)) ",\"markeredgecolor\"," mat2str(centcolors(col,:)) ",\"markerfacecolor\"," mat2str(centcolors(col,:)) ",\"markersize\",8)"]);
  endfor
endfunction

function [assignments,C] = demoDBscan(X,minpts,EPS)
  C = 0;
  assignments = zeros(size(X)(1),1);
  clustered = zeros(size(X)(1),1);
  for i=1: size(X)(1)
    if(clustered(i)==1)
      continue;
    endif
    clustered(i)=1;
    isneighbour = [];
    neighbourcount = 0;
    for j=1: size(X)(1)
      dist = sqrt(sum((X(i,:)-X(j,:)).^2));
      if(dist<EPS)
        neighbourcount++;
        isneighbour = [isneighbour j];
      endif
    endfor
    if(neighbourcount<minpts)
      continue;
    else
      C++;
      assignments(i) = C;
      for k=isneighbour
        if(clustered(k)==0)
          clustered(k) = 1;
          _isneighbour = [];
          _neighbourcount = 0;
          for j=1: size(X)(1)
            dist = sqrt(sum((X(k,:)-X(j,:)).^2));
            if(dist<EPS)
              _neighbourcount++;
              _isneighbour = [_isneighbour j];
            endif
          endfor
          if(_neighbourcount>=minpts)
            isneighbour = [isneighbour _isneighbour];
          endif
        endif
        assignments(k) = C;
      endfor
    endif
    showAssignments(X,assignments);
    printf("Presione ENTER para buscar siguiente cluster\n");
    fflush(stdout);
    pause();
  endfor
endfunction


% Configuración
minPts=5; # mínimo número de puntos para conexión
epsilo=0.4; # Tamaño que esfera que debe contener los minPts 



sigma=0.1;
N=15;
centros=rand(10,2)*(2-2*sigma)-(1-sigma);
data=normrnd(0,sigma,N,2)+centros(1,:);
for i_=2:rows(centros)
  data=[data;(normrnd(0,sigma,N,2)+centros(i_,:))];
endfor;

figure(1)
demoDBscan(data,minPts,epsilo);
