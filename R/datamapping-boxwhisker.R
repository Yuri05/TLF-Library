#' @title BoxWhiskerDataMapping
#' @docType class
#' @description  Data Mapping for Box Whisker Plots
#' @field x Name of x variable to map
#' @field y Name of y variable to map
#' @field ymin Name of function used for calculating lower whisker
#' @field lower Name of function used for calculating lower line of box
#' @field middle Name of function used for calculating middle line
#' @field upper Name of function used for calculating upper line of box
#' @field ymax Name of function used for calculating upper whisker
#' @field minOutlierLimit Name of function used for calculating lower outlier limit
#' @field maxOutlierLimit Name of function used for calculating upper outlier limit
#' @section Methods:
#' \describe{
#' \item{new(...)}{
#' Initialize BoxWhiskerDataMapping. ymin, lower, middle, upper, ymax, minOutlierLimit, maxOutlierLimit inputs are names of functions}
#' \item{checkMapData(data, metaData = NULL)}{Check data mapping is correct. Create output data.frame with map data only.}
#' \item{getBoxWhiskers(data)}{Check data mapping is correct. Create output data.frame with map data only.}
#' \item{getOutliers(data)}{Check data mapping is correct. Create output data.frame with map data only.}
#' }
#' @export
#' @format NULL
BoxWhiskerDataMapping <- R6::R6Class(
  "BoxWhiskerDataMapping",
  inherit = XYGDataMapping,
  public = list(
    outlierLimits = NULL,
    boxWhiskerLimits = NULL,

    initialize = function(x = NULL, # If user wants a unique box, x does not need to be filled
                              y,
                              ymin = tlfStatFunctions$`Percentile5%`,
                              lower = tlfStatFunctions$`Percentile25%`,
                              middle = tlfStatFunctions$`Percentile50%`,
                              upper = tlfStatFunctions$`Percentile75%`,
                              ymax = tlfStatFunctions$`Percentile95%`,
                              minOutlierLimit = tlfStatFunctions$`Percentile25%-1.5IQR`,
                              maxOutlierLimit = tlfStatFunctions$`Percentile75%+1.5IQR`,
                              ...) {
      super$initialize(x = x, y = y, ...)

      super$groupMapping$color <- super$groupMapping$color %||% super$groupMapping$fill

      self$boxWhiskerLimits <- c(ymin, lower, middle, upper, ymax)
      self$outlierLimits <- c(minOutlierLimit, maxOutlierLimit)
    },

    getBoxWhiskerLimits = function(data) {
      # Dummy silent variable if x is NULL
      if (is.null(self$x)) {
        data$defaultAes <- factor("")
      }

      # Transform names into functions for aggregation summary
      boxWhiskerLimitsFunctions <- sapply(self$boxWhiskerLimits, match.fun)

      # Use aggregation summary to get box specific values
      summaryObject <- AggregationSummary$new(
        data = data,
        xColumnNames = self$x %||% "defaultAes",
        groupingColumnNames = self$groupMapping$fill$label,
        yColumnNames = self$y,
        aggregationFunctionsVector = boxWhiskerLimitsFunctions,
        aggregationFunctionNames = c("ymin", "lower", "middle", "upper", "ymax")
      )

      boxWhiskerLimits <- summaryObject$dfHelper

      # Dummy variable for aesthetics
      boxWhiskerLimits$defaultAes <- factor("")

      return(boxWhiskerLimits)
    },

    getOutliers = function(data) {
      # Dummy silent variable if x is NULL
      if (is.null(self$x)) {
        data$defaultAes <- factor("")
      }

      # Transform names into functions for aggregation summary
      outlierLimitsFunctions <- sapply(self$outlierLimits, match.fun)

      # Use aggregation summary to get outliers boundaries specific values
      summaryObject <- AggregationSummary$new(
        data = data,
        xColumnNames = self$x %||% "defaultAes",
        groupingColumnNames = self$groupMapping$fill$label,
        yColumnNames = self$y,
        aggregationFunctionsVector = outlierLimitsFunctions,
        aggregationFunctionNames = c("minOutlierLimit", "maxOutlierLimit")
      )

      outlierLimits <- summaryObject$dfHelper

      # Merge outlier limits to data
      outliers <- merge.data.frame(data, outlierLimits)

      # Create the outliers variables by flagging which are lower or higher than limits
      outliers[, "minOutliers"] <- outliers[, self$y]
      outliers[, "maxOutliers"] <- outliers[, self$y]

      minOutliersFlag <- outliers[, self$y] < outliers[, "minOutlierLimit"]
      maxOutliersFlag <- outliers[, self$y] > outliers[, "maxOutlierLimit"]

      outliers$minOutliers[!minOutliersFlag] <- NA
      outliers$maxOutliers[!maxOutliersFlag] <- NA

      # Dummy variable for aesthetics
      outliers$defaultAes <- factor("")

      return(outliers)
    }
  )
)
