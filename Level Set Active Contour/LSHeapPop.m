function [node,dist] = LSHeapPop()
global heap;
if heap.len==0
    node=[];
    dist=[];
    return;
end
node = heap.q(1,1);
dist = heap.q(2,1);        


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This section is updating the priority queue after removing the head
%node
heap.q(:,1) = heap.q(:,heap.len);
hindx = 1;

while (heap.len>2*hindx)&&((heap.q(2,2*hindx)<heap.q(2,hindx))||...
        heap.q(2,(2*hindx+1))<heap.q(2,hindx))
    if (heap.q(2,(2*hindx))<heap.q(2,hindx))&&(heap.q(2,(2*hindx))<heap.q(2,(2*hindx+1)))
        temp = heap.q(:,(2*hindx));
        heap.q(:,(2*hindx)) = heap.q(:,hindx);
        heap.q(:,hindx) = temp;
        hindx = (2*hindx);
    else
        temp = heap.q(:,(2*hindx)+1);
        heap.q(:,(2*hindx)+1) = heap.q(:,hindx);
        heap.q(:,hindx) = temp;
        hindx = (2*hindx)+1;
    end
end
if (heap.len==(2*hindx))&&(heap.q(2,(2*hindx))<heap.q(2,hindx))
    temp = heap.q(:,(2*hindx));
    heap.q(:,(2*hindx)) = heap.q(:,hindx);
    heap.q(:,hindx) = temp;
end
heap.len = heap.len-1;

