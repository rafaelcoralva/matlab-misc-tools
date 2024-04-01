function [Mt,Vt,Vp]=pca(M);

%  Projection de M, représentant des signaux capteurs échantillonnés à Fe,
% sur la base des vecteurs propres de M'*M, Vt est la base obtenue, Vp les valeurs
%  propres.
% 

%              2) projection sur les directions principales  et tris par Vp décroissante  


% détermination des directions principales

Msq=M'*M;
[V,D]=eig(Msq);


% tri des vecteurs propres par ordre décroissant

[Vp,index]=sort(diag(D));
Vp=Vp(length(Vp):-1:1);

index=index(length(index):-1:1);
Vt=V(:,index');

% projection sur la base des vecteurs propres

Mt=M*Vt;

