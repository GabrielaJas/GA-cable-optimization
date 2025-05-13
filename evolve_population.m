function [newPop, bestFitness] = evolve_population(population, fitness, mutationRate, startPoint, endPoint, gridSize, obstacleGrid)
    [~, idx] = sort(fitness);
    population = population(idx);
    newPop = population(1:5);  % elityzm: zachowaj najlepsze

    while length(newPop) < length(population)
        % Krzyżowanie
        p1 = population{randi(10)};
        p2 = population{randi(10)};
        child = crossover_paths(p1, p2);

        % Mutacja z uwzględnieniem przeszkód
        if rand < mutationRate
            child = mutate_path(child, gridSize, obstacleGrid);
        end

        % Wymuszenie końcowego punktu
        child(end, :) = endPoint;

        newPop{end+1} = child;
    end

    bestFitness = fitness(idx(1));
end
