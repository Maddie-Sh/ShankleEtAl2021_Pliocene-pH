%   Maddie Shankle
%   20 July 2021

% This code was adapted originaly from code written by James Rae at the
% University of St Andrews, whose group is currently working on updating
% this procedure. Please check their GitHub for updates.
% https://github.com/St-Andrews-Isotope-Geochemistry

% Example input table from JWBR: Foster2012.xlsx. Has: Site, Core, Section, 
%  Interval, mcd, Age, Mg_Ca, T, d11B, d11Ber, pH, pHer, CO3, CO3er, pCO2, 
%  pCO2erP, pCO2erM [n = 17]

close all
clearvars
clc

input = readtable('Shankle_MC_input.xlsx'); % ('Shankle_MC_input_Uk37.xlsx');  
    % Needs to have cols: T, d11B (MANUALLY input all else in next sect)
output_subfolder = 'Outputs';
output_filename  = 'test_omega.mat'; % pH_Uk37_erT2S1_modMgCa_d11Bsw_OMEAGA.mat';
                        % Note, if doing Omega = 4,5,or6 with no error,
                        %  remove -1: Omegamc = Omega + rand*Omegaerflat - 1;
                        % The -1 ok w/ er of 2 given rand fcn's uniform distbn
load pK_CaMg_MyAMI.mat  
    % Look up table from JWBR, used for getting Kspc (solubility product of
    %  calcite, ~eqb constant for dissolved compound/saturated solution)
    %  https://www.chemguide.co.uk/physical/ksp/introduction.html

                        
    
                        
