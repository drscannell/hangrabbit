// Generated by CoffeeScript 1.6.3
(function() {
  var HangRabbit,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  HangRabbit = (function() {
    function HangRabbit() {
      this.handleTextInputEnter = __bind(this.handleTextInputEnter, this);
      this.ENTER_KEYCODE = 13;
      $(".js-phrase-input").keyup(this.handleTextInputEnter);
      this.refreshLetterChoices();
    }

    HangRabbit.prototype.refreshLetterChoices = function() {
      var $container, c, x, _i, _results;
      $container = $('.js-letter-choices');
      $container.empty();
      _results = [];
      for (x = _i = 65; _i <= 90; x = ++_i) {
        c = String.fromCharCode(x);
        _results.push($container.append("<span class=\"letter-choice\">" + c + "</span>"));
      }
      return _results;
    };

    HangRabbit.prototype.handleTextInputEnter = function($ev) {
      var inputText;
      if ($ev.keyCode === this.ENTER_KEYCODE) {
        inputText = $(".js-phrase-input").val();
        return this.validateInput(inputText);
      }
    };

    HangRabbit.prototype.validateInput = function(phrase) {
      var li, phrases;
      phrases = ((function() {
        var _i, _len, _ref, _results;
        _ref = $("li.js-phrase");
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          li = _ref[_i];
          _results.push(li.innerHTML);
        }
        return _results;
      })()) || [];
      if (__indexOf.call(phrases, phrase) >= 0) {
        return this.showValidationMessage("You already added that!");
      } else {
        this.addPhrase(phrase);
        return this.clearPhraseInput();
      }
    };

    HangRabbit.prototype.showValidationMessage = function(message) {
      return $(".js-validation-message").html(message);
    };

    HangRabbit.prototype.addPhrase = function(phrase) {
      var html;
      console.log("Adding phrase: '" + phrase + "'");
      html = "<li class=\"js-phrase\">" + phrase + "</li>";
      return $(".js-phrase-list").append(html);
    };

    HangRabbit.prototype.clearPhraseInput = function() {
      return $('.js-phrase-input').val("");
    };

    return HangRabbit;

  })();

  $(document).ready(function() {
    var hangRabbit;
    return hangRabbit = new HangRabbit;
  });

}).call(this);
