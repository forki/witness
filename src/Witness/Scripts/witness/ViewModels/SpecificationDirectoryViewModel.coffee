# reference "../../lib/knockout.js"
# reference "ViewModels.coffee"
# reference "SpecificationFileViewModel.coffee"

{ SpecificationFileViewModel } = @Witness.ViewModels

@Witness.ViewModels.SpecificationDirectoryViewModel = class SpecificationDirectoryViewModel
	
	constructor: (@directory) ->
		@name = @directory.name
		@status = ko.observable "notdownloaded"
		@isOpen = ko.observable false
		@canRun = ko.dependentObservable =>
			result = null
			switch @status()
				when "downloaded", "passed", "failed" then result = yes
				else result = no
			result

		@files = (new SpecificationFileViewModel file for file in @directory.files)
		@directories = (new SpecificationDirectoryViewModel directory for directory in @directory.directories)
		@errors = ko.observableArray []

		for status in [ "downloading", "downloaded", "downloadFailed", "running", "passed", "failed" ]
			do (status) =>
				@directory.on[status].addHandler => @status status

		@directory.on.failed.addHandler => @isOpen true

		for helper in @directory.helpers
			helper.on.downloadFailed.addHandler (errors) =>
				@errors.push error for error in errors

	download: ->
		@directory.download()

	fileTemplate: (file) ->
		return "file-of-one" if file.specifications().length == 1
		return "file-of-many"

	run: ->
		@reset()
		@directory.run {}, (->), (->) if @canRun() 

	reset: ->
		directory.reset() for directory in @directories
		file.reset() for file in @files

	toggleOpen: ->
		@isOpen(not @isOpen())
