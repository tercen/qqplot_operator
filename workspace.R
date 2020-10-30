library(tercen)
library(dplyr)

options("tercen.workflowId" = "wwww")
options("tercen.stepId"     = "dddd")

getOption("tercen.workflowId")
getOption("tercen.stepId")

(ctx = tercenCtx())  %>% 
  select(.y, .ci, .ri) %>% 
  group_by(.ci, .ri) %>%
  summarise(median = median(.y)) %>%
  ctx$addNamespace() %>%
  ctx$save()
