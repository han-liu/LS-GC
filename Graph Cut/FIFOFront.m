function n = FIFOFront()
global fifo
n = fifo.q(fifo.front);
end