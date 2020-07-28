# 2020_07_Assembling-experimental-datasets_Stuart-Allen

## Workshop description

For a researcher, data is a valuable resource - especially if you have gone to the time and expense of collecting it yourself. Assembling datasets from your experiments is a crucial step towards answering your research questions. A well-constructed dataset makes analysis easier and increases the future utility of your data. This workshop will cover the nuts and bolts of assembling a dataset - a topic relevant to students and experienced researchers alike. Using relevant R functions and packages we will look at how to avoid common pitfalls, and how to implement assertive data validation to keep your data shipshape.

## Code

#### `R/assertr_demo.R`

Demonstration of the `assertr` package for data validation.

#### `R/dataspice_demo.R`

Demonstration of the `dataspice` package for quick and easy creation of lightweight metadata.

**Note:** The `dataspice` package must be installed from GitHub, so you'll need to first install the `devtools` package:

``` r
#install.packages("devtools")
devtools::install_github("ropenscilabs/dataspice")
```

See the [dataspice GitHub repository](https://github.com/ropenscilabs/dataspice) for more information.

## Links

#### assertr

[GitHub](https://github.com/ropensci/assertr) / [vignette](https://cran.r-project.org/web/packages/assertr/vignettes/assertr.html) / [reference](https://cran.r-project.org/web/packages/assertr/assertr.pdf)

#### dataspice

[GitHub](https://github.com/ropenscilabs/dataspice) / [documentation](https://docs.ropensci.org/dataspice/) 

#### General

[NHMRC Code for the Responsible Conduct of Research 2018](https://www.nhmrc.gov.au/about-us/publications/australian-code-responsible-conduct-research-2018)

[1,500 scientists lift the lid on reproducibility](https://www.nature.com/news/1-500-scientists-lift-the-lid-on-reproducibility-1.19970)

