clc
clear
%   $Id: main_PDGPCS.m Created at 2021-5-30 16:00 $
%   by Zhennan Wang, Northwestern Polytechtical University, China
%   Copyright (c) 2018-2021 by Key Laboratory of Information Fusion Technology of 
%   Ministry of Education in Northwestern Polytechnical University.  
%   If any problem, please contact atuzaiwang@163.com for help.


%*******************default network inforamtion
[~,ppi] = xlsread('string_network.xlsx');  % node : 11289 , edge : 273210

%***** expression data, mutation data and pathway data *******************
expression_tumor = 'example_tumor.txt';
expression_normal = 'example_normal.txt';
cnv_fileName = 'example_cnv.txt';
snv_fileName = 'example_snv.txt';

pathway_net = importdata('KEGG_pathways_network.xlsx');
pathway.pathway_name = pathway_net(2:end,3);
pathway.pathway_id = unique(pathway.pathway_name);
pathway.pathway_gene_all = pathway_net(2:end,1:2);


[cohort_driver_rank,personalized_driver_rank] = ...
                    PDGPCS(ppi,expression_normal,expression_tumor,cnv_fileName,snv_fileName,pathway);










