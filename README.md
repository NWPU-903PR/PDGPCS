# PDPCST
PDPCST is a personalized driver genes prediction method
PDPCST uesd gene expression data, gene mutation data and pathway data to predict driver genes. 

operation system ：linux

Input:
1. Gene expression data: tumor and normal expression data, the data format is same as example
                        ('example_tumor.txt' and 'example_normal.txt',the patient's id in the two files must correspond).
2. Gene mutation data: the data format is same as example ('example_snp.txt' or 'example_cnv.by_genes')
3. Pathway data: the data format is same as example ('KEGG_pathways_network.xlsx'). 
                 
Run:
4. run main_PDPCST.m.

Output:
5. The output driver_symbol: the symbol of driver genes
              driver_rank: the ranking of each patient (column), 0 represents the gene is not driver in this patient and 
                           non-zero number is the ranking of the gene in a patient.
