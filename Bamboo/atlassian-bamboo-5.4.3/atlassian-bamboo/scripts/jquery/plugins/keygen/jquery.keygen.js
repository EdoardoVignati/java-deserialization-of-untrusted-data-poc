(function (exp, $) {
    exp.KeyGenerator = function () {
        // These words will not be used in key generation for acronyms.
        var IGNORED_WORDS = ["THE", "A", "AN", "AS", "AND", "OF", "OR"],
            // The (non-ascii) characters used as keys will be replaced with their (ascii) value.
            CHARACTER_MAP = {},

            getTotalLength = function (words) {
                return words.join("").length;
            },

            removeIgnoredWords = function (words) {
                return $.grep(words, function (word, index) {
                    return $.inArray(word, IGNORED_WORDS) === -1;
                });
            },

            createAcronym = function (words) {
                var result = "";
                $.each(words, function (i, word) {
                    result += word.charAt(0);
                });
                return result;
            },

            getFirstSyllable = function (word) {
                // Best guess at getting the first syllable
                // Returns the substring up to and including the first consonant to appear after a vowel
                var pastVowel = false;
                var i;
                for (i = 0; i < word.length; i++) {
                    if (isVowelOrY(word[i])) {
                        pastVowel = true;
                    } else {
                        if (pastVowel) {
                            return word.substring(0, i + 1);
                        }
                    }
                }
                return word;
            },

            isVowelOrY = function (c) {
                return c && c.length === 1 && c.search("[AEIOUY]") !== -1;
            };

        CHARACTER_MAP[199] = "C"; // â
        CHARACTER_MAP[231] = "c"; // ?
        CHARACTER_MAP[252] = "u"; // Ù
        CHARACTER_MAP[251] = "u"; // ?
        CHARACTER_MAP[250] = "u"; // Ï
        CHARACTER_MAP[249] = "u"; // ?
        CHARACTER_MAP[233] = "e"; // ?
        CHARACTER_MAP[234] = "e"; // ?
        CHARACTER_MAP[235] = "e"; // Ô
        CHARACTER_MAP[232] = "e"; // ?
        CHARACTER_MAP[226] = "a"; // ä
        CHARACTER_MAP[228] = "a"; // ?
        CHARACTER_MAP[224] = "a"; // ö
        CHARACTER_MAP[229] = "a"; // Î
        CHARACTER_MAP[225] = "a"; // à
        CHARACTER_MAP[239] = "i"; // ¥
        CHARACTER_MAP[238] = "i"; // Ó
        CHARACTER_MAP[236] = "i"; // Ò
        CHARACTER_MAP[237] = "i"; // Õ
        CHARACTER_MAP[196] = "A"; // Û
        CHARACTER_MAP[197] = "A"; // ?
        CHARACTER_MAP[201] = "E"; // Ä
        CHARACTER_MAP[230] = "ae"; // ?
        CHARACTER_MAP[198] = "Ae"; // ¨
        CHARACTER_MAP[244] = "o"; // ª
        CHARACTER_MAP[246] = "o"; // ?
        CHARACTER_MAP[242] = "o"; // ÷
        CHARACTER_MAP[243] = "o"; // Ñ
        CHARACTER_MAP[220] = "U"; //  
        CHARACTER_MAP[255] = "Y"; // ¯
        CHARACTER_MAP[214] = "O"; // É
        CHARACTER_MAP[241] = "n"; // Ð
        CHARACTER_MAP[209] = "N"; // ã

        return {
            generateKey: function (name, options) {
                options = $.extend({}, options);

                var desiredKeyLength = (typeof options.desiredKeyLength == 'number') ? options.desiredKeyLength : 4,
                    maxKeyLength = (typeof options.maxKeyLength == 'number') ? options.maxKeyLength : Infinity,
                    charBlacklistRegex = (typeof options.charBlacklistRegex != 'undefined'? options.charBlacklistRegex : /[^a-zA-Z0-9]/g);

                name = $.trim(name);
                if (!name) {
                    return "";
                }

                // Brute-force chunk-by-chunk substitution and filtering.
                var filtered = [];
                for (var i = 0, ii = name.length; i < ii; i++) {
                    var sub = CHARACTER_MAP[name.charCodeAt(i)];
                    filtered.push(sub ? sub : name[i]);
                }

                name = filtered.join('');

                // Split into words
                var words = [];
                $.each(name.split(/\s+/), function (i, word) {
                    if (word) {
                        // Remove blacklisted characters
                        word = word.replace(charBlacklistRegex, "");
                        // uppercase the word (NOTE: JavaScript attempts to convert characters like Â•Ã€? in to SS)
                        word = word.toUpperCase();
                        // add the word, should it be worthy.
                        word.length && words.push(word);
                    }
                });

                // Remove ignored words
                if (desiredKeyLength && getTotalLength(words) > desiredKeyLength) {
                    words = removeIgnoredWords(words);
                }

                var key;

                if (words.length == 0) {
                    // No words were worthy!
                    key = "";
                } else if (words.length == 1) {
                    // If we have one word, and it is longer than a desired key, get the first syllable

                    var word = words[0],
                        firstSyllable = getFirstSyllable(word);

                    if (maxKeyLength < word.length || // must use the smaller one
                        Math.abs(word.length - desiredKeyLength) >= Math.abs(firstSyllable.length - desiredKeyLength)) { // should use the smaller one because it's closer to desired length.
                        key = firstSyllable;
                    } else {
                        key = word;
                    }
                } else {
                    var totalLength = getTotalLength(words),
                        acronym = createAcronym(words);
                    if (maxKeyLength < totalLength  || // must use the smaller one
                        Math.abs(totalLength - desiredKeyLength) >= Math.abs(acronym.length - desiredKeyLength)) { // should use the smaller one because it's closer to desired length.
                        key = acronym;
                    } else {
                        // The words are short enough to use as a key
                        key = words.join('');
                    }
                }

                // Limit the length of the key
                if (maxKeyLength && key.length > maxKeyLength) {
                    key = key.substr(0, maxKeyLength);
                }

                return key;
            }
        };
    };

    var keyGenerator = exp.KeyGenerator();

    $.fn.generateFrom = function ($nameElement, options) {
        var defaultOptions = {
                desiredKeyLength: 4,
                maxKeyLength: 10,
                maxNameLength: 30,
                timeoutMS: 100,
                charBlacklistRegex: /[^a-zA-Z0-9]/g, // Remove whitespace and punctuation characters (i.e. anything not A-Z or 0-9)
                uppercase: true,
                validationCallback: function () {
                },
                errorCallback: function () {
                }
            },

            $keyElement = $(this).first(),

            $nameElement = $nameElement.first(),

            options = $.extend({}, defaultOptions, options);

        (function () {
            var shouldUpdateKey = function () {
                    return $keyElement.data("autosuggest") !== false;
                },

                setKeyEdited = function (key) {
                    if (key) {
                        // If the key is manually edited, do not suggest automatically generated keys anymore
                        if ($keyElement.data("lastGeneratedValue") !== key) {
                            $keyElement.data("autosuggest", false);
                        }
                    } else {
                        // If the user deletes the entire key field, turn suggest back on.
                        $keyElement.data("autosuggest", true);
                    }
                },

                updateKey = function (key) {
                    var oldKey = $keyElement.val();
                    $keyElement.data("lastGeneratedValue", key);
                    $keyElement.val(key);
                    return oldKey != key;
                },

                onNameTimeout = function () {
                    setKeyEdited($keyElement.val());
                    autofillKeyIfNeeded();
                },

                bindNameHook = function (e) {
                    bindHook(e, onNameTimeout);
                },

                bindHook = function (e, func) {
                    var el = $(e.target), hook;
                    hook = function () {
                        unbindHook(e);
                        func();
                        if (el.is(":visible")) {
                            el.data("checkHook", setTimeout(hook, options.timeoutMS));
                        }
                    };
                    if (!el.data("checkHook")) {
                        el.data("checkHook", setTimeout(hook, 0));
                    }
                },

                unbindHook = function (e) {
                    var el = $(e.target);
                    clearTimeout(el.data("checkHook"));
                    el.removeData("checkHook");
                },

                autofillKeyIfNeeded = function () {
                    if (shouldUpdateKey()) {
                        var key = keyGenerator.generateKey($nameElement.val(), {
                            desiredKeyLength: options.desiredKeyLength,
                            maxKeyLength: options.maxKeyLength,
                            charBlacklistRegex: options.charBlacklistRegex
                        });
                        if (updateKey(key)) {
                            options.validationCallback();
                        }
                    }
                };

            // Input restrictions
            $nameElement.attr("maxlength", options.maxNameLength);
            $keyElement.attr("maxlength", options.maxKeyLength);
            if (options.uppercase) {
                $keyElement.css("text-transform", "uppercase");
            }

            // Poll the name field for updates
            if (document.activeElement && document.activeElement === $nameElement[0]) {
                bindNameHook({ target: $nameElement[0] });
            }
            $nameElement.focus(bindNameHook);
            $nameElement.blur(unbindHook);

        })();

        return this;
    };
})(window, jQuery);
