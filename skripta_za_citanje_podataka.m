
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
time_ms = raw{5};


validIdx = ~strncmp(varNames, '$', 1);
varNames = varNames(validIdx);
values = values(validIdx);
time_ms = time_ms(validIdx);


t_start = min(time_ms);
t_all = (time_ms - t_start) / 1000;


uniqueVars = unique(varNames);

figure('Name', ['Prikaz signala: ' filename], 'NumberTitle', 'off');
hold on;

for i = 1:length(uniqueVars)
    currentVar = uniqueVars{i};
    idx = strcmp(varNames, currentVar);
    
    t_var = t_all(idx);
    y_var = values(idx);
    
    
    if length(t_var) == 1
        t_var = [t_var; max(t_all)];
        y_var = [y_var; y_var(1)];
    end
    
    
    plot(t_var, y_var, 'LineWidth', 1.8, 'DisplayName', currentVar);
end

hold off;
grid on;
xlabel('Vreme [s]');
ylabel('Vrednost');
title(['Vremenski odziv signala - ', strrep(filename, '_', '\_')]);
legend('Location', 'best');