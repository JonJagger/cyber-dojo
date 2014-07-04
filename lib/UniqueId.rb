
module UniqueId

  def unique_id
    `uuidgen`.strip.delete('-')[0...10].upcase
  end

end

# 10 hex chars gives a N possibilities where
# N == 16^10 == 1,099,511,627,776
# which is more than enough as long as
# uuidgen is reasonably well behaved.

# Idea: massage the uuidgen into a format of
# three letters (A-F) + three digits (0-9)
# to make it more user friendly. Eg BEA327....
# Analysis: gives 6^3 * 10^3 == 216,000 possibilities
# Outcome: duplication too likley. Idea not used.
