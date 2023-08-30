class Api::V0::VendorsController < ApplicationController
  def show
    render json: VendorSerializer.new(Vendor.find(params[:id]))
  rescue ActiveRecord::RecordNotFound
    render_vendor_not_found
  end

  def create
    vendor = Vendor.new(vendor_params)
    if vendor.save
      render json: VendorSerializer.new(Vendor.create!(vendor_params)), status: :created
    else
      render json: ErrorVendor.new(vendor.errors.full_messages.to_sentence), status: :bad_request
    end
  end

  private

  def render_vendor_not_found
    render json: ErrorVendor.new("Couldn't find Vendor with 'id'=#{params[:id]}"), status: :not_found
  end

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
end
