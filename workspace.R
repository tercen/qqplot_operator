library(tercen)
library(dplyr)

options("tercen.workflowId" = "0add2df8c4543198d0b9ab7b55003e76")
options("tercen.stepId"     = "d732d42f-cb7d-4402-9639-ca768ccba766")

getOption("tercen.workflowId")
getOption("tercen.stepId")

qqp_exp <- function(df, distribution) {
  get_expected <- function (y, distri = distrib) {
    probs = c(0.25, 0.75)
    y <- quantile(y, probs, names = FALSE, na.rm = TRUE)
    x <- distri(probs)
    slope <- diff(y) / diff(x)
    int <- y[1L] - slope * x[1L]
    return(c(int, slope))
  }
  
  if(distribution == "normal") distrib <- qnorm
  if(distribution == "uniform") distrib <- qunif
  
  q_obs <- quantile(df$.y, probs = seq(0, 1, length.out = length(df$.y)), type = 7)
  q_theo <- distrib(ppoints(length(df$.y)))
  theo <- get_expected(q_obs)
  q_exp <- theo[1] + theo[2] * q_theo
  
  df_out <- data.frame(q_obs, q_theo, q_exp)
  df_out$.ci <- df$.ci[1]
  df_out$.ri <- df$.ri[1]
  return(df_out)
}

qqp <- function(df) {
  df_out <- as.data.frame(qqplot(df$.x, df$.y))
  df_out$.ci <- df$.ci[1]
  df_out$.ri <- df$.ri[1]
  return(df_out)
}  


ctx <- tercenCtx()

distribution <- "normal"
if(!is.null(ctx$op.value("distribution"))) distribution <- ctx$op.value("distribution")

if(ctx$hasXAxis | ctx$isPairwise) {
  ctx %>% 
    select(.x, .y, .ci, .ri) %>% 
    group_by(.ci, .ri) %>%
    do(qqp(.)) %>%
    ctx$addNamespace() %>%
    ctx$save()
} else {
  ctx %>% 
    select(.y, .ci, .ri) %>% 
    group_by(.ci, .ri) %>%
    do(qqp_exp(., distribution)) %>%
    ctx$addNamespace() %>%
    ctx$save()
}

