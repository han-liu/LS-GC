function LSHeapInit(initlen)
global heap;
if (nargin<1)
    initlen = 100000;
end
heap.q = zeros(2,initlen);
heap.len = 0;
                