﻿# reference "Witness.coffee"
# reference "Event.coffee"

{ Event } = @Witness

createDescriptionFromFunction = (func) ->
	s = func.toString()
	match = s.match /function\s*\(\)\s*{\s*return\s*(.*)\s*;\s*}/
	return match[1] if match
	return s

@Witness.Assertion = class Assertion
	constructor: (@action) ->
		if @action.description
			@description = @action.description
		else
			@description = createDescriptionFromFunction @action.func

		@on = Event.define "run", "done", "fail"

	run: (context, assertionDone, assertionFail) ->
		@on.run.raise()

		done = (result) =>
			if typeof result == "undefined" # no error thrown, so treat as success
				@on.done.raise()
				assertionDone()
			else if result == true
				@on.done.raise()
				assertionDone()
			else
				error = new Error "Assertion failed: " + @description
				@on.fail.raise error
				assertionFail error

		@action.run context,
			done
			(error) =>
				@on.fail.raise error
				assertionFail error