%% clear variables and console and close windows
clear
clc
close all

%% set directory
%cd('C:/...')

%% data import
formatSpec = '%{yyyy-MM-dd}D%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f';
dataset    = readtable('2004-2014_dax_ftse.csv','Delimiter',',', 'Format',formatSpec);

%% DAX log-returns
X = diff(log(dataset{:, 'DAX30'}));

%% limits for the y-axis in the plot
yLimUp = max(abs([min(X) max(X)]) - 0);
yLims  = [-yLimUp, yLimUp];

%% Date variable
date_X      = dataset{2:end, 'Date'};
date_X_Year = year(date_X);
where_put   = [true; (diff(date_X_Year) == 1)];

%% for the density we take the log-returns of the last four years available in the dataset 
% i.e from 10.05.2010 to 10.05.2014
Index = 1:size(X, 1);
start = Index(date_X == '2010-05-10');
End   = Index(end);
X_lastfour = X(start:End);

%% these objects will be later required to plot the density
mu_X      = mean(X_lastfour);
sigma2_X  = var(X_lastfour);
sigma_X   = std(X_lastfour);
ndata     = linspace(-yLimUp, yLimUp, 10000);

density = [];
for i = ndata
     d       = (sqrt(2*pi*sigma2_X))^(-1)*exp(-(i - mu_X)^2/(2*sigma2_X));     
     density = [density d];
end

%% plot of the DAX log-returns with the normal density for the observations 
% of the last four years available
plot(Index, X)
set(gcf,'color','w') % set the background color to white
hold on
line([start, start], yLims, 'Color','k','LineWidth', 2)
line([End, End], yLims,'Color','k','LineWidth',2)
plot(End + density*10, ndata, 'Color', 'r', 'LineWidth',2.5)
line([start, End], [mu_X, mu_X],'Color','k','LineWidth',2,'LineStyle','--')

%% fill the area betwenn the area under the density curve between (mu - sigma) and (mu + sigma)
a = mu_X - sigma_X;
b = mu_X + sigma_X;
i = a;
while i<b 
  to   = End + ((sqrt(2*pi*sigma2_X))^(-1)*exp(-(i - mu_X)^2/(2*sigma2_X)))*10;
  line([End, to], [i, i], 'Color', 'r', 'Linewidth', 2, 'LineStyle', '-')
  i = i + ((b - a) / 100);
end

%% names of the axes
ylim(yLims)
xlabel('Date')
ylabel('DAX log-returns')
set(gca,'XTick', Index(where_put))
set(gca,'XTickLabels', date_X_Year(where_put))
set(gcf,'color','w')

hold off