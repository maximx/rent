class Settings::ItemsController < ApplicationController
  layout "application_aside"

  before_action :login_required
  before_action :find_items

  def show
    @rent_records_count = @items.joins(:rent_records).group(:item_id, :aasm_state).count
    @rent_records_count.default = 0
  end

  def calendar
    @event_sources_path = calendar_settings_items_path(format: :json, role: params[:role])
    rent_records_json = if params[:role] == "borrower"
                           current_user.rent_records.includes(:borrower)
                             .overlaps(params[:start], params[:end]).to_json
                         else
                           RentRecord.includes(:borrower).where(item_id: current_user.items)
                             .overlaps(params[:start], params[:end]).to_json
                         end

    respond_to do |format|
      format.html { render :calendar }
      format.json { render json: rent_records_json }
    end
  end

  private

    def find_items
      @items = current_user.items.send(overlap_method, params[:started_at], params[:ended_at])
                .search_by(params[:query])
    end

    def overlap_method
      if Item.overlaps_values.include?(params[:overlaps])
        params[:overlaps]
      else
        Item.overlaps_types.first.second
      end
    end

end
