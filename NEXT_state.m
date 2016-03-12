function [next_state,memory_contents]=NEXT_state(current_state,input,L,k)
binary_state=dec2bin(current_state,k*(L-1));
binary_input=dec2bin(input,k);
next_state_binary=[binary_input,binary_state(1:(L-2)*k)];
next_state=bin2dec(next_state_binary);
memory_contents=[binary_input,binary_state];
