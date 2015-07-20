'use strict'
path      = require 'path'
When      = require 'when'
WhenNode  = require 'when/node'
WhenKeys  = require 'when/keys'
_         = require 'lodash'
walk      = require 'walk-tree-as-promised'
fs        = WhenNode.liftAll(require 'fs-extra')
concat    = WhenNode.lift(require 'concat')

class CPlusPlusConcat
  constructor: (@srcDirectory, @destDirectory, @libName) ->

  concat: (callback) =>
    fs.remove @destDirectory
      .then => fs.mkdirs @destDirectory
      .then => walk @srcDirectory
      .then (files) => @groupFiles files
      .then (groupedFiles) =>
        WhenKeys.map(groupedFiles, @concatType).then => groupedFiles
      .then (groupedFiles) =>
        WhenKeys.map groupedFiles, (files, type) => @removeIncludes groupedFiles.h, type
      .then (@addIncludeToCpp)

      .catch (error) =>
        return callback error if callback?
        When.reject error

  groupFiles: (files) =>
    groupedFiles = _.groupBy files, (file) =>
      return 'h' if _.endsWith(file, '.h') || _.endsWith(file, '.hpp')
      return 'cpp' if _.endsWith(file, '.c') || _.endsWith(file, '.cpp')
      return 'ignore'

    _.omit groupedFiles, 'ignore'

  concatType: (files, type) =>
    filesWithDir = _.map files, (file) => path.join @srcDirectory, file
    concat filesWithDir, path.join(@destDirectory, "#{@libName}.#{type}")

  removeIncludes: (includeFiles, type) =>
    libFilename = path.join @destDirectory, "#{@libName}.#{type}"
    includeFileRegex = @getIncludeFileRegex includeFiles
    fs.readFile(libFilename, encoding: 'utf8').then (fileContents) =>
      fs.writeFile libFilename, fileContents.replace(includeFileRegex, "//include file removed")


  getIncludeFileRegex: (includeFiles) =>
    includeFiles = _.map includeFiles, path.basename
    includeGroup = includeFiles.join('|').replace /\./g, '\\.'
    ///
      ^\#include\s*[<\"]  #beginning of include statement
      (#{includeGroup})   #group of include files we've seen
      [>\"].*$            #end of include statement
    ///gm

  addIncludeToCpp: =>
    libFilename = path.join @destDirectory, "#{@libName}.cpp"
    fs.readFile(libFilename, encoding: 'utf8').then (fileContents) =>
      fs.writeFile libFilename, "#include \"#{@libName}.h\"\n#{fileContents}"

module.exports = CPlusPlusConcat
