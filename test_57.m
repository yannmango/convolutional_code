clear;
clc;

err_limit=100;%set the limit of error number

srcBlockSize=60;%length of message
k00=1;
G1=[1 0 1 ;1 1 1 ];%(5,7)
  % errorCount=0;
    errorCount1=0;
    err_count_the=0;
%     errorCount2=0;
%     errorCount3=0;
    testLength=0;
    %BER=0;
    BER1=0;
%     BER2=0;
%     BER3=0;
R=1/2;
i=0
for EbN0=0:10
 %   fprintf('%d>',EbN0)
    SNR=10^(EbN0/10);
    sigma=1/sqrt(2*R*SNR);        
     err_num1=0;
     err_num_the=0;
     ndata=0;
     i=i+1;
while err_num1<=err_limit
    ndata=ndata+1;
       
        input=(randn(1,srcBlockSize)>0);% Generate a source block
 
 %---------------------------------------------- 

src1=cnv_encd(G1,k00,input);%convolutional encoding
[row_src1 col_src1]=size(src1) ; 
%BPSKmodulation
src0=2*src1-1;       
        yt1=src0;
        noiseVec=randn(1,col_src1);%Generate noise
        noiseVec=noiseVec*sigma;
        yt1=yt1+noiseVec;
        
        yt2=2*input-1;
        yt2=yt2+noiseVec(1:length(input));
%         
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        rev1=yt1>0;
       rev2=yt2>0;
        [row_rev1 col_rev1]=size(rev1);
        decode1=viterbi(G1,k00,rev1);%decoding of convolutional code
        %[row_input col_input]=size(input);
       
%        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         

        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        errorNum1=sum(xor(input,decode1));
        err_num1=err_num1+errorNum1;
        errorNum2=sum(xor(input, rev2));
        err_num_the=err_num_the+errorNum2;

        end  %for      
            BER1(i)=err_num1/(ndata*length(decode1));
            BER2(i)=err_num_the/(ndata*length(input));
            
end


EbN0=0:8;
semilogy(EbN0(1:end),BER1,'r-');
hold on;
semilogy(EbN0(1:end),BER2,'b-');
title('\bf BER performance with BPSK of (5,7) code');
xlabel('\fontsize{10} \bf Eb/N0');ylabel('\fontsize{10} \bf BER');
legend('BER-EbNo with convolutioanl',' code theoretical BER-EbNo curve');


