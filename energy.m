function [E] = energy(z)
[m,n]=size(z);
E=0;
for i=1:m
    for j=1:n
E=E + sum(z(i,j)^2 ) ;

    end
end
% E=sum(abs(z(:)).^2);
end
