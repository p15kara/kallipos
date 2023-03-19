# Master files for pibook

The master files are coded in a home made extended version of markdown, which has the following custom extensions:

* `Figures` and `Epigraphs` are stored in a YAML file and included with Image overloading.
* `Notes` are also stored in a YAML file and included with Note overloading.
* Extra files such as `Abstracts` `Biographies` `Case studies` are stored in a markdown file at the `extras` repository and included with Image overloading.
* Overloading the standard markdown type of Image allows for easy removal of the respective sections.

The above extensions are easy to process during production with pandoc lua filters, or with cli tools such as bash, sed, awk.
