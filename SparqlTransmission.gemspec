Gem::Specification.new do |spec|
  
  spec.name = 'SparqlTransmission'
  spec.author = 'Michael Sokol'
  spec.email = 'mikaa123@gmail.com'
  spec.homepage = 'http://github.com/mikaa123/SparqlTransmission'
  spec.version = '1.1'
  spec.summary = 'SparqlTransmission handles SPARQL queries over distant
    end-point and format the results in a ruby hash'
  spec.files = %w[
    Rakefile
    README
    SparqlTransmission.gemspec
    lib/SparqlTransmission.rb
    tests/SparqlTransmissionTest.rb
    tests/sparql_response.xml
    tests/sparql_foaf_response.xml
    examples/example.rb
  ]
  spec.test_files = %w[
    tests/SparqlTransmissionTest.rb
    tests/sparql_response.xml
    tests/sparql_foaf_response.xml    
  ]
                  
  
end