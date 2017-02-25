module Pronto
  describe Config do
    let(:config) { described_class.new(config_hash) }
    let(:config_hash) { {} }

    describe '#github_slug' do
      subject { config.github_slug }

      context 'from env variable' do
        before { stub_const('ENV', 'PRONTO_GITHUB_SLUG' => 'mmozuras/pronto') }
        it { should == 'mmozuras/pronto' }
      end

      context 'from config hash' do
        let(:config_hash) { { 'github' => { 'slug' => 'rails/rails' } } }
        it { should == 'rails/rails' }
      end
    end

    describe '#github_web_endpoint' do
      subject { config.github_web_endpoint }

      context 'from env variable' do
        before { stub_const('ENV', 'PRONTO_GITHUB_WEB_ENDPOINT' => '4.2.2.2') }
        it { should == '4.2.2.2' }
      end

      context 'from config hash' do
        let(:config_hash) { { 'github' => { 'web_endpoint' => 'localhost' } } }
        it { should == 'localhost' }
      end

      context 'default' do
        let(:config_hash) { ConfigFile::EMPTY }
        it { should == 'https://github.com/' }
      end
    end

    describe '#github_hostname' do
      subject { config.github_hostname }
      let(:config_hash) { ConfigFile::EMPTY }
      it { should == 'github.com' }
    end

    describe '#gitlab_slug' do
      subject { config.gitlab_slug }

      context 'from env variable' do
        before { stub_const('ENV', 'PRONTO_GITLAB_SLUG' => 'rick/deckard') }
        it { should == 'rick/deckard' }
      end

      context 'from config hash' do
        let(:config_hash) { { 'gitlab' => { 'slug' => 'ruby/ruby' } } }
        it { should == 'ruby/ruby' }
      end
    end

    describe '#runner_config' do
      subject { config.runner_config('my_runner') }

      context 'without runner key' do
        it { should == {} }
      end

      context 'with configuration' do
        let(:config_hash) do
          { 'my_runner' => { 'default_level' => 'warning' } }
        end

        it { should == { 'default_level' => 'warning' } }
      end
    end
  end
end
