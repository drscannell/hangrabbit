class HangRabbit
	constructor: ->
		# properties
		@ENTER_KEYCODE = 13

		# events
		$(".js-phrase-input").keyup @handleTextInputEnter
		$(".js-letter-choices").click @handleLetterChoice

		@loadNewGame "Gimme a break"

		@refreshLetterChoices()

	loadNewGame: (phrase) ->
		phrase = phrase.toLowerCase()
		console.log "Loading game for '#{phrase}'"
		$clueArea = $("js-letter-underlines")
		for letter in phrase
			if letter == " "
				console.log "space"
			else
				console.log letter
	
	handleLetterChoice: ($ev) =>
		if $($ev.target).hasClass "letter-choice"
			console.log $ev.target.innerHTML

	refreshLetterChoices: ->
		$container = $('.js-letter-choices')
		$container.empty()
		for x in [65..90]
			c = String.fromCharCode x
			$container.append "<span class=\"letter-choice\">#{c}</span>"

	handleTextInputEnter: ($ev) =>
		if $ev.keyCode == @ENTER_KEYCODE
			inputText = $(".js-phrase-input").val()
			@validateInput inputText

	validateInput: (phrase) ->
		phrases = (li.innerHTML for li in $("li.js-phrase")) or []
		if phrase in phrases
			@showValidationMessage "You already added that!"
		else
			@addPhrase phrase
			@clearPhraseInput()
	
	showValidationMessage: (message) ->
		$(".js-validation-message").html message

	addPhrase: (phrase) ->
		console.log "Adding phrase: '#{phrase}'"
		html = "<li class=\"js-phrase\">#{phrase}</li>"
		$(".js-phrase-list").append html

	clearPhraseInput: ->
		$('.js-phrase-input').val ""

$(document).ready ->
	hangRabbit = new HangRabbit
