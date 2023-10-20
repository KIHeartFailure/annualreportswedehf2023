timefunc <- function(qi = qitmp, starttime = global_year - 5, stoptime = global_year, ll = lltmp, ul = ultmp,
                     data = rsdata, ylimmin = c(0, 100), onlyindex = FALSE, legplace = NULL) {
  tmp <- data %>%
    filter(indexyear %in% paste(seq(starttime, stoptime, 1)) &
      !is.na(!!sym(qi)))

  if (onlyindex) {
    tmp <- tmp %>%
      filter(ttype == "Index")

    byvar <- "vtype"
    #  if (is.null(legplace)) legplace <- c(1, 22)
  }
  if (!onlyindex) {
    byvar <- "ttype"
  }

  datafig <- tmp %>%
    filter(!is.na(!!sym(byvar))) %>%
    group_by(!!sym(byvar), indexyear, .drop = F) %>%
    count(!!sym(qi), .drop = F) %>%
    mutate(
      tot = sum(n),
      percent = n / tot * 100
    ) %>%
    ungroup() %>%
    filter(!!sym(qi) == 1) %>%
    filter(tot >= 10) %>%
    rename(unit = !!sym(byvar))

  p <- ggplot(datafig, aes(x = indexyear, y = percent, group = unit)) +
    geom_line(aes(col = unit), linewidth = 1.5) +
    geom_point(aes(col = unit), size = 3.5) +
    geom_hline(aes(yintercept = ll * 100, linetype = global_labnams[3]), col = global_colslimit[2]) +
    geom_hline(aes(yintercept = ul * 100, linetype = global_labnams[2]), col = global_colslimit[1]) +
    scale_colour_manual(values = global_cols) +
    # scale_linetype_manual(values = c(Prim = "solid", Target = "longdash")) +
    # scale_shape_manual(values = c(Prim = 16, Target = NA)) +
    # scale_linewidth_manual(values = c(Prim = 1.5, Target = 1)) +
    scale_linetype_manual(
      name = "limit", values = c("longdash", "longdash"), 
      guide = guide_legend(override.aes = list(color = global_colslimit[c(2, 1)]))
    ) +
    theme_classic() +
    theme(
      text = element_text(size = global_figfontsize),
      legend.position = "bottom",
      legend.box.margin = margin(c(0, 0, 0, 0)),
      legend.box = "vertical",
      legend.title = element_blank(),
      panel.grid.major.y = element_line(
        color = global_gridcolor,
        linewidth = 0.5,
        linetype = 1
      )
    ) +
    #guides(guide_legend(nrow = 2, byrow = F)) +
    # scale_y_discrete(expand(0, 1)) +
    scale_y_continuous(breaks = seq(0, 100, 10), limits = c(0, 100)) +
    labs(y = "Proportion (%)", x = "Year")
  p
}
