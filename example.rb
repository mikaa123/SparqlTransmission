require 'SparqlTransmission'

st = SparqlTransmission.new("http://dbpedia.org/sparql")

#sq.results

#p sq.has_result?

st.query = %[
  SELECT ?person ?city
  WHERE 
  { 
    ?person <http://dbpedia.org/ontology/birthPlace> ?city
  }
]

st.execute_query.results[1..5].each {|res| puts res.collect { |r| r * ": "} * " | "}

p st.has_result?