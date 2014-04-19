
containers = %w(
  csharp-2.10.8.1_nunit
  erlang-5.10.2_eunit
  gcc-4.8.1_assert
  go-1.1.2_testing
  gpp-4.8.1_assert
  gpp-4.8.1_cpputest
  gpp-4.8.1_googletest
  groovy-2.2.0_junit
  haskell-7.6.3_hunit
  perl-5.14.2_test_simple
  python-3.3.5_pytest
  python-3.3.5_unittest
  ruby-1.9.3_test_unit
)

containers.each{|container| `docker pull cyberdojo/#{container}`}
