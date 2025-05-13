function points = bresenham3d(p1, p2)
    p1 = round(p1);
    p2 = round(p2);

    diff = abs(p2 - p1);
    n = max(diff) + 1;  % liczba kroków między punktami

    points = zeros(n, 3);
    for i = 1:3
        points(:, i) = round(linspace(p1(i), p2(i), n));
    end
end
