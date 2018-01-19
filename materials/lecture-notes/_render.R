quiet = "--quiet" %in% commandArgs(FALSE)
formats = commandArgs(TRUE)


if (length(formats) == 0) {
  formats = c(
    "bookdown::pdf_book",
    "bookdown::gitbook"
  )
}

for (fmt in formats) {
  cmd = sprintf("bookdown::render_book('index.rmd', '%s', quiet=%s)", fmt, quiet)
  cat(cmd, "\n")
  res = bookdown:::Rscript(c('-e', shQuote(cmd)))
  if (res != 0) stop('Failed to compile the book to ', fmt) 
}