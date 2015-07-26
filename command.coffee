commander   = require 'commander'
program = require 'commander'
CppConcat = require './index'
packageJSON = require './package.json'

program
  .version packageJSON
  .option '-s, --source-directory <source-directory>', 'Directory containing the source files to concat'
  .option '-d, --destination-directory <destination-directory>', 'Directory to output destination files'
  .option '-n --library-name <library-name>', 'Name for the generated files'
  .parse process.argv

return console.log "source directory is required" unless program.sourceDirectory?
return console.log "destination directory is required" unless program.destinationDirectory?
return console.log "library name is required" unless program.libraryName?

concater = new CppConcat( 
  program.sourceDirectory
  program.destinationDirectory
  program.libraryName
)

concater.concat (error) => console.error "something bad happened! #{error.message}" if error?
