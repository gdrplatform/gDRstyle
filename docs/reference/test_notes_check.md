# Assume there is a valid note:

    > checking R code for possible problems ... NOTE mini_app: no visible binding for '<<-' assignment to ‘CONFIG’ 

and we want every other note in this section (and others) to fail check.
Accepted NOTE has 2 lines, therefore the length = 2. Then we want to
check whether the content of this NOTE is correct, so we take one of the
lines (eg. index_to_check = 2) and grep for content of this line (eg.
text_to_check = "assignment to" ) This will result in any other NOTE
failing check Take:

     list( list(length = 2, index_to_check = 2, text_to_check = "assignment to") ) `` then following NOTE will be treated as invalid > checking R code for possible problems ... NOTE mini_app: no visible binding for '<<-' assignment to ‘CONFIG’ sandbox_app : sandboxUI: no visible binding for global variable ‘pcg_path’ Undefined global functions or variables: pcg_path 

Assume there is a valid note:

    > checking R code for possible problems ... NOTE
    mini_app: no visible binding for '<<-' assignment to ‘CONFIG’

and we want every other note in this section (and others) to fail check.
Accepted NOTE has 2 lines, therefore the length = 2. Then we want to
check whether the content of this NOTE is correct, so we take one of the
lines (eg. index_to_check = 2) and grep for content of this line (eg.
text_to_check = "assignment to" ) This will result in any other NOTE
failing check Take:

      list(
        list(length = 2, index_to_check = 2, text_to_check = "assignment to")
      )
    ``
    then following NOTE will be treated as invalid
    > checking R code for possible problems ... NOTE
    mini_app: no visible binding for '<<-' assignment to ‘CONFIG’
    sandbox_app : sandboxUI: no visible binding for global variable
    ‘pcg_path’
    Undefined global functions or variables:
     pcg_path

## Usage

``` r
test_notes_check(check_results, bioccheck_results, valid_notes_list)
```

## Value

`NULL`
