﻿# reference "Witness.coffee"

@witness.Event = class Event
	constructor: ->
		@handlers = []

	addHandler: (handler) ->
		@handlers.push handler

	removeHandler: (handler) ->
		@handlers = (h for h in @handlers when h isnt handler)

	raise: (args...) ->
		for handler in @handlers
			handler.apply null, args


# This helper function is used to create an object with an Event object
# for each of the given names.
# An object that needs events would typically have something like this
# in its constructor:
#   @on = Witness.Event.define "running", "passed", "failed"
Event.define = (names...) ->
	events = {}
	events[name] = new Event() for name in names
	events
