
containers = %w(
  gcc-4.8.1_assert
  gpp-4.8.1_assert
  gpp-4.8.1_cpputest
  gpp-4.8.1_googletest
  ruby-1.9.3_test_unit
  python-3.3.5_unittest
  python-3.3.5_pytest
  groovy-2.2.0_junit
)

containers.each{|container| `docker pull cyberdojo/#{container}`}

