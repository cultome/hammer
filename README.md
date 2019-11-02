# Hammer

A toolkit to mangle data files

## Usage

#### Inspect files

```bash
$ hammer inspect somefile.csv --stats --sample --fullload
File format: csv
Number of records: 5179
Properties:
  - name (string)
  - line (string)
  - estacion (string)
  - x (float)
  - y (float)
  - cons (integer)
  - afluencia (float)
  - POBTOT_2 (float)
  - POTOT (float)
  - Betweeness (float)
Stats:
  x (float)
    - sum: -513442.4126096798
    - max: 0
    - min: -99.33576107
    - avg: -99.139295734636
    - median: -99.14043188
  y (float)
    - sum: 100426.45677906
    - max: 19.57663202
    - min: 19.13318768
    - avg: 19.39109032227457
    - median: 19.39048536
[...]
```
 * The basic behavior (without flags) is to detect the file type and properties.
 * The flag `stats` creates a summary of the properties in the file depending on its detected type.
 * The flag `sample` display a random sample of records in the file.
 * By default `hammer` only analyzes a sample of the data file, the flag `fullload` tell it to use the full content of the file. This is a global flag and modifies the whole app behavior.

#### Filter file through a template

```bash
$ hammer template "<%= x %> <%= y %>" --file=some/file.csv --fullload --output=some/other.txt
$ cat some/other.txt
1 2
3 4
[...]
```

## Features
  - [x] Interactive mode to play with the data
  - [x] Handle basic encoding issues
  - [x] Handle empty/missing values
  - [x] Exploratory analysis
  - [ ] Connect to multiple datasources (databases, files of different formats)
  - [ ] Write to multiples backends or files
  - [ ] Validate records, including cross validations between records
  - [ ] Transform formats and types of records
  - [ ] Handle errors gracefuly to prevent the process to break and start all over again
  - [ ] To have middleware-like featue to calculate metrics, log messages or apply reductions
  - [ ] Resolvers to navigate a relationship in the datasource and bring an associated values given an ID
  - [ ] DRY run to return the "execution plan" but not execute anything
  - [ ] Have events hooks
  - [ ] Translate catalogs

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
