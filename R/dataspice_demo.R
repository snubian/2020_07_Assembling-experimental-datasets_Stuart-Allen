# metadata with dataspice quick & easy demo
#
# Stuart Allen, 30/07/2020
#
# https://docs.ropensci.org/dataspice/
# https://github.com/ropenscilabs/dataspice


# dataspice needs to be installed from github:
# install.packages("devtools")
# devtools::install_github("ropenscilabs/dataspice")


library(tidyverse)
library(dataspice)


# =====================================================================================
#
# specify the dir containing our data file(s)


dirData <- "data/vines"


# =====================================================================================
#
# process the data files and create blank metadata template files
#
#   - metadata are created in a dir named "metadata" within the data dir
#
#   - four metadata templates are created:
#       - access.csv        describe the file types, download URL
#       - attributes.csv    describe the variables in the dataset
#       - biblio.csv        project details, spatial and temporal coverage
#       - creators.csv      researcher contact details


create_spice(dirData)


# =====================================================================================
#
# prep_attributes() is a helper function to auto-fill column names into the attributes metadata table
#
#   - we need to specify the path to the data, and also the path to attributes.csv


prep_attributes(
  data_path = sprintf("%s/vines_site_plot.csv", dirData),
  attributes_path = sprintf("%s/metadata/attributes.csv", dirData)
)


# =====================================================================================
#
# we can choose to edit the metadata tables manually, but there are awesome helper functions
# that let us edit the via a Shiny app
#
#   - we just need to specify the metadata dir


dirMetadata <- sprintf("%s/metadata", dirData)


edit_creators(dirMetadata)
edit_biblio(dirMetadata)
edit_access(dirMetadata)
edit_attributes(dirMetadata)


# =====================================================================================
#
# once we've completed our metadata tables we can choose to have dataspice create for us
# a simple, self-contained HTML page that includes all of our metadata in a tidier format
#
#   - the first step is to call the write_spice() function, which generates a JSON file
#     containing our metadata in a standardised structure 
#
#   - N.B. the metadata CSV files need to be at least partially completed for this step


write_spice(dirMetadata)


#   - we then call build_site() which creates a HTML page in a specified dir


build_site(
  path = sprintf("%s/dataspice.json", dirMetadata),
  out_path = sprintf("%s/docs/index.html", dirData)
)

