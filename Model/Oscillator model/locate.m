function [idleft,idright] = locate(value, vector)
[d p] = min(abs(vector - value));
if value > vector(p)
    idleft=p;
    idright=p+1;
else
    idright=p;
    idleft=p-1;
end

if idright > length(vector)
    idright=0;
end

end