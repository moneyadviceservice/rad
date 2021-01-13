class Admin::BaseFirmsController < Admin::ApplicationController
  def index
    @search = resource_class.ransack(params[:q])
    @firms = @search.result.page(params[:page]).per(20)
    @directory_type = resource_class.name

    respond_to do |format|
      format.csv do
        send_data(
          ::Reports::FirmsExport.new(@search.result).generate_csv,
          filename: csv_filename
        )
      end

      format.html { render :index }
    end
  end

  def show
    @firm = resource_class.find(params[:id])
  end

  def resource_path
    raise NotImplementedError
  end
  helper_method :resource_path

  def approve
    firm_id = params[:retirement_firm_id] || params[:travel_insurance_firm_id]
    @firm = resource_class.find(firm_id)
    @firm.approve!
    redirect_back(fallback_location: admin_retirement_firm_path(@firm))
  end

  def hide
    firm_id = params[:retirement_firm_id] || params[:travel_insurance_firm_id]
    @firm = resource_class.find(firm_id)
    @firm.hide!
    redirect_back(fallback_location: admin_retirement_firm_path(@firm))
  end

  def firms_search_path
    raise NotImplementedError
  end

  private

  def csv_filename
    firm_type = @firms.first.class.name == 'Firm' ? 'retirement_firms' : @firms.first.class.name.underscore
    "#{firm_type}_#{Time.zone.now.to_formatted_s(:number)}.csv"
  end

  def resource_class
    raise NotImplementedError
  end
end
