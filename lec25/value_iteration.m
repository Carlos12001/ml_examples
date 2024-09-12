1;

numStates=12;
numActions=5;

%% Nemónicos de estados a índice
s11= 1; s21= 2; s31= 3; s41= 4;
s12= 5; s22= 6; s32= 7; s42= 8;
s13= 9; s23=10; s33=11; s43=12;

%% Acciones
N=1; S=2; E=3; O=4; T=5; % Terminal

%% Probabilidades de transición separadas por acción

%% P_sN  
%%    11 21 31 41  12 22 32 42  13 23 33 43 
PsN=[ .1 .1 .0 .0  .8 .0 .0 .0  .0 .0 .0 .0 ; % 11
      .1 .8 .1 .0  .0 .0 .0 .0  .0 .0 .0 .0 ; % 21
      .0 .1 .0 .1  .0 .0 .8 .0  .0 .0 .0 .0 ; % 31
      .0 .0 .1 .1  .0 .0 .0 .8  .0 .0 .0 .0 ; % 41
      .0 .0 .0 .0  .2 .0 .0 .0  .8 .0 .0 .0 ; % 12
      .0 .0 .0 .0  .0 .0 .0 .0  .0 .0 .0 .0 ; % 22
      .0 .0 .0 .0  .0 .0 .1 .1  .0 .0 .8 .0 ; % 32
      .0 .0 .0 .0  .0 .0 .0 .0  .0 .0 .0 .0 ; % 42
      .0 .0 .0 .0  .0 .0 .0 .0  .9 .1 .0 .0 ; % 13
      .0 .0 .0 .0  .0 .0 .0 .0  .1 .8 .1 .0 ; % 23
      .0 .0 .0 .0  .0 .0 .0 .0  .0 .1 .8 .1 ; % 33
      .0 .0 .0 .0  .0 .0 .0 .0  .0 .0 .0 .0 ; ];% 43

%% P_sS
%%    11 21 31 41  12 22 32 42  13 23 33 43 
PsS=[ .9 .1 .0 .0  .0 .0 .0 .0  .0 .0 .0 .0 ; % 11
      .1 .8 .1 .0  .0 .0 .0 .0  .0 .0 .0 .0 ; % 21
      .0 .1 .8 .1  .0 .0 .0 .0  .0 .0 .0 .0 ; % 31
      .0 .0 .1 .9  .0 .0 .0 .0  .0 .0 .0 .0 ; % 41
      .8 .0 .0 .0  .2 .0 .0 .0  .0 .0 .0 .0 ; % 12
      .0 .0 .0 .0  .0 .0 .0 .0  .0 .0 .0 .0 ; % 22
      .0 .0 .8 .0  .0 .0 .1 .1  .0 .0 .0 .0 ; % 32
      .0 .0 .0 .0  .0 .0 .0 .0  .0 .0 .0 .0 ; % 42
      .0 .0 .0 .0  .8 .0 .0 .0  .1 .1 .0 .0 ; % 13
      .0 .0 .0 .0  .0 .0 .0 .0  .1 .8 .1 .0 ; % 23
      .0 .0 .0 .0  .0 .0 .8 .0  .0 .1 .0 .1 ; % 33
      .0 .0 .0 .0  .0 .0 .0 .0  .0 .0 .0 .0 ; ];% 43

%% P_sE
%%    11 21 31 41  12 22 32 42  13 23 33 43 
PsE=[ .1 .8 .0 .0  .1 .0 .0 .0  .0 .0 .0 .0 ; % 11
      .0 .2 .8 .0  .0 .0 .0 .0  .0 .0 .0 .0 ; % 21
      .0 .0 .1 .8  .0 .0 .1 .0  .0 .0 .0 .0 ; % 31
      .0 .0 .0 .9  .0 .0 .0 .1  .0 .0 .0 .0 ; % 41
      .1 .0 .0 .0  .8 .0 .0 .0  .1 .0 .0 .0 ; % 12
      .0 .0 .0 .0  .0 .0 .0 .0  .0 .0 .0 .0 ; % 22
      .0 .0 .1 .0  .0 .0 .0 .8  .0 .0 .1 .0 ; % 32
      .0 .0 .0 .0  .0 .0 .0  1  .0 .0 .0 .0 ; % 42
      .0 .0 .0 .0  .1 .0 .0 .0  .1 .8 .0 .0 ; % 13
      .0 .0 .0 .0  .0 .0 .0 .0  .0 .2 .8 .0 ; % 23
      .0 .0 .0 .0  .0 .0 .1 .0  .0 .0 .1 .8 ; % 33
      .0 .0 .0 .0  .0 .0 .0 .0  .0 .0 .0  0 ; ];% 43


