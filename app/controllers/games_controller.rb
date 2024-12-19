require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('a'..'z').to_a.sample }
  end

  def score
    # set variables
    @word = params['user_input']
    @letters = params['letters']
    @result = ''
    # use dictionary api
    url = "https://dictionary.lewagon.com/#{@word}"
    response = URI.parse(url).read
    json_response = JSON.parse(response)
    # check if @word is in the dictionary and return true or false
    dictionary_valid = json_response['found']
    # check if @word comes out of the grid and return true or false
    grid_valid = @word.chars.all? do |char|
      @word.count(char) <= @letters.count(char)
    end

    # The word can’t be built out of the original grid ❌
    # The word is valid according to the grid, but is not a valid English word ❌
    if grid_valid == false && dictionary_valid == false
      @result = "Sorry! #{@word.capitalize} doesn't built out of the grid and it is not in the dictionary."
    elsif grid_valid == true && dictionary_valid == false
      @result = "Sorry! #{@word.capitalize} is not in the dictionary."
    elsif grid_valid == false && dictionary_valid == true
      @result = "Sorry! #{@word.capitalize} doesn't built out of the grid."
    elsif grid_valid == true && dictionary_valid == true
      @result = "Congraturations! #{@word.capitalize} is a valid English word. (Your score: ---)."
    end
    # raise
  end
end
