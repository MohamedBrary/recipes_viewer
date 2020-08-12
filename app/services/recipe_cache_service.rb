# This service can easily be turned into a general model caching service,
# that takes the model also as a parameter, or be extended to specific model service
class RecipeCacheService
  attr_accessor :action, :action_params

  # expiration times can be adjusted based on freuqncy of creating and updating entries
  ENTRY_EXPIRY = 12.hours
  LIST_EXPIRY = 6.hours

  # this object is initialized with two params:
  # action: one of these values [:list, :find]
  # action_params: params for the given action
  # list: requires 'per_page', and 'page' keys
  # find: requires 'id' key
  def initialize(action:, action_params:)
    @action = action
    @action_params = action_params
  end

  def call
    case action
    when :list
      check_list_params
      list
    when :find
      check_find_params
      find
    end
  end

  def list
    # we cache the ids of the given list, with these specific pagination params
    cached_list_value = Rails.cache.read("recipes/list/#{per_page_param}/#{page_param}")

    # if not cached we retrieve the list, then cache it
    if cached_list_value.blank?
      recipes = Recipe.all(per_page: per_page_param, page: page_param)
      cache_list(recipes)
    else
      ids = cached_list_value[:ids]
      total_entries = cached_list_value[:total_entries]
      # to support pagination for plain arrays, by utlizing 'total_entries' value
      WillPaginate::Collection.create(page_param, per_page_param, total_entries) do |pager|
        pager.replace(read_list_cache(ids))
      end
    end

  end

  def find(id=nil)
    id ||= id_param
    Rails.cache.fetch("recipes/#{id}", expires_in: ENTRY_EXPIRY) do
      # raises Exceptions::RecordNotFound when recipe not found
      Recipe.find(id)
    end
  end

  private

  # ---------
  # Basic Cache Calls

  def cache_list(list)
    # cache the ids, and total_entries for pagination purposes
    list_ids = list.map(&:id)
    cached_value = {ids: list_ids, total_entries: list.total_entries}
    Rails.cache.write("recipes/list/#{per_page_param}/#{page_param}", cached_value, expires_in: LIST_EXPIRY)

    # and then cache each entry separately
    list.each do |entry|
      Rails.cache.write("recipes/#{entry.id}", entry, expires_in: ENTRY_EXPIRY)
    end

    list
  end

  def read_list_cache(ids)
    # single entry expiry is longer than the list, so we are sure that these calls would hit the cache,
    # but to be safer in case of cache failure, we use the main 'find' method instead of 'read'
    # as 'find' would try the cache then find the actual record if failed
    ids.map { |id| find(id) }
  end

  # ---------
  # Params Processing

  def per_page_param
    @per_page_param ||= action_params[:per_page].to_i
  end

  def page_param
    @page_param ||= action_params[:page].to_i
  end

  def id_param
    @id_param ||= action_params[:id].to_s
  end

  # ---------
  # Error Handling

  def check_list_params
    raise Exceptions::BadRequest, 'list action should have valid per_page and page as params' if list_bad_request?
  end

  def check_find_params
    raise Exceptions::BadRequest, 'find action should have an id as param' if find_bad_request?
  end

  def list_bad_request?
    per_page_param.blank? || per_page_param.to_i <= 0 ||
      page_param.blank? || page_param.to_i <= 0
  end

  def find_bad_request?
    id_param.blank?
  end

  class << self

    def fetch(action: :find, action_params:)
      new(action: action, action_params: action_params).call
    end

    def list(list_params)
      new(action: :list, action_params: list_params).call
    end

    def find(id)
      new(action: :find, action_params: {id: id}).call
    end
  end

end
