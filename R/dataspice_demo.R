# metadata with dataspice demo
#
# Stuart Allen, 23/07/2020
#
# https://docs.ropensci.org/dataspice/
# https://github.com/ropenscilabs/dataspice
# https://orcid.org/

# dataspice needs to be installed from github:
# install.packages("devtools")
# devtools::install_github("ropenscilabs/dataspice")


library(tidyverse)
library(dataspice)


# dir containing data file(s)
dirData <- "data/vines"

# destination dir for metadata
dirMetadata <- "data/vines/metadata"

# process the data files and create metadata template files
create_spice(dirData)

# auto-fill column names into the attributes metadata table
prep_attributes(
  data_path = sprintf("%s/vines_site_plot.csv", dirData),
  attributes_path = sprintf("%s/attributes.csv", dirMetadata)
)

# helper functions to edit metadata tables via a Shiny app
# can also edit these tables manually
edit_creators(dirMetadata)
edit_biblio(dirMetadata)
edit_access(dirMetadata)
edit_attributes(dirMetadata)

write_spice(dirMetadata)

build_site(
  path = sprintf("%s/dataspice.json", dirMetadata),
  out_path = sprintf("%s/docs/index.html", dirData)
)
