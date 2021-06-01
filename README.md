# PDGPCS
PDGPCS is a driver genes prediction method;
PDGPCS uesd gene expression data, gene mutation data and pathway data to predict driver genes.
We obtained the source C code of PCST from M.Bailly-Bechet et al(M.Bailly-Bechet, C. Borgs, A. Braunstein, J. Chayes, 
A. Dagkessamanskaia, J.-M.François, and R. Zecchina. Finding undetected protein associations in 
cellsignaling by belief propagation. Proc Natl Acad Sci U S A 2011;108(2):882-887.).
The matlab fronted ("MsgSteriner.mexa64") is compiled by Visual Studio Code.

Input:
1. Gene expression data: tumor and normal expression data, the data format is same as example
                        ('example_tumor.txt' and 'example_normal.txt' ,the  patient's id in the two files must correspond).
2. Gene mutation data: the data format is same as example ('example_snp.txt' or 'example_cnv.txt' )
3. Pathway data: the data format is same as example ('KEGG_pathways_network.xlsx' ). 
                 
Run:
   run main_PDGPCS.m.

Output:
   1. cohort_driver_rank: driver genes ranking in the population.
   2. personalized_driver_rank: the ranking of each patient. 
