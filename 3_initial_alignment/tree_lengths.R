#!/usr/bin/env Rscript
# tree_length_violin.R
#
# Make a PDF (“tree_lengths_violin.pdf”) with violin plots of tree‑length
# distributions for two IQ‑TREE *.treefile collections.
#
# Usage (bash):
#   Rscript tree_length_violin.R                   # uses default filenames
#   Rscript tree_length_violin.R path/to/loci_mix.treefile path/to/loci_mf.treefile
#
# ---------------------------------------------------------------------------

# ---- 1.  Load packages ----
library(ape)
library(phangorn)
library(ggplot2)
library(dplyr)

# ---- 2.  File paths ----
args <- commandArgs(trailingOnly = TRUE)
file_mix <- if (length(args) >= 1) args[1] else "loci_mix.treefile"
file_mf  <- if (length(args) >= 2) args[2] else "loci_mf.treefile"

# ---- 3.  Helper: extract tree lengths ----
tree_lengths <- function(f, label) {
  trees <- read.tree(f)                  # phylo or multiPhylo
  if (inherits(trees, "phylo")) trees <- list(trees)
  tibble(
    dataset = label,
    length  = vapply(trees, \(tr) sum(tr$edge.length, na.rm = TRUE), numeric(1))
  )
}

# ---- 4.  Build data frame ----
df <- bind_rows(
  tree_lengths(file_mix, "MIX"),
  tree_lengths(file_mf,  "MF")
)

# ---- 5.  Plot & save ----
pdf("tree_lengths_violin.pdf", width = 6, height = 4)
ggplot(df, aes(dataset, length, fill = dataset)) +
  geom_violin() +
  geom_jitter(width = 0.12, size = 0.7, alpha = 0.5, colour = "black") +
  labs(x = NULL, y = "Tree length (sum of branch lengths)") +
  theme_minimal(base_size = 12) +
  theme(legend.position = "none")
dev.off()
