class SearchController < ApplicationController
  def home
  end

  def result
      require "duck_duck_go"
      @search_param = params[:search_text]
      @search_results = DuckDuckGo.new.zeroclickinfo(@search_param)
  end
end
