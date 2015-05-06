.onAttach <- function(libname, pkgname) {
  
  # http://www.asciiset.com/figletserver.html (chunky)
  
  banner <-     
"
.----..---.-..-----..--.--..---.-..--------..---.-..-----..-----.
|   _||  _  ||  _  ||  |  ||  _  ||        ||  _  ||  _  ||__ --|
|__|  |___._||__   ||_____||___._||__|__|__||___._||   __||_____|
                |__|                               |__|          
"

  g <- crayon::green $ bgWhite
  b <- crayon::blue $ bgWhite
  s <- crayon::silver $ bgWhite

  styled_banner <- 
    g("Welcome to ...") %+% s(str_dup(" ", 24)) %+%
    s("https://") %+% b("raquamaps") %+% s(".github.io") %+%
    b(banner) %+% 
    g("New to raquamaps? See the vignette for a tutorial...") %+%
    g("\n(use suppressPackageStartupMessages() to silence this banner)")

  packageStartupMessage(styled_banner)
}
