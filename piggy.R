### TESTANDO PIGGY

library(piggyback)

### SUBINDO: 

piggyback::pb_new_release(repo = "BIT-Analytics/eleicoes_pr_2022", 
                          tag = "v0.0.0")

# UPLOAD
# pb_upload("dados/dadosPNAD.RDS", repo = "BIT-Analytics/eleicoes_pr_2022")

pb_download("dados/dadosPNAD.RDS", repo = "BIT-Analytics/eleicoes_pr_2022")