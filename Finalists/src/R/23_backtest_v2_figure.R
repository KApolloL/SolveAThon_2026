# 23_backtest_v2_figure.R: figures for the v2 award backtest (task E1). Reads only; edits no other file.
# Run from Finalists/src: Rscript R/23_backtest_v2_figure.R
# Input:  data/processed/backtest_v2_result.csv (written by 21_backtest_v2.R)
# Output: outs/figures/backtest_v2_pooled.png, backtest_v2_by_agency.png
#
# Pooling matches fact sheet rows 26 to 29: weight each agency by its won programs, 4-week windows,
# agencies with 3+ won programs. Random is the exact expected value from 21_backtest_v2.R.
# NOT HERE: the "in-time" line (catch with >= IN_TIME_DAYS before close). backtest_v2_result.csv has no
# in-time column, and 21_backtest_v2.R is Kent's file. Adding it needs a small change there (ask Kent).
# Limits (printed on the figures): exploratory, not the pre-set bar; program-level match favors repeat
# funding; award data never enters the score; small denominators; no notice-level award link exists.

here::i_am("src/R/23_backtest_v2_figure.R")
source(here::here("src", "R", "00_config.R"))
source(here::here("src", "R", "helpers_report.R"))
suppressPackageStartupMessages({ library(readr); library(dplyr); library(tidyr); library(ggplot2) })

res <- read_csv(file.path(DIR_PROCESSED, "backtest_v2_result.csv"), show_col_types = FALSE)
four <- res |> filter(window_weeks == 4, won_in_pool >= 3)
caption <- "Exploratory, not the pre-set bar. Program-level match favors repeat funding; award data never enters the score."

# ---- Figure 1: pooled recall at Top 10 / 20 / 50, model vs soonest-deadline vs random ----------
pooled <- four |> group_by(top_n) |>
  summarise(n_prog = sum(won_in_pool), model = sum(caught) / sum(won_in_pool),
            deadline = sum(deadline_pct * won_in_pool) / sum(won_in_pool),
            random = sum(random_pct * won_in_pool) / sum(won_in_pool), .groups = "drop")
print(as.data.frame(pooled |> mutate(across(c(model, deadline, random), \(x) round(x, 3)))))
long <- pooled |> pivot_longer(c(model, deadline, random), names_to = "method", values_to = "share") |>
  mutate(method = factor(method, levels = c("model", "deadline", "random"),
                         labels = c("Tool ranking", "Soonest deadline", "Random")),
         top_n = factor(top_n, labels = paste("Top", sort(unique(pooled$top_n)))))
p1 <- ggplot(long, aes(top_n, share, fill = method)) +
  geom_col(position = position_dodge(width = 0.75), width = 0.7) +
  geom_text(aes(label = scales::percent(share, accuracy = 1)), position = position_dodge(width = 0.75),
            vjust = -0.4, size = 3.8) +
  scale_fill_manual(values = c("Tool ranking" = FIG_COLORS$main, "Soonest deadline" = FIG_COLORS$muted,
                               "Random" = FIG_COLORS$accent)) +
  scale_y_continuous(limits = c(0, 1), labels = scales::percent) +
  labs(title = "Would the tool have surfaced programs NC agencies later won?",
       subtitle = paste0("Share of ", pooled$n_prog[1], " won programs (12 agencies with 3+, 4-week windows) that reach the list"),
       x = NULL, y = "Won programs reached", fill = NULL, caption = caption) +
  theme_finals() + theme(legend.position = "bottom")
export_figure(p1, "backtest_v2_pooled", width = 9, height = 5)

# ---- Figure 2: by agency, Top 10, with 95% interval and the two baselines ------------------------
a10 <- four |> filter(top_n == 10) |>
  mutate(lab = paste0(toupper(agency_id), " (", caught, "/", won_in_pool, ")"),
         lab = factor(lab, levels = lab[order(pct)]))
p2 <- ggplot(a10, aes(y = lab)) +
  geom_linerange(aes(xmin = ci_low, xmax = ci_high), color = FIG_COLORS$muted, linewidth = 1.2) +
  geom_point(aes(x = pct, color = "Tool ranking"), size = 3.5) +
  geom_point(aes(x = deadline_pct, color = "Soonest deadline"), shape = 15, size = 2.5) +
  geom_point(aes(x = random_pct, color = "Random"), shape = 17, size = 2.5) +
  geom_vline(xintercept = 0.5, linetype = "dashed", color = "grey40") +
  scale_color_manual(values = c("Tool ranking" = FIG_COLORS$main, "Soonest deadline" = "grey35",
                                "Random" = FIG_COLORS$accent)) +
  scale_x_continuous(limits = c(0, 1), labels = scales::percent) +
  labs(title = "By agency, Top 10, 4-week windows",
       subtitle = "Label = programs reached / won. Bar = 95% interval on the tool.\nDashed = 50% line (team judgment). Not a statewide number.",
       x = "Won programs reached", y = NULL, color = NULL, caption = caption) +
  theme_finals() + theme(legend.position = "bottom")
export_figure(p2, "backtest_v2_by_agency", width = 9, height = 5.5)
message("Limit: small denominators (1 to 38 programs per agency); intervals are wide. In-time line not drawn (see header).")
