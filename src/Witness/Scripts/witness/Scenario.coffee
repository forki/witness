﻿# reference "Witness.coffee"
# reference "Sequence.coffee"
# reference "TryAll.coffee"

this.Witness.Scenario = class Scenario
	
	constructor: (@givens, @whens, @thens, @disposes) ->
		assertions = (new Witness.Assertion action for action in @thens)
		tryAllAssertions = new Witness.TryAll assertions
		sequence = new Witness.Sequence [].concat @givens, @whens, tryAllAssertions
		# The dispose whens must *always* run, even if the previous sequence fails.
		# So combine them using a TryAll.
		@aggregateAction = new Witness.TryAll [].concat sequence, disposes

	run: (outerContext, done, fail) ->
		context = {}
		@aggregateAction.run context, done, fail
