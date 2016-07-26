module Batchable
  extend ActiveSupport::Concern

  module Methods
    extend ActiveSupport::Concern

    included do
      before_action :set_model_name
    end

    def batch_destroy
      @params.each do |id|
        object = @model.find(id)
        object.destroy
      end

      redirect_to @redirect_path
    end

    private

    def set_model_name
      model          = self.class.to_s.rpartition("Controller").first
      @model         = eval(model.singularize)
      @params        = params["#{model.singularize.downcase}_ids".to_sym]
      @redirect_path = eval("#{model.downcase}_path")
    end
  end

  included do
    include Methods
  end
end
