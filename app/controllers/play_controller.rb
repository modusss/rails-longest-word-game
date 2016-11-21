require 'open-uri'
require 'json'

class PlayController < ApplicationController
  def game
    @grid = generate_grid(10)
  end

  def score
    @result = run_game(params[:shot],params[:form_grid],params[:start_time], Time.now)
  end

#private

  def generate_grid(grid_size)
    #generate a randomized array of letters in a given size
    chars = 'abcdefghjkmnpqrstuvwxyz'
    grid  = ''
    grid_size.times { grid << chars[rand(chars.size)] }
    return grid.split("")
  end

  def run_game(attempt, grid, start_time, end_time)

    #we have to test if the string "attempt" is fully inside the "grid" array
    valid = true
    score_number = 0
    #verifing if the word received "attempt" is included into the random words created by the method 'generate_grid'
    attempt.split('').each do|l|
      valid = true if grid.include?(l)
      score_number += 1
    end
    result = {}
    #we have to get a score mesured balancing the time and the quantity of words matched by the user
    result[:time] = end_time.to_f - start_time.to_f
    result[:score] = score_number.to_f**3 / result[:time]
    if valid
      #the api with the given key inside plus the 'attempt' parameter interpolated at the end
      url = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=71d98ae3-25fd-40a9-a513-c32cc840b38f&input=#{attempt}"
      trans = JSON.parse(open(url).read)
      #in this hash gets the first element of the hash translation (who has only one element)
      #and from this result returns the value from "output" key
      result[:translation] = trans["outputs"].first["output"]
      if result[:translation] != attempt
        result[:message] = "well done"
      else
        result[:message] = "not an english word"
        result[:score] = 0
        result[:translation] = ""
      end
      return result
    else
      result[:message] = "not in the grid"
      result[:score] = 0
      return result
    end

  end
end
