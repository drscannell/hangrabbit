class HangRabbit
	constructor: ->
		# properties
		@ENTER_KEYCODE = 13
		@game = null

		tap = if 'ontouchstart' in window then 'touchstart' else 'click'

		# events
		$(".js-phrase-input").on 'keypress',  @handleKeystroke
		$(".js-letter-choices").on tap, @handleLetterChoiceEvent
		$(".js-submit").on "click", @submitPhrase

		# svg
		svgObject = document.getElementById "svg"
		svgDoc = svgObject.contentDocument
		@face = svgDoc.getElementById "face"
		@bodyparts = [
			svgDoc.getElementById "head"
			svgDoc.getElementById "torso"
			svgDoc.getElementById "left_arm"
			svgDoc.getElementById "right_arm"
			svgDoc.getElementById "right_leg"
			svgDoc.getElementById "left_leg"
		]

	hideKeyboard: ->
		document.activeElement.blur()
		$(".js-phrase-input").blur()
	
	handleKeystroke: ($ev) =>
		if $ev.keyCode == @ENTER_KEYCODE
			@submitPhrase()

	validatePhrase: (phrase, callback) ->
		if phrase.length < 3
			callback "At least 3 letters!"
		else
			callback null

	submitPhrase: =>
		phrase = $(".js-phrase-input").val()
		@validatePhrase phrase, (err) =>
			if err
				$('.js-warning').html err
			else
				@loadNewGame phrase
				@hideKeyboard

	loadNewGame: (phrase) ->
		$(".js-phrase-input-form").hide()
		@refreshLetterChoices()
		phrase = phrase.toLowerCase()
		@game = new Game phrase
		$(".js-message").html "Select a letter. You have #{@game.getAttemptsLeft()} guesses left."
		$(".js-phrase-input").blur()
		$clueArea = $(".js-letter-underlines")
		$clueArea.empty()
		for letter in phrase
			if letter.match /[^a-z]/i
				$clueArea.append "<span class=\"char space\" >#{letter}</span>"
			else
				$clueArea.append "<span class=\"char underscore\" />"
		for bodypart in @bodyparts
			bodypart.setAttribute "class", "hidden"
		@face.setAttribute "class", "hidden"
	
	handleLetterChoiceEvent: ($ev) =>
		shouldHandleLetterChoice = true
		if @game.isLost() then shouldHandleLetterChoice = false
		if @game.isWon() then shouldHandleLetterChoice = false
		if not $($ev.target).hasClass "letter-choice" then shouldHandleLetterChoice = false
		if $($ev.target).hasClass "disabled" then shouldHandleLetterChoice = false
		
		if shouldHandleLetterChoice
			$($ev.target).addClass "disabled"
			guess = $ev.target.innerHTML
			@handleGuess guess

	handleGuess: (guess) =>
		locations = @game.guessLetter guess
		if locations.length == 0
			n = @game.maxAttempts - @game.getAttemptsLeft() - 1
			@bodyparts[n].setAttribute "class", "reveal"
		for location in locations
			$(".char").eq(location).removeClass("underscore").addClass("guessed").html(guess)
		if @game.isLost()
			@face.setAttribute "class", "reveal"
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
		$(".js-phrase-input").val ""
		$('.js-warning').html ""

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
	constructor: (@phrase, @maxAttempts = 6) ->
		@phrase = @phrase.toLowerCase()
		@rightGuesses = []
		@wrongGuesses = []
		@uniqueLetters = []
		for letter in @phrase
			if letter.match(/[a-z]/i) and letter not in @uniqueLetters
				@uniqueLetters.push letter
	getPhrase: -> @phrase
	isWon: =>
		@rightGuesses.length == @uniqueLetters.length
	isLost: ->
		@wrongGuesses.length >= @maxAttempts
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



window.addEventListener 'load', ()->
	hangRabbit = new HangRabbit
, false
