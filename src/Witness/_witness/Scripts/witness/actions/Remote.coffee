﻿# reference "../Dsl.coffee"
# reference "../dsl/async.coffee"
# reference "../dsl/defineActions.coffee"

{ async } = @Witness.Dsl::

@Witness.Dsl::defineActions
	remote: async (remotefunc) ->
		$.ajax 
			url:"execute-script"
			type: "POST"
			data: "(#{remotefunc})(this)"
			success: (data) =>
				@done data
			error: (xhr, data) =>
				@fail JSON.parse(xhr.responseText).error
			dataType: "json"
