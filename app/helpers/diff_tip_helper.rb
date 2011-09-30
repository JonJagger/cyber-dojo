module DiffTipHelper

  def diff_tip(n_deleted, n_added)
    pluralize(n_deleted, "deletion") + " &amp; " + pluralize(n_added, "addition")
  end
  
end

