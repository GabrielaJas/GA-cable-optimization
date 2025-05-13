% Dodaj folder z voxelise.m do ścieżki
addpath('C:\Users\User\Documents\MATLAB\AEIgIS thesis\ga_3d_v3\Mesh_voxelisation\Mesh_voxelisation');

% Ścieżka do pliku STL
modelPath = 'C:/Users/User/Documents/Inventor/AEIgIS - thesis/Final assembly v0/ga_model.stl';

% Wczytaj dane STL (tylko do obliczenia wymiarów)
[stlData, ~] = stlread(modelPath);
vertices = stlData.Points;

% Oblicz rozmiar modelu w mm
minBounds = min(vertices);
maxBounds = max(vertices);
modelSize = maxBounds - minBounds;

% Ustal maksymalną liczbę voxelów w największym wymiarze
maxGridRes = 1000;

% Oblicz skalę i rozdzielczości voxelowe na każdej osi
scale = maxGridRes / max(modelSize);  % voxel/mm
gridX = round(modelSize(1) * scale);
gridY = round(modelSize(2) * scale);
gridZ = round(modelSize(3) * scale);

% Wygeneruj maskę voxelową
voxelMask = voxelise(gridX, gridY, gridZ, modelPath, 'xyz');

% Dopasuj kolejność osi (Y <-> X)
obstacleGrid = permute(voxelMask, [2 1 3]);

% Utwórz siatki osi w jednostkach mm
voxelSizeMM = 1 / scale;
x = (0:size(obstacleGrid,2)-1) * voxelSizeMM;
y = (0:size(obstacleGrid,1)-1) * voxelSizeMM;
z = (0:size(obstacleGrid,3)-1) * voxelSizeMM;

% Wizualizacja voxelowa
figure;
rotate3d on;  % interaktywny obrót myszką

% Tworzenie izopowierzchni i wyświetlenie
p = patch(isosurface(x, y, z, obstacleGrid, 0.5));
p.FaceColor = 'red';
p.EdgeColor = 'none';

% Ustawienia wizualizacji
daspect([1 1 1]);
view(3);
axis tight;
camlight;
lighting gouraud;
title('Voxel model of the deflectometer');
xlabel('X [mm]');
ylabel('Y [mm]');
zlabel('Z [mm]');
