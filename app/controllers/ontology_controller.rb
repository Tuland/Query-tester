include Java
include_class 'com.hp.hpl.jena.rdf.model.ModelFactory'
include_class 'com.hp.hpl.jena.ontology.OntModelSpec'
include_class 'com.hp.hpl.jena.ontology.OntModel'
include_class 'com.hp.hpl.jena.ontology.Ontology'
include_class 'com.hp.hpl.jena.query.QueryFactory'
include_class 'com.hp.hpl.jena.query.QueryExecutionFactory'
include_class 'com.hp.hpl.jena.query.ResultSetFormatter'


include_class 'java.lang.System'

class OntologyController < ApplicationController
  
  UNDEFINED_PREFIX = "[Undefined]"
  
  URL = "http://0.0.0.0:3000/onto/02_07_mantic_global.owl"
  BASE = "http://www.semanticweb.org/ontologies/2010/4/mantic_global.owl"
  MODEL = ModelFactory.createOntologyModel(OntModelSpec::OWL_MEM)
  MODEL.read(URL, "RDF/XML")
  
  
  layout 'main', :except => [ :load, :search, :edit ]
  
  def index
    @header = "Query Tester"
  end
  
  def search
    
    session[:prefixes].remove("")
    prefixes_map = session[:prefixes]
    
    prefix_str = ""
    prefixes_map.each do |key, value|
      prefix_str << "PREFIX " + key + ": "
      prefix_str << "<" + value +">\n"
    end
    
    if params[:query][:select_enable] == "1"
      select_str = "SELECT "+ params[:query][:select]
    else
      select_str = "CONSTRUCT " + params[:query][:construct] 
    end

    select_str << "\n"
    
    where_str = "WHERE " + params[:query][:where] + "\n"
    
    other_str = ""
    if params[:query][:other_enable] == "1"
      other_str << params[:query][:other]
    end
    
    query_str = prefix_str + select_str + where_str + other_str
    
    query = QueryFactory.create(query_str)
    qe = QueryExecutionFactory.create(query, MODEL)
    results = qe.execSelect()
    
    @results = ResultSetFormatter.asText(results)
    
    qe.close()
    
  end
  
  def load

    @base_str = "base " + BASE
    @url_str = "URL: " + URL
    
    @prefix_map = MODEL.getNsPrefixMap

    session[:prefixes] = @prefix_map.dup
    
  end

  def edit
    @e_uri = params[:uri]
    @e_value = params[:value]
    @e_editorId = params[:editorId]
    @e_old_prefix = params[:old_prefix]

    if @e_old_prefix == UNDEFINED_PREFIX
      session[:prefixes].remove("")
    else
      session[:prefixes].remove(@e_old_prefix)
    end
    session[:prefixes][@e_value] = @e_uri
  end
  
end