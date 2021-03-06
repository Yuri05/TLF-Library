% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot-ddiratio.R
\name{plotDDIRatio}
\alias{plotDDIRatio}
\title{plotDDIRatio}
\usage{
plotDDIRatio(data, metaData = NULL, dataMapping = NULL,
  plotConfiguration = NULL)
}
\arguments{
\item{data}{data.frame (or list of data.frames? TO BE DISCUSSED)
containing the data to be used for the plot}

\item{metaData}{list of lists (structure TO BE DISCUSSED)
containing complementary information to data (e.g. unit)}

\item{dataMapping}{R6 class PKRatioDataMapping
mapping of x, y axes + mapping of colorGrouping, sizeGrouping, shapeGrouping}

\item{plotConfiguration}{R6 class PKRatioPlotConfiguration
Plot Configuration defining title, subtitle, xlabel, ylabel watermark, and legend}
}
\value{
a ggplot graphical object
}
\description{
plotDDIRatio(data, metaData, dataMapping, plotConfiguration)
}
\details{
Create a DDI-Ratio plot
}
