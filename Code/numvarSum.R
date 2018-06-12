# numvarSum function ----------------------------------------------
# this summarizes a numerical variable (n, na(missing, mean, median, sd,
# variance, min, max, and se) when given a data frame or tibble and
# variable: q14_rpt_fun(df, var)

numvarSum <- function(df, expr) {
  expr <- enquo(expr) # turns expr into a quosure
  summarise(df,
          n = sum((!is.na(!!expr))), # non-missing
          na = sum((is.na(!!expr))), # missing
          mean = mean(!!expr, na.rm = TRUE), # unquotes mean()
          median = median(!!expr, na.rm = TRUE), # unquotes median()
          sd = sd(!!expr, na.rm = TRUE), # unquotes sd()
          variance = var(!!expr, na.rm = TRUE), # unquotes var()
          min = min(!!expr, na.rm = TRUE), # unquotes min()
          max = max(!!expr, na.rm = TRUE), # unquotes max()
          se = sd/sqrt(n)) # standard error
}
