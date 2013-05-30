require 'approvals'
require 'approvals/rspec'

Approvals.configure do |c|
  c.approvals_path = './'
end

RSpec.configure do |c|
  c.add_setting :approvals_namer_class, :default => Approvals::Namers::RSpecNamer
  c.add_setting :approvals_path, :default => './'
end


