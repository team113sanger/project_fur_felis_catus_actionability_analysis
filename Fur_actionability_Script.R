#1st_Feb_2025. The aim of this script is to use data from OncoKB downloaded in late Jan 25 to identify if there might be drugs targeting "Fur" driver genes. 
#The Fur driver list comes from Louise on the 15th Feb 25. 

library(tidyverse)
library(readxl)


#Import dataframes

#The file below is a file that associates genes and drugs. It comes via OnkoKB. https://www.oncokb.org/
oncokb_biomarker_drug_associations <- read_delim("data/oncokb_biomarker_drug_associations.tsv", 
                                                 delim = "\t", escape_double = FALSE, 
                                                 trim_ws = TRUE)

#This file is from Louise. Late Jan 2025. 

FINAL_list_of_FUR_driver_genes_15th_Feb_25 <- read_excel("data/FELINE_FUR_DRIVER_GENES_unique_list.xlsx")
Feline_FUR_driver_gene_list_for_Dave <- FINAL_list_of_FUR_driver_genes_15th_Feb_25

#Select the genes against which to search the OncoKB dataframe. 

Feline_FUR_driver_genes <- Feline_FUR_driver_gene_list_for_Dave |> filter(!is.na(`Gene name`)) |>
  select(`Gene name`)

onkoKB_Fur_List <- oncokb_biomarker_drug_associations |> filter(oncokb_biomarker_drug_associations$Gene %in% Feline_FUR_driver_genes$`Gene name`)


onkoKB_Fur_List_filter <- onkoKB_Fur_List |> filter(Level == 1 | Level == 2 | Level == 3 | Level == 4)

write.csv(onkoKB_Fur_List_filter, "onkoKB_Fur_List_filter.csv")

#################################

#Import data from the Pharos database: https://pharos.nih.gov/. This dataframe was also used for Vicky's actionability analysis. 
query_results_Pharos <- read_csv("data/query_results(Pharos_download_26_10_24).csv")

#The list of genes is held in the variable: Feline_FUR_driver_genes

Feline_FUR_driver_genes_distinct <- Feline_FUR_driver_genes |> distinct()

pharos_Fur <- query_results_Pharos |> filter(query_results_Pharos$Symbol %in% Feline_FUR_driver_genes_distinct$`Gene name`)

length(setdiff(Feline_FUR_driver_genes$`Gene name`, query_results_Pharos$Symbol))
# Only 1 genes is on the Feline_FUR_driver_genes$`Gene name` list that is not on the query_results_Pharos$Symbol list. 
# This is not actually a "gene" there was a "-" in the file. So the overlap is 100%. 

write.csv(Feline_FUR_driver_genes_distinct, "Feline_FUR_driver_genes_distinct.csv")
write.csv(pharos_Fur, "pharos_Fur.csv")

#A systematic analysis of the landscape of synthetic lethality-driven precision oncology. PMID: 38218178

#Import the data file. 

Schaffer <- read_excel("data/1-s2.0-S2666634023004075-mmc2.xlsx")

Schaffer_Fur <- Schaffer |> filter(Schaffer$mut_gene %in% Feline_FUR_driver_genes_distinct$`Gene name`)

write.csv(Schaffer_Fur, "Schaffer_Fur.csv")


#################################

#COSMIC Actionability analysis. 
#provided by Ian in Feb 2025. 

#Import data 

Actionability <- read_delim("data/Actionability_AllData_v14_GRCh37.tsv", 
                            delim = "\t", escape_double = FALSE, 
                            trim_ws = TRUE)

Actionability_Fur <- Actionability |> filter(Actionability$GENE %in% Feline_FUR_driver_genes_distinct$`Gene name`)

write.csv(Actionability_Fur, "Actionability_Fur.csv")
