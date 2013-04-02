pdfbrochure(1) -- A tool to create brochures
============================================

## SYNOPSIS

pdfbrochure [-e] [-t] [-n <2..inf> | -s <list-of-pages>] [-f <file>]
pdfbrochure [-e] [-t] <2..inf> <file>
pdfbrochure [-e] [-t] -f <file> <2..inf>
pdfbrochure [-e] [-t] [-n <2..inf> | -s <list-of-pages>] <file>
pdfbrochure -h

## DESCRIPTION

*pdfbrochure* creates a brochure from a sequential PDF.
It does this by taking a page selection for PDFjam and transforming it.

The purpose of pdfbrochure is mainly educational because pdfjam allready supports booklets  with --booklet=true. See also the *pdfbook* command.

The *pageselection* can either be specified as a normal PDFjam
pageselection (see PDFjam on that) or as a number,
which would then be expanded to a pageselection from page 0 to that page.
The pageselection must at least contain two items;
No further checking is done, so invalid page literals or missing pages
won't be detected untill pdfjam is called.
Generally it is advisable to use the number of pages as a pageselection.

The following  *transformations* are then applied:

1. The number of pages is normalized to a multiple of four.
   This is done by adding the required amount of pages.
2. If the *-e* option is given, pdfbrochure makes sure the last page is empty.
3. Then pdfbrochure shifts the pages to create a brochure:

     -     FRONT               BACK
     ----------------------------------
     last    first    | first+1  last-1
     last-2  first+2  | first+3  last-3
     last-4  first+4  | first+5  last-5
     last-6  first+6  | first+7  last-7
     last-8  first+8  | first+9  last-9
     last-10 first+10 | first+11 last-11
     last-12 first+12 | first+13 last-13
     last-14 first+14 | first+15 last-15
     last-16 first+16 | first+17 last-17
       ...      ...   |   ...      ...

In the last step PDFjam is called and the new PDF is created.
If *-t* is given, no PDF will be created, instad the
the transformed selection is printed to *stdout*.

## OPTIONS

* -e 
  Make shure the last page is empty
* -t
  Don't invoke PDFjam instead just output the transformed selection
* -h
  Show this help
* -f <file>
  The file to transform
* -n <2..inf>
  Selection - The number of pages
* -s <selection>
  Selection - Vector of pages

## RETURN VALUES

This program terminates with 0 if successfull,
otherwise 1 is returned.

## AUTHOR

* Karolin Varner

## LICENSE

pdfbrochure lis licensed under CC0 (which basically means Public Domain).

## SEE ALSO

pdfjam, pdfbook, pdfnup

