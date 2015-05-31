<!--
<link href='http://fonts.googleapis.com/css?family=IM+Fell+Double+Pica+SC' rel='stylesheet' type='text/css'>
<h1 style="font-family:'IM Fell Double Pica SC', serif;">
  <font color="#deebf7">r</font><font color="#3182bd">a</font><font color="#9ecae1">qua</font><font color="#3182bd">m<font color="#9ecae1">aps</font>
</h1>
-->

```r
Welcome to ...                        https://raquamaps.github.io
.----..---.-..-----..--.--..---.-..--------..---.-..-----..-----.
|   _||  _  ||  _  ||  |  ||  _  ||        ||  _  ||  _  ||__ --|
|__|  |___._||__   ||_____||___._||__|__|__||___._||   __||_____|
                |__|                               |__|          
```

`raquamaps` is a set of tools that make it easier to produce Aqua Maps - model-based large-scale predictions of natural occurrences of marine species.

The model uses estimates of environmental preferences with respect to depth, water temperature, salinity, primary productivity, and association with sea ice or coastal areas. These estimates of species preferences, called environmental envelopes, are derived from large sets of occurrence data available from online collection databases.

This package can be used in an IDE like `RStudio` or from an application like `QGIS` or the embedded UI can be used directly from a web browser in order to generate predicted distribution maps for marine species.

It's already possible to do this at https://aquamaps.org, but the `raquamaps` package offers an open source alternative to the earlier MS Access based solution, which simplifies licensing issues and creates a solution which is easier to integrate, maintain and develop further.

## Installing from github

If you want to install the latest version of the raquamaps package from github, you can do it like so:

```r
# First make sure you have the devtools package
# which simplifies installations from github
# Note: Windows users have to first install Rtools to use devtools

install.packages("devtools") 

# install the raquamaps package from github with this command
# which may require RCurl, if so you can first install RCurl with ...
# install.packages("RCurl")

library("devtools")
install_git("https://github.com/raquamaps/raquamaps.git")
# ... or if you have RCurl:
install_github("raquamaps/raquamaps")  

```

## Building

Open the raquamaps directory's .Rproj file in RStudio and use the Build tab to build a source tarball (it will use the version number in the DESCRIPTION file). 

You may need to install a few libraries for the build to go through. R libraries can be installed from within RStudio. Or you could do it at the R prompt using commands like:

```r
install.packages("RCurl")  
```

On some linux distros you may need system libraries, which can be installed like so:

```console
sudo apt-get install libgdal1-dev libproj-dev libcurl4-openssl-dev
```

Don't forget to put the .tar.gz source tarball into the archive-tarball directory before pushing changes to gitorious/github.


## Quick Start

To see some quick usage examples to get you started, open the Vignette.

[Click to see Vignette](https://raquamaps.github.io/raquamaps-intro.html)

### Credits


raquamaps would have not been possible without many amazing R libraries, such as

* dplyr, stringr etc from Hadley Wickham
* rgbif etc from ROpenSci
* rMaps

TODO: Rewrite this! Check references!

raquamaps uses the rMaps R package to create, customize and publish interactive maps that depicts the predicted species distribution occurrence patterns. The rMaps package supports multiple mapping libraries, including [leaflet](http://leafletjs.com), [datamaps](http://datamaps.github.io) and [crosslet](http://sztanko.github.io/crosslet/)

## References

* Kaschner, K., R. Watson, A.W. Trites and D. Pauly. 2006. Mapping worldwide distributions of marine mammals using a Relative Environmental Suitability (RES) model. Mar. Ecol. Prog. Ser. 316:285-310.

* Ready, J., K. Kaschner, A.B. South, P.D. Eastwood, T. Rees, J. Rius, E. Agbayani, S. Kullander, and R. Froese. 2010. Predicting the distributions of marine organisms at the global scale. Ecol. Model. 221: 467-478, doi:10.1016/j.ecolmodel.2009.10.025

* Kesner-Reyes, K., K. Kaschner, S. Kullander, C. Garilao, J. Barile, and R. Froese. 2012. AquaMaps: algorithm and data sources for aquatic organisms. In: Froese, R. and D. Pauly. Editors. 2012. FishBase. World Wide Web electronic publication. www.fishbase.org, version (04/2012).

* Östergren J, Kullander S O, Prud'homme O, Reyes K K, Kaschner K and Froese R (in preparation) Predicting freshwater-dependent species distributions in Europe

## License

raquamaps is licensed under the AGPL license.
