#' Provides an overview of all 'resources' available from opendata.nhs.scot
#' 
#' @description Provides an overview of all 'resources' available from 
#'  opendata.nhs.scot. With the option to limit results based on both package
#'  and resource names.
#'  
#' @param package_contains character string treated as a regular expression to
#'  be matched against the package names returned.
#' @param resource_contains character string treated as a regular expression to
#'  be matched against the resource names returned.
#' 
#' @return a table containing the names of all available packages and resources,
#'  or those containing the string specified in the contains arguments, along
#'  with the resource ID.
#'  
#' @examples
#' \dontrun{
#' all_resources()
#' all_resources(package_contains = "population")
#' all_resources(package_contains = "population", resource_contains = "GP")
#' }
#' 
#' @export
all_resources <- function(package_contains = NULL, resource_contains = NULL) {
  
  pac <- all_packages(contains = package_contains)
  
  if (length(pac) < 1) {
    
    catch <- NULL
    
    print(glue::glue("No packages found with \"{package_contains}\" in name."))
    
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
        
        print(glue::glue("No resources found with \"{resource_contains}\" in name."))
        
      } else {
        
        rownames(catch) <- NULL
        
      }
    }
  }
  
  return(catch)
}
