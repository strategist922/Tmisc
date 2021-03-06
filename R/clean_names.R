#' Cleans names of a data.frame.
#'
#' Resulting names are unique and consist only of the \code{_} character, lowercase letters, and numbers.
#'
#' @param x the input data.frame.
#' 
#' @return Returns the data.frame with clean names.
#' 
#' @importFrom stats setNames
#' 
#' @examples
#' # not run:
#' # clean_names(poorly_named_df)
#'
#' # library(dplyr) ; library(readxl)
#' # not run:
#' # readxl("messy_excel_file.xlsx") %>% clean_names()
#' 
#' @export
clean_names <- function(x){

  # Takes a data.frame, returns the same data frame with cleaned names
  old_names <- names(x)
  new_names <- old_names %>%
    gsub("'", "", .) %>% # remove quotation marks
    gsub("\"", "", .) %>% # remove quotation marks
    gsub("%", "percent", .) %>%
    make.names(.) %>%
    gsub("[.]+", "_", .) %>% # convert 1+ periods to single _
    gsub("[_]+", "_", .) %>% # fix rare cases of multiple consecutive underscores
    tolower(.) %>%
    gsub("_$", "", .) # remove string-final underscores

  # Handle duplicated names - they mess up dplyr pipelines
  # This appends the column number to repeated instances of duplicate variable names
  dupe_count <- sapply(1:length(new_names), function(i) { sum(new_names[i] == new_names[1:i]) })
  new_names[dupe_count > 1] <- paste(new_names[dupe_count > 1],
                                     dupe_count[dupe_count > 1],
                                     sep = "_")
  stats::setNames(x, new_names)
}
