# sort bibliography

library(RefManageR)

mybib <- ReadBib("references.bib")

mybib <- sort(mybib, sorting = "nyt") # sort by name - year - title

WriteBib(mybib, file = "references.bib")

