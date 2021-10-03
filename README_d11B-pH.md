### Read Me for code for producing pH from d11B (Monte Carlo simulation)
Madison Shankle   
03 October 2021   

   
This code (all that for producing pH from d11B, not the figure code in directory "Figures Code") was adapted originaly from code written by James Rae at the University of St Andrews, whose group is currently working on updating this procedure. Please check their GitHub for updates. https://github.com/St-Andrews-Isotope-Geochemistry   

The main script for running this code is "Shankle_d11B_to_pH_MonteCarlo_wAlk.m" (you can equivalently use "Shankle_d11B_to_pH_MonteCarlo_wOmega.m" if you prefer to use omega (calcite saturation state) as your second carboante system parameter besides pH for estimating pCO2). 

That script will require an input file (here, "Shankle_MC_input.xlsx") consisting of two columns, temperature in degrees Celsius and d11B in permil of your samples. The code also automatically puts the output in a subdirectory called "Outputs", so make sure you have a folder named this in your working directory.    

Other files you will need to have in your working directory are:
* "pK_CaMg_MyAMI.mat" - a look-up table used for getting Kspc (solubility product of
    %  calcite, ~eqb constant for dissolved compound/saturated solution)
* Various files for calculating carbonate chemistry: "fnd11BtopH_d11BswMgCa_pKb_V2.m", "fncsysKMgCaV2.m", "equiv3MyAMIV2.m", and "d11BMioceneSWMgCaOmega456log_combo.m"
* The "PyMyAMI.m" and "PITZER.py" files and the "MyAMI-master" subfolder and all its contents, which are involved in using the look-up table.    

Contact Madison Shankle at mgs23@st-andrews.ac.uk for assistance or questions.
