class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  attr_accessor :word, :guesses, :wrong_guesses
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    raise ArgumentError if letter.nil?
    if letter.match?(/\A[a-zA-Z]\z/) 
      letter = letter.downcase
      if @word.include?(letter)
        if @guesses.include?(letter)
          return false
        else
          @guesses << letter
        end
      else
        if @wrong_guesses.include?(letter)
          return false
        else
          @wrong_guesses << letter
        end
      end
      true
    else
      raise ArgumentError
    end
  end

  def word_with_guesses
    result = ''
    @word.each_char do |char|
      if @guesses.include?(char)
        result << char
      else
        result << '-'
      end
    end
    result
  end

  def check_win_or_lose
    if !word_with_guesses.include?('-')
      :win
    elsif @wrong_guesses.length >= 7
      :lose
    else
      :play
    end
  end
  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('https://esaas-randomword-27a759b6224d.herokuapp.com/RandomWord') 
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http| 
      return http.post(uri, "").body
    end
  end
end
