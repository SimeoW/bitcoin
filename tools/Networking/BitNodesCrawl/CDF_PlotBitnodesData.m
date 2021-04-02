global show_windows marker_size line_width font_size;
show_windows = 'on';
marker_size = 15;
line_width = 2;
font_size = 18;

plot = 3;

legendPos = 'SouthEast'


data = readmatrix('Node_Latencies.csv');

%fig = figure('position', [600, 600, 210, 300], 'Name', name, 'visible', show_windows);
fig = figure('Name', 'Latencies', 'visible', show_windows);

y = data(:, 2);

c = cdfplot(y);

grid on;

set(c,'LineWidth', line_width);
set(c, 'LineStyle', '-', 'Color', 'black');
avg = mean(y);
x_vals = get(c,'Xdata');
y_vals = get(c,'Ydata');
[d,ix] = min(abs(x_vals-avg));

xline(avg, 'LineWidth', line_width, 'LineStyle', '--', 'color', 'black', 'HandleVisibility','off');
texthandle = text(avg + 150, 0.1, num2str(floor(avg * 100) / 100), 'FontSize', font_size - 3);
set(texthandle,'Rotation',90);

xlim([0, max(y)]);
xticks([0, 1, 10, 100, 1000, 50000]);
%xlim([0 xlimit(2)]);

set(gca, 'XScale', 'log');
set(gca,'XTickLabel', num2str(get(gca,'XTick').'));
set(gca, 'YMinorTick','on', 'YMinorGrid','on')
set(gca, 'XMinorTick','on', 'XMinorGrid','on')
set(gca,'FontSize',font_size);

axis square;
title('');
xlabel('Nework Latency (ms)');
ylabel('');

%legend('N = 32', 'N = 256', 'N = 512');
