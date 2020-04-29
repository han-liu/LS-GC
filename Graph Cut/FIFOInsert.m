function FIFOInsert(n)
global fifo
if fifo.end+length(n) > length(fifo.q)
    fifo.q = [fifo.q, zeros(1, fifo.N)]; 
end
fifo.q(fifo.end+1:fifo.end+length(n))= n;
fifo.end = fifo.end + length(n);
end