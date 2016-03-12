function output=cnv_encd(G,k0,input)
% cnv_encd(G,k0,input),k0是每一时钟周期输入编码器的bit数，
% G是决定输入序列的生成矩阵，它有n0行L*k0列n0是输出bit数，
% 参数n0和L由生成矩阵G导出，L是约束长度。L之所以叫约束长度
% 是因为编码器在每一时刻里输出序列不但与当前输入序列有关，
% 而且还与编码器的状态有关，这个状态是由编码器的前(L-1)k0。
% 个输入决定的,通常卷积码表示为(n0,k0,m)，m=(L-1)*k0是编码
% 器中的编码存贮个数，也就是分为L-1段，每段k0个
% 有些人将m=L*k0定义为约束长度，有的人定义为m=(L-1)*k0

% 查看是否需要补0，输入input必须是k0的整数部 
if rem(length(input),k0)>0
    input=[input,zeros(size(1:k0-rem(length(input),k0)))];
end
n=length(input)/k0;

% 检查生成矩阵G的维数是否和k0一致 
if rem(size(G,2),k0)>0
    error('Error,G is not of the right size.')
end

% 得到约束长度L和输出比特数n0
 
L=size(G,2)/k0;
n0=size(G,1);
% 在信息前后加0，使存贮器归0，加0个数为(L-1)*k0个
u=[zeros(size(1:(L-1)*k0)),input,zeros(size(1:(L-1)*k0))];

% 得到uu矩阵,它的各列是编码器各个存贮器在各时钟周期的内容 
u1=u(L*k0:-1:1);
%将加0后的输入序列按每组L*k0个分组，分组是按一比特增加
%从1到L*k0比特为第一组，从2到L*k0+1为第二组，。。。。，
%并将分组按倒序排列。 
for i=1:n+L-2
    u1=[u1,u((i+L)*k0:-1:i*k0+1)];
end
uu=reshape(u1,L*k0,n+L-1);
% 得到输出，输出由生成矩阵G*uu得到
output=reshape(rem(G*uu,2),1,n0*(L+n-1));
