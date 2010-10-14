require 'test/unit'
require 'net/http'
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
  
  def test_parse_request
    sq = SparqlTransmission.new("http://dbpedia.org/sparql")
    res = String.new
    File.open('sparql_response.xml').each { |line| res += line }
    result = sq.send(:parse_request, res)
    assert_equal(105, sq.number_of_result, "Wrong number of result")
    assert_equal("subject", result[:variables][0], "Wrong requested variable")
    assert_equal("http://www.openlinksw.com/schemas/virtrdf#DefaultQuadMap-G", result[:results][0][:subject], "Wrong result")
    assert_raise(ArgumentError, "ArgumentError not raised") { sq.send(:parse_request, 1) }
  end
  
  def test_fail
    assert(true, 'Assertion was false.')
  end
end