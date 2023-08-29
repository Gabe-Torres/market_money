class Api::V0::VendorsController < ApplicationController
  def show
    render json: VendorSerializer.new(Vendor.find(params[:id]))
  rescue ActiveRecord::RecordNotFound
    render_vendor_not_found
  end

  private

  def render_vendor_not_found
    render json: ErrorVendor.new("Couldn't find Vendor with 'id'=#{params[:id]}"), status: :not_found
  end
end
