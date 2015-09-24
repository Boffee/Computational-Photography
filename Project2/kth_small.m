function val = kth_small(vector, k)

if length(vector) > 1
    pivot = vector(end);
    j = 1;
    for i = 1:length(vector)-1
        if vector(i) < pivot
            temp = vector(i);
            vector(i) = vector(j);
            vector(j) = temp;
            j = j + 1;
        end
    end
    vector(end) = vector(j);
    vector(j) = pivot;

    if k == j
        val = vector(j);
    elseif k < j
        val = kth_small(vector(1:j-1), k);
    else
        val = kth_small(vector(j+1:end), k - j);
    end
else
    val = vector;
end