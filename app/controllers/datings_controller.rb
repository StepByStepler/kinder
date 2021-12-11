# frozen_string_literal: true

# Controller which handles everything when user is already logged in
class DatingsController < ApplicationController
  before_action :authenticate

  def view
  end
end
