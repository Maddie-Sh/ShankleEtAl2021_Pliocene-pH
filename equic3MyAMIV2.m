% _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
%
% csys and equic were originally written by Zeebe to accompany Zeebe and
% Wolf-Gladrow 2001 textbook.
% 
% Kat Allen made some modifications to allow batch inputs.
% 
% James Rae did debugging and tweaked some of code during PhD (Feb/Mar
% 2010).  Made versions that are equivalent to CO2SYS and various other
% programs (see pdfs in Readme folder for details).
% 
% This version is what decided followed best practices most closely.  Is
% equivalent to SeaCarb.  Uses Lee [B]tot, KF determination of Perez and
% Fraga [1987], and K pressure corrections on SWS.  See pH_etc.pdf for
% further details.
% 
% csysK.m and equic2.m are JR?s modifications of Kat?s modifications of
% original Zeebe code.
% 
% csysKslim.m is a slimmed down version of above code (not really used much
% or tested).
% 
% fncsysK.m and equic3.m are version of above that can be run as a
% function.  Gives output in standard double array (RESULTS) or table
% format (csysOUT).

% have added Hain 2015 Mg Ca influence on pK model - MyAMI

% for testing independent of csys
% TC1 = 25;
% S1 = 35;
% P1 = 0;
% i = 1;
% B_all = 1;
% Mg_all = 1;
% Ca_all = 1;
% phflag = 0;                     % Total Scale (0) or Free Scale (1)
% k1k2flag = 1;                   % Roy (0) or Mehrbach (1)



tk = 273.15;           % [K] (for conversion [deg C] <-> [K])
T = TC1(i) + tk;           % TC [C]; T[K]
TC = TC1(i);
P = P1(i);
S = S1(i);
Cl = S1(i) / 1.80655;      % Cl = chlorinity; S = salinity (per mille)
cl3 = Cl.^(1/3);   
% Don't know where the expression for ionic strength below comes from.  Is
% only used for KF where Dickson and Riley 1979 is ref'd (though this ref'd
% from DOE94).  However my copies of DOE94 does not have this expression,
% and Dickson and Riley don't give the expression they use, just the
% measurements.  Their artificial SW has a normal mix of ions, so don't see
% why wouldn't use the normal ionic strength expression. 
%ION = 0.00147 + 0.03592 * Cl + 0.000068 * Cl .* Cl;   % ionic strength
iom0 = 19.924*S/(1000.-1.005*S);% 
S_T = 0.14/96.062/1.80655*S;   % (mol/kg soln) total sulfate 
                               %  Dickson and Goyet (1994) Ch.5 p.11

% phflag = phflag(i);
% k1k2flag = k1k2flag(i);

%Activate this when changing boron seawater concentration
%Make sure to input B_all(i) = input_data(;,9) in csysK.m as well

%bor = B_all(i).*(432.6)*(S/35)* 1.e-6 ;  % (mol/kg), Lee et al. 2010
bor = B_all(i).*(0.0002414/10.811)*(S/1.80655); %±1.62, from Lee (2010): B/Cl = 0.2414 and Sal/Cl = 1.80655 (Cox 1967)


%Kat had: bor = B_all(i).*(416)*(S/35)* 1.e-6 ;  % (mol/kg), DOE94

%bor = 1.*(416.*(S_all(i)/35.))* 1.e-6 ; % for use with constant B

% Kat's original Optional:  sensitivity of K1 to Mg & Ca in sw
% % Both of these originally used an absolute value for Cl, which meant that
% % would get MgCa effect on K1K2 even if Mg_all and Ca_all = 1 if salinity
% % not at 35 (where absolute value of Cl can be used).  Changed this from
% % 19.374 to Cl (=S_all(i)/1.80655). 
% 
% 
% nf_mg = Mg_all(i).*(0.002726*Cl) ; % frac modern * modern
% nf_ca = Ca_all(i).*(0.000531*Cl) ; % frac modern * modern
% 
% ni_mg = 0.002726.*Cl ;
% ni_ca = 0.000531.*Cl ;
% 
% delta_n_mg = nf_mg - ni_mg ;
% delta_n_ca = nf_ca - ni_ca ;
% 
% Sk1_mg = 155.05/1000 ;  % from Ben-Yaakov & Goldhaber, 1973
% Sk1_ca = 33.73/1000 ;   % from Ben-Yaakov & Goldhaber, 1973
% Sk2_mg = 442.24/1000 ;  % from Ben-Yaakov & Goldhaber, 1973
% Sk2_ca = 38.85/1000 ;   % from Ben-Yaakov & Goldhaber, 1973


