# reference "_namespace.coffee"
# reference "../lib/knockout.js"
# reference "../witness/Event.coffee"

{ Event } = @Witness

@Witness.ui.Tree = class Tree

	constructor: (@rootDirectory) ->
		@nodes = ko.observableArray []
		@selectedNode = ko.observable null

		@nodeSelected = new Event()

	nodeTemplateId: (node) ->
		node.templateId

	selectNode: (node) ->
		@selectedNode()?.isSelected no
		node.isSelected yes
		@selectedNode node
		@nodeSelected.raise node
		
	map: (func) ->
		for node in @nodes()
			node.map func