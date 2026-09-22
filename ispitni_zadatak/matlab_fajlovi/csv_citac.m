clear all;
clc;
close all;

[filename, pathname] = uigetfile({'*.csv;*.txt', 'Trace fajlovi (*.csv, *.txt)'; '*.*', 'Svi fajlovi (*.*)'}, ...
                                  'Izaberite Trace CSV/TXT fajl iz TIA Portala');

if isequal(filename, 0) || isequal(pathname, 0)
    disp('Izbor fajla je otkazan.');
    return;
end

fullFilePath = fullfile(pathname, filename);
fprintf('Ucitavanje fajla: %s...\n', filename);

try
    rawData = importdata(fullFilePath);
    if isstruct(rawData)
        matrixData = rawData.data;
    else
        matrixData = rawData;
    end
catch
    matrixData = readmatrix(fullFilePath);
end

if isempty(matrixData)
    error('Fajl je prazan ili MATLAB ne može da procita brojeve.');
end

[rows, ~] = size(matrixData);

Ts = 0.04; 
time = (0:rows-1)' * Ts; 

u = matrixData(:, end-1); 
y = matrixData(:, end);   

figure('Name', ['Odziv sistema - ' filename], 'NumberTitle', 'off', 'Color', [1 1 1]);

plot(time, y, 'b-', 'LineWidth', 2.0); hold on;
plot(time, u, 'r--', 'LineWidth', 1.8);

grid on;
title(['Odziv objekta y[k] i upravljanje u[k] (' filename ')'], 'Interpreter', 'none', 'FontSize', 12);
xlabel('Vreme [s]', 'FontSize', 11);
ylabel('Vrednost signala', 'FontSize', 11);
legend({'Izlaz objekta y[k]', 'Upravljanje u[k]'}, 'Location', 'southeast', 'FontSize', 10);
xlim([0 max(time)]);

disp('Prikaz rezultata');