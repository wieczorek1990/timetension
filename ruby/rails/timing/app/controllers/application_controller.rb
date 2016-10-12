class ApplicationController < ActionController::API
  def initialize
    @response = {}
    @errors = {}
  end

  protected
    def save_or_errors(instance, key)
      if instance.save
        @response[key] = ActiveModelSerializers::SerializableResource.new(instance)
        true
      else
        @errors[key] = instance.errors
        false
      end
    end
end
