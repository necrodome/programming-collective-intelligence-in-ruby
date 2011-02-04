require 'helper'

class TestChapter2 < Test::Unit::TestCase
  def setup
    @recommender = Chapter2::Recommender.new
  end

  def test_loaded_data_count
    assert_equal 8, @recommender.sample_data.length
  end

  def test_no_similar_items
    people = @recommender.sample_data
    similarity_score = @recommender.sim_distance(people, 'Selem', 'Toby')
    assert_equal 0, similarity_score
  end

  def test_similar_items_sim_distance
    people = @recommender.sample_data
    similarity_score = @recommender.sim_distance(people, 'Lisa Rose', 'Gene Seymour')
    assert_in_delta 0.294298055085549, similarity_score, 0.00001
  end

  def test_similar_items_sim_pearson
    people = @recommender.sample_data
    similarity_score = @recommender.sim_pearson(people, 'Lisa Rose', 'Gene Seymour')
    assert_in_delta 0.396059017191, similarity_score, 0.00001
  end

  def test_top_matches
    people = @recommender.sample_data
    matches = @recommender.top_matches(people, 'Toby', 3)

    assert_equal 3, matches.length

    assert_equal "Lisa Rose", matches.first[1]
    assert_in_delta 0.99124070716192991, matches.first[0], 0.00001

    assert_equal "Mick LaSalle", matches[1][1]
    assert_in_delta 0.92447345164190486, matches[1][0], 0.00001
  end


end
