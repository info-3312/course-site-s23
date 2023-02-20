library(tidyverse)
library(rscorecard)
library(here)

# authenticate API token
sc_key(getOption("scorecard_token"))

# function to retrieve cornell percent of degrees by field
cornell_pct_program <- function(year){
  # generate API query
  scorecard_raw <- sc_init() %>%
    # only 4 year institutions
    sc_filter(unitid == 190415) %>%
    # select subset of variables based on data dictionary
    sc_select(
      PCIP01,
      PCIP03,
      PCIP04,
      PCIP05,
      PCIP09,
      PCIP10,
      PCIP11,
      PCIP12,
      PCIP13,
      PCIP14,
      PCIP15,
      PCIP16,
      PCIP19,
      PCIP22,
      PCIP23,
      PCIP24,
      PCIP25,
      PCIP26,
      PCIP27,
      PCIP29,
      PCIP30,
      PCIP31,
      PCIP38,
      PCIP39,
      PCIP40,
      PCIP41,
      PCIP42,
      PCIP43,
      PCIP44,
      PCIP45,
      PCIP46,
      PCIP47,
      PCIP48,
      PCIP49,
      PCIP50,
      PCIP51,
      PCIP52,
      PCIP54
    ) %>%
    # get latest observations
    sc_year(year) %>%
    # process query and store as tibble
    sc_get(return_json = TRUE)

  # extract results into data frame
  scorecard_tbl <- jsonlite::fromJSON(txt = scorecard_raw)$results

  # wrangle into tidy form
  scorecard_clean <- scorecard_tbl |>
    select(contains("academics.program")) |>
    pivot_longer(
      cols = everything(),
      names_to = c(".value", "variable"),
      names_sep = 5
    ) |>
    pivot_longer(
      col = -variable,
      names_to = "year",
      names_transform = parse_number,
      values_to = "pct"
    )

  return(scorecard_clean)
}


# get data for 2001-2020
cornell_degrees <- map_dfr(.x = 2001:2020, .f = cornell_pct_program, .progress = TRUE)
write_csv(x = cornell_degrees, file = here("application-exercises/data/cornell-degrees-raw.csv"))

# clean up
cornell_clean <- cornell_degrees |>
  # mutate(variable = str_remove(string = variable, pattern = "academics.program_percentage.")) |>
  rename(field_of_study = variable)

# keep only degree types in top six in 2020
cornell_lite <- cornell_clean |>
  filter(year == max(year)) |>
  slice_max(order_by = pct, n = 6) |>
  select(field_of_study) |>
  inner_join(y = cornell_clean)

cornell_lite |>
  # make wider for exercise
  pivot_wider(names_from = year, values_from = pct) |>
  write_csv(file = here("application-exercises/data/cornell-degrees.csv"))
