# frozen_string_literal: true

require 'helper'

describe Octokit::Repository do
  context 'when passed a string containg a slash' do
    before do
      @repository = Octokit::Repository.new('sferik/octokit')
    end

    it 'sets the repository name and username' do
      expect(@repository.name).to eq('octokit')
      expect(@repository.username).to eq('sferik')
    end

    it 'responds to repo and user' do
      expect(@repository.repo).to eq('octokit')
      expect(@repository.user).to eq('sferik')
    end

    it 'renders slug as string' do
      expect(@repository.slug).to eq('sferik/octokit')
      expect(@repository.to_s).to eq(@repository.slug)
    end

    it 'renders url as string' do
      expect(@repository.url).to eq('https://github.com/sferik/octokit')
    end
  end

  context 'when passed a string without a slash' do
    it 'raises ArgumentError' do
      expect { Octokit::Repository.new('raise-error') }
        .to raise_error Octokit::InvalidRepository, '"raise-error" is invalid as a repository identifier. Use the user/repo (String) format, or the repository ID (Integer), or a hash containing :repo and :user keys.'
    end
  end

  context 'when passed a string with more than 1 slash' do
    it 'raises ArgumentError' do
      expect { Octokit::Repository.new('more_than/one/slash') }
        .to raise_error Octokit::InvalidRepository, '"more_than/one/slash" is invalid as a repository identifier. Use the user/repo (String) format, or the repository ID (Integer), or a hash containing :repo and :user keys.'
    end
  end

  context 'when passed an invalid path' do
    it 'raises ArgumentError' do
      expect { Octokit::Repository.new('invalid / path') }
        .to raise_error Octokit::InvalidRepository, '"invalid / path" is invalid as a repository identifier. Use the user/repo (String) format, or the repository ID (Integer), or a hash containing :repo and :user keys.'
    end
  end

  context 'when passed a boolean true' do
    it 'raises ArgumentError' do
      expect { Octokit::Repository.new(true) }
        .to raise_error Octokit::InvalidRepository, 'true is invalid as a repository identifier. Use the user/repo (String) format, or the repository ID (Integer), or a hash containing :repo and :user keys.'
    end
  end

  context 'when passed a boolean false' do
    it 'false raises ArgumentError' do
      expect { Octokit::Repository.new(false) }
        .to raise_error Octokit::InvalidRepository, 'false is invalid as a repository identifier. Use the user/repo (String) format, or the repository ID (Integer), or a hash containing :repo and :user keys.'
    end
  end

  context 'when passed nil' do
    it 'raises ArgumentError' do
      expect { Octokit::Repository.new(nil) }
        .to raise_error Octokit::InvalidRepository, 'nil is invalid as a repository identifier. Use the user/repo (String) format, or the repository ID (Integer), or a hash containing :repo and :user keys.'
    end
  end

  describe '.path' do
    context 'with named repository' do
      it 'returns the url path' do
        repository = Octokit::Repository.new('sferik/octokit')
        expect(repository.path).to eq 'repos/sferik/octokit'
      end
    end

    context 'with repository id' do
      it 'returns theu url path' do
        repository = Octokit::Repository.new(12_345)
        expect(repository.path).to eq 'repositories/12345'
      end
    end
  end # .path

  describe 'self.path' do
    it 'returns the api path' do
      expect(Octokit::Repository.path('sferik/octokit')).to eq 'repos/sferik/octokit'
      expect(Octokit::Repository.path(12_345)).to eq 'repositories/12345'
    end
  end

  context 'when passed an integer' do
    it 'sets the repository id' do
      repository = Octokit::Repository.new(12_345)
      expect(repository.id).to eq 12_345
    end
  end

  context 'when passed a hash' do
    it 'sets the repository name and username' do
      repository = Octokit::Repository.new({ username: 'sferik', name: 'octokit' })
      expect(repository.name).to eq('octokit')
      expect(repository.username).to eq('sferik')
    end
  end

  context 'when passed a frozen hash' do
    it 'sets the repository name and username' do
      repository = Octokit::Repository.new({ username: 'sferik', name: 'octokit' }.freeze)
      expect(repository.name).to eq('octokit')
      expect(repository.username).to eq('sferik')
    end
  end

  context 'when passed a hash with invalid username' do
    it 'raises ArgumentError' do
      expect { Octokit::Repository.new({ username: 'invalid username!', name: 'octokit' }) }
        .to raise_error Octokit::InvalidRepository, "#{{ username: 'invalid username!', name: 'octokit' }.inspect} is invalid as a repository identifier. Use the user/repo (String) format, or the repository ID (Integer), or a hash containing :repo and :user keys."
    end
  end

  context 'when passed a hash with a username that contains a slash' do
    it 'raises ArgumentError' do
      expect { Octokit::Repository.new({ username: 'invalid/username', name: 'octokit' }) }
        .to raise_error Octokit::InvalidRepository, "#{{ username: 'invalid/username', name: 'octokit' }.inspect} is invalid as a repository identifier. Use the user/repo (String) format, or the repository ID (Integer), or a hash containing :repo and :user keys."
    end
  end

  context 'when passed a hash with invalid repo' do
    it 'raises ArgumentError' do
      expect { Octokit::Repository.new({ username: 'sferik', name: 'invalid repo!' }) }
        .to raise_error Octokit::InvalidRepository, "#{{ username: 'sferik', name: 'invalid repo!' }.inspect} is invalid as a repository identifier. Use the user/repo (String) format, or the repository ID (Integer), or a hash containing :repo and :user keys."
    end
  end

  context 'when passed a hash with a repo that contains a slash' do
    it 'raises ArgumentError' do
      expect { Octokit::Repository.new({ username: 'sferik', name: 'invalid/repo' }) }
        .to raise_error Octokit::InvalidRepository, "#{{ username: 'sferik', name: 'invalid/repo' }.inspect} is invalid as a repository identifier. Use the user/repo (String) format, or the repository ID (Integer), or a hash containing :repo and :user keys."
    end
  end

  context 'when passed a Repo' do
    it 'sets the repository name and username' do
      repository = Octokit::Repository.new(Octokit::Repository.new('sferik/octokit'))
      expect(repository.name).to eq('octokit')
      expect(repository.username).to eq('sferik')
      expect(repository.url).to eq('https://github.com/sferik/octokit')
    end
  end

  context 'when given a URL' do
    it 'sets the repository name and username' do
      repository = Octokit::Repository.from_url('https://github.com/sferik/octokit')
      expect(repository.name).to eq('octokit')
      expect(repository.username).to eq('sferik')
    end

    it 'parses api urls' do
      repo_from_url = Octokit::Repository.from_url('https://api.github.com/repos/sferik/octokit-repos/issues/21')
      expect(repo_from_url.name).to eq('octokit-repos')
      expect(repo_from_url.username).to eq('sferik')
    end

    it 'parses html urls' do
      repo_from_url = Octokit::Repository.from_url('https://github.com/sferik/octokit/issues/132')
      expect(repo_from_url.name).to eq('octokit')
      expect(repo_from_url.username).to eq('sferik')
    end

    it 'raises InvalidRepository error for unsupported url' do
      expect { Octokit::Repository.new('https://api.github.com/gists/0083ae') }
        .to raise_error Octokit::InvalidRepository, '"https://api.github.com/gists/0083ae" is invalid as a repository identifier. Use the user/repo (String) format, or the repository ID (Integer), or a hash containing :repo and :user keys.'
    end
  end
end
