require 'spec_helper'

describe 'patroni' do
  test_on = {
    # The supported OS's are listed here explicitly instead of automatically
    # using the list from metadata.json. This is to prevent extra, wasteful and
    # useless testing for RedHat like systems which would otherwise run the
    # same tests for OracleLinux and RedHat.
    supported_os: [
      {
        'operatingsystem'        => 'CentOS',
        'operatingsystemrelease' => ['7', '8'],
      },
      {
        'operatingsystem'        => 'Debian',
        'operatingsystemrelease' => ['8', '9', '10'],
      },
    ],
  }

  on_supported_os(test_on).each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) { { 'scope' => 'testscope' } }

      it { is_expected.to compile }
    end
  end
end
