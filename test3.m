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

    while err_count1<=err_limit
msg = randint(1,1e3); %generate transmitted data,size:1-by-10^3
% Trellises
 %Define trellis for rate 1/2 code.
trel = poly2trellis(3,[5 7]); 
% Code words
code = convenc(msg,trel); % Encode.
state = 20;
inter = randintrlv(code,state);
% BPSK modulation
s0 = sign(msg-0.5); 
s1 = sign(inter-0.5); 
% AWGN Channel
add_noise0=awgn(s0,snr_db(snr_count),'measured');
add_noise1=awgn(s1,snr_db(snr_count),'measured');

% Deinterleaver with noise for soft decoding
deinter_noise = randdeintrlv(add_noise1,state);
% add noise
r_0 = 0.5*sign(add_noise0) + 0.5;
r_1 = 0.5*sign(add_noise1) + 0.5; 
% Deinterleaver
deinter_1 = randdeintrlv(r_1,state);
% Traceback length
tblen = 5;
% viterbi Decoding
decoded1 = vitdec(deinter_1,trel,tblen,'cont','hard');  % vitdec ??
% finnish decoding
%calculate error number
count0=sum(r_0~=msg);
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
semilogy(snr_db,ber0(1:end-1),'b-');
hold on;
semilogy(snr_db,ber1(1:end-1),'r-');
hold on;
% semilogy(snr_db,ber_the,'r*');
title('\bf BER performance of Golay coding and BPSK modulation system');
xlabel('\fontsize{10} \bf Eb/N0');ylabel('\fontsize{10} \bf BER');
% legend('without coding','BER-EbNo with convolutional code','theoretical BER-EbNo curve');
legend('theoretical BER-EbNo curve','BER-EbNo with convolutional code');
figure;
semilogx(ber0(1:end-1),snr_db,'b-');
hold on;
semilogx(ber1(1:end-1),snr_db,'r-');
% hold on;
% semilogx(ber_the,snr_db,'r*');
title('\bf coding gain of Golay coding and BPSK modulation system');
xlabel('\fontsize{10} \bf BER');ylabel('\fontsize{10} \bf Eb/N0');
legend('theoretical EbNo-BER curve','EbNo-BER with convolutional code');
hold on;
