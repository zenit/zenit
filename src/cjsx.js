var CoffeeReact = null
var crypto = require('crypto')
var path = require('path')

exports.shouldCompile = function () {
  return true
}

exports.getCachePath = function (sourceCode) {
  return path.join(
    'cjsx',
    crypto
      .createHash('sha1')
      .update(sourceCode, 'utf8')
      .digest('hex') + '.js'
  )
}

exports.compile = function (sourceCode, filePath) {
  if (!CoffeeReact) {
    var previousPrepareStackTrace = Error.prepareStackTrace
    CoffeeReact = require('coffee-react')

    // When it loads, coffee-react reassigns Error.prepareStackTrace. We have
    // already reassigned it via the 'source-map-support' module, so we need
    // to set it back.
    Error.prepareStackTrace = previousPrepareStackTrace
  }

  if (process.platform === 'win32') {
    filePath = 'file:///' + path.resolve(filePath).replace(/\\/g, '/')
  }

  var output = CoffeeReact.compile(sourceCode, {
    filename: filePath,
    sourceFiles: [filePath],
    sourceMap: true
  })

  var js = output.js
  js += '\n'
  js += '//# sourceMappingURL=data:application/json;base64,'
  js += new Buffer(output.v3SourceMap).toString('base64')
  js += '\n'
  return js
}
