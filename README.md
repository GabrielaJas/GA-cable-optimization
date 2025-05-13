# GA-cable-optimization

Pliki astar_voxel i astar_voxel3d są obecnie niestotne - możliwe jest ich użycie do wygenerowania trasy startowej

Obecnie kod optymalizuje 3 trasy kablowe
Trzeba podac punkty startowe i punkty końcowe

Żeby uruchomic optymalizację, trzeba wpisac w command window:

startPoints = [ ...
    40, 210, 170;   % kabel 1
    500, 210, 170;  % kabel 2
    960, 210, 170   % kabel 3
];

endPoints = [ ...
    750, 150, 50;   % koniec 1
    750, 150, 50;   % koniec 2
    750, 150, 50    % koniec 3
];

paths = route_ga_solver(obstacleGrid, startPoints, endPoints, voxelSizeMM);