%% P_sO
%%    11 21 31 41  12 22 32 42  13 23 33 43 
PsO=[ .9 .0 .0 .0  .1 .0 .0 .0  .0 .0 .0 .0 ; % 11
      .8 .2 .0 .0  .0 .0 .0 .0  .0 .0 .0 .0 ; % 21
      .0 .8 .1 .0  .0 .0 .1 .0  .0 .0 .0 .0 ; % 31
      .0 .0 .8 .1  .0 .0 .0 .1  .0 .0 .0 .0 ; % 41
      .1 .0 .0 .0  .8 .0 .0 .0  .1 .0 .0 .0 ; % 12
      .0 .0 .0 .0  .0 .0 .0 .0  .0 .0 .0 .0 ; % 22
      .0 .0 .1 .0  .0 .0 .8 .0  .0 .0 .1 .0 ; % 32
      .0 .0 .0 .0  .0 .0 .0 .0  .0 .0 .0 .0 ; % 42
      .0 .0 .0 .0  .1 .0 .0 .0  .9 .0 .0 .0 ; % 13
      .0 .0 .0 .0  .0 .0 .0 .0  .8 .2 .0 .0 ; % 23
      .0 .0 .0 .0  .0 .0 .1 .0  .0 .8 .1 .0 ; % 33
      .0 .0 .0 .0  .0 .0 .0 .0  .0 .0 .0 .0 ; ];% 43

PsT=zeros(numStates,numStates);


%% Probabilidades de transición Ps(currentState,targetState,action)
Ps=[];

Ps(:,:,N)=PsN;
Ps(:,:,S)=PsS;
Ps(:,:,E)=PsE;
Ps(:,:,O)=PsO;
Ps(:,:,T)=PsT;

%% Recompensas solo por estado
R=ones(1,numStates)*-.02;
R(s22)=0;
R(s42)=-1; %% <- A lot depends on this terminal state
R(s43)=+1;


%% Helper: show policy
function show_policy(PO)

  astr={"N","S","E","O"," "};
  delta=20;
  clf();
  hold on;
  for y=0:2
    plot([0 4*delta],[y*delta,y*delta],"b","linewidth",2);
    for x=0:3
      plot([x*delta x*delta],[0,3*delta],"r","linewidth",2);
      text((x+0.5)*delta,(y+0.5)*delta,astr(PO(x+y*4+1)));
    endfor
  endfor
  plot([0,delta*4,delta*4,0,0],[0,0,delta*3,delta*3,0],"k","linewidth",3);

endfunction


%% Helper: show policy
function show_value(Value)

  ps = 512;
  cmap=colormap(hot(ps));

  eps = 1e-6;
  
  mnv = min(Value(:))-eps;
  mxv = max(Value(:))+eps;

  
  delta=20;
  clf();
  hold on;
  for y=0:2
    for x=0:3
      val = Value(x+y*4+1);
      cidx = 1+round((ps-1)*(val-mnv)/(mxv-mnv));
      %% plot([x*delta x*delta],[0,3*delta],"r","linewidth",2);
      rectangle("Position",[x*delta y*delta (x+1)*delta (y+1)*delta],
                "FaceColor",cmap(cidx,:));

      tidx = ps+1-cidx; %% Text color index
      if (abs(tidx-ps/2)<0.1*ps) tidx = ps; endif
      
      text((x+0.5)*delta,(y+0.5)*delta,num2str(val),
           "horizontalalignment","center",
           "color",cmap(tidx,:));

    endfor
  endfor
  plot([0,delta*4,delta*4,0,0],[0,0,delta*3,delta*3,0],"k","linewidth",3);

  axis([0,delta*4,0,delta*3]);
endfunction


figure(3,"name","Recompensa");
show_value(R)


########################
## Iteración de valor ##
########################
V=R;
Vnew=zeros(1,numStates);

sincronico=true;

PO=ones(1,numStates)*T; ## Terminal action as default
gamma=0.9; ## Discount factor

eps=1e-6;
do
  change=0;
  
  for s=1:numStates
    [maxVal,bestAction]=max(sum(reshape(V,numStates,1).*reshape(Ps(s,:,1:4),numStates,4)));
    
    newVal = R(s) + gamma*maxVal; ## versión sincrónica de actualización
    if (newVal > (V(s)+eps))
      PO(s)=bestAction;    ## Cambie acción solo si hay mejora
    endif

    if (sincronico)
      Vnew(s)=newVal; ## versión sincrónica
    else
      V(s)=newVal; ## versión asincrónica
    endif
    
    change += abs(newVal-V(s));
  endfor

  if (sincronico)
    V = Vnew; ## versión sincrónica
  endif
  
  figure(1,"name","Policy");
  show_policy(PO);
  
  figure(2,"name","Value function");
  show_value(V)
  
  printf("Change: %f\n",change);
  fflush(stdout);
  drawnow();
  pause();
 
  
until (change<=1e-3)

% Resuelva sistema de ecuaciones lineales

%    11 21 31 41  12 22 32 42  13 23 33 43 
M = zeros(numStates,numStates);
b = reshape(R,numStates,1);
for s=1:numStates ## Initial state
  M(s,s)=1;
 
  for t=1:numStates ## Target state
    M(s,t)-=gamma*Ps(s,t,PO(s));
  endfor;
endfor;

% Función de valor
Vpi=M\b

figure(4,"name","Policy");
show_policy(PO)

figure(5,"name","Value function");
show_value(Vpi)
