function FIFOPop()
global fifo
fifo.front = fifo.front + 1;
if fifo.front > fifo.M
   fifo.end = fifo.end - fifo.front + 1 ;
   reinit = zeros(1, fifo.N);
   reinit(1:fifo.end) = fifo.q(fifo.front:fifo.end+fifo.front-1);
   fifo.q = reinit;
   fifo.front = 1;
end
end