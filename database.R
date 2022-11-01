# https://github.com/wcota/br_eleicoes_2022_2T/blob/main/br.csv

caminho <- "https://raw.githubusercontent.com/wcota/br_eleicoes_2022_2T/main/br.csv"
df_eleicoes_pr_2turno <- read.csv(caminho)

# save ddf
save(df_eleicoes_pr_2turno, file = "data.RData")