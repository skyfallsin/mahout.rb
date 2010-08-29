require 'java'
require File.dirname(__FILE__) + '/../../mahout'

import org.apache.mahout.cf.taste.impl.model.file.FileDataModel
import org.apache.mahout.cf.taste.impl.similarity.PearsonCorrelationSimilarity
import org.apache.mahout.cf.taste.impl.neighborhood.NearestNUserNeighborhood
import org.apache.mahout.cf.taste.impl.recommender.GenericUserBasedRecommender


class RecommenderIntro
  def initialize(*args)
    puts filename = ARGV[0] || "data.csv"
    model = FileDataModel.new(java.io.File.new(filename))
    similarity = PearsonCorrelationSimilarity.new(model)
    neighborhood = NearestNUserNeighborhood.new(1000, similarity, model)
    recommender = GenericUserBasedRecommender.new(model, neighborhood, similarity)
    recommender.recommend(ARGV[1].to_i, 5).each{|x| puts x}
  end
end

RecommenderIntro.new
