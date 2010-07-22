# class representing the current state of a filter search,
# which is simply a group of keys with filter terms as values
class SearchFilter
  
  # has containing filters that can be set
  attr_accessor :valid_filters
  
  # current state of the filter search
  attr_reader :current_filters
  

  # Class variables
  @filter_types = [:id, :text]
  @filter_index = {}
  
  class << self
    # list of all filter types handelled by the class
    attr_reader :filter_types
    # index of all filters created
    attr_accessor :filter_index
  end
  
  def initialize valid_filters = {}, name = nil
    distinct_filters = valid_filters.values.uniq
    raise "Invalid filter types supplied #{(distinct_filters - (SearchFilter.filter_types & distinct_filters)).join(',')}" if (distinct_filters & SearchFilter.filter_types).length != distinct_filters.length
    
    @current_filters = {}
    @valid_filters   = valid_filters
    
    SearchFilter.filter_index[name] = self if name
  end
  
  def load_filters(params, setup = @valid_filters)
    @current_filters = prepare_filters(params, setup)
  end
  
  # turns an input hash into a hash of valid, prepared filters
  def prepare_filters(input, setup = @valid_filters)
    input = input.keys_to_symbols
    (setup.keys & input.keys).inject({}) do |prepared, filter|
      # TODO if we ever do more complex filters (eg multiple ids, where logically they're stored as a list but go
      # back to a csv string for display), this is where we do it
      prepared.merge(filter => input[filter])
    end
  end
  
  def current_filters_with(filter)
    # TODO if we ever add multiple values per filter (eg UNION or OR on tags) refactor this
    filter = prepare_filters(filter)
    current_filters.merge(filter)
  end
  
end