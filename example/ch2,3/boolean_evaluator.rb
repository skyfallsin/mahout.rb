require 'java'
require File.dirname(__FILE__) + '/../../mahout'

import org.apache.mahout.cf.taste.impl.model.file.FileDataModel
import org.apache.mahout.cf.taste.impl.model.GenericBooleanPrefDataModel
import org.apache.mahout.cf.taste.impl.similarity.PearsonCorrelationSimilarity
import org.apache.mahout.cf.taste.impl.similarity.LogLikelihoodSimilarity
import org.apache.mahout.cf.taste.impl.neighborhood.NearestNUserNeighborhood
import org.apache.mahout.cf.taste.impl.recommender.GenericUserBasedRecommender
import org.apache.mahout.cf.taste.impl.recommender.GenericBooleanPrefUserBasedRecommender
import org.apache.mahout.cf.taste.impl.eval.RMSRecommenderEvaluator
import org.apache.mahout.cf.taste.impl.eval.GenericRecommenderIRStatsEvaluator
import org.apache.mahout.cf.taste.impl.eval.AverageAbsoluteDifferenceRecommenderEvaluator
import org.apache.mahout.cf.taste.eval.RecommenderBuilder
import org.apache.mahout.cf.taste.eval.DataModelBuilder


class CustomRecommender
  include RecommenderBuilder

  def build_recommender(model)
#    similarity = PearsonCorrelationSimilarity.new(model)
    similarity = LogLikelihoodSimilarity.new(model)
    neighborhood = NearestNUserNeighborhood.new(10, similarity, model)
#    GenericUserBasedRecommender.new(model, neighborhood, similarity)
    GenericBooleanPrefUserBasedRecommender.new(model, neighborhood, similarity)
  end
end

class CustomDataModel
  include DataModelBuilder

  def build_data_model(training_data)
    GenericBooleanPrefDataModel.new(
      GenericBooleanPrefDataModel.toDataMap(training_data))
  end
end

#model = FileDataModel.new(java.io.File.new(ARGV[0] || "data.csv"))
#evaluator = RMSRecommenderEvaluator.new 
#puts "RMSQ: "+evaluator.evaluate(CustomRecommender.new, nil, model, 0.7, 1.0).to_s



model = GenericBooleanPrefDataModel.new(FileDataModel.new(java.io.File.new(ARGV[0])))
evaluator = AverageAbsoluteDifferenceRecommenderEvaluator.new
recommender_builder = CustomRecommender.new 
model_builder = CustomDataModel.new

puts evaluator.evaluate(recommender_builder, model_builder, model, 0.9, 1.0)

ir_evaluator = GenericRecommenderIRStatsEvaluator.new
stats = ir_evaluator.evaluate(recommender_builder, model_builder, model, nil, 10,
  GenericRecommenderIRStatsEvaluator::CHOOSE_THRESHOLD, 1.0)
puts "PRECISION: #{stats.precision}"
puts "RECALL: #{stats.recall}"
