library(tercen)
library(dplyr)

options("tercen.workflowId" = "wwww")
options("tercen.stepId"     = "dddd")

getOption("tercen.workflowId")
getOption("tercen.stepId")

qqp_exp <- function(df, distribution) {
  get_expected <- function (y, distri = distribution) {
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

qqp <- function(df, distribution) {
  df_out <- as.data.frame(qqplot(df$.x, df$.y))
  df_out$.ci <- df$.ci[1]
  df_out$.ri <- df$.ri[1]
  return(df_out)
}  
ctx <- tercenCtx()

distribution <- "normal"
if(!is.null(ctx$op.value("distribution"))) distribution <- ctx$op.value("distribution")

## if only one
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
    do(qqp_exp(.)) %>%
    ctx$addNamespace() %>%
    ctx$save()
}

## else compare x and y