%% INPUTS

    nmc = 10000;            % Number of simulations

    % Calibration Coefficients. d11B_calcite --> d11B_borate. 
    %  i.e. d11B4 = (d11Bcmc + cal_a)./cal_b;
    %  O. univera (Henehan et al, '16): cal_a = 0.42; cal_b = 0.95.
        cal_a = 0.42;       % intercept
        cal_a_er = 2.85/2;	%  (er only used if do_cal_uncert == 1)
		
    	cal_b = 0.95;       % slope
        cal_b_er = 0.17/2;  %  (er only used if do_cal_uncert == 1)
                    

    % Do calibration uncertainty? 1 if yes, 0 if no
        do_cal_uncert   = 0;    % 1 if yes, 0 if no
    
        
    % degC, psu
        T       = input.T;
        Ter     = 2.0;          
        S       = 34.5.*ones(size(input,1),1); % same for all data pts
        Ser     = 1.0;          

        
    % mmol/kg. Modern: Mg = 52.8171, Ca = 10.2821.
    %          5Ma   : Mg = 43,   Ca = 12. (Horita'02 Tbl2)
    %   Extrap 6Ma   : Mg = 41.0, Ca = 12.3 (er +-0.5 in JWBR's script, +-2 in Miocene fig5.8 in Boron textbook)
        Mg      = 52.8171.*ones(size(input,1),1); % same for all data pts
        Mger    = 0;
        Ca      = 10.2821.*ones(size(input,1),1); % same for all data pts
        Caer    = 0;     
%         Mg      = 43.0.*ones(size(input,1),1); % same for all data pts
%         Mger    = 2;
%         Ca      = 12.0.*ones(size(input,1),1); % same for all data pts
%         Caer    = 2;    
%         Mg      = 41.0.*ones(size(input,1),1); % same for all data pts
%         Mger    = 2;
%         Ca      = 12.3.*ones(size(input,1),1); % same for all data pts
%         Caer    = 2;             
        
    % Permil, Foster '10. Modern d11Bsw and er (1sigma)
        d11Bsw  = 39.61.*ones(size(input,1),1);
        d11Bswer = 0.04/2;     
%         d11Bsw  = 40.*ones(size(input,1),1); % ~6Ma value, acc. to Greenop '17 Clmt of the Past
%         d11Bswer = 1/2;               
        
    % Depth (?). Zeros if all data pts @ surf
        Z       = zeros(size(input,1),1);
        Zer     = 0;

        
    % Permil, from input file. Er = 1sigma (2sd/2)
        d11Bc   = input.d11B;
        d11Bcer = input.d11Ber/2;
        
        
    % For finding pCO2
        Omega   = 5;        % Omega = calcite satn state (thmdyn potential
%         Omegaer = 0.5;      %  for a mineral to form or to dissolve).
%         Omegaerflat = 2;    %  ( = [Ca2+][CO32-] / Ksp). % OG SCRIPT USES
                              %  THIS ERROR
        Omegaerflat = 0;
        % MS 22-04-2021: comment out lines above and un-comment lines below
        % to calc pCO2 with mod Alk instead of mod calcite saturation state (omega)
%         alk     = 2275;         % micro-mol / kg (close to mod both sites, Takahashi '14 Jan map ODV)
%         alkerflat   = 200; 

        

        
%% START OF CODE
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! %
% ----------------------------------------------------------------------- %
% ----------------------------------------------------------------------- %
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! %


% Make an empty array to be filled with pHs (& pCO2s, if doing it)
%  > # of data points in rows (length(T) - or any input variable), & 10,000 
%    (nmc) columns across (can then avg/sd across a row to get pH/error on
%    a single data point)
    pHmc    = ones(length(T),nmc);
    pCO2mc  = ones(length(T), nmc);
                        
  

%% MC SIMULATION

% From JWBR: randn gives normal distribution with SD of 1.  Multiply by
%  1SIGMA, then use percentiles to find 95% confidence. 

% More detailed notes:
% MS: normal distbn = mean 0, sd ("sigma") 1. Doing e.g. T + randn*Ter 
%  randomizes T by picking out a T from a a normal distribution ~about your 
%  T value w/ a sigma (sd) of the sd of the T measurement/value.
% MS: JWBR uses normal distribution around everything (except omega, not
%  involved in pH calc), so I will too.


for jj = 1:nmc      % Calc all # of pHs (# of data pts you have), nmc times
    
    % --- Randomize inputs ---------------------------------------------- %
        Tmc = T + randn*Ter;
        Smc = S + randn*Ser;
        Zmc = Z + randn*Zer;
        d11Bswmc = d11Bsw + randn*d11Bswer; % Will be the same for all data pts
        Mgmc = Mg + randn*Mger;             %  same^
        Camc = Ca + randn*Caer;             %  same^
        d11Bcmc = d11Bc + randn*d11Bcer;
        % JWBR: Omegamc = Omega + randn*Omegaer; % Note below is uni distbn
        Omegamc = Omega + rand*Omegaerflat ; % - 1; % JWBR: note that have made Omega flat % MS: idk what the -1 is for, and think it gave weird answers when I used it
        % MS 22-04-2021: comment out lines above and un-comment line below
        % to calc pCO2 with mod Alk instead of mod calcite saturation state (omega)
% % %         alkmc = alk + rand*alkerflat;
    
    % --- d11B foram to d11B borate ------------------------------------- %
        % NOTE: JWBR's script has Greenop'19's accounting for d11Bsw (not
        %   included here) (ln56 pCO2mc2_04SWer_Omega_norm_2020.m)
        % If doing CALIBRATION UNCERTAINTY, randomize the calbr coefficients
        %  within their error (Monte Carlo)
            if do_cal_uncert == 1
                cal_a_mc = cal_a + randn*cal_a_er;	
                cal_b_mc = cal_b + randn*cal_b_er;
                d11B4 = (d11Bcmc + cal_a_mc)./cal_b_mc;
            else
                d11B4 = (d11Bcmc + 0.42)./0.95;
            end
        
    
    
    % --- pH calculation ------------------------------------------------ %
    % Produces a pH column as long as the # of your data points.
    %  Function takes column vectors & returns col vector of pH.
    %  NOTE: needs pH_Ca_Mg_MyAMI.mat file in your directory.
    %  AND: the PyMyAMI.m, PITZER.py, & associated files. 
        pH = fnd11BtopH_d11BswMgCa_pKb_V2(d11B4, Tmc, Smc, Zmc, d11Bswmc, Mgmc, Camc);
    
    % --- Put the calc'd pHs into 1st col of pHmc, and repeat nmc times - %
        pHmc(:,jj) = pH;
    
% MS: Now, Kspc,,, for calc'ing pCO2 or needed    
    % JWBR: get Kspc for this interval - flag doesn't matter, just want Kspc
    Car = round((Camc/1000),3);
    Mgr = round((Mgmc/1000),3);
    % MS: ^Takes Ca/Mg (same for all data points, converts units and
    %  rounds to 3rd decimal place. Then goes on below to look up each combo
    %  of Ca and Mg to calc a value, Caind+Mgind-1 (?). Used in Kspc calc.
    
    CaMgind = zeros(length(Car)); % Create an empty square array, #x# ur data pts
    for ii = 1:length(Car)
        Caii = Car(ii);   % Take iith value from rounded, /1000 Ca values (all same)
        Mgii = Mgr(ii);   % Same with Mg
        Caind = find(round(pK_CaMg.Ca, 3)==Car(ii)); % returns indices in 1st col of where that Ca val is in table... MS added the rounding bit for it to work (in look up table, isn't 0.0090, actually 0.00899999.)
        Mgind = find(pK_CaMg.Mg(Caind)==Mgr(ii)); % ...and for the rows of that Ca, take index (w/in those rows) of appropriate Mg val (2nd col)
        CaMgind(ii) = Caind(1)+Mgind-1; % get the index, 1st Ca row, then  down the number of rows to the right Mg val (minus 1, +exact number would go one too far)
        % Below, take appropriate index'd row of all coefficients used in the Kspc equation

        Tk = Tmc + 273.15;
        logKspc = pK_CaMg.pKspCp0(CaMgind(ii)) + pK_CaMg.pKspCp1(CaMgind(ii))*Tk(ii) + pK_CaMg.pKspCp2(CaMgind(ii))/Tk(ii) + pK_CaMg.pKspCp3(CaMgind(ii))*log10(Tk(ii)) + (pK_CaMg.pKspCp4(CaMgind(ii)) + pK_CaMg.pKspCp5(CaMgind(ii))*Tk(ii) + pK_CaMg.pKspCp6(CaMgind(ii))/Tk(ii))*Smc(ii)^0.5 + pK_CaMg.pKspCp7(CaMgind(ii))*Smc(ii) + pK_CaMg.pKspCp8(CaMgind(ii))*Smc(ii)^1.5;
        Kspc(ii,1) = 10^logKspc;
    end    

    KspcAV = mean(Kspc);    % averaged Kspc, down each column, returns a row

    % MS 22-04-2021: comment out line below if calc'ing pCO2 with mod Alk
    % instead of omega
    OmegaCO3AV = Omegamc./(mean(Camc)/1000).*KspcAV*10^6; %umol/kg

    % now use this as input to csys
    % MS 22-04-2021: if calc'ing pCO2 with alk, switch out commenting below
    flag1 = 7; % CO3 and pH
% % %     flag1 = 8; %pH and ALK given

    % MS 22-04-2021: if calc'ing pCO2 with alk, switch out commenting below
    co31 = OmegaCO3AV*ones(length(Kspc),1);
% % %     co31 = [];

    ph1 = pH;
    s1 = [];
    hco31 = [];
    dic1 = [];
    pco21 = [];
    % MS 22-04-2021: if calc'ing pCO2 with alk, switch out commenting below
    alk1 = ones(length(Kspc));
% % %     alk1 = alkmc*ones(length(Kspc),1);;

    [RESULTS, csysOUT] = fncsysKMgCaV2(flag1,Tmc,Smc,Zmc,ph1,s1,hco31,co31,alk1,dic1,pco21, Mgmc, Camc);

    pCO2mc(:,jj) = csysOUT.PCO2_r; 
    jj
    
end
    
    
%%

%     pH_real = real(pHmc);
%  
%     pH_mean = mean(pH_real, 2);
%     pH_2sd  = 2*std(pH_real, 0, 2);
%     
%     pH_final = [pH_mean, pH_2sd];


    pH_mean = mean(pHmc, 2);
    pH_2sd  = 2*std(pHmc, 0, 2);
    
    pH_final = [pH_mean, pH_2sd];

    pCO2_mean = mean(pCO2mc, 2);
    pCO2_2sd = 2*std(pCO2mc, 0, 2);
    
    pCO2_final = [pCO2_mean, pCO2_2sd];
    
%%    
    figure;
    
    scatter(input.Age(1:12), pH_final(1:12,1), 'r')
    hold on
    scatter(input.Age(13:end), pH_final(13:end,1), 'b')

    errorbar(input.Age(1:12), pH_final(1:12,1), pH_final(1:12,2), 'or')
    errorbar(input.Age(13:end), pH_final(13:end,1), pH_final(13:end,2), 'ob')
    
    legend('West', 'East')
    xlabel('Age (Ma)', 'FontWeight', 'Bold')
    ylabel(['pH (' char(177) '2sd)'], 'FontWeight', 'Bold')
    title(['Avg. 2sd = ' num2str(round(mean(pH_final(:,2)),3))]);
    
    set(gcf, 'Position', [250 250 1200 500]);
    
    

    figure;
    
    scatter(input.Age(1:12), pCO2_final(1:12,1), 'r')
    hold on
%     scatter(input.Age(13:end), pCO2_final(13:end,1), 'b')

    errorbar(input.Age(1:12), pCO2_final(1:12,1), pCO2_final(1:12,2), 'or')
%     errorbar(input.Age(13:end), pCO2_final(13:end,1), pCO2_final(13:end,2), 'ob')
    
    legend('West') %, 'East')
    xlabel('Age (Ma)', 'FontWeight', 'Bold')
    ylabel(['pCO2 (ppm, ' char(177) '2sd)'], 'FontWeight', 'Bold')
    title(['Avg. 2sd = ' num2str(round(mean(pCO2_final(:,2)),3))]);
    
    set(gcf, 'Position', [250 250 1200 500]);
    
    
    
%%
% Save data

    save(output_filename, 'pH_final', 'pCO2_final');
