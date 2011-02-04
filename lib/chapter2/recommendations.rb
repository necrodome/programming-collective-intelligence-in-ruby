require 'yaml'

module Chapter2
  class Recommender
    attr_accessor :sample_data

    def initialize
      @sample_data = YAML::load(File.open(File.join(File.dirname(__FILE__),"data.yml")))
    end

    # Returns a distance-based similarity score for person1 and person2
    def sim_distance(prefs, person1, person2)
      #return 0 if no items shared
      return 0 if prefs[person1].keys.detect {|item| prefs[person2].keys.include? item }.nil?

      # Add up the squares of all the differences
      squares = []
      for item in prefs[person1].keys
        if prefs[person2].include? item
          squares << (prefs[person1][item] - prefs[person2][item]) ** 2
        end
      end

      sum_of_squares = squares.inject { |sum,value| sum += value }
      return 1/(1+Math::sqrt(sum_of_squares))
    end

    # Returns the Pearson correlation coefficient for p1 and p2
    def sim_pearson(prefs, p1, p2)
      # Get the list of mutually rated items
      si = prefs[p1].keys.select {|item| prefs[p2].keys.include? item}

      # if there are no ratings in common, return -1
      return -1 if si.length == 0

      # Add up all the preferences
      sum1 = si.inject(0) { |sum,value| sum += prefs[p1][value] }
      sum2 = si.inject(0) { |sum,value| sum += prefs[p2][value] }

      # Sum up the squares
      sum1Sq = si.inject(0) { |sum,value| sum += prefs[p1][value] ** 2 }
      sum2Sq = si.inject(0) { |sum,value| sum += prefs[p2][value] ** 2 }

      # Sum up the products
      pSum = si.inject(0) { |sum,value| sum += (prefs[p1][value] * prefs[p2][value])}

      # Calculate the Pearson score
      n = si.length
      num = pSum - (sum1*sum2/n)
      den = Math.sqrt((sum1Sq - (sum1 ** 2)/n) * (sum2Sq - (sum2 ** 2)/n))

      return 1 if den == 0
      r = num / den
    end

    def top_matches(prefs, person, n = 5, similarity = :sim_pearson)
      scores = prefs.keys.collect {|other| [self.send(similarity, prefs, person, other), other] if other != person}.compact
      scores.sort!
      scores.reverse!
      scores[0...n]
    end

  end
end


