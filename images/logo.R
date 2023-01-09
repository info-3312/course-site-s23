library(tidyverse)
library(rcis)
library(hexSticker)
library(here)
library(showtext)
library(colorspace)

set.seed(123)

font_add_google("Atkinson Hyperlegible")
# showtext_auto()

# use bechdel dataset
bechdel_samp <- bechdel |>
  # collapse genre into 5 categories
  mutate(genre = fct_lump_n(f = genre, n = 3)) |>
  slice_sample(n = 25) |>
  # ensure observations do not fall outside of sticker border
  filter(imdb_rating > 5.5)

# generate scatterplot
p <- ggplot(data = bechdel_samp, mapping = aes(x = metascore, y = imdb_rating)) +
  geom_point(mapping = aes(color = genre)) +
  geom_smooth(method = "lm", color = "#9FAD9F", se = FALSE) +
  colorblindr::scale_color_OkabeIto(guide = "none") +
  ylim(c(5, NA)) +
  theme_void() +
  theme_transparent()

# main site
sticker(
  # colors of sticker background/border
  h_color = "#B31B1B", h_fill = "#F7F7F7",
  # package name and formatting
  package = "INFO 2950", p_color = "#222222",
  p_x = .8, p_y = 1.3, p_size = 5,
  p_family = "Atkinson Hyperlegible",
  p_fontface = "bold",
  # subplot
  subplot = p,
  s_x = 1, s_y = .8,
  s_width = 1.75, s_height = 1.75,
  # save file
  filename = here("images", "logo.svg")
)

# slides
sticker(
  # colors of sticker background/border
  h_color = "#B31B1B", h_fill = "#F7F7F7",
  # package name and formatting
  package = "INFO 2950", p_color = "#222222",
  p_x = .8, p_y = 1.3, p_size = 5,
  p_family = "Atkinson Hyperlegible",
  p_fontface = "bold",
  # subplot
  subplot = p,
  s_x = 1, s_y = .8,
  s_width = 1.75, s_height = 1.75,
  # save file
  filename = here("slides", "images", "logo.svg")
)

# favicon
sticker(
  # colors of sticker background/border
  h_color = "#B31B1B", h_fill = "#F7F7F7",
  # package name and formatting
  package = NULL, p_color = "#222222",
  p_x = .8, p_y = 1.3, p_size = 5,
  p_family = "Atkinson Hyperlegible",
  p_fontface = "bold",
  # subplot
  subplot = p,
  s_x = 1, s_y = .8,
  s_width = 1.75, s_height = 1.75,
  # save file
  filename = here("images", "favicon.png"),
  dpi = 90
)
