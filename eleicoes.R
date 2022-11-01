# projeto inicial

# https://github.com/wcota/br_eleicoes_2022_2T/blob/main/br.csv

caminho <- "https://raw.githubusercontent.com/wcota/br_eleicoes_2022_2T/main/br.csv"
df_eleicoes_pr_2turno <- read.csv(caminho)

# save ddf
save(df_eleicoes_pr_2turno, file = "dados/df.RData")


# grafico ----
# arquivo
load("data.RData")

# pacotes
library(echarts4r)
library(tidyverse)

df <- df_eleicoes_pr_2turno |> 
  dplyr::select(date_totalizacao, cand, votos, porcentagem_votos) |> 
  dplyr::mutate(chack = paste(date_totalizacao, cand)) |> 
  dplyr::distinct(chack, .keep_all = T) |> 
  dplyr::select(-chack) |> 
  # tidyr::pivot_wider(names_from = cand, values_from = votos) |> 
  dplyr::mutate(date_totalizacao = ifelse(date_totalizacao == " ",
                                          "2022-10-30 17:00:00",
                                          date_totalizacao),
                date_totalizacao = lubridate::ymd_hms(date_totalizacao))


# axis
label_js2 <- list(
  formatter = htmlwidgets::JS(
    "function(value, index, precision = 2){
    const abbrev = ['', 'K', 'M', 'B', 'T'];
    const unrangifiedOrder = Math.floor(Math.log10(Math.abs(value)) / 3)
    const order = Math.max(0, Math.min(unrangifiedOrder, abbrev.length -1 ))
    const suffix = abbrev[order];
    return (((value / Math.pow(10, order * 3)).toFixed(2) + suffix))
                               }"
  )
)




p1 <- df |> 
  # dplyr::filter(date_totalizacao < 
  #                 lubridate::ymd_hms("2022-10-30 22:57:09")) |> 
  dplyr::filter(date_totalizacao < 
                  lubridate::ymd_hms("2022-10-30 20:00:00")) |> 
  dplyr::group_by(cand) |> 
  e_charts(date_totalizacao) |> 
  e_line(votos, symbol = "none",
         endLabel = list(show = T,
                         formatter =  htmlwidgets::JS(
                           "function(params, precision = 2){
    const abbrev = ['', 'K', 'M', 'B', 'T'];
    const unrangifiedOrder = Math.floor(Math.log10(Math.abs(params.value[1])) / 3)
    const order = Math.max(0, Math.min(unrangifiedOrder, abbrev.length -1 ))
    const suffix = abbrev[order];
    return (((params.value[1] / Math.pow(10, order * 3)).toFixed(2) + suffix))
                               }"
                         )),
         lineStyle = list(width = 4, opacity = 0.7),
         emphasis = list(focus = 'series',
           itemStyle = list(shadowBlur = 2))) |> 
  e_y_axis(axisLabel = label_js2, 
           interval = 8000000, max = 64000000) |> 
  e_datazoom(x_index = 0,
             type = "slider", 
             toolbox = FALSE,
             bottom = 5) |> 
  e_datazoom(y_index = 0, type = "slider") |> 
  e_animation(duration = 1000) |> 
  e_tooltip(
    formatter = htmlwidgets::JS(
      "function (params) {
          return params.value[3] + ': ' + params.value[0];
        }"
    )) |> 
  e_title("2º Turno 2022") |> 
  e_theme("infographic")
p1  


p2 <- df |> 
  # dplyr::filter(date_totalizacao < 
  #                 lubridate::ymd_hms("2022-10-30 22:57:09"),
  #               porcentagem_votos != 0) |> 
  dplyr::filter(date_totalizacao < 
                  lubridate::ymd_hms("2022-10-30 20:00:09"),
                porcentagem_votos != 0) |> 
  dplyr::group_by(cand) |> 
  e_charts(date_totalizacao) |> 
  e_line(porcentagem_votos, symbol = "none",
         endLabel = list(show = T,
                         formatter =  htmlwidgets::JS(
                           "function(params, precision = 2){
    const abbrev = ['', 'K', 'M', 'B', 'T'];
    const unrangifiedOrder = Math.floor(Math.log10(Math.abs(params.value[1])) / 3)
    const order = Math.max(0, Math.min(unrangifiedOrder, abbrev.length -1 ))
    const suffix = abbrev[order];
    return (((params.value[1] / Math.pow(10, order * 3)).toFixed(2) + suffix))
                               }"
                         )),
    lineStyle = list(width = 4, opacity = 0.7),
    emphasis = list(focus = 'series',
                    itemStyle = list(shadowBlur = 2))) |> 
  e_y_axis(axisLabel = label_js2, 
           interval = 2, max = 65, min = 40) |> 
  e_datazoom(x_index = 0,
             type = "slider", 
             toolbox = FALSE,
             bottom = 5) |> 
  e_datazoom(y_index = 0, type = "slider") |> 
  e_animation(duration = 1000) |> 
  e_tooltip(
    formatter = htmlwidgets::JS(
      "function (params) {
          return params.value[3] + ': ' + params.value[0];
        }"
    )) |> 
  e_title("2º Turno 2022 - % votos") |> 
  e_theme("infographic")
p2




e_arrange(p1, p2, rows = 2, cols = 1)
