# render website

# system("quarto render")

quarto::quarto_render()

# preview website

quarto::quarto_preview()

# publish to quarto

system("quarto publish quarto-pub")

# sort bibliography

library(RefManageR)

mybib <- ReadBib("globalfamilies.bib")

mybib <- sort(mybib, sorting = "nyt") # sort by name - year - title

WriteBib(mybib, file = "globalfamilies.bib")

