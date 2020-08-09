function! s:rand(max)
  return str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:]) % a:max
endfunction

function! s:random_word(str)
  let words = split(a:str)
  if len(words) == 0
    return
  endif
  let long_words = filter(words, 'len(v:val) > 3')
  if len(long_words) > 10
    return long_words[s:rand(len(long_words))]
  endif
  return words[s:rand(len(words))]
endfunction

function! spellshock#play()
  let original_spell = &spell
  set spell

  let content = join(getline(1, '$'), "\n")
  if len(content) == 0
    echo "empty file!"
    return
  end
  let og_word = s:random_word(content)
  let word = substitute(og_word, '[,.!?''\"]', '', 'g') " remove punctuation

  let suggestions = spellsuggest(word, 50)
  let idx = s:rand(len(suggestions)/2 + (len(suggestions)/2)) " discard the first half of the suggestions
  let sug = suggestions[idx]

  while 1
    let guess = input('suggestion: ' . sug . ", your guess: ")
    if guess == ''
      echo "\r"
      echo 'you gave up! the answer was "' . word . '" and your suggestion was "' . sug . '"'
      break
    endif
    if guess == word
      echo "\r"
      echo 'correct! the answer was "' . word . '" and your suggestion was "' . sug . '"'
      break
    endif
  endwhile

  let &spell = original_spell
endfunction
