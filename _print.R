library(pagedown)

pagedown::chrome_print(input = "slides/visualizations.html", 
    options = list(
        printBackground = TRUE,
        preferCSSPageSize = TRUE),
    output = "slides/visualizations.pdf")