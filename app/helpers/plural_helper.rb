module PluralHelper

  def plural(n, word)
    n.to_s + ' ' + word + (n == 1 ? '' : 's')
  end

end