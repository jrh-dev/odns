#' Provides an overview of all resources available from opendata.nhs.scot.
#' 
#' @description Provides an overview of all resources available from 
#'  opendata.nhs.scot, with the option to limit results based on both package
#'  and resource names. The returned data.frame can be used to look-up package
#'  and resource ids and is useful for exploring the available data sets.
#'  
#' @param package_contains a character string containing a regular expression to
#'  be matched against available package names. If a character vector > length 1
#'  is supplied, the first element is used.
#' @param resource_contains a character string containing a regular expression
#'  to be matched against available resource names. If a character vector > 
#'  length 1 is supplied, the first element is used.
#' 
#' @return a data.frame containing details of all available packages and
#'  resources, or those containing the string specified in the 
#'  \code{package_contains} and \code{resource_contains} arguments.
#'  
#' @examples
#' \dontrun{
#' all_resources()
#' all_resources(package_contains = "standard-populations")
#' all_resources(
#'   package_contains = "standard-populations", resource_contains = "European"
#' )
#' }
#' 
#' @export
all_resources <- function(package_contains = NULL, resource_contains = NULL) {
  
  pac <- all_packages(contains = package_contains)
  
  if (length(pac) < 1) {
    
    stop(glue::glue("No packages found with \"{package_contains}\" in name."))
    
  } else {
    
    catch <-  vector(mode = "list", length = length(pac))
    
    for (ii in seq_len(length(catch))) {
      
      catch[[ii]] <- package_metadata(pac[ii])$resources
      
      catch[[ii]]$package_name <- pac[ii]
      
      catch[[ii]] <- catch[[ii]][c("name", "package_name", "id", "package_id", "last_modified")]
      
    }
    
    catch = do.call(rbind, catch)
    
    if (!is.null(resource_contains)) {
      catch <- catch[grepl(as.character(resource_contains), catch$name, ignore.case = TRUE),]
      
      if (nrow(catch) < 1) {
        
        catch <- NULL
        
        stop(glue::glue("No resources found with \"{resource_contains}\" in name."))
        
      } else {
        
        rownames(catch) <- NULL
        
      }
    }
  }
  
  return(catch)
}
