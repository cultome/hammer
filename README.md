# Hammer

## Features
  * Connect to multiple datasources (databases, files of different formats)
  * Write to multiples backends or files
  * Validate records, including cross validations between records
  * Transform formats and types of records
  * Handle empty/missing values
  * To have visibility in every step of the current process
  * Handle errors gracefuly to prevent the process to break and start all over again
  * To have middleware-like featue to calculate metrics, log messages or apply reductions
  * Exploratory analysis:
      * View distributions of values
  * Resolvers to navigate a relationship in the datasource and bring an associated values given an ID
  * DRY run to return the "execution plan" but not execute anything
  * Interactive mode to play with the data

## Working on right now
 * Agregar eventos al hammer
 * Que hammer trate de areglar los datos donde apliquen ("19" y "19 años")
 * Que hammer considere problemas basicos de encoding.
 * Que hammer considere un mapeo de catalogos cuando se carguen datos (1=femenino, 2=masculino)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