% -------------------------------------------------------------------------
% code adapted from Chris Roberts:  Conversion of CO2 fugacity into partial pressure
% -------------------------------------------------------------------------
% Relationship from Kortzinger (1999) see Zeebe and Wolf-Gladrow (2001)

BB = ((-1636.75 + 12.0408*T - (3.27957e-2)*T^2 + (3.16528e-5)*T^3))*1e-6 ;
delta = (57.7 - 0.118*T)*1e-6;
R = 8.314472;
%R = 8.314; in Kat's version

pH2O = exp(24.4543 - 6745.09/T - 4.8489*log(T/100) - 0.000544*S);

% ... continued in csysK



%------------------ Ks ----------------------------------------
%       Dickson and Goyet (1994), Chapter 5, p.13
%       (required for total2free)
%       Equilibrium constant for HSO4- = H+ + SO4--
%
%       K_S  = [H+]free [SO4--] / [HSO4-]
%       pH-scale: free scale !!!
%
%       the term log(1-0.001005*S) converts from
%       mol/kg H2O to mol/kg soln


tmp1 = -4276.1 ./ T + 141.328 -23.093*log(T);
tmp2 = +(-13856 ./ T + 324.57 - 47.986 * log(T)).*sqrt(iom0);
tmp3 = +(35474 ./ T - 771.54 + 114.723 * log(T)).*iom0;
tmp4 = -2698 ./ T .*sqrt(iom0).*iom0 + 1776 ./ T .*iom0 .*iom0;
                                       

lnKs = tmp1 + tmp2 + tmp3 + tmp4 + log(1-0.001005*S);

Ks = exp(lnKs);



