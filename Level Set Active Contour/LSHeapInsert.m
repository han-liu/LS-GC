function LSHeapInsert(node,dist)
global heap;

if heap.len==size(heap.q,2)
    heap.q(:,heap.len+1:2*heap.len) = 0;
end
heap.len = heap.len+1;                
heap.q(:,heap.len) = [node;dist];
cur = heap.len;
while (cur>1)&&( heap.q(2,floor(cur/2)) > heap.q(2,cur))
    temp = heap.q(:,cur);
    heap.q(:,cur) = heap.q(:,floor(cur/2));
    heap.q(:,floor(cur/2)) =temp;
    cur = floor(cur/2);
end
