class AvatarSession < ActiveRecord::Base
  belongs_to :dojo_start_point
  has_many :traffic_lights
end
