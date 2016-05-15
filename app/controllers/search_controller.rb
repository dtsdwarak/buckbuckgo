class SearchController < ApplicationController

  rescue_from SocketError, with: :api_error

  def home
  end

  def result
      require "duck_duck_go"
      @search_param = params[:search_text]
      @search_results = DuckDuckGo.new.zeroclickinfo(@search_param)
      @hash = @search_results.related_topics
  end

  def ajax
    require "duck_duck_go"
    require "json"
    search_param = params[:search_text]
    search_results = DuckDuckGo.new.zeroclickinfo(search_param)
    hash = search_results.related_topics
    arr = Array.new
    hash.each do |key, array|
        array.each do |x|
            arr << "<a href='https://" + x.first_url.hostname + x.first_url.request_uri + "'>" + x.result[/(>\s*(.*?)\s*<)/,2] + "</a>"
        end
    end
    render :json => arr.first(7)
  end

  private

  def api_error
      flash[:notice] = "API Error. Try again from sometime."
      redirect_to "/"
  end
end
