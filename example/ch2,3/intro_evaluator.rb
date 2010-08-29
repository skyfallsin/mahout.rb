require 'java'
require File.dirname(__FILE__) + '/../../mahout'

import org.apache.mahout.cf.taste.impl.model.file.FileDataModel
import org.apache.mahout.cf.taste.impl.similarity.PearsonCorrelationSimilarity
import org.apache.mahout.cf.taste.impl.neighborhood.NearestNUserNeighborhood
import org.apache.mahout.cf.taste.impl.recommender.GenericUserBasedRecommender
import org.apache.mahout.cf.taste.impl.eval.RMSRecommenderEvaluator
import org.apache.mahout.cf.taste.impl.eval.GenericRecommenderIRStatsEvaluator
import org.apache.mahout.cf.taste.eval.RecommenderBuilder


class CustomRecommender
  include RecommenderBuilder

  def build_recommender(model)
    similarity = PearsonCorrelationSimilarity.new(model)
    neighborhood = NearestNUserNeighborhood.new(2, similarity, model)
    GenericUserBasedRecommender.new(model, neighborhood, similarity)
  end
end

model = FileDataModel.new(java.io.File.new(ARGV[0] || "data.csv"))
evaluator = RMSRecommenderEvaluator.new 
puts "RMSQ: "+evaluator.evaluate(CustomRecommender.new, nil, model, 0.7, 1.0).to_s

ir_evaluator = GenericRecommenderIRStatsEvaluator.new
stats = ir_evaluator.evaluate(CustomRecommender.new, nil, model, nil, 2,
  GenericRecommenderIRStatsEvaluator::CHOOSE_THRESHOLD, 1.0)
puts "PRECISION: #{stats.precision}"
puts "RECALL: #{stats.recall}"

