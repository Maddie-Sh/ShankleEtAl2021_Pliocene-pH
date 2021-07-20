% plot Miocene d11B data at range of d11BSW, Mg&Ca, and 2nd carbonate
% system parameter

% This code was written by James Rae, University of St Andrews, to
% accompany Rae (2017), Boron isotopes in foraminifera: systematics,
% biomineralisation, and carbonate system reconstruction, AiG.  Please send
% any queries to jwbr@st-andrews.ac.uk.  Please cite reference above if
% using this code, and make sure to cite original foram data references, as
% given in spreadsheets. 

% This code uses:
% - Matlab R2014b or later for use of table arrays
% - stackplot.m - James's code for making stacked paleo plots
% - The spreadsheets 'Foster2012.xlsx' and 'Lear2010.xlsx'; these could also be read in from a .mat file, which is quicker, but less convenient to edit
% - rgb.m (a very useful code for generating different colours from https://uk.mathworks.com/matlabcentral/fileexchange/24497-rgb-triple-of-color-name--version-2/content/rgb.m)
% - d11BpHplot (also provided in Rae 2017)
% - Kb from Dickson 1990
% - In case of [Ca] & [Mg] not equal to modern, the MyAMI ion pairing model
% from Hain et al. 2015 is used.  A lookup table of this model's output is
% given in pK_CaMg_MyAMI.mat
% - fnd11BtopH_d11Bsw & fnd11BtopH_d11BswMgCa provided by Rae 2017
% - pre-saved Monte-Carlo pCO2 created using pCO2mc2_04SWer_Omega_norm.m
% (F12_combo_pCO2mcFosterSWer_OmegaFlat4-6.mat)
% - CO2 system codes fncsysKMgCa.m and equic3MyAMI.m.  These were modified
% by James Rae and Kat Allen from Richard Zeebe's originals.  These should
% be consistent with latest best practice for CO2 system calculations,
% equivalent to CO2SYS.m and Seacarb. 


close all
clear all

%% make the figure

limage = [11 17];
lim = limage;
ageticks = [11:1:17];

%Edit this data
numplots = 4; %this is the number of axes you would like
handles = stackplot(numplots);

%% load data

% Foster 2012
F12_761 = readtable('Foster2012.xlsx','sheet','ODP761');
F12_926 = readtable('Foster2012.xlsx','sheet','ODP926');

combo = cat(1,F12_761,F12_926);
combo = sortrows(combo,'Age');

% Lear 2010
L10_761 = readtable('Lear2010.xlsx','range','A11:Q201');

d11Bsw = 37.82;
d11Bswer = 0.35; % 2sig

%% d18O
h = numplots;
hold(handles(h),'on')

plot(L10_761.Age,L10_761.d18Osw,'s-','MarkerEdgeColor',rgb('Black'),'MarkerFaceColor',rgb('White'),'MarkerSize',5,'Color',rgb('Grey'),'Parent',handles(h))

set(handles(h),'Ydir','reverse')
ylabel(handles(h),['ODP761 \delta^{18}O_{SW} (' char(8240) ')'])
axis(handles(h),[lim(1) lim(2) -inf inf])

%% d11B
h = numplots-1;
hold(handles(h),'on')

plot(combo.Age,combo.d11B,'-','Color',rgb('Grey'),'Parent',handles(h))

err = errorbar(F12_761.Age, F12_761.d11B, F12_761.d11Ber,'Color',rgb('LightGray'),'Parent',handles(h));
set(err,'Marker','none','Linestyle','none')
plot(F12_761.Age,F12_761.d11B,'o','MarkerEdgeColor',rgb('Black'),'MarkerFaceColor',rgb('Blue'),'MarkerSize',10,'Color',rgb('Grey'),'Parent',handles(h))

err = errorbar(F12_926.Age, F12_926.d11B, F12_926.d11Ber,'Color',rgb('LightGray'),'Parent',handles(h));
set(err,'Marker','none','Linestyle','none')
plot(F12_926.Age,F12_926.d11B,'^','MarkerEdgeColor',rgb('Black'),'MarkerFaceColor',rgb('LightSkyBlue'),'MarkerSize',12,'Color',rgb('Grey'),'Parent',handles(h))


set(handles(h),'Ydir','reverse')
ylabel(handles(h),['\delta^{11}B (' char(8240) ')'])
axis(handles(h),[lim(1) lim(2) -inf inf])


%% pH
h = numplots-2;
hold(handles(h),'on')


% combo
combo.d11B4 = (combo.d11B - 1.85)./0.88;

combo.S = 35.*ones(size(combo,1),1);
combo.Z = zeros(size(combo,1),1);
combo.d11Bsw = d11Bsw.*ones(size(combo,1),1);
% calc for mod MgCa
combo.pHnew = fnd11BtopH_d11Bsw(combo.d11B4, combo.T, combo.S, combo.Z, combo.d11Bsw);

plot(combo.Age,combo.pHnew,':','Color',rgb('Red'),'Parent',handles(h))

% for Miocene MgCa from Horita 2002
combo.Mg = 48.*ones(size(combo,1),1);
combo.Ca = 14.*ones(size(combo,1),1);
combo.pHnewMgCa = fnd11BtopH_d11BswMgCa(combo.d11B4, combo.T, combo.S, combo.Z, combo.d11Bsw, combo.Mg, combo.Ca);

plot(combo.Age,combo.pHnewMgCa,'-','Color',rgb('Grey'),'Parent',handles(h))


% ODP 761
F12_761.d11B4 = (F12_761.d11B - 1.85)./0.88;

F12_761.S = 35.*ones(size(F12_761,1),1);
F12_761.Z = zeros(size(F12_761,1),1);
F12_761.d11Bsw = d11Bsw.*ones(size(F12_761,1),1);

F12_761.Mg = 48.*ones(size(F12_761,1),1);
F12_761.Ca = 14.*ones(size(F12_761,1),1);
F12_761.pHnewMgCa = fnd11BtopH_d11BswMgCa(F12_761.d11B4, F12_761.T, F12_761.S, F12_761.Z, F12_761.d11Bsw, F12_761.Mg, F12_761.Ca);

plot(F12_761.Age,F12_761.pHnewMgCa,'o','MarkerEdgeColor',rgb('Black'),'MarkerFaceColor',rgb('Blue'),'MarkerSize',10,'Color',rgb('Grey'),'Parent',handles(h))

% ODP926
F12_926.d11B4 = (F12_926.d11B - 1.85)./0.88;

F12_926.S = 35.*ones(size(F12_926,1),1);
F12_926.Z = zeros(size(F12_926,1),1);
F12_926.d11Bsw = d11Bsw.*ones(size(F12_926,1),1);
F12_926.pHnew = fnd11BtopH_d11Bsw(F12_926.d11B4, F12_926.T, F12_926.S, F12_926.Z, F12_926.d11Bsw);

F12_926.Mg = 48.*ones(size(F12_926,1),1);
F12_926.Ca = 14.*ones(size(F12_926,1),1);

F12_926.pHnewMgCa = fnd11BtopH_d11BswMgCa(F12_926.d11B4, F12_926.T, F12_926.S, F12_926.Z, F12_926.d11Bsw, F12_926.Mg, F12_926.Ca);
plot(F12_926.Age,F12_926.pHnewMgCa,'^','MarkerEdgeColor',rgb('Black'),'MarkerFaceColor',rgb('LightSkyBlue'),'MarkerSize',12,'Color',rgb('Grey'),'Parent',handles(h))


% different d11Bsw - do for combo
d11BswRange = [d11Bsw-d11Bswer d11Bsw+d11Bswer]; % uses Foster central estimate with ±0.8 permil 2sigma
for ii = 1:length(d11BswRange)
    d11BswVar = d11BswRange(ii).*ones(size(combo,1),1);
    pHVar = fnd11BtopH_d11BswMgCa(combo.d11B4, combo.T, combo.S, combo.Z, d11BswVar, combo.Mg, combo.Ca);
    plot(combo.Age,pHVar,'--','Color',rgb('Grey'),'Parent',handles(h))
end


set(handles(h),'Ydir','reverse')
ylabel(handles(h),['pH_{tot}'])
axis(handles(h),[lim(1) lim(2) -inf inf])


%% pCO2 - ALK based
h = numplots-3;
hold(handles(h),'on')

% calculate ODP761 pCO2 from new pH calculation above using ALK as in Foster 2008
flag1 = 8; % specifies use of pH and ALK
s1 = [];
hco31 = [];
co31 = [];
dic1 = [];
pco21 = [];
ph1 = F12_761.pH;
alk1 = 1292.*ones(size(F12_761,1),1); % as in F2012
[RESULTS, csysOUT] = fncsysKMgCaV2(flag1,F12_761.T,F12_761.S,F12_761.Z,ph1,s1,hco31,co31,alk1,dic1,pco21, F12_761.Mg, F12_761.Ca);
F12_761.pCO2new = csysOUT.PCO2_r; 

% plot(F12_761.Age,F12_761.pCO2new,'o-','MarkerEdgeColor',rgb('Blue'),'MarkerFaceColor',rgb('White'),'MarkerSize',10,'Color',rgb('Grey'),'Parent',handles(h))


% calculate ODP926 pCO2 from new pH calculation above using ALK as in Foster 2008
flag1 = 8; % specifies use of pH and ALK
s1 = [];
hco31 = [];
co31 = [];
dic1 = [];
pco21 = [];
ph1 = F12_926.pH;
alk1 = 1292.*ones(size(F12_926,1),1); % as in F2012
[RESULTS, csysOUT] = fncsysKMgCaV2(flag1,F12_926.T,F12_926.S,F12_926.Z,ph1,s1,hco31,co31,alk1,dic1,pco21, F12_761.Mg, F12_761.Ca);
F12_926.pCO2new = csysOUT.PCO2_r; 

% plot(F12_926.Age,F12_926.pCO2new,'^','MarkerEdgeColor',rgb('LightSkyBlue'),'MarkerFaceColor',rgb('White'),'MarkerSize',12,'Color',rgb('Grey'),'Parent',handles(h))


%% now use Omega as 2nd parameter

% get Kspc for this interval - flag doesn't matter, just want Kspc
flag1 = 8;
s1 = [];
hco31 = [];
co31 = [];
dic1 = [];
pco21 = [];
ph1 = F12_761.pHnewMgCa;
alk1 = 1292.*ones(size(F12_761,1),1); % as in F2012

[RESULTS, csysOUT] = fncsysKMgCaV2(flag1,F12_761.T,F12_761.S,F12_761.Z,ph1,s1,hco31,co31,alk1,dic1,pco21, F12_761.Mg, F12_761.Ca);

F12_761.Kspc = csysOUT.Kspc_r;
KspcAV = mean(F12_761.Kspc);

Omega = 5;
O5CO3AV = Omega./(mean(F12_761.Ca)/1000).*KspcAV*10^6; %umol/kg
% now use this as input to csys
flag1 = 7; % CO3 and pH
co31 = O5CO3AV.*ones(size(F12_761,1),1);
ph1 = F12_761.pHnewMgCa;
[RESULTS, csysOUT] = fncsysKMgCaV2(flag1,F12_761.T,F12_761.S,F12_761.Z,ph1,s1,hco31,co31,alk1,dic1,pco21, F12_761.Mg, F12_761.Ca);
F12_761.pCO2O5 = csysOUT.PCO2_r; 

Omega = 4;
O4CO3AV = Omega./(mean(F12_761.Ca)/1000).*KspcAV*10^6; %umol/kg
% now use this as input to csys
flag1 = 7; % CO3 and pH
co31 = O4CO3AV.*ones(size(F12_761,1),1);
ph1 = F12_761.pHnewMgCa;
[RESULTS, csysOUT] = fncsysKMgCaV2(flag1,F12_761.T,F12_761.S,F12_761.Z,ph1,s1,hco31,co31,alk1,dic1,pco21, F12_761.Mg, F12_761.Ca);
F12_761.pCO2O4 = csysOUT.PCO2_r; 

Omega = 6;
O6CO3AV = Omega./(mean(F12_761.Ca)/1000).*KspcAV*10^6; %umol/kg
% now use this as input to csys
flag1 = 7; % CO3 and pH
co31 = O6CO3AV.*ones(size(F12_761,1),1);
ph1 = F12_761.pHnewMgCa;
[RESULTS, csysOUT] = fncsysKMgCaV2(flag1,F12_761.T,F12_761.S,F12_761.Z,ph1,s1,hco31,co31,alk1,dic1,pco21, F12_761.Mg, F12_761.Ca);
F12_761.pCO2O6 = csysOUT.PCO2_r; 

err = errorbar(F12_761.Age, F12_761.pCO2O5, [F12_761.pCO2O5-F12_761.pCO2O4], [F12_761.pCO2O6-F12_761.pCO2O5], 'Color',rgb('Blue'),'Parent',handles(h));
set(err,'Marker','none','Linestyle','none')
plot(F12_761.Age,F12_761.pCO2O5,'o-','MarkerEdgeColor',rgb('Black'),'MarkerFaceColor',rgb('Blue'),'MarkerSize',10,'Color',rgb('Grey'),'Parent',handles(h))


% plot 926 with same Omegas
ph1 = F12_926.pHnewMgCa;
alk1 = 1292.*ones(size(F12_926,1),1); % as in F2012
flag1 = 7; % CO3 and pH
ph1 = F12_926.pHnewMgCa;
% Omega 5
co31 = O5CO3AV.*ones(size(F12_926,1),1);
[RESULTS, csysOUT] = fncsysKMgCaV2(flag1,F12_926.T,F12_926.S,F12_926.Z,ph1,s1,hco31,co31,alk1,dic1,pco21, F12_926.Mg, F12_926.Ca);
F12_926.pCO2O5 = csysOUT.PCO2_r; 
% Omega 4
co31 = O4CO3AV.*ones(size(F12_926,1),1);
[RESULTS, csysOUT] = fncsysKMgCaV2(flag1,F12_926.T,F12_926.S,F12_926.Z,ph1,s1,hco31,co31,alk1,dic1,pco21, F12_926.Mg, F12_926.Ca);
F12_926.pCO2O4 = csysOUT.PCO2_r; 
% Omega 6
co31 = O6CO3AV.*ones(size(F12_926,1),1);
[RESULTS, csysOUT] = fncsysKMgCaV2(flag1,F12_926.T,F12_926.S,F12_926.Z,ph1,s1,hco31,co31,alk1,dic1,pco21, F12_926.Mg, F12_926.Ca);
F12_926.pCO2O6 = csysOUT.PCO2_r; 

err = errorbar(F12_926.Age, F12_926.pCO2O5, [F12_926.pCO2O5-F12_926.pCO2O4], [F12_926.pCO2O6-F12_926.pCO2O5], 'Color',rgb('LightSkyBlue'),'Parent',handles(h));
set(err,'Marker','none','Linestyle','none')
plot(F12_926.Age,F12_926.pCO2O5,'^','MarkerEdgeColor',rgb('Black'),'MarkerFaceColor',rgb('LightSkyBlue'),'MarkerSize',12,'Color',rgb('Grey'),'Parent',handles(h))



% Combo with same Omegas
ph1 = combo.pHnewMgCa;
alk1 = 1292.*ones(size(combo,1),1); % as in F2012
flag1 = 7; % CO3 and pH
ph1 = combo.pHnewMgCa;
% Omega 5
co31 = O5CO3AV.*ones(size(combo,1),1);
[RESULTS, csysOUT] = fncsysKMgCaV2(flag1,combo.T,combo.S,combo.Z,ph1,s1,hco31,co31,alk1,dic1,pco21, combo.Mg, combo.Ca);
combo.pCO2O5 = csysOUT.PCO2_r; 
plot(combo.Age,combo.pCO2O5,'-','Color',rgb('Grey'),'Parent',handles(h))



% different d11Bsw - using Omega
d11BswRange = [d11Bsw-d11Bswer d11Bsw+d11Bswer]; % uses Foster central estimate with ±0.8 permil 2sigma
for jj = 1:length(d11BswRange)
    flag1 = 7;
    d11BswVar = d11BswRange(jj).*ones(size(combo,1),1);
    ph1 = fnd11BtopH_d11BswMgCa(combo.d11B4, combo.T, combo.S, combo.Z, d11BswVar, combo.Mg, combo.Ca);
    co31 = O5CO3AV.*ones(size(combo,1),1);
    alk1 = 1292.*ones(size(combo,1),1); % as in F2012
    [RESULTS, csysOUT] = fncsysKMgCaV2(flag1,combo.T,combo.S,combo.Z,ph1,s1,hco31,co31,alk1,dic1,pco21, combo.Mg, combo.Ca);
    pCO2Var = csysOUT.PCO2_r; 
    
    plot(combo.Age,pCO2Var,'--','Color',rgb('Grey'),'Parent',handles(h))
end


%% MC pCO2
% load pre-saved Monte-Carlo created using pCO2mc2_04SWer_Omega_norm.m 
load F12_combo_pCO2mcFosterSWer_OmegaFlat4-6_2020.mat % uses 0.175 SW error 1 sigma and flat Omega from 4-6 on combo dataset

meanpCO2mc = mean(pCO2mc,2);
modepCO2mc = mode(pCO2mc,2);
medianpCO2mc = median(pCO2mc,2);
sdpCO2mc = std(pCO2mc,0,2);
% percentiles
pCO2percentiles = prctile(pCO2mc,[2.5 16 84 97.5],2);
% 68%
plot(combo.Age, pCO2percentiles(:,2),'-','Color',rgb('Green'),'Parent',handles(h))
plot(combo.Age, pCO2percentiles(:,3),'-','Color',rgb('Green'),'Parent',handles(h))
% 95%
plot(combo.Age, pCO2percentiles(:,1),':','Color',rgb('Green'),'Parent',handles(h))
plot(combo.Age, pCO2percentiles(:,4),':','Color',rgb('Green'),'Parent',handles(h))


set(handles(h),'YScale','log','Ytick',[200:100:1400],'YTickLabel',{'200' '' '400' '' '600' '' '800' '' '' '' '1200' '' ''})
ylabel(handles(h),'Atmospheric CO_2 (ppm)')
axis(handles(h),[lim(1) lim(2) -inf inf])


%% alter axes and prettify figure
%[left bottom width height]
axpos = get(handles(1),'Position');
set(handles(1), 'Position', [axpos(1) axpos(2) axpos(3) axpos(4)+0.08])
% axpos = get(handles(2),'Position');
% set(handles(2), 'Position', [axpos(1) axpos(2) axpos(3) axpos(4)+0.03])
% axpos = get(handles(3),'Position');
% set(handles(3), 'Position', [axpos(1) axpos(2) axpos(3) axpos(4)+0.05])
% axpos = get(handles(4),'Position');
% set(handles(4), 'Position', [axpos(1) axpos(2)+0.05 axpos(3) axpos(4)-0.05])

set(handles(1),'XTick',[ageticks])
set(handles(numplots),'XTick',[ageticks])

xlabel(handles(1),'Age (Ma)')

for i = 1:numplots;
    set(handles(i),'Tickdir','out','XMinorTick','on','YMinorTick','on','FontSize',12)
end
set(gcf, 'Position',[360 104 508 594])

