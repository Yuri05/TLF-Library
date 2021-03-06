isSameLength <- function(...) {
  args <- list(...)
  nrOfLengths <- length(unique(lengths(args)))

  return(nrOfLengths == 1)
}

#' Check if the provided object has nbElements elements
#'
#' @param object An object or a list of objects
#' @param nbElements number of elements that are supposed in object
#'
#' @return TRUE if the object or all objects inside the list have nbElements.
#' Only the first level of the given list is considered.
isOfLength <- function(object, nbElements) {
  return(length(object) == nbElements)
}

validateIsOfLength <- function(object, nbElements) {
  if (isOfLength(object, nbElements)) {
    return()
  }
  stop(messages$errorWrongLength(object, nbElements))
}

#' Check if the provided object is of certain type
#'
#' @param object An object or a list of objects
#' @param type String  representation or Class of the type that should be checked for
#'
#' @return TRUE if the object or all objects inside the list are of the given type.
#' Only the first level of the given list is considered.
isOfType <- function(object, type) {
  if (is.null(object)) {
    return(FALSE)
  }

  type <- typeNamesFrom(type)

  inheritType <- function(x) inherits(x, type)

  if (inheritType(object)) {
    return(TRUE)
  }
  object <- c(object)

  all(sapply(object, inheritType))
}

validateIsOfType <- function(object, type, nullAllowed = FALSE) {
  if (nullAllowed && is.null(object)) {
    return()
  }

  if (isOfType(object, type)) {
    return()
  }
  # Name of the variable in the calling function
  objectName <- deparse(substitute(object))
  objectTypes <- typeNamesFrom(type)

  stop(messages$errorWrongType(objectName, class(object)[1], objectTypes))
}

validateEnumValue <- function(enum, value) {
  if (value %in% names(enum)) {
    return()
  }

  stop(messages$errorValueNotInEnum(enum, value))
}

typeNamesFrom <- function(type) {
  if (is.character(type)) {
    return(type)
  }
  type <- c(type)
  sapply(type, function(t) t$classname)
}

validateIsString <- function(object, nullAllowed = FALSE) {
  validateIsOfType(object, "character", nullAllowed)
}

validateIsNumeric <- function(object, nullAllowed = FALSE) {
  validateIsOfType(object, c("numeric", "integer"), nullAllowed)
}

validateIsLogical <- function(object, nullAllowed = FALSE) {
  validateIsOfType(object, "logical", nullAllowed)
}

validateIsSameLength <- function(...) {
  if (isSameLength(...)) {
    return()
  }
  # Name of the variable in the calling function
  objectName <- deparse(substitute(list(...)))

  # Name of the arguments
  argnames <- sys.call()
  arguments <- paste(lapply(argnames[-1], as.character), collapse = ", ")

  stop(messages$errorDifferentLength(arguments))
}

#' Check if the provided object is included in a parent object
#'
#' @param values Vector of values
#' @param parentValues Vector of values
#'
#' @return TRUE if the values are inside the parent values.
isIncluded <- function(values, parentValues) {
  if (is.null(values)) {
    return(FALSE)
  }

  return(as.logical(min(values %in% parentValues)))
}

validateIsIncluded <- function(values, parentValues, nullAllowed = FALSE) {
  if (nullAllowed && is.null(values)) {
    return()
  }

  if (isIncluded(values, parentValues)) {
    return()
  }

  stop(messages$errorNotIncluded(values, parentValues))
}

validateMapping <- function(mapping, data, nullAllowed = FALSE) {
  if (nullAllowed && is.null(mapping)) {
    return()
  }

  if (isOfType(mapping, "numeric")) {
    if (ncol(data) >= mapping) {
      return()
    }
    stop(messages$errorExceedLength(mapping, ncol(data)))
  }
  if (isOfType(mapping, "character")) {
    variableNames <- names(data)
    validateIsIncluded(mapping, variableNames)
    return()
  }

  stop(messages$errorWrongType(mapping, class(mapping), c("numeric", "character")))
}

#' Check that 2 conflicting inputs can't be provided at the same time
#'
#' @param eitherInput Input or list of inputs
#' @param orInput Input or list of inputs
validateEitherOrNullInput <- function(eitherInput, orInput) {
  # Convert input to list of input if not already as list
  if (!isOfType(eitherInput, "list")) {
    eitherInput <- list(eitherInput)
  }
  if (!isOfType(orInput, "list")) {
    orInput <- list(orInput)
  }

  # False if one element from input is not null
  if (as.logical(min(sapply(eitherInput, is.null))) || as.logical(min(sapply(orInput, is.null)))) {
    return()
  }
  stop(messages$errorConflictingInput(names(eitherInput), names(orInput)))
}
