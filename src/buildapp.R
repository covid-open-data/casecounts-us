suppressPackageStartupMessages(library(casecountapp))

sources_country <- source_list(
  source_entry(source_id = "JHU", admin_level = 0,
    file = "https://raw.githubusercontent.com/covid-open-data/xform-casecount-us-jhu/master/output/admin0/US.csv"),
  source_entry(source_id = "NYT", admin_level = 0,
    file = "https://raw.githubusercontent.com/covid-open-data/xform-casecount-us-nytimes/master/output/admin0/US.csv"),
  source_entry(source_id = "FACTS", admin_level = 0,
    file = "https://raw.githubusercontent.com/covid-open-data/xform-casecount-us-usafacts/master/output/admin0/US.csv")
)

sources_state <- source_list(
  source_entry(source_id = "JHU", admin_level = 1,
    file = "https://raw.githubusercontent.com/covid-open-data/xform-casecount-us-jhu/master/output/admin1/US.csv"),
  source_entry(source_id = "NYT", admin_level = 1,
    file = "https://raw.githubusercontent.com/covid-open-data/xform-casecount-us-nytimes/master/output/admin1/US.csv"),
  source_entry(source_id = "FACTS", admin_level = 1,
    file = "https://raw.githubusercontent.com/covid-open-data/xform-casecount-us-usafacts/master/output/admin1/US.csv")
)

sources_county <- source_list(
  source_entry(source_id = "JHU", admin_level = 2,
    file = "https://raw.githubusercontent.com/covid-open-data/xform-casecount-us-jhu/master/output/admin2/US.csv"),
  source_entry(source_id = "NYT", admin_level = 2,
    file = "https://raw.githubusercontent.com/covid-open-data/xform-casecount-us-nytimes/master/output/admin2/US.csv"),
  source_entry(source_id = "FACTS", admin_level = 2,
    file = "https://raw.githubusercontent.com/covid-open-data/xform-casecount-us-usafacts/master/output/admin2/US.csv")
)

timestamp <- Sys.time()
time_str <- format(timestamp, "%Y-%m-%d %H:%M %Z", tz = "UTC")

app <- register_app("US-Covid19", path = "docs")

message("Creating country-level display...")

country_display <- build_casecount_display(
  app,
  sources = sources_country,
  ref_source = "NYT",
  name = "United States",
  desc = paste0("Covid-19 cases and deaths in the US - updated ", time_str),
  state = list(labels = list("view_states")),
  geo_links = geo_link_filter(
    display = "States",
    variable = "admin0_name",
    ref_level = "states"
  ),
  # max_date = as.Date("2020-06-17"),
  min_date = as.Date("2020-03-01"),
  order = 1,
  nrow = 1,
  ncol = 1,
  case_fatality_max = 12,
  thumb = system.file("thumbs/US/country.png", package = "casecountapp")
)

message("Creating state-level display...")

state_display <- build_casecount_display(
  app,
  sources = sources_state,
  ref_source = "NYT",
  name = "States",
  desc = paste0("Covid-19 cases and deaths in the US by state - updated ", time_str),
  views = default_views(
    ref_source = "NYT", comp_sources = c("JHU", "FACTS"), entity_pl = "states"),
  state = list(
    sort = list(trelliscopejs::sort_spec("cur_case_nyt", dir = "desc")),
    labels = list("view_counties"), sidebar = 4),
  geo_links = geo_link_filter(
    display = "Counties",
    variable = "admin1_name",
    ref_level = "counties"
  ),
  order = 2,
  # max_date = as.Date("2020-06-17"),
  min_date = as.Date("2020-03-01"),
  case_fatality_max = 12,
  thumb = system.file("thumbs/US/states.png", package = "casecountapp")
)

message("Creating county-level display...")

county_display <- build_casecount_display(
  app,
  sources = sources_county,
  ref_source = "NYT",
  name = "Counties",
  desc = paste0("Covid-19 cases and deaths in the US by county - updated ",
    time_str),
  views = default_views(
    ref_source = "NYT", comp_sources = c("JHU", "FACTS"), entity_pl = "states"),
  state = list(
    sort = list(trelliscopejs::sort_spec("cur_case_nyt", dir = "desc")),
    labels = list(), sidebar = 4),
  append_higher_admin_name = TRUE,
  order = 3,
  # max_date = as.Date("2020-06-17"),
  min_date = as.Date("2020-03-01"),
  case_fatality_max = 12,
  thumb = system.file("thumbs/US/counties.png", package = "casecountapp")
)

# deploy_netlify(app, Sys.getenv("NETLIFY_APP_ID"))
