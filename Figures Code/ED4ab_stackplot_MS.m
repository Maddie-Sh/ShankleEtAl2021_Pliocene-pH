function [handles] = ED4ab_stackplot_MS(numplots)

% Credit to James Rae with minor tweaks by Madison Shankle, 13-09-2021

%Define positions of axes below, first left or right placement
%(alternating) then placement within window


width = 0.7;
left = (1 - width)/2;

figure('Color','white')
handles = zeros(numplots,1);
for i = 1:numplots
    if floor(i/2) < i/2
        str = 'right';
    else
        str = 'left';
    end
    
    %define positions of axes.  Position vector (of each axis rectable) is
    %[left bottom width height] in units normalised to window size
    if i ==1
        handles(i) = axes('Position',[left .06 width (1-left)/numplots],...
            'XAxisLocation','bottom',...
            'YAxisLocation',str,...
            'Color','none',...
            'XColor','k','YColor','k');
    elseif i ==numplots
        handles(i) = axes('Position',[left .11+(1-left)/numplots*(i-1) width (1-left)/numplots],...
            'XAxisLocation','top',...
            'YAxisLocation',str,...
            'Color','none',...
            'XColor','k','YColor','k');
    else
        handles(i) = axes('Position',[left .11+(1-left)/numplots*(i-1) width (1-left)/numplots],...
            'XAxisLocation','bottom',...
            'YAxisLocation',str,...
            'Color','none',...
            'XColor','none','YColor','k');     % MS changed XColor from white to none (so won't show up overlapping on data)
    end
end