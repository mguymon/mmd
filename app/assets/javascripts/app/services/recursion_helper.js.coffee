# http://stackoverflow.com/a/18609594/1272477

angular.module("DeployerApp.services").factory "RecursionHelper", ["$compile", ($compile) ->
  RecursionHelper = 
    compile: (element) ->
      contents = element.contents().remove()
      compiledContents = undefined
      (scope, element) ->
        compiledContents = $compile(contents)  unless compiledContents
        compiledContents scope, (clone) ->

          # Helper for config-tree directive
          scope.isObject = (val) ->
            typeof(val) == 'object'
            
          element.append clone


  RecursionHelper
]