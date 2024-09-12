1;

pkg load statistics;
pkg load geometry;

# Parámetros de distribución
mu1=[1 0.8];

# Se=le => SE=EL => S=ELE'
e1=[sqrt(3)/2,1/2];
e2=[-e1(2),e1(1)];
E=[e1;e2]';                   # Eigenvectores 
Sigma1=E*diag([0.1,0.003])*E'; # Sintetice covarianza

# Genere 100 puntos con esa distribución gaussiana
m=100;
X=mvnrnd(mu1,Sigma1,m);

figure(1,"name","Original data");
hold off;
plot(X(:,1),X(:,2),'bx');
axis([0,2,0,2]);
daspect([1,1,1]);

# Calcule la media
mu=sum(X)/m;
hold on;
plot([mu(1)],[mu(2)],'ro',"markerfacecolor",[1,0.5,0]);

# Zero mean data
X0=X-mu;

# Compute covariance
Sigma=X0'*X0/m;

# Eigenvectors and Eigenvalues of Sigma
[P,L]=eig(Sigma);
# Sort them
[sL,perm]=sort(diag(L),"descend");
P=P(perm,:);
L=diag(sL);

sL=sqrt(L); # Just for display: std. dev on each principal component

tip=mu+sL(1,1)*P(1,:);
plot([mu(1),tip(1)],[mu(2),tip(2)],'g',"linewidth",2);
tip=mu+sL(2,2)*P(2,:);
plot([mu(1),tip(1)],[mu(2),tip(2)],'m',"linewidth",2);

Y=X0*P';

figure(2,"name","Projected data");
hold off;
plot(Y(:,1),Y(:,2),"ro");
hold on;
plot(Y(:,1),zeros(rows(Y),1),"bo","markerfacecolor",[0,0,1]);
daspect([1,1,1]);

# Whitening

figure(3);
W=Y*inv(sL);

figure(3,"name","Whitened data");
hold off;
plot(W(:,1),W(:,2),"k^");
daspect([1,1,1]);

