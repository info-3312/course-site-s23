library(tidyverse)
library(rcis)
library(hexSticker)
library(here)

library(showtext)
font_add_google("Atkinson Hyperlegible", "atkinson")

p <- scorecard %>%
  mutate(type = fct_infreq(f = type)) %>%
  ggplot(mapping = aes(x = type, fill = type)) +
  geom_bar(color = NA) +
  scale_fill_manual(values = c("#073949", "#F8981D", "#6EB43F"), guide = "none") +
  annotate(
    geom = "text", label = "INFO 3312", x = 2, y = 1600, size = 4,
    family = "atkinson", fontface = "bold", color = "#006699"
  ) +
  # annotate(
  #   geom = "text", label = "5312", x = 2.15, y = 1400, size = 4,
  #   family = "atkinson", fontface = "bold", color = "#FFFFFF"
  # ) +
  # annotate(
  #   geom = "text", label = "Data Communication", fontface = "bold", x = 2, y = 1275,
  #   size = 3, color = "#FFFFFF", family = "atkinson"
  # ) +
  theme_void() +
  theme_transparent()

# main site
sticker(
  # colors of sticker background/border
  h_color = "#B31B1B", h_fill = "#FFFFFF",
  # package name and formatting
  package = "Data Communication", p_color = "#006699",
  p_x = 1, p_y = 1.32, p_size = 3,
  p_family = "Atkinson Hyperlegible",
  p_fontface = "bold",
  # subplot
  subplot = p,
  s_x = 1, s_y = 0.95,
  s_width = 1, s_height = 1.3,
  # save file
  filename = here("images", "logo.svg")
)

# favicon
p <- scorecard %>%
  mutate(type = fct_infreq(f = type)) %>%
  ggplot(mapping = aes(x = type, fill = type)) +
  geom_bar(color = NA) +
  scale_fill_manual(values = c("#073949", "#F8981D", "#6EB43F"), guide = "none") +
  # annotate(
  #   geom = "text", label = "INFO 3312", x = 2, y = 1600, size = 4,
  #   family = "atkinson", fontface = "bold", color = "#006699"
  # ) +
  # annotate(
  #   geom = "text", label = "5312", x = 2.15, y = 1400, size = 4,
  #   family = "atkinson", fontface = "bold", color = "#FFFFFF"
  # ) +
  # annotate(
  #   geom = "text", label = "Data Communication", fontface = "bold", x = 2, y = 1275,
  #   size = 3, color = "#FFFFFF", family = "atkinson"
  # ) +
  theme_void() +
  theme_transparent()

sticker(
  # colors of sticker background/border
  h_color = "#B31B1B", h_fill = "#FFFFFF",
  # package name and formatting
  package = NULL, p_color = "#006699",
  p_x = 1, p_y = 1.32, p_size = 3,
  p_family = "Atkinson Hyperlegible",
  p_fontface = "bold",
  # subplot
  subplot = p,
  s_x = 1, s_y = 0.95,
  s_width = 1, s_height = 1.3,
  # save file
  filename = here("images", "favicon.png"),
  dpi = 90
)
