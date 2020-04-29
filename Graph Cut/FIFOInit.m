function FIFOInit(initlen)
global fifo
fifo.N = initlen;
fifo.M = initlen*(1/2);
fifo.q = zeros(1, fifo.N);
fifo.front = 1;
fifo.end = 0;
return