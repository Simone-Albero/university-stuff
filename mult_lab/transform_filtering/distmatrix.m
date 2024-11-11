function y = distmatrix(M,N)

u = 0:(M - 1);
v = 0:(N - 1);

ind_u = find(u > M/2);
u(ind_u) = u(ind_u) - M;
ind_v = find(v > N/2);
v(ind_v) = v(ind_v) - N;

[V, U] = meshgrid(v, u);

%calculate distance matrix
y = sqrt((U .^ 2) + (V .^ 2));