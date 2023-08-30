class Api::V0::VendorsController < ApplicationController
  def show
    render json: VendorSerializer.new(Vendor.find(params[:id]))
  rescue ActiveRecord::RecordNotFound
    render_vendor_not_found
  end

  def create
    render json: VendorSerializer.new(Vendor.create!(vendor_params)), status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.message }, status: :bad_request
  end

  def update
    render json: VendorSerializer.new(Vendor.update!(params[:id], vendor_params))
  rescue ActiveRecord::RecordNotFound
    render_vendor_not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.message }, status: :bad_request
  end

  private

  def render_vendor_not_found
    render json: ErrorVendor.new("Couldn't find Vendor with 'id'=#{params[:id]}"), status: :not_found
  end

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
end
