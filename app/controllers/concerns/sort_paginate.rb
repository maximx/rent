module SortPaginate
  private
    def get_sort_param
      ( Item.sort_list.include? params[:sort] ) ? params[:sort] : 'recent'
    end

    def sort_and_paginate_items
      if get_sort_param == 'recent'
        @items = @items.order('items.created_at')
      else
        @items = @items.order('price')
      end
      @items = @items.reverse_order unless get_sort_param == 'cheap'
      @items = @items.page(params[:page])
    end
end
