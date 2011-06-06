require 'grit'
require 'uri'

module Repoviz
  class Repo
    include Grit

    REPO_DIR = File.dirname(__FILE__) + "/repos"
    attr_reader :grit_repo

    def initialize(username, project)
      username_dir = "#{REPO_DIR}/#{username}"
      project_dir = "#{username_dir}/#{project}"
      Dir.mkdir(username_dir) unless File.exists?(username_dir)
      @git = Git.new(project_dir)
      clone(username, project, project_dir) unless File.exists?(project_dir)
      
      @grit_repo = Grit::Repo.new(project_dir)
    end

    def clone(username, project, project_dir)
      Git.with_timeout(300) do 
        @git.clone({:quiet => false, :verbose => true, :progress => true, :branch => 'master'}, "git://github.com/#{username}/#{project}.git", project_dir)
      end
    end

    def pull
      @git.pull({:quiet => false, :verbose => true, :progress => true}, "origin", "master")
    end

  end
end
