suppressPackageStartupMessages(library(casecountapp))

sources_country <- list(
  list(source_id = "JHU", admin_level = 0,
    file = "https://raw.githubusercontent.com/covid-open-data/xform-casecount-us-jhu/master/output/admin0/US.csv"),
  list(source_id = "NYT", admin_level = 0,
    file = "https://raw.githubusercontent.com/covid-open-data/xform-casecount-us-nytimes/master/output/admin0/US.csv"),
  list(source_id = "FACTS", admin_level = 0,
    file = "https://raw.githubusercontent.com/covid-open-data/xform-casecount-us-usafacts/master/output/admin0/US.csv")
)

sources_state <- list(
  list(source_id = "JHU", admin_level = 1,
    file = "https://raw.githubusercontent.com/covid-open-data/xform-casecount-us-jhu/master/output/admin1/US.csv"),
  list(source_id = "NYT", admin_level = 1,
    file = "https://raw.githubusercontent.com/covid-open-data/xform-casecount-us-nytimes/master/output/admin1/US.csv"),
  list(source_id = "FACTS", admin_level = 1,
    file = "https://raw.githubusercontent.com/covid-open-data/xform-casecount-us-usafacts/master/output/admin1/US.csv")
)

sources_county <- list(
  list(source_id = "JHU", admin_level = 2,
    file = "https://raw.githubusercontent.com/covid-open-data/xform-casecount-us-jhu/master/output/admin2/US.csv"),
  list(source_id = "NYT", admin_level = 2,
    file = "https://raw.githubusercontent.com/covid-open-data/xform-casecount-us-nytimes/master/output/admin2/US.csv"),
  list(source_id = "FACTS", admin_level = 2,
    file = "https://raw.githubusercontent.com/covid-open-data/xform-casecount-us-usafacts/master/output/admin2/US.csv")
)

timestamp <- Sys.time()
time_str <- format(timestamp, "%Y-%m-%d %H:%M %Z", tz = "UTC")

dir.create("dist", showWarning = FALSE)
app <- register_app("US-Covid19", path = "docs")

country_display <- build_casecount_display(
  app,
  sources = sources_country,
  ref_source = "NYT",
  name = "United States",
  desc = paste0("Covid-19 cases and deaths in the US - updated ", time_str),
  state = list(labels = list("view_states")),
  geo_links = list(list(
    display = "States",
    variable = "admin0_name",
    cog_type = "cog_disp_filter",
    ref_level = "states",
    type = "href"
  )),
  order = 1,
  nrow = 1,
  ncol = 1,
  case_fatality_max = 12,
  thumb = system.file("thumbs/US/country.png", package = "casecountapp")
)

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
  geo_links = list(list(
    display = "Counties",
    variable = "admin1_name",
    cog_type = "cog_disp_filter",
    ref_level = "counties",
    type = "href"
  )),
  order = 2,
  case_fatality_max = 12,
  thumb = system.file("thumbs/US/states.png", package = "casecountapp")
)

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
  case_fatality_max = 12,
  thumb = system.file("thumbs/US/counties.png", package = "casecountapp")
)

# deploy_netlify(app, Sys.getenv("NETLIFY_APP_ID"))
