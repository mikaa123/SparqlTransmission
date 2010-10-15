require 'SparqlTransmission'

# Creates a SparqlTransmission and initialize the object on the SPARQL end-point URL
st = SparqlTransmission.new("http://dbpedia.org/sparql")

# Creates the SPARQL query
st.query = %[
  SELECT ?subject ?predicat ?object
  WHERE 
  { 
    ?subject ?predicat ?object
  }
]

# To execute the query, do
st.execute_query

# The results can then be fetched using the result method
res = st.results

# You can also chain the process, and do the following to view the results
# line by line, such as
#
#   variable1: URI, variable2: URI, ..., variableN: URI
st.execute_query.results.each do |res|
  puts res.collect { |r| r * ": "} * ", "
end

# Same as above, but asynchronous
st.execute_async_query.results.each do |res|
  puts res.collect { |r| r * ": "} * ", "
end

# To get the number of results returned by the query
puts st.number_of_result

# To get the names of the variables requested
puts st.requested_variables