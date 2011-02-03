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

      sum_of_squares = prefs[person1].inject(0) {|result, element| result + ((prefs[person1][element.first] - prefs[person2][element.first]) ** 2) unless prefs[person2][element.first].nil?}
      return 1/(1+Math::sqrt(sum_of_squares))
    end

  end
end


