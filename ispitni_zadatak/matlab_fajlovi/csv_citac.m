clear all;
clc;
close all;

[filename, pathname] = uigetfile({'*.csv;*.txt', 'Trace fajlovi (*.csv, *.txt)'; '*.*', 'Svi fajlovi (*.*)'}, ...
                                  'Izaberite Trace CSV/TXT fajl sa 3 signala');

if isequal(filename, 0) || isequal(pathname, 0)
    disp('Izbor fajla je otkazan.');
    return;
end

fullFilePath = fullfile(pathname, filename);

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
    error('Fajl je prazan ili MATLAB ne može da pročita brojeve.');
end

[rows, cols] = size(matrixData);

Ts = 0.04; 
time = (0:rows-1)' * Ts; 

u = matrixData(:, end-2); 
y = matrixData(:, end-1); 
w = matrixData(:, end);   

figure('Name', ['Odziv sistema - ' filename], 'NumberTitle', 'off', 'Color', [1 1 1]);

plot(time, w, 'b--', 'LineWidth', 1.8); hold on;
plot(time, y, 'k-',  'LineWidth', 2.0);          
plot(time, u, 'r-.', 'LineWidth', 1.5);          

grid on;
title(['Analiza odziva sistema (' filename ')'], 'Interpreter', 'none', 'FontSize', 12);
xlabel('Vreme [s]', 'FontSize', 11);
ylabel('Vrednost signala', 'FontSize', 11);

legend({'Zadata vrednost w[k]', 'Izlaz objekta y[k]', 'Upravljanje u[k]'}, ...
       'Location', 'southeast', 'FontSize', 10);

xlim([0 max(time)]);
