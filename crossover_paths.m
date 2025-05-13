function child = crossover_paths(p1, p2)
    cut = randi(min(size(p1,1), size(p2,1)));
    child = [p1(1:cut, :); p2(cut+1:end, :)];
end
