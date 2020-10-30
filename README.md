# QQ-plot operator

##### Description

The `qqplot_operator` is a template repository for the creation of R operators in Tercen.

##### Usage

Input projection|.
---|---
`y-axis`        | numeric, input values 
`x-axis`        | numeric, variable to compare to the first one, optional

Input parameters|.
---|---
`distribution`        | Distribution to compare to, if no x-axis is provided (either normal or uniform)

Output relations|.
---|---
`q_obs`        | observed quantiles (if no x-axis is provided)
`q_theo`        | theoretical quantiles (if no x-axis is provided)
`q_exp`        | expected quantiles (if no x-axis is provided)
`x`        | observed x quantiles (if an x-axis is provided)
`y`        | observed y quantiles (if an x-axis is provided)

##### Details

This operator is a wrapper of the `qqplot` [R function](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/qqnorm.html).

##### See Also

[histogram_operator](https://github.com/tercen/histogram_operator)

