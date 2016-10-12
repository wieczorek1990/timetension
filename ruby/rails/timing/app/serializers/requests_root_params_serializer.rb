class RequestsRootParamsSerializer
  include ActiveModel::Validations

  attr_accessor :now

  validates :now, format: { with: /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z\z/, allow_nil: true }

  def initialize(params)
    @now = params[:now] if params.has_key? :now
  end

  def default?
    @now.nil?
  end

  def extended?
    not default?
  end

  def parse_now
    DateTime.parse @now unless default?
  end
end