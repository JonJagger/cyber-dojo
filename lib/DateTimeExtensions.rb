
class ActiveSupport::TimeWithZone
  def to_a
    [self.year, self.month, self.day, self.hour, self.min, self.sec]
  end
end