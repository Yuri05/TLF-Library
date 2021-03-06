% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/datamapping-xygroup.R
\docType{class}
\name{XYGDataMapping}
\alias{XYGDataMapping}
\title{XYGDataMapping}
\format{An object of class \code{R6ClassGenerator} of length 24.}
\usage{
XYGDataMapping
}
\description{
Abstract class for X Y Group Mapping
}
\section{Fields}{

\describe{
\item{\code{x}}{Name of x variable to map}

\item{\code{y}}{Name of y variable to map}

\item{\code{groupMapping}}{R6 class mapping groups to aesthetic properties}
}}

\section{Methods}{

\describe{
\item{new(x, y, groupMapping = NULL, color = NULL, fill = NULL, linetype = NULL, shape = NULL, size = NULL)}{
Initialize XYGDataMapping. Either input groupMapping or input color, fill, linetype, shape and/or size}
\item{checkMapData(data, metaData = NULL)}{Check data mapping is correct. Create output data.frame with map data only.}
}
}

\keyword{datasets}