%------- total2free -----------------------------------------------
%
%       convert from pH_total ('total`) to pH ('free`):
%       pH_total = pH_free - log(1+S_T/K_S(s,tk))

total2free = 1.+S_T./Ks;


% --------------------- Kf  --------------------------------------------
%  Kf = [H+][F-]/[HF]  
%
%   (Dickson and Riley, 1979 in Dickson and Goyet, 
%   1994, Chapter 5, p. 14)
%   pH-scale: 'total'   

%***should be on free for doing pH scale conversions***
% ORIGINALLY USED "ION" term as discussed at top.  Changed to iom0 in
% fitting with other ionic strength terms. 

% tmp1 = 1590.2./T - 12.641 + 1.525.*sqrt(iom0);
% tmp2 = log(1.-0.001005.*S);% + log(1.+S_T./Ks);
% 
% 
% lnKf = tmp1 + tmp2;
% Kf = exp(lnKf);

% keeping on free scale

% if phflag == 0;
%         Kf  = exp(lnKf);
% end;
% if phflag == 1;
%         lnKf = lnKf-log(total2free);
%         Kf  = exp(lnKf);
% end;

% Here use values of Perez and Fraga.  Note this is only suitable for S
% ranging between 10 and 40 and T ranging between 9 and 33oC.  Value is on
% tot scale so convert to FREE

lnKf = 874./T - 9.68 + 0.111.*(S.^0.5);


Kf = exp(lnKf)/total2free;




%-------------- sws2free -----------------------------------------------
%
%       convert from pH_sws ('seawater scale`) to pH ('free`):
%       pH_sws = pH_free - log(1+S_T/K_S(S,T)+F_T/K_F(S,T))

%F_T = 7.e-5.*(S./35.);

%rounding error in original above - should be (as in CO2SYS):
% Riley, J. P., Deep-Sea Research 12:219-220, 1965:
% this is .000068.*Sali./35. = .00000195.*Sali
%TF = (0.000067./18.998).*(Sal./1.80655); % in mol/kg-SW

F_T = (0.000067./18.998).*(S./1.80655);

sws2free   = (1.+S_T./Ks+F_T./Kf);

sws2tot = total2free./sws2free;
tot2sws = 1./sws2tot;
%corr = sws2free./total2free;



% --------------------- Kwater -----------------------------------
%
%       Millero (1995)(in Dickson and Goyet (1994, Chapter 5, p.18))
%       $K_w$ in mol/kg-soln.
%       pH-scale: pH$_{total}$ ('total` scale).

%***TYPO*** in tmp1 = -13847.26./T + 148.96502 - 23.6521 .* log(T);
%148.96502 should be 148.9652 (as in original DOE94 & DOE07) - corrected
%below. 
                                                     
tmp1 = -13847.26./T + 148.9652 - 23.6521 .* log(T);
tmp2 = + (118.67./T - 5.977 + 1.0495.*log(T)).*sqrt(S) - 0.01615.*S;

lnKw =  tmp1 + tmp2;

if phflag == 0;
        Kw  = exp(lnKw);
end;
if phflag == 1;
        lnKw = lnKw-log(total2free);
        Kw  = exp(lnKw);
end;


%---------------------- Kh (K Henry) ----------------------------
%
%               CO2(g) <-> CO2(aq.)
%               Kh      = [CO2]/ p CO2
%
%   Weiss (1974)   [mol/kg/atm]
%
%                             
%
tmp = 9345.17 ./ T - 60.2409 + 23.3585 * log(T/100.);
nKhwe74 = tmp + S.*(0.023517-0.00023656*T+0.0047036e-4*T.*T);

tmpKh1= 9050.69 ./ T - 58.0931 + 22.2940 * log(T/100.);
nKhwe74l = tmpKh1 + S .* (0.027766-0.00025888*T+0.0050578e-4 * T .* T);

%Kh= exp(nKhwe74l);
Kh= exp(nKhwe74);




% --------------------- K1 ---------------------------------------
%   first acidity constant:
%   [H^+] [HCO_3^-] / [CO2] = K_1
%
%   (Roy et al., 1993 in Dickson and Goyet, 1994, Chapter 5, p. 14)
%   pH-scale: 'total'. mol/kg-soln

tmp1 = 2.83655 - 2307.1266 ./ T - 1.5529413 .* log(T);
tmp2 =         - (0.20760841 + 4.0484 ./ T) .* sqrt(S);
tmp3 =         + 0.08468345 .* S - 0.00654208 .* S .* sqrt(S);   
tmp4 =         + log(1 - 0.001005 .* S);

lnK1roy = tmp1 + tmp2 + tmp3 + tmp4;
K1roy = 0;

if phflag == 0;
        K1roy  = exp(lnK1roy);
end;
if phflag == 1;
        lnK1roy = lnK1roy-log(total2free);
        K1roy   = exp(lnK1roy);
end;






% --------------------- K2 ----------------------------------------
%
%   second acidity constant:
%   [H^+] [CO_3^--] / [HCO_3^-] = K_2
%
%   (Roy et al., 1993 in Dickson and Goyet, 1994, Chapter 5, p. 15)
%   pH-scale: 'total'. mol/kg-soln

tmp1 = -9.226508 - 3351.6106 ./ T - 0.2005743 .* log(T);
tmp2 = (-0.106901773 - 23.9722 ./ T) .* sqrt(S);
tmp3 = 0.1130822 .* S - 0.00846934 .* S.^1.5 + log(1 - 0.001005 * S);

lnK2roy = tmp1 + tmp2 + tmp3;

if phflag == 0;
        K2roy  = exp(lnK2roy);
end;
if phflag == 1;
        lnK2roy = lnK2roy-log(total2free);
        K2roy   = exp(lnK2roy);
end;



% --------------------- K1 ---------------------------------------
%   first acidity constant:
%   [H^+] [HCO_3^-] / [H_2CO_3] = K_1
%
%   Mehrbach et al (1973) refit by Lueker et al. (2000).
%
%   pH-scale: 'total'. mol/kg-soln

pK1mehr = 3633.86./T - 61.2172 + 9.6777.*log(T) - 0.011555.*S + 0.0001152.*S.*S;

if phflag == 0;
        K1mehr  = 10^(-pK1mehr);
end;
if phflag == 1;
	lnK1mehr = log(10^(-pK1mehr))-log(total2free);
        K1mehr   = exp(lnK1mehr) ;
end;




% --------------------- K2 ----------------------------------------
%
%   second acidity constant:
%   [H^+] [CO_3^--] / [HCO_3^-] = K_2
%
%   Mehrbach et al. (1973) refit by Lueker et al. (2000).
%
%   pH-scale: 'total'. mol/kg-soln

pK2mehr = 471.78./T + 25.9290 - 3.16967.*log(T) - 0.01781.*S + 0.0001122.*S.*S;

if phflag == 0;
        K2mehr  = 10^(-pK2mehr);
end;
if phflag == 1;
	lnK2mehr = log(10^(-pK2mehr))-log(total2free);
        K2mehr   = exp(lnK2mehr);
end;



%----------- Roy or Mehrbach. default: Roy 

K1 = K1roy;
K2 = K2roy;

if (exist('k1k2flag'))

if k1k2flag == 0;
K1 = K1roy;
K2 = K2roy;
end;

if k1k2flag == 1;
K1 = K1mehr;
K2 = K2mehr;
end;

end;




% --------------------- Kb  --------------------------------------------
%  Kbor = [H+][B(OH)4-]/[B(OH)3]
%
%   (Dickson, 1990 in Dickson and Goyet, 1994, Chapter 5, p. 14)
%   pH-scale: 'total'. mol/kg-soln


tmp1 =  (-8966.90-2890.53*sqrt(S)-77.942*S+1.728*S.^(3./2.)-0.0996*S.*S);
tmp2 =   +148.0248+137.1942*sqrt(S)+1.62142*S;
tmp3 = +(-24.4344-25.085*sqrt(S)-0.2474*S).*log(T);

lnKb = tmp1 ./ T + tmp2 + tmp3 + 0.053105*sqrt(S).*T;

if phflag == 0;
        Kb  = exp(lnKb);
end;
if phflag == 1;
        lnKb = lnKb-log(total2free);
        Kb  = exp(lnKb);
end;


% --------------------- Phosphoric acid ---------------------
%
%
%   (DOE, 1994)  (Dickson and Goyet): pH_T, mol/(kg-soln)
%   Ch.5 p. 16
%
%

lnK1P = -4576.752 ./ T + 115.525 - 18.453*log(T) ...
        + (-106.736 ./ T + 0.69171) .* sqrt(S) ...
        + (-0.65643 ./ T - 0.01844) .* S;
lnK2P = -8814.715 ./ T + 172.0883 - 27.927 * log(T) ...
        + (-160.34 ./ T + 1.3566) .* sqrt(S) ...
        + (0.37335 ./ T - 0.05778) .* S;
lnK3P = -3070.75 ./ T - 18.141 ...
        + (17.27039 ./ T + 2.81197) .* sqrt(S) ...
        + (-44.99486 ./ T - 0.09984) .* S;

K1P = exp(lnK1P);
K2P = exp(lnK2P);
K3P = exp(lnK3P);

%??? Why no conversion to pHfree if flag that want free scale?



% --------------------- Silicic acid ---------------------------
%
%   (DOE, 1994)  (Dickson and Goyet): pH_T, mol/(kg-soln)
%   Ch.5 p. 17
%
%


lnKSi = -8904.2 ./ T + 117.385 - 19.334*log(T) ...
      + (3.5913-458.79 ./ T) .* sqrt(iom0) + (188.74 ./ T - 1.5998) .* iom0 ...
      + (0.07871 - 12.1652 ./ T) .*iom0.^2 + log(1-0.001005*S);

KSi = exp(lnKSi);



% --------------------- Kspc (calcite) ----------------------------
%
% apparent solubility product of calcite
%
%  Kspc = [Ca2+]T [CO32-]T
%
%  where $[]_T$ refers to the equilibrium total 
% (free + complexed) ion concentration.
%
%  Mucci 1983 mol/kg-soln

tmp1 = -171.9065-0.077993.*T+2839.319./T+71.595.*log10(T);
tmp2 = +(-0.77712+0.0028426.*T+178.34./T).*sqrt(S);
tmp3 = -0.07711.*S+0.0041249.*S.^1.5;
log10Kspc = tmp1 + tmp2 + tmp3;

Kspc = 10.^(log10Kspc);

% --------------------- Kspa (aragonite) ----------------------------
%
% apparent solubility product of aragonite
%
%  Kspa = [Ca2+]T [CO32-]T
%
%  where $[]_T$ refers to the equilibrium total 
% (free + complexed) ion concentration.
%
%  Mucci 1983 mol/kg-soln

tmp1 = -171.945-0.077993.*T+2903.293./T+71.595.*log10(T);
tmp2 = +(-0.068393+0.0017276.*T+88.135./T).*sqrt(S);
tmp3 = -0.10018.*S+0.0059415.*S.^1.5;
log10Kspa = tmp1 + tmp2 + tmp3;

Kspa = 10.^(log10Kspa);



%% Ca Mg influence - MyAMI - these overwrite values calculated above. 

Ca = Ca1(i);
Mg = Mg1(i);

if Ca ~= 10.2821 && Mg ~= 52.8171;

Car = round((Ca/1000),3);
Mgr = round((Mg/1000),3);

% using lookup
%     pK_CaMg = readtable('pK_CaMg_lookup.xlsx');
%     load pK_CaMg.mat
%     
%     Caind = find(pK_CaMg.Ca==Car);
%     Mgind = find(pK_CaMg.Mg(Caind)==Mgr);
%     CaMgind = Caind(1)+Mgind-1;
%     
%     lnK0 = pK_CaMg.pK0p0(CaMgind) + pK_CaMg.pK0p1(CaMgind)*100/T + pK_CaMg.pK0p2(CaMgind)*log(T/100) + S*(pK_CaMg.pK0p3(CaMgind) + pK_CaMg.pK0p4(CaMgind)*T/100 + pK_CaMg.pK0p5(CaMgind)*(T/100)^2);
%     Kh = exp(lnK0);
%     
%     logK1 = pK_CaMg.pK1p0(CaMgind) + pK_CaMg.pK1p1(CaMgind)/T + pK_CaMg.pK1p2(CaMgind)*log(T) + pK_CaMg.pK1p3(CaMgind)*S + pK_CaMg.pK1p4(CaMgind)*S^2;
%     K1 = 10^logK1;
%     
%     logK2 = pK_CaMg.pK2p0(CaMgind) + pK_CaMg.pK2p1(CaMgind)/T + pK_CaMg.pK2p2(CaMgind)*log(T) + pK_CaMg.pK2p3(CaMgind)*S + pK_CaMg.pK2p4(CaMgind)*S^2;
%     K2 = 10^logK2;
%     
%     lnKb = pK_CaMg.pKbp0(CaMgind) + pK_CaMg.pKbp1(CaMgind)*S^0.5 + pK_CaMg.pKbp2(CaMgind)*S + 1/T*(pK_CaMg.pKbp3(CaMgind) + pK_CaMg.pKbp4(CaMgind)*S^0.5 + pK_CaMg.pKbp5(CaMgind)*S + pK_CaMg.pKbp6(CaMgind)*S^1.5 + pK_CaMg.pKbp7(CaMgind)*S^2) + log(T)*(pK_CaMg.pKbp8(CaMgind) + pK_CaMg.pKbp9(CaMgind)*S^0.5 + pK_CaMg.pKbp10(CaMgind)*S) + pK_CaMg.pKbp11(CaMgind)*T*S^0.5;
%     Kb = exp(lnKb);
%     
%     lnKw = pK_CaMg.pKwp0(CaMgind) + pK_CaMg.pKwp1(CaMgind)/T + pK_CaMg.pKwp2(CaMgind)*log(T) + (pK_CaMg.pKwp3(CaMgind)/T + pK_CaMg.pKwp4(CaMgind) + pK_CaMg.pKwp5(CaMgind)*log(T))*S^0.5 + pK_CaMg.pKwp6(CaMgind)*S;
%     Kw = exp(lnKw);
%     
%     logKspc = pK_CaMg.pKspCp0(CaMgind) + pK_CaMg.pKspCp1(CaMgind)*T + pK_CaMg.pKspCp2(CaMgind)/T + pK_CaMg.pKspCp3(CaMgind)*log10(T) + (pK_CaMg.pKspCp4(CaMgind) + pK_CaMg.pKspCp5(CaMgind)*T + pK_CaMg.pKspCp6(CaMgind)/T)*S^0.5 + pK_CaMg.pKspCp7(CaMgind)*S + pK_CaMg.pKspCp8(CaMgind)*S^1.5;
%     Kspc = 10^logKspc;
%     
%     logKspa = pK_CaMg.pKspAp0(CaMgind) + pK_CaMg.pKspAp1(CaMgind)*T + pK_CaMg.pKspAp2(CaMgind)/T + pK_CaMg.pKspAp3(CaMgind)*log10(T) + (pK_CaMg.pKspAp4(CaMgind) + pK_CaMg.pKspAp5(CaMgind)*T + pK_CaMg.pKspAp6(CaMgind)/T)*S^0.5 + pK_CaMg.pKspAp7(CaMgind)*S + pK_CaMg.pKspAp8(CaMgind)*S^1.5;
%     Kspa = 10^logKspa;
%     
%     lnKs = pK_CaMg.pKSp0(CaMgind) + pK_CaMg.pKSp1(CaMgind)/T + pK_CaMg.pKSp2(CaMgind)*log(T) + (pK_CaMg.pKSp3(CaMgind)/T + pK_CaMg.pKSp4(CaMgind) + pK_CaMg.pKSp5(CaMgind)*log(T))*iom0^0.5 + (pK_CaMg.pKSp6(CaMgind)/T + pK_CaMg.pKSp7(CaMgind) + pK_CaMg.pKSp8(CaMgind)*log(T))*iom0 + pK_CaMg.pKSp9(CaMgind)/T*iom0^1.5 + pK_CaMg.pKSp10(CaMgind)/T*iom0^2 + log(1 - 0.001005*S);
%     Ks = exp(lnKs);

% using PyMyAMI
PITZERpath = 'C:/Users/Maddie/Dropbox/College/CLASSES - My School Work Files MS/2018-2019/Boron - Fifth Element textbook/Supplements/UPDATED CODE/PITZER.py'; %MyAMI-master'; % <MS edit. ORIG>: '/Users/jameswbrae/Documents/Work/Computer-Code-Models/CO2_calculations/MyAMI_Hain/MyAMI_V1_sourcecode/Pitzer.py';
[K] = PyMyAMI(PITZERpath,num2str(TC),num2str(S),num2str(Car),num2str(Mgr));
    Kh = K.K0(1)*K.K0(2)/K.K0(3);
    K1 = K.K1(1)*K.K1(2)/K.K1(3);
    K2 = K.K2(1)*K.K2(2)/K.K2(3);
    Kb = K.Kb(1)*K.Kb(2)/K.Kb(3);
    Kw = K.Kw(1)*K.Kw(2)/K.Kw(3);
    Kspc = K.KsC(1)*K.KsC(2)/K.KsC(3);
    Kspa = K.KsA(1)*K.KsA(2)/K.KsA(3);
    Ks = K.KSO4(1)*K.KSO4(2)/K.KSO4(3);
end

%% ----------------------------------------------------
%
% Density of seawater as function of S,T,P.
%
% Millero et al. 1981, Gill, 1982.
%
%     
%                 
%
%----------------------------------------------------


%------------ Density of pure water

rhow = 999.842594 + 6.793952e-2*T -9.095290e-3*T^2 ...
            + 1.001685e-4*T^3 -1.120083e-6*T^4 + 6.536332e-9*T^5;

%------------ Density of seawater at 1 atm, P=0

A =   8.24493e-1 - 4.0899e-3*T + 7.6438e-5*T^2 - 8.2467e-7*T^3 ...
    + 5.3875e-9*T^4;
    
B = -5.72466e-3 + 1.0227e-4*T - 1.6546e-6*T^2; 

C = 4.8314e-4;   

rho0 = rhow + A*S + B*S^(3/2) + C*S^2;


%-------------- Secant bulk modulus of pure water 
%
% The secant bulk modulus is the average change in pressure 
% divided by the total change in volume per unit of initial volume.


Ksbmw =   19652.21 + 148.4206*T - 2.327105*T^2 ...
	+ 1.360477e-2*T^3 - 5.155288e-5*T^4;

%-------------- Secant bulk modulus of seawater at 1 atm

Ksbm0 = Ksbmw ...
	+ S*( 54.6746 - 0.603459*T + 1.09987e-2*T^2 ...
			- 6.1670e-5*T^3) ...
	+ S^(3/2)*( 7.944e-2 + 1.6483e-2*T - 5.3009e-4*T^2);


%-------------- Secant bulk modulus of seawater at S,T,P
	
Ksbm = Ksbm0 ...
	+ P*( 3.239908 + 1.43713e-3*T + 1.16092e-4*T^2 ...
		- 5.77905e-7*T^3) ...
	+ P*S*( 2.2838e-3 - 1.0981e-5*T - 1.6078e-6*T^2) ...
 	+ P*S^(3/2)*1.91075e-4 ...
 	+ P*P*(8.50935e-5 - 6.12293e-6*T + 5.2787e-8*T^2) ...
 	+ P^2*S*(-9.9348e-7 + 2.0816e-8*T + 9.1697e-10*T^2);
 	

%------------- Density of seawater at S,T,P

rho = rho0/(1.-P/Ksbm);


%---------------------- Pressure effect on K's (Millero, 95) ----------%
if P > 0.0

%RGasConstant = 83.14472; %this is NEW proper R.  83.1451 ORIGINALLY; 83.131 also used in empirical fit

RGAS = 8.314510;        % J mol-1 deg-1 (perfect Gas)  
RP = 83.14472;             % mol bar deg-1 
%R = 83.131;                            % conversion cm3 -> m3          *1.e-6
                        %            bar -> Pa = N m-2  *1.e+5
                        %                => *1.e-1 or *1/10

% index: K1 1, K2 2, Kb 3, Kw 4, Ks 5, Kf 6, Kspc 7, Kspa 8,
%        K1P 9, K2P 10, K3P 11

%----- note: there is an error in Table 9 of Millero, 1995.
%----- The coefficients -b0 and b1
%----- have to be multiplied by 1.e-3!

%----- there are some more errors! 
%----- the signs (+,-) of coefficients in Millero 95 do not
%----- agree with Millero 79

%***** CHANGED KB A2 TO -VE (was 2.608*10^3, now -2.608*10^3)
%***** CHANGED KW TO SW VALUES USED IN CO2SYS (old values a0 25.6, a1
%0.2324, a2 -3.6246, b0 5.13, b1 0.0794 - as they appear within vectors)
%***** CHANGED KSPA -a0 to 45.96 to agree with Millero 1979

%***** CO2SYS VALUES FOR REFERENCE
% % PressureEffectsOnKW:
%     %               This is from Millero, 1983 and his programs CO2ROY(T).BAS.
%     deltaV(F)  = -20.02 + 0.1119.*TempC(F) - 0.001409.*TempC(F).^2;
%     %               Millero, 1992 and Millero, 1995 have:
%     Kappa(F)   = (-5.13 + 0.0794.*TempC(F))./1000; % Millero, 1983
%     %               Millero, 1995 has this too, but Millero, 1992 is different.
% 	lnKWfac(F) = (-deltaV(F) + 0.5.*Kappa(F).*Pbar(F)).*Pbar(F)./RT(F);
%     %               Millero, 1979 does not list values for these.

%***** OLD EQUIC2 VALUES FOR REFERENCE
% a0 = -[25.5   15.82  29.48  25.60  18.03    9.78  48.76   46. ...
% 	14.51 23.12 26.57];
% a1 =  [0.1271 -0.0219 0.1622 0.2324 0.0466 -0.0090 0.5304  0.5304 ...
% 	0.1211 0.1758 0.2020];
% a2 =  [0.0     0.0    2.608 -3.6246 0.316  -0.942  0.0     0.0 ...
% 	-0.321 -2.647 -3.042]*1.e-3;
% b0 = -[3.08   -1.13   2.84   5.13   4.53    3.91  11.76   11.76 ...
% 	2.67 5.15 4.08]*1.e-3;
% b1 =  [0.0877 -0.1475 0.0    0.0794 0.09    0.054  0.3692  0.3692 ...
% 	0.0427 0.09 0.0714]*1.e-3;
% b2 =  [0.0     0.0    0.0    0.0    0.0     0.0    0.0     0.0 ...
% 	0.0 0.0 0.0];



a0 = -[25.5   15.82  29.48  20.02  18.03    9.78  48.76   45.96 ...
	14.51 23.12 26.57];
a1 =  [0.1271 -0.0219 0.1622 0.1119 0.0466 -0.0090 0.5304  0.5304 ...
	0.1211 0.1758 0.2020];
a2 =  [0.0     0.0    -2.608 -1.409 0.316  -0.942  0.0     0.0 ...
	-0.321 -2.647 -3.042]*1.e-3;
b0 = -[3.08   -1.13   2.84   5.13   4.53    3.91  11.76   11.76 ...
	2.67 5.15 4.08]*1.e-3;
b1 =  [0.0877 -0.1475 0.0    0.0794 0.09    0.054  0.3692  0.3692 ...
	0.0427 0.09 0.0714]*1.e-3;
b2 =  [0.0     0.0    0.0    0.0    0.0     0.0    0.0     0.0 ...
	0.0 0.0 0.0];

for ipc=1:length(a0);
  deltav(ipc)  =  a0(ipc) + a1(ipc).*TC + a2(ipc).*TC.*TC;
  deltak(ipc)  = (b0(ipc) + b1(ipc).*TC + b2(ipc).*TC.*TC);  
  lnkpok0(ipc) = -(deltav(ipc)./(RP.*T)).*P + (0.5*deltak(ipc)./(RP.*T)).*P.*P;
end;


% Convert to SWS for P correction

K1 = K1*tot2sws;
K2 = K2*tot2sws;
Kb = Kb*tot2sws;
Kw = Kw*tot2sws;
K1P = K1P*tot2sws;
K2P = K2P*tot2sws;
K3P = K3P*tot2sws;



K1 = K1*exp(lnkpok0(1));
K2 = K2*exp(lnkpok0(2));
Kb = Kb*exp(lnkpok0(3));
Kw = Kw*exp(lnkpok0(4));
Ks = Ks*exp(lnkpok0(5));
Kf = Kf*exp(lnkpok0(6));
Kspc = Kspc*exp(lnkpok0(7));
Kspa = Kspa*exp(lnkpok0(8));
K1P = K1P*exp(lnkpok0(9));
K2P = K2P*exp(lnkpok0(10));
K3P = K3P*exp(lnkpok0(11));

% Convert back to TOT scale with pressure corrected conversion
total2free = 1.+S_T./Ks;
sws2free   = (1.+S_T./Ks+F_T./Kf);
sws2tot = total2free./sws2free;
tot2sws = 1./sws2tot;


K1 = K1*sws2tot;
K2 = K2*sws2tot;
Kb = Kb*sws2tot;
Kw = Kw*sws2tot;
K1P = K1P*sws2tot;
K2P = K2P*sws2tot;
K3P = K3P*sws2tot;



end;


             

return;               