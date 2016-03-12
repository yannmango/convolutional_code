function y=bin2deci(x)
% 将二进制数转化为十进制数

t=length(x);
y=(t-1:-1:0);
y=2.^y;
y=x*y';