# PDGPCS
PDGPCS is a personalized driver genes prediction method;
PDGPCS uesd gene expression data, gene mutation data and pathway data to predict driver genes.
We obtained the source C code of PCST from M.Bailly-Bechet et al(M.Bailly-Bechet, C. Borgs, A. Braunstein, J. Chayes, 
A. Dagkessamanskaia, J.-M.François, and R. Zecchina. Finding undetected protein associations in 
cellsignaling by belief propagation. Proc Natl Acad Sci U S A 2011;108(2):882-887.).
The matlab fronted ("MsgSteriner.mexa64") is compiled by Visual Studio Code.

operation system ：linux

Input:
1. Gene expression data: tumor and normal expression data, the data format is same as example
                        ('example_tumor.txt' and 'example_normal.txt' in Data.zip,the patient's id in the two files must correspond).
2. Gene mutation data: the data format is same as example ('example_snp.txt' or 'example_cnv.by_genes' in Data.zip)
3. Pathway data: the data format is same as example ('KEGG_pathways_network.xlsx' in Data.zip). 
                 
Run:
4. run main_PDGPCS.m.

Output:
5. The output driver_symbol: the symbol of driver genes
              driver_rank: the ranking of each patient (column), 0 represents the gene is not driver in this patient and 
                           non-zero number is the ranking of the gene in a patient.
