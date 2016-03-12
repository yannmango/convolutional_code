function [decoder_output,survivor_state,cumulated_metric]=viterbi(G,k,channel_output)
% [decoder_output,survivor_state,cumulated_metric]=viterbi(G,k,channel_output)
% 
% k=1;
% G=[1 1 1;1 0 1];
n=size(G,1);%get the column number
% if rem(size(G,2),k)~=0 %
%     error('Size of G and k do not agree')
% end
% if rem(size(channel_output,2),n)~=0
%     error('channle output not of the right size')
% end
L=size(G,2)/k;%# of constraint length
number_of_states=2^((L-1)*k);

%current SR state
for j=0:number_of_states-1
    for t=0:2^k-1%# of input state 0/1
        [next_state,memory_contents]=NEXT_state(j,t,L,k);%next SR state based on current state and input
        input(j+1,next_state+1)=t;%input based on current state and next state
                 %column is current state ,row is next state
        branch_output=rem(memory_contents*G',2);%
        nextstate(j+1,t+1)=next_state;
%         branch_output=double(branch_output);
        output(j+1,t+1)=bin2deci(branch_output);%'bin2dec' function input must be string type
                         %instead we define this function by ourselves                                                                                                                                                                                     
    end
end
input;
state_metric=zeros(number_of_states,2);%recode the Hamming distance,row1 current distant,column 2 is the current+next Hamming
depth_of_trellis=length(channel_output)/n;%times we need to compare
channel_output_matrix=reshape(channel_output,n,depth_of_trellis);
survivor_state=zeros(number_of_states,depth_of_trellis+1);
[row_survivor col_survivor]=size(survivor_state);%recode the survived path
%
for i=1:depth_of_trellis-L+1
    flag=zeros(1,number_of_states);

    if i<=L
        step=2^((L-i)*k);%at initials state,the cicle times is increased indivially,2,4,8...until the 2*number_of_state
    else
        step=1;
    end
    for j=0:step:number_of_states-1
        for t=0:2^k-1%trellis input
            branch_metric=0; %distance
            binary_output=deci2bin(output(j+1,t+1),n);%binary presentation
            for tt=1:n
                branch_metric=branch_metric+metric(channel_output_matrix(tt,i),binary_output(tt));%distance between this trellis branch and received
            end
            %choose the smaller distance branch,if next state is not
            %visited,choose this one,or cover with smaller one
            if ((state_metric(nextstate(j+1,t+1)+1,2)>state_metric(j+1,1)+branch_metric)|flag(nextstate(j+1,t+1)+1)==0)
                state_metric(nextstate(j+1,t+1)+1,2)=state_metric(j+1,1)+branch_metric;%choose the smaller one
                survivor_state(nextstate(j+1,t+1)+1,i+1)=j;%recode the path
                flag(nextstate(j+1,t+1)+1)=1;%next state is visited
            end
        end
    end
    state_metric=state_metric(:,2:-1:1);
end


%flushing bits(input can only be 0) ,the same as the upper part
for i=depth_of_trellis-L+2:depth_of_trellis
    flag=zeros(1,number_of_states);
    last_stop=number_of_states/(2^((i-depth_of_trellis+L-2)*k));
    for j=0:last_stop-1
        branch_metric=0;
        binary_output=deci2bin(output(j+1,1),n);
        for tt=1:n
            branch_metric=branch_metric+metric(channel_output_matrix(tt,i),binary_output(tt));
        end
        if ((state_metric(nextstate(j+1,1)+1,2)>state_metric(j+1,1)+branch_metric)|flag(nextstate(j+1,1)+1)==0)
            state_metric(nextstate(j+1,1)+1,2)=state_metric(j+1,1)+branch_metric;
            survivor_state(nextstate(j+1,1)+1,i+1)=j;
            flag(nextstate(j+1,1)+1)=1;
        end
    end
    state_metric=state_metric(:,2:-1:1);
end

%get the output based on the best path
state_sequence=zeros(1,depth_of_trellis+1);
size(state_sequence);
state_sequence(1,depth_of_trellis)=survivor_state(1,depth_of_trellis+1);
for i=1:depth_of_trellis
   state_sequence(1,depth_of_trellis-i+1)=survivor_state((state_sequence(1,depth_of_trellis+2-i)+1),depth_of_trellis-i+2);
end
state_sequence;
decoder_output_matrix=zeros(k,depth_of_trellis-L+1);
for i=1:depth_of_trellis-L+1
    dec_output_deci=input(state_sequence(1,i)+1,state_sequence(1,i+1)+1);%get the input one
    dec_output_bin=deci2bin(dec_output_deci,k);
    decoder_output_matrix(:,i)=dec_output_bin(k:-1:1)';
end
decoder_output=reshape(decoder_output_matrix,1,k*(depth_of_trellis-L+1));
cumulated_metric=state_metric(1,1);
