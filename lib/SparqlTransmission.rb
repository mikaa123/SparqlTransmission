require 'net/http'
require 'rexml/document'

# This class allows the transmission of a SPARQL request to a SPARQL end-point.
# It then parses the result of the query
class SparqlTransmission
  
  attr_reader :number_of_result
  
  # This method initialize the SparqlTransmission with the URL of an end-point
  def initialize(uri)
    unless uri.is_a? String
      raise ArgumentError, "You must provide a valid uri as arguments"
    end
    @uri = URI.parse uri
    @number_of_result = nil
    @result = nil
  end
  
  # Returns the results of the request, which are an array of hash
  def results; @result[:results] if @result != nil; end
  
  # Returns the list of request variables in the query
  def requested_variables; @result[:variables] if @result != nil; end
  
  # Assigns a SPARQL query
  def query=(str)
    unless str.is_a? String
      raise ArgumentError, "The query must be a String"
    end
    begin
      @query = URI.escape str
    rescue
      # The URI.escape method doesn't work on the current version of Shoes, so here is an alternative
      caracters = {" " => "%20", "{" => "%7b", "}" => "%7d", "<" => "%3c", ">" => "%3e", ":" => "%3a", "?" => "%3f", "'" => "%27",
                   "(" => "%28", ")" => "%29", "/" => "%2f", "," => "%2c", "#" => "%23"}
      @query = str.gsub(/[^a-zA-Z0-9_\.\-]/) { |s| caracters[s] }
    end
    self
  end
  
  # Checks if the current transmission received any result
  def has_result?; @result != nil; end
  
  # Executes the current request synchronously
  def execute_query
    if @query
      http = Net::HTTP.new(@uri.host)
      http.open_timeout = 10
      request = Net::HTTP::Get.new(@uri.request_uri + "?query=#{@query}")
      request['Accept'] = "application/sparql-results+xml"
      response = http.request(request)
      if response.is_a? Net::HTTPSuccess; @result = parse_request(response.body)
      else raise Exception, "HTTP Error"; end
      self
    end
  end
  
  # Same as execute_query, but does it on a speratate thread, so the main thread
  # don't get blocked until a response arrives
  def execute_async_query
    if @query
      th = Thread.new(@query) do |query|
        http = Net::HTTP.new(@uri.host)
        http.open_timeout = 10
        request = Net::HTTP::Get.new(@uri.request_uri + "?query=#{query}")
        request['Accept'] = "application/sparql-results+xml"
        response = http.request(request)
        if response.is_a? Net::HTTPSuccess; @result = parse_request(response.body)
        else raise Exception, "HTTP Error"; end
        yield results
        self
      end
    end
  end
  
  private
  # Used to parse the XML received by the SPARQL end-point
  def parse_request(req)
    unless req.is_a? String
      raise ArgumentError, "The response must be a String"
    end
    doc = REXML::Document.new(req)
    
    # Getting the list of sparql variables
    res = {:variables => doc.elements.collect('sparql/head/variable') do |element|
      element.attribute('name').to_s
    end}

    # Getting the result list
    res[:results] = doc.elements.collect('sparql/results/result') do |element|
      current_result = {}

      # Finding the binding variable for the result
      element.each_element('binding') do |elt|
        bind = elt.attribute('name').to_s.to_sym
        elt.each_element('*') { |e| current_result[bind] = e.text }
      end
      current_result
    end

    @number_of_result = res[:results].length
    res
  end
  
end