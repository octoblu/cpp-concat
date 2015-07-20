'use strict'
# through = require 'through2'
_ = require 'lodash'
fs = require 'fs.extra'

class CPlusPlusConcat
  @concat: (srcDirectory, destDirectory, callback=->) =>
    @getGroupedFiles srcDirectory, (error, groupedFiles)=>
      return callback error if error?
      console.log "#{JSON.stringify groupedFiles, null, 2}"

  @getGroupedFiles: (srcDirectory, callback=->) =>
    files = []
    fs.walk srcDirectory
      .on 'files', (root, fileStats, next) =>
        files = files.concat files, fileStats
        next()

      .on 'errors', (root, nodeStats, next) =>
        _.each nodeStats, (nodeStat) =>
          console.error "[ERROR] #{nodeStat.name}"
          console.error nodeStat.error.message || (nodeStat.error.code + ": " + nodeStat.error.path)

        next()

      .on 'end', =>
        callback null, @groupFiles files


  @groupFiles: (files) =>
    _.groupBy files, (file) =>
      return 'header' if _.endsWith(file.name, 'h') || _.endsWith(file.name, 'hpp')
      return 'source' if _.endsWith(file.name, 'c') || _.endsWith(file.name, 'cpp')
      return 'ignore'

module.exports = CPlusPlusConcat
