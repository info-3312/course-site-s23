## prep_data.R
## Prep SCOTUS data

library(tidyverse)
library(here)

# read in data
scdb_leg <- here("exams/data/SCDB_Legacy_07_justiceCentered_Citation.csv") |>
  read_csv()
scdb_mod <- here("exams/data/SCDB_2022_01_justiceCentered_Citation.csv") |>
  read_csv()

scdb <- bind_rows(scdb_leg, scdb_mod)

# split data into justice-level and case-level
scdb_case <- select(scdb, caseId:minVotes, -voteId) |>
  distinct() |>
  write_csv(here("exams/data/scdb-case.csv"))
scdb_vote <- select(scdb, caseId:voteId, term, justice:secondAgreement) |>
  write_csv(here("exams/data/scdb-vote.csv"))
