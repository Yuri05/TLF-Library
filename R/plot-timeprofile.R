#' Create a Time Profile plot
#'
#' @title plotTimeProfile
#' @param data list of data.frames (or list of data.frames? TO BE DISCUSSED)
#' containing the data to be used for the plot
#' @param metaData list of lists (structure TO BE DISCUSSED)
#' containing complementary information to data (e.g. unit)
#' @param dataMapping R6 class TimeProfileDataMapping
#' mapping of which data is observation, which data is simulation
#' x, y axes + mapping of colorGrouping, sizeGrouping, shapeGrouping
#' @param plotConfiguration R6 class PKRatioPlotConfiguration
#' Plot Configuration defining title, subtitle, xlabel, ylabel watermark, and legend
#' @description
#' plotTimeProfile(data, metaData, dataMapping, plotConfiguration)
#' @return a ggplot graphical object
#' @export
#'
#'






plotTimeProfile <- function(data,
                            metaData = NULL,
                            dataMapping = NULL,
                            plotConfiguration = NULL,
                            timeCol = NULL,
                            yCol = NULL,
                            color = NULL ,
                            shape = NULL ,
                            size = NULL ,
                            linetype = NULL,
                            yAggCol = NULL,
                            errorMinCol = NULL, errorMaxCol = NULL,
                            yAggFun = NULL,
                            errorMinAggFun = NULL,
                            errorMaxAggFun = NULL) {
  # If no data mapping or plot configuration is input, use default
  #configuration <- plotConfiguration %||% TimeProfilePlotConfiguration$new()

  # dataMapping <- getDataAndDataMapping(data, metaData, timeCol  , yCol , color = NULL , shape = NULL , size = NULL , linetype = NULL, errorCol = NULL, errorMinCol = NULL, errorMaxCol = NULL, yAggFun = NULL, errorMinAggFun = NULL, errorMaxAggFun = NULL)

  if ( is.null(dataMapping) ){

    if(!is.null(yAggFun)){


      errorMinCol = NULL
      errorMaxCol = NULL

      if ( (!is.null(errorMinAggFun)) & (!is.null(errorMaxAggFun)) ){

        errorMinCol = c("errorMin")
        errorMaxCol = c("errorMax")

      }

      data<-getData(data=data, metaData=metaData, timeCol=timeCol , yCol=yCol , color=color , shape=shape , size=size , linetype=linetype , yAggCol=yAggCol,  errorMinCol=errorMinCol , errorMaxCol=errorMaxCol , yAggFun=yAggFun ,   errorMinAggFun=errorMinAggFun , errorMaxAggFun=errorMaxAggFun )
      yCol = yAggCol
      print(data)
    }

    dataMapping <- TimeProfileDataMapping$new(x = timeCol , y = yCol , errorMin = errorMinCol , errorMax = errorMaxCol , color = color , shape = shape , size = size , linetype = linetype , data = data , metaData = metaData )

  }

  plotObject <- ggplot(dataMapping$data,aes(x=x,y=y, color = color, linetype = linetype)) + geom_line()


  if ( (!is.null(errorMinAggFun)) & (!is.null(errorMaxAggFun)) ){

    plotObject <-  plotObject + geom_errorbar(aes(ymin = errorMin, ymax = errorMax), width = 0.2)

  }


  return(plotObject)
}



getData <-function(data, metaData, timeCol , yCol , color = NULL , shape = NULL , size = NULL , linetype = NULL, yAggCol = NULL, errorMinCol = NULL, errorMaxCol = NULL, yAggFun = NULL, errorMinAggFun = NULL, errorMaxAggFun = NULL){

  aggregationFunctionsVector = c(yAggFun,errorMinAggFun,errorMaxAggFun)
  aggregationFunctionNames   = c(yAggCol,errorMinCol,errorMaxCol)

  helperObj <- TimeProfileHelper$new(data = data,
                                     timeColumnName = timeCol,
                                     groupingColumnNames = c(color , shape , size, linetype),
                                     valuesColumnNames = yCol,
                                     aggregationFunctionsVector = aggregationFunctionsVector,
                                     aggregationFunctionNames = aggregationFunctionNames)

  return( helperObj$dfHelper )

}
