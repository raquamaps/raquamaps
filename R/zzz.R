
.onAttach <- function(libname, pkgname) {
  
  # http://www.asciiset.com/figletserver.html (chunky)
  
  banner <-     
"
.----..---.-..-----..--.--..---.-..--------..---.-..-----..-----.
|   _||  _  ||  _  ||  |  ||  _  ||        ||  _  ||  _  ||__ --|
|__|  |___._||__   ||_____||___._||__|__|__||___._||   __||_____|
                |__|                               |__|          
"

  `%+%` <- crayon::`%+%`
  r <- stringr::str_dup

  g <- crayon::green $ bgWhite
  b <- crayon::blue $ bgWhite
  s <- crayon::silver $ bgWhite

  styled_banner <- 
    g("Welcome to ...") %+% s(r(" ", 24)) %+%
    s("https://") %+% b("raquamaps") %+% s(".github.io")  %+%
    b(banner) %+%
    g("New to raquamaps? See the vignette for a tutorial...")  %+%
    g(r(" ", 9)) %+%
    g("\n(use suppressPackageStartupMessages() to silence this banner)") %+%
    g(r(" ", 4))
    
  suppressWarnings(packageStartupMessage(styled_banner))
}