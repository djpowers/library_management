class LibrariesController < ApplicationController
  def create
    @library = Library.create(name: params[:name])
  end
end
