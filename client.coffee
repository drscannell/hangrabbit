class HangRabbit
	constructor: ->
		# properties
		@ENTER_KEYCODE = 13
		@game = null

		# events
		$(".js-phrase-input").keyup @handleTextInputEnter
		$(".js-single-device-phrase-input").keyup @handlePhraseSubmission
		$(".js-letter-choices").click @handleLetterChoice

	hideKeyboard: ->
		document.activeElement.blur()
		$("input").blur()
	
	handlePhraseSubmission: ($ev) =>
		if $ev.keyCode == @ENTER_KEYCODE
			phrase = $(".js-single-device-phrase-input").val()
			if @validatePhrase phrase
				@loadNewGame phrase
				@hideKeyboard

	validatePhrase: (phrase) ->
		return true

	loadNewGame: (phrase) ->
		$(".js-phrase-input-form").hide()
		@refreshLetterChoices()
		phrase = phrase.toLowerCase()
		@game = new Game phrase
		$(".js-message").html "Select a letter. You have #{@game.getAttemptsLeft()} guesses left."
		$clueArea = $(".js-letter-underlines")
		$clueArea.empty()
		for letter in phrase
			if letter == " "
				$clueArea.append "<span class=\"char space\" />"
			else
				$clueArea.append "<span class=\"char underscore\" />"
	
	handleLetterChoice: ($ev) =>
		isValidGuess = true
		if @game.isLost() then isValidGuess = false
		if @game.isWon() then isValidGuess = false
		if not $($ev.target).hasClass "letter-choice" then isValidGuess = false
		if $($ev.target).hasClass "disabled" then isValidGuess = false
		
		if isValidGuess
			$($ev.target).addClass "disabled"
			guess = $ev.target.innerHTML
			locations = @game.guessLetter guess
			for location in locations
				$(".char").eq(location).removeClass("underscore").addClass("guessed").html(guess)
			if @game.isLost()
				$(".js-message").html "You ran out of guesses! The phrase was \"#{@game.getPhrase()}\"."
				@showPhraseInputForm()
			else if @game.isWon()
				$(".js-message").html "You got it!"
				@showPhraseInputForm()
			else
				tone = if locations.length > 0 then "Nice!" else "Oops!"
				noun = if @game.getAttemptsLeft() > 1 then "guesses" else "guess"
				$(".js-message").html "#{tone} You have #{@game.getAttemptsLeft()} #{noun} left..."

	showPhraseInputForm: ->
		$(".js-phrase-input-form").show()
		$(".js-single-device-phrase-input").val ""

	refreshLetterChoices: ->
		$container = $(".js-letter-choices")
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



class Game
	constructor: (@phrase, @maxAttempts = 5) ->
		@phrase = @phrase.toLowerCase()
		@rightGuesses = []
		@wrongGuesses = []
		@uniqueLetters = []
		for letter in @phrase
			@uniqueLetters.push letter if (letter != " ") and (letter not in @uniqueLetters)
	getPhrase: -> @phrase
	isWon: -> @rightGuesses.length == @uniqueLetters.length
	isLost: -> @wrongGuesses.length >= @maxAttempts
	getAttemptsLeft: -> @maxAttempts - @wrongGuesses.length
	guessLetter: (guess) ->
		guess = guess.toLowerCase()
		locations = []
		for letter,i in @phrase
			locations.push i if letter == guess
		if locations.length > 0
			@rightGuesses.push guess
		else
			@wrongGuesses.push guess
		return locations




$(document).ready ->
	hangRabbit = new HangRabbit
