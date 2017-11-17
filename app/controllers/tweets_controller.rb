class TweetsController < ApplicationController
  def index
    search_term = params[:search_term]
    @tweets = if search_term.present?
                TweetsSearchService.new(search_term: search_term,
                                        order_by: params[:order_by]).call
              else
                {}
              end
  end
end
