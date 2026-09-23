[filename, filepath] = uigetfile('*.txt', 'Izaberite log fajl');

if isequal(filename, 0)
    disp('Izbor fajla je otkazan.');
    return;
end

fullpath = fullfile(filepath, filename);

fid = fopen(fullpath, 'r', 'n', 'UTF-16LE');
if fid == -1
    fid = fopen(fullpath, 'r');
end

raw = textscan(fid, '%q %q %f %f %f', 'HeaderLines', 1);
fclose(fid);

varNames = cellstr(raw{1});
values = raw{3};

validIdx = ~strncmp(varNames, '$', 1);
varNames = varNames(validIdx);
values = values(validIdx);

uniqueVars = unique(varNames);

T_hmi = 0.1;

figure('Name', ['Prikaz signala: ' filename], 'NumberTitle', 'off');
hold on;

for i = 1:length(uniqueVars)
    currentVar = uniqueVars{i};
    idx = strcmp(varNames, currentVar);
    
    y_var = values(idx);
    t_var = (0:length(y_var)-1)' * T_hmi;
    
    if length(y_var) == 1
        t_var = [0; 5.0];
        y_var = [y_var; y_var];
    end
    
    plot(t_var, y_var, 'LineWidth', 1.8);
end

hold off;
grid on;
xlabel('Vreme [s]');
ylabel('Vrednost');
title(['Vremenski odziv signala - ', strrep(filename, '_', '\_')]);
legend({'w[k]', 'y[k]'}, 'Location', 'best');
