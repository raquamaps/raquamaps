.onAttach <- function(libname, pkgname) {
  
  # http://www.lemoda.net/games/figlet/figlet-instant.html
  
  banner <- 
"
       _______                       _______                      
.----.|   _   |.-----..--.--..---.-.|   |   |.---.-..-----..-----.
|   _||       ||  _  ||  |  ||  _  ||       ||  _  ||  _  ||__ --|
|__|  |___|___||__   ||_____||___._||__|_|__||___._||   __||_____|
                  |__|                              |__|          
"
  
  g <- crayon::green $ bgWhite
  b <- crayon::blue $ bgWhite
  s <- crayon::silver $ bgWhite

  styled_banner <- 
    g("Welcome to ...") %+%
    b(banner) %+% 
    s(str_dup(" ", 39)) %+%
    s("https://") %+% b("raquamaps") %+% s(".github.io")

  packageStartupMessage(styled_banner)
}
