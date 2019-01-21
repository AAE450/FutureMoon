% Function turns the figure background white, increases font sizes, and
% allows mathematical formulae be inputted as figure titles. 
% (Makes figures appropriate for a Latex report)
function plot_latex(plt, xtitle, ytitle,ztitle, tl ,str)
% set the plot legend 
if isempty(str) == false 
    lgd = legend(str, 'Interpreter','latex'); 
    lgd.FontSize = 30;
end 

% set x label, y label and title of the graph, as interpreted using latex 
xlabel(xtitle,'fontsize',30,'Interpreter','latex');
ylabel(ytitle,'fontsize',30,'Interpreter','latex');
zlabel(ztitle,'fontsize',30,'Interpreter','latex');
title(tl,'fontsize',30,'Interpreter','latex');

% sets the fontsize of the values on the axes.
set(gca,'fontsize',24)

% the default matlab plot background is grey, this turns it to white 
set(gcf,'color','w');

% increase the width of lines plotted on the graph
% set(plt , 'linewidth',2);


% add a grid 
grid minor; 
end 