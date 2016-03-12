function y=deci2bin(x,t)
% 十进制数x转化为二进制数，二进制数至少表示为t位

y=zeros(1,t);
i=1;
while x>=0&i<=t
    y(i)=rem(x,2);
    x=(x-y(i))/2;
    i=i+1;
end
y=y(t:-1:1);

