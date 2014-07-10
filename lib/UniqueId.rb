# mixin

module UniqueId

  def unique_id
    `uuidgen`.strip.delete('-')[0...10].upcase
  end

end

# 10 hex chars gives N possibilities where
# N == 16^10 == 1,099,511,627,776
# which is more than enough as long as
# uuidgen is reasonably well behaved.
#
# 6 hex chars are all that need to be entered
# to enable id-auto-complete which gives
# N == 16^6 == 16,777,216 possibilities.
#
# Idea: massage the uuidgen into a format of
# three letters (A-F) + three digits (0-9)
# to make it more user friendly. Eg BEA327....
# Analysis: gives 6^3 * 10^3 == 216,000 possibilities
# Outcome: duplication too likely. Idea not used.
