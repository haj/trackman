module Breadcrumbable
  extend ActiveSupport::Concern

  module Methods
    extend ActiveSupport::Concern

    included do
      before_action :breadcrumb_index, only: :index
      before_action :breadcrumb_new, only: [:new, :create]
      before_action :breadcrumb_edit, only: [:edit, :update]
      before_action :breadcrumb_show, only: :show
    end

    private

    def breadcrumb_index
      add_breadcrumb "Index"
    end

    def breadcrumb_new
      add_breadcrumb "New"
    end

    def breadcrumb_edit
      add_breadcrumb "Edit"
      add_breadcrumb params[:id]
    end

    def breadcrumb_show
      add_breadcrumb params[:id]      
    end
  end

  included do
    include Methods
  end
end
