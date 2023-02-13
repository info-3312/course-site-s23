---
format: html
---

## `data-wrangling-i` - live-coding guide

1. Open RStudio in a new project
2. Create a new R script or Quarto document
3. Import `scdb_cases`

```r
scdb_case <- read_csv("https://info3312.infosci.cornell.edu/slides/data/scdb-case.csv")
```

4. Select relevant columns for viewing purposes

```r
scdb_case |>
  # select relevant columns
  select(term, majVotes, minVotes)
```

4. Filter data

```r
scdb_case |>
  # select relevant columns
  select(term, majVotes, minVotes) |>
  # filter to include post 1945 term cases
  filter(term >= 1945) |>
```

5. Calculate vote margin variable

```r
scdb_case |>
  # select relevant columns
  select(term, majVotes, minVotes) |>
  # filter to include post 1945 term cases
  filter(term >= 1945) |>
  # calculate vote margin for each case
  mutate(vote_margin = majVotes - minVotes)
```

6. Calculate number of cases decided per term and vote margin

```r
scdb_case |>
  # select relevant columns
  select(term, majVotes, minVotes) |>
  # filter to include post 1945 term cases
  filter(term >= 1945) |>
  # calculate vote margin for each case
  mutate(vote_margin = majVotes - minVotes) |>
  # calculate number of cases decided per term and vote margin
  count(term, vote_margin)
```

7. Calculate percentages by term

```r
scdb_case |>
  # select relevant columns
  select(term, majVotes, minVotes) |>
  # filter to include post 1945 term cases
  filter(term >= 1945) |>
  # calculate vote margin for each case
  mutate(vote_margin = majVotes - minVotes) |>
  # calculate number of cases decided per term and vote margin
  count(term, vote_margin) |>
  # calculate percentages by term
  group_by(term) |>
  mutate(
    n_pct = n / sum(n)
  )
```

8. Generate basic plot

```r
scdb_case |>
  # select relevant columns
  select(term, majVotes, minVotes) |>
  # filter to include post 1945 term cases
  filter(term >= 1945) |>
  # calculate vote margin for each case
  mutate(vote_margin = majVotes - minVotes) |>
  # calculate number of cases decided per term and vote margin
  count(term, vote_margin) |>
  # calculate percentages by term
  group_by(term) |>
  mutate(
    n_pct = n / sum(n)
  ) |>
  # generate graph
  ggplot(mapping = aes(x = term, y = n_pct, fill = vote_margin)) +
  geom_area()
```

9. Need to convert `vote_margin` to factor

```r
scdb_case |>
  # select relevant columns
  select(term, majVotes, minVotes) |>
  # filter to include post 1945 term cases
  filter(term >= 1945) |>
  # calculate vote margin for each case
  mutate(vote_margin = majVotes - minVotes) |>
  # calculate number of cases decided per term and vote margin
  count(term, vote_margin) |>
  # calculate percentages by term
  group_by(term) |>
  mutate(
    n_pct = n / sum(n),
    # convert vote_margin to factor variable for plotting
    vote_margin = factor(x = vote_margin)
  ) |>
  # generate graph
  ggplot(mapping = aes(x = term, y = n_pct, fill = vote_margin)) +
  geom_area()
```

10. Why not adding up to 1? Check data frame for gaps. Need complete combinations of `term` and `vote_margin`

```r
scdb_case |>
  # select relevant columns
  select(term, majVotes, minVotes) |>
  # filter to include post 1945 term cases
  filter(term >= 1945) |>
  # calculate vote margin for each case
  mutate(vote_margin = majVotes - minVotes) |>
  # calculate number of cases decided per term and vote margin
  count(term, vote_margin) |>
  # calculate percentages by term
  group_by(term) |>
  mutate(
    n_pct = n / sum(n),
    # convert vote_margin to factor variable for plotting
    vote_margin = factor(x = vote_margin)
  )
```

11. Fill in missing combos with `tidyr::complete()`

```r
scdb_case |>
  # select relevant columns
  select(term, majVotes, minVotes) |>
  # filter to include post 1945 term cases
  filter(term >= 1945) |>
  # calculate vote margin for each case
  mutate(vote_margin = majVotes - minVotes) |>
  # fill in all the missing combination of rows - plot won't look right otherwise
  complete(term, vote_margin, fill = list(n = 0)) |>
  # calculate number of cases decided per term and vote margin
  count(term, vote_margin) |>
  # calculate percentages by term
  group_by(term) |>
  mutate(
    n_pct = n / sum(n),
    # convert vote_margin to factor variable for plotting
    vote_margin = factor(x = vote_margin)
  ) |>
  # generate graph
  ggplot(mapping = aes(x = term, y = n_pct, fill = vote_margin)) +
  geom_area()
```

