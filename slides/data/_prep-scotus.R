## prep_data.R
## Prep SCOTUS data

library(tidyverse)
library(here)

# read in data
scdb_leg <- here("slides/data/SCDB_Legacy_07_justiceCentered_Citation.csv") |>
  read_csv()
scdb_mod <- here("slides/data/SCDB_2022_01_justiceCentered_Citation.csv") |>
  read_csv()

scdb <- bind_rows(scdb_leg, scdb_mod)

# split data into justice-level and case-level
scdb_case <- select(scdb, caseId:minVotes, -voteId) |>
  distinct() |>
  # drop NAs for majVotes or minVotes for wrangling-i exercise
  drop_na(majVotes, minVotes) |>
  write_csv(here("slides/data/scdb-case.csv"))
scdb_vote <- select(scdb, caseId:voteId, term, justice:secondAgreement) |>
  write_csv(here("slides/data/scdb-vote.csv"))
