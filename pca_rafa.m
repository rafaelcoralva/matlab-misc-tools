function [princ_comp, eigenvec, eigenval] =pca_rafa(S);

[row col]=size(S);

if row>col   
    S=S';    
end

[channels samples]=size(S);
clear row col

% De-meaning the data
M=mean(S')';

for i=1:length(S)  
    B(:,i)=S(:,i)-M;   
end

clear i

% Computing the covariance of the de-meaned data. PCA essentially aims at
% removing the covariance - i.e. finding a projection where C is diagonal.
C=cov(B');

% Obtaing the eigenvectors and eigenvalues of the covariance matrix.
[eigenvec, eigenval]=eig(C); % The columns are the eigenvectors.

% Sorting the eigenvectors and eigenvalues by decreasing order
[eigenval,index]=sort(diag(eigenval));
eigenval=eigenval(length(eigenval):-1:1);

index=index(length(index):-1:1);
eigenvec=eigenvec(:,index');

clear index

% Extracting the principal components
princ_comp=eigenvec' * B;
diag_cov=inv(eigenvec)*C*eigenvec;

end