
containers = %w(
  csharp-2.10.8.1
  csharp-2.10.8.1_nunit
  erlang-5.10.2
  erlang-5.10.2_eunit
  gcc-4.8.1
  gcc-4.8.1_assert
  go-1.1.2
  go-1.1.2_testing
  gpp-4.8.1
  gpp-4.8.1_assert
  gpp-4.8.1_cpputest
  gpp-4.8.1_googletest
  groovy-2.2.0
  groovy-2.2.0_junit
  haskell-7.6.3
  haskell-7.6.3_hunit
  java-1.8
  java-1.8_junit
  perl-5.14.2
  perl-5.14.2_test_simple
  python-3.3.5
  python-3.3.5_pytest
  python-3.3.5_unittest
  ruby-1.9.3
  ruby-1.9.3_test_unit
)

containers.each do |container|
  p container
  `docker pull cyberdojo/#{container}`
end

