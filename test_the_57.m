clear all;
clc;
snr_db = 0:10;%Eb/N0 of dB
err_count0=0;
err_count1=0;
count0=0;
count1=0;
err_limit=100;
ndata=0;
ber0=zeros(1,length(snr_db));
ber1=ber0;
for snr_count=1:length(snr_db)
    err_count0=0;
err_count1=0;
    ndata=0;

    while err_count0<=err_limit
msg = rand(1,1e3)>0; %generate transmitted data,size:1-by-10^3
% Trellises
 %Define trellis for rate 1/2 code.
trel = poly2trellis(4,[15 17]); 
% Code words
code = convenc(msg,trel); % Encode.
l

s0=2*msg-1;
s1=2*code-1;
N0=10^(-snr_db(snr_count)/10)*2;
        sigma=sqrt(N0/2);
        rand_noise=randn(1,length(code));
        
        noise=sigma*rand_noise;
        

r_0=s0+noise(1:length(msg));
r_1=s1+noise;


demo_0=r_0>0;
demo_1=r_1>0;

% Traceback length
tblen = 5;
% viterbi Decoding
decode0=demo_0;
decoded1 = vitdec(demo_1,trel,tblen,'cont','hard');  % vitdec ??
% finnish decoding
%calculate error number
count0=sum(decode0~=msg);
err_count0=err_count0+count0;%for uncoded data
count1=sum(decoded1(tblen+1:end)~=msg(1:end-tblen));%for convolutional code
err_count1=err_count1+count1;
ndata=ndata+1;
    end
ber0(snr_count)=err_count0/(ndata*length(msg));
ber1(snr_count)=err_count1/(ndata*length(msg(1:end-tblen)));
end
% for i=1:length(snr_db)
%     SNR=2*10^(snr_db(i)/10);
%     ber_the(i)=0.5*erfc(sqrt(SNR));
% end
% for i=1:length(snr_db)
%     SNR=10^(snr_db(i)/10);
%     ber_the(i)=0.5*erfc(sqrt(SNR));
%     
% end
semilogy(snr_db,ber0,'b-');
hold on;
semilogy(snr_db,ber1(1:end),'r-');
% semilogy(snr_db,ber_the,'g-');
% semilogy(snr_db,ber_the,'r*');
title('\bf BER performance of Golay coding and BPSK modulation system');
xlabel('\fontsize{10} \bf Eb/N0');ylabel('\fontsize{10} \bf BER');
% legend('without coding','BER-EbNo with convolutional code','theoretical BER-EbNo curve');
legend('theoretical BER-EbNo curve','BER-EbNo with convolutional code');
figure;

