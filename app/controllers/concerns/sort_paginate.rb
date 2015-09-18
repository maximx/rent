module SortPaginate
  private

    def sort_params
      ( ['price'].include? params[:sort] ) ? params[:sort] : 'items.created_at'
    end

    def sort_and_paginate_items
      @items = @items.order(sort_params)
      @items = @items.reverse_order unless params[:order] == 'asc'
      @items = @items.page(params[:page])
    end
end
