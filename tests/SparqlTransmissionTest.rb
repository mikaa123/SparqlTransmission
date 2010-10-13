require 'test/unit'
require '../SparqlTransmission'

class SparqlTransmission_Test < Test::Unit::TestCase
  def setup
    @sq = SparqlTransmission.new("http://dbpedia.org/sparql")
  end

  def test_create_SparqlTransmission
    assert(SparqlTransmission.new("http://dbpedia.org/sparql"))
    
    [   "SparqlTransmission.new()",
        "SparqlTransmission.new(2)",
        "SparqlTransmission.new(1..3)",
        "SparqlTransmission.new(['hey'])",
        "SparqlTransmission.new({:t => :test})"
    ].each { |t| assert_raise(ArgumentError, "Error for #{t}") { eval t } }
  end
  
  def test_fail
    assert(true, 'Assertion was false.')
  end
end