12. Add color to area borders. Label the y-axis

```r
scdb_case |>
  # select relevant columns
  select(term, majVotes, minVotes) |>
  # filter to include post 1945 term cases
  filter(term >= 1945) |>
  # calculate vote margin for each case
  mutate(vote_margin = majVotes - minVotes) |>
  # fill in all the missing combination of rows - plot won't look right otherwise
  complete(term, vote_margin, fill = list(n = 0)) |>
  # calculate number of cases decided per term and vote margin
  count(term, vote_margin) |>
  # calculate percentages by term
  group_by(term) |>
  mutate(
    n_pct = n / sum(n),
    # convert vote_margin to factor variable for plotting
    vote_margin = factor(x = vote_margin)
  ) |>
  # generate graph
  ggplot(mapping = aes(x = term, y = n_pct, fill = vote_margin)) +
  geom_area(color = "cornsilk4") +
  # print the y-axis labels using percentages rather than proportions
  scale_y_continuous(labels = label_percent())
```

13. Use appropriate color palette

```r
scdb_case |>
  # select relevant columns
  select(term, majVotes, minVotes) |>
  # filter to include post 1945 term cases
  filter(term >= 1945) |>
  # calculate vote margin for each case
  mutate(vote_margin = majVotes - minVotes) |>
  # fill in all the missing combination of rows - plot won't look right otherwise
  complete(term, vote_margin, fill = list(n = 0)) |>
  # calculate number of cases decided per term and vote margin
  count(term, vote_margin) |>
  # calculate percentages by term
  group_by(term) |>
  mutate(
    n_pct = n / sum(n),
    # convert vote_margin to factor variable for plotting
    vote_margin = factor(x = vote_margin)
  ) |>
  # generate graph
  ggplot(mapping = aes(x = term, y = n_pct, fill = vote_margin)) +
  geom_area(color = "cornsilk4") +
  # print the y-axis labels using percentages rather than proportions
  scale_y_continuous(labels = label_percent()) +
  # change the color palette
  scale_fill_viridis_d()
```

14. Change order of stack using `fct_rev()`

```r
scdb_case |>
  # select relevant columns
  select(term, majVotes, minVotes) |>
  # filter to include post 1945 term cases
  filter(term >= 1945) |>
  # calculate vote margin for each case
  mutate(vote_margin = majVotes - minVotes) |>
  # fill in all the missing combination of rows - plot won't look right otherwise
  complete(term, vote_margin, fill = list(n = 0)) |>
  # calculate number of cases decided per term and vote margin
  count(term, vote_margin) |>
  # calculate percentages by term
  group_by(term) |>
  mutate(
    n_pct = n / sum(n),
    # convert vote_margin to factor variable for plotting
    vote_margin = factor(x = vote_margin),
    vote_margin = fct_rev(f = vote_margin)
  ) |>
  # generate graph
  ggplot(mapping = aes(x = term, y = n_pct, fill = vote_margin)) +
  geom_area(color = "cornsilk4") +
  # print the y-axis labels using percentages rather than proportions
  scale_y_continuous(labels = label_percent()) +
  # change the color palette
  scale_fill_viridis_d()
```

15. Label the plot and color the subtitle and caption

```r
scdb_case |>
  # select relevant columns
  select(term, majVotes, minVotes) |>
  # filter to include post 1945 term cases
  filter(term >= 1945) |>
  # calculate vote margin for each case
  mutate(vote_margin = majVotes - minVotes) |>
  # fill in all the missing combination of rows - plot won't look right otherwise
  complete(term, vote_margin, fill = list(n = 0)) |>
  # calculate number of cases decided per term and vote margin
  count(term, vote_margin) |>
  # calculate percentages by term
  group_by(term) |>
  mutate(
    n_pct = n / sum(n),
    # convert vote_margin to factor variable for plotting
    vote_margin = factor(x = vote_margin),
    vote_margin = fct_rev(f = vote_margin)
  ) |>
  # generate graph
  ggplot(mapping = aes(x = term, y = n_pct, fill = vote_margin)) +
  geom_area(color = "cornsilk4") +
  # print the y-axis labels using percentages rather than proportions
  scale_y_continuous(labels = label_percent()) +
  # change the color palette
  scale_fill_viridis_d() +
  # label our graph
  labs(
    title = "U.S. Supreme Court decisionmaking since 1945",
    subtitle = "Split between majority and minority justice votes",
    x = "Term",
    y = "Percent of total cases decided",
    fill = "Vote margin",
    caption = "Source: The Supreme Court Database"
  ) +
  # match subtitle and caption colors to area borders
  theme(
    plot.subtitle = element_text(color = "cornsilk4"),
    plot.caption = element_text(color = "cornsilk4")
  )
```


