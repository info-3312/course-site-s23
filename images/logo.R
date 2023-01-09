library(tidyverse)
library(here)
library(sf)
library(tidycensus)
library(colorspace)
library(scales)
library(showtext)
library(hexSticker)

set.seed(123)

font_add_google("Atkinson Hyperlegible")

# import ny state parks shapefile
# source: https://gis.ny.gov/gisdata/inventories/details.cfm?DSID=430
ny_parks <- st_read(dsn = here("images", "data", "oprhp18")) |>
  st_transform(crs = 3857) |>
  filter(Category == "State Park")

# calculate nps centroids
ny_centroids <- st_centroid(x = ny_parks)

# ny state counties
ny_counties <- get_acs(
  geography = "county",
  variables = "B01001_001E",
  state = "New York",
  geometry = TRUE
) |>
  st_transform(crs = 3857)

# ny state itself
ny_state <- get_acs(
  geography = "state",
  variables = "B01001_001E",
  state = "New York",
  geometry = TRUE
) |>
  st_transform(crs = 3857)

# interpolate grid on counties
ny_grid <- st_make_grid(
  x = ny_counties, n = c(200, 200),
  square = FALSE
) |>
  st_intersection(ny_counties) |>
  st_transform(crs = 3857)

# calculate great circle distance between national park centroids and counties
distance_to_park_centroid <- st_distance(
  x = ny_grid,
  y = ny_centroids
)

min_distance <- distance_to_park_centroid |>
  array_branch(margin = 1) |>
  map_dbl(.f = min)

p <- ny_grid |>
  st_as_sf() |>
  # minimum distance in miles
  mutate(min_distance = min_distance * 0.000621) %>%
  ggplot() +
  geom_sf(aes(fill = min_distance, color = min_distance)) +
  geom_sf(data = ny_counties, fill = NA, size = 0.1) +
  geom_sf(data = ny_state, fill = NA, size = 0.4) +
  # geom_sf(data = ny_parks, fill = sequential_hcl(n = 3, palette = "viridis", rev = TRUE)[[1]]) +
  scale_fill_continuous_sequential(
    name = "Distance\n(in miles)",
    palette = "viridis",
    aesthetics = c("fill", "color"),
    guide = "none"
  ) +
  theme_void()

# main site
sticker(
  # colors of sticker background/border
  h_color = "#6EB43F", h_fill = "#F7F7F7",
  # package name and formatting
  package = "INFO 3312/5312", p_color = "#006699",
  p_x = 1.175, p_y = 0.6, p_size = 13,
  p_family = "Atkinson Hyperlegible",
  p_fontface = "bold",
  # subplot
  subplot = p,
  s_x = 1, s_y = .8,
  s_width = 3.75, s_height = 3.75,
  white_around_sticker = TRUE,
  # save file
  filename = here("images", "logo.png")
)

# favicon
sticker(
  # colors of sticker background/border
  h_color = "#6EB43F", h_fill = "#F7F7F7",
  # package name and formatting
  package = NULL, p_color = "#FFFFFF",
  p_x = 1.175, p_y = 0.6, p_size = 13,
  p_family = "Atkinson Hyperlegible",
  p_fontface = "bold",
  # subplot
  subplot = p,
  s_x = 1, s_y = .8,
  s_width = 3.75, s_height = 3.75,
  white_around_sticker = TRUE,
  # save file
  filename = here("images", "favicon.png"),
  dpi = 90
)

