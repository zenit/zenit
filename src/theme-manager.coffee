path = require 'path'
_ = require 'underscore-plus'
{Emitter, Disposable, CompositeDisposable} = require 'event-kit'
fs = require 'fs-plus'

# Extended: Handles loading and activating available themes.
#
# An instance of this class is always available as the `zenit.themes` global.
module.exports =
class ThemeManager
  constructor: ({@configDirPath, @resourcePath, @styleManager}) ->
    @emitter = new Emitter
    @styleSheetDisposablesBySourcePath = {}
    @lessCache = null
    @initialLoadComplete = false

  ###
  Section: Private
  ###

  # Resolve and apply the stylesheet specified by the path.
  #
  # This supports both CSS and Less stylsheets.
  #
  # * `stylesheetPath` A {String} path to the stylesheet that can be an absolute
  #   path or a relative path that will be resolved against the load path.
  #
  # Returns a {Disposable} on which `.dispose()` can be called to remove the
  # required stylesheet.
  requireStylesheet: (stylesheetPath) ->
    if fullPath = @resolveStylesheet(stylesheetPath)
      content = @loadStylesheet(fullPath)
      @applyStylesheet(fullPath, content)
    else
      throw new Error("Could not find a file at path '#{stylesheetPath}'")

  loadBaseStylesheets: ->
    @reloadBaseStylesheets()

  reloadBaseStylesheets: ->
    @requireStylesheet('../static/zenit')
    if nativeStylesheetPath = fs.resolveOnLoadPath(process.platform, ['css', 'less'])
      @requireStylesheet(nativeStylesheetPath)

  stylesheetElementForId: (id) ->
    document.head.querySelector("zenit-styles style[source-path=\"#{id}\"]")

  resolveStylesheet: (stylesheetPath) ->
    if path.extname(stylesheetPath).length > 0
      fs.resolveOnLoadPath(stylesheetPath)
    else
      fs.resolveOnLoadPath(stylesheetPath, ['css', 'less'])

  loadStylesheet: (stylesheetPath, importFallbackVariables) ->
    if path.extname(stylesheetPath) is '.less'
      @loadLessStylesheet(stylesheetPath, importFallbackVariables)
    else
      fs.readFileSync(stylesheetPath, 'utf8')

  loadLessStylesheet: (lessStylesheetPath, importFallbackVariables=false) ->
    unless @lessCache?
      LessCompileCache = require './less-compile-cache'
      @lessCache = new LessCompileCache({resourcePath: path.join(__dirname), importPaths: @getImportPaths()})

    try
      if importFallbackVariables
        baseVarImports = """
        @import "variables/ui-variables";
        """
        less = fs.readFileSync(lessStylesheetPath, 'utf8')
        @lessCache.cssForFile(lessStylesheetPath, [baseVarImports, less].join('\n'))
      else
        @lessCache.read(lessStylesheetPath)
    catch error
      error.less = true
      if error.line?
        # Adjust line numbers for import fallbacks
        error.line -= 2 if importFallbackVariables

        message = "Error compiling Less stylesheet: `#{lessStylesheetPath}`"
        detail = """
          Line number: #{error.line}
          #{error.message}
        """
      else
        message = "Error loading Less stylesheet: `#{lessStylesheetPath}`"
        detail = error.message

      # TODO: Use {NotificationManager} instead of console.log
      console.error message

      throw error

  removeStylesheet: (stylesheetPath) ->
    @styleSheetDisposablesBySourcePath[stylesheetPath]?.dispose()

  applyStylesheet: (path, text) ->
    @styleSheetDisposablesBySourcePath[path] = @styleManager.addStyleSheet(text, sourcePath: path)

  getImportPaths: ->