#' @export
SeuratWizard <- function(ip=NULL,port=NULL){
  if(is.null(ip))
    ip = '0.0.0.0'

  if(is.null(port))
    port = 1234

  appDir <- system.file('shiny', package = "SeuratWizard")
  shiny::runApp(appDir,host = getOption('shiny.host', ip),port = port,launch.browser = FALSE)
}
