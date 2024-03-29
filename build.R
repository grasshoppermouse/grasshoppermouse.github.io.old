local({
    if (!file.exists('_config.yml')) return()
    x = iconv(readLines('_config.yml', encoding = 'UTF-8'), 'UTF-8')
    x = grep('^markdown:\\s*[a-z]+\\s*$', x, value = TRUE)
    # see if we need to use the Jekyll render in knitr (i.e. if the markdown
    # engine is kramdown)
    if (length(x) == 0 || (length(x) == 1 && strsplit(x, ':\\s*')[[1]][2] == 'kramdown')) {
        knitr::render_jekyll()
    } else knitr::render_markdown()
})
local({
    # input/output filenames are passed as two additional arguments to Rscript
    a = commandArgs(TRUE)
    d = gsub('^_|[.][a-zA-Z]+$', '', a[1])
    knitr::opts_chunk$set(
        fig.path   = sprintf('figure/%s/', d),
        cache.path = sprintf('cache/%s/', d)
    )
    # set where you want to host the figures (I store them in my Dropbox Public
    # folder, and you might prefer putting them in GIT)
    knitr::opts_knit$set(base.url = '/')
    knitr::opts_knit$set(width = 70)
    knitr::knit(a[1], a[2], quiet = TRUE, encoding = 'UTF-8', envir = .GlobalEnv)
})