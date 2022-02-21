class UsersController < ApplicationController

  before_action :set_bulk_importer, only: [:import]

  def import
    unless @importer.call!
      flash[:error] = @importer.errors.messages.values.flatten.to_sentence
      redirect_to new_import_users_path
    end
  end

  private

  def set_bulk_importer
    @file = params[:file]
    @importer = Users::BulkImporter.new(@file.path)
  end
end
