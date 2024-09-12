1;

%graphics_toolkit("gnuplot"); # Without this no contour is saved!

function idx=nearestCentroid(p,centers)
  dist=sum((centers-p).^2,2);
  [val,idx]=min(dist);
endfunction


% kmeans++ is just a strategy for initialization of the k centroids,
% before the kmeans starts.
function centers=kmeanspp(data,nbCluster)
  centers=data(randi(rows(data)),:);
  d=zeros(rows(data),1);

  for i=2:nbCluster
    for j=1:rows(data)
      d(j)=nearestCentroid(data(j,:),centers);
    endfor
    acc=sum(d)*rand();

    for j=1:length(d)
      acc -= d(j);
      if (acc>0)
        continue;
      endif
      centers = [centers;data(j,:)];
      break;
    endfor
  endfor
  
endfunction

function[centroid, pointsInCluster, assignment]= demoKmeans(data, nbCluster,init="random",iterative=0,savePics=0)
% usage
% function[centroid, pointsInCluster, assignment]=
% demoKmeans(data, nbCluster)
%
% Output:
% centroid: matrix in each row are the Coordinates of a centroid
% pointsInCluster: row vector with the nbDatapoints belonging to
% the centroid
% assignment: row Vector with clusterAssignment of the dataRows
%
% Input:
% data in rows
% nbCluster : nb of centroids to determine
% init: one of 'random','takek','kmeans++'
%
% (c) by Christian Herta ( www.christianherta.de )
%
  data_dim = length(data(1,:));
  nbData   = length(data(:,1));

  % init the centroids randomly
  data_min = min(data);
  data_max = max(data);
  data_diff = data_max .- data_min ;

  if (strcmp(init,"random"))
    printf("Completely random initialization\n");
    % every row is a centroid
    centroid = rand(nbCluster, data_dim);
    for i=1 : 1 : length(centroid(:,1))
      centroid( i , : ) =   ( centroid( i , : )  .* data_diff ) + data_min;
    end
  elseif (strcmp(init,"takek"))
    printf("Selecting %i random points from the data\n");
    idx=randi(rows(data),nbCluster,1);
    centroid = data(idx,:);
  else
    printf("Using kmeans++\n");
    centroid=kmeanspp(data,nbCluster);
  endif
  % end init centroids

  hold off;
  plot(data(:,1),data(:,2),"bx");
  hold on;
  centmarkers={'o','p','s','d','^','v','<','>','*','h'};
  centcolors=[1,0,0;
              0,1,0;
              0.6,0.5,0;
              0,0.5,0.5;
              0.5,0,0.6;
              1,0,0.5];

  % show centroids
  for i_=1:rows(centroid)
    eval(["plot([centroid(" num2str(i_) ",1)],[centroid(" num2str(i_) ",2)],'" centmarkers{i_} "',\"color\"," mat2str(centcolors(i_,:)) ",\"markeredgecolor\"," mat2str(centcolors(i_,:)) ",\"markerfacecolor\",\"yellow\",\"markersize\",12)"]);
  endfor
  axis([-1,1,-1,1]);
  daspect([1,1,1]);
  printf("Centroides iniciales\n");
  fflush(stdout);
  drawnow();

  if (savePics)
    filename=sprintf("kmeans_0_%s_.pdf",init);
    print(gcf(),filename,"-dpdf");
  endif
  
  if (iterative)
    pause();
  endif

  % no stopping at start
  pos_diff = 1.;
  iteracion=1;
  % main loop until
  while pos_diff > 0.0

    % E-Step
    assignment = [];
    % assign each datapoint to the closest centroid
    for d = 1 : length( data(:, 1) );

      min_diff = ( data( d, :) .- centroid( 1,:) );
      min_diff = min_diff * min_diff';
      curAssignment = 1;

      for c = 2 : nbCluster;
        diff2c = ( data( d, :) .- centroid( c,:) );
        diff2c = diff2c * diff2c';
        if( min_diff >= diff2c)
          curAssignment = c;
          min_diff = diff2c;
        endif
      endfor

      % assign the d-th dataPoint
      assignment = [ assignment; curAssignment];

    endfor

    %% Plot all the points with their respective assignment
    hold off;
    % show centroids
    for i_=1:rows(centroid)
      eval(["plot([centroid(" num2str(i_) ",1)],[centroid(" num2str(i_) ",2)],'" centmarkers{i_} "',\"color\"," mat2str(centcolors(i_,:)) ",\"markeredgecolor\"," mat2str(centcolors(i_,:)) ",\"markerfacecolor\",\"yellow\",\"markersize\",12)"]);
      hold on;
    endfor

    % show the points
    for i_=1:length(assignment)
      eval(["plot([data(" num2str(i_) ",1)],[data(" num2str(i_) ",2)],'" centmarkers{assignment(i_)} "',\"color\"," mat2str(centcolors(assignment(i_),:)) ",\"markeredgecolor\"," mat2str(centcolors(assignment(i_),:)) ",\"markerfacecolor\"," mat2str(centcolors(assignment(i_),:)) ",\"markersize\",8)"]); 
    endfor

    % Diagrama de Voronoi
    [vx,vy]=voronoi(centroid(:,1),centroid(:,2));
    plot(vx,vy,"-b");
    axis([-1,1,-1,1]);
    daspect([1,1,1]);
    
    printf("Reasignación de iteración %i\n",iteracion);
    fflush(stdout);
    drawnow();


    if (savePics)
      filename=sprintf("kmeans_%i_%s_.pdf",iteracion,init);
      print(gcf(),filename,"-dpdf");
    endif

    if (iterative)
      pause();
    endif
    iteracion++;
    
    % for the stoppingCriterion
    oldPositions = centroid;
    
    % M-Step
    % recalculate the positions of the centroids
    centroid = zeros(nbCluster, data_dim);
    pointsInCluster = zeros(nbCluster, 1);

    for d = 1: length(assignment);
      centroid( assignment(d),:) += data(d,:);
      pointsInCluster( assignment(d), 1 )++;
    endfor

    for c = 1: nbCluster;
      if( pointsInCluster(c, 1) != 0)
        centroid( c , : ) = centroid( c, : ) / pointsInCluster(c, 1);
      else
        % set cluster randomly to new position
        centroid( c , : ) = (rand( 1, data_dim) .* data_diff) + data_min;
      endif
    endfor

    %stoppingCriterion
    pos_diff = sum (sum( (centroid .- oldPositions).^2 ) );

  endwhile;
endfunction;

% Configuración
sigma=0.1; # desviación en cada centro de datos
N=10; # cuantos puntos por centro?
k=5;  # cuantos clusters?

% Crear los clusters
centros=rand(10,2)*(2-2*sigma)-(1-sigma);
data=normrnd(0,sigma,N,2)+centros(1,:);
for i_=2:rows(centros)
  data=[data;(normrnd(0,sigma,N,2)+centros(i_,:))];
endfor;


figure(1);
demoKmeans(data,k,"random",0);
title("Selección aleatoria");

figure(2);
demoKmeans(data,k,"takek",0);
title("Inicie con k datos");

figure(3);
demoKmeans(data,k,"kmeans++",0);
title("kmeans++");
