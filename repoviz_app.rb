require './repo.rb'

class RepovizApp < Sinatra::Base
  set :static, true
  set :public, 'public'

  include Grit

  get '/' do
    erb :index
  end

  get '/:username/:project' do
    @username = params[:username]
    @project = params[:project]
    repovis = Repoviz::Repo.new(@username, @project)
    repovis.pull

    erb :project
  end

  get '/:username/:project/committers.json' do
    repovis = Repoviz::Repo.new(params[:username], params[:project])
    repovis.pull
    commits = {:commits => []}
    repovis.grit_repo.commits('master', 20).each { |commit| commits[:commits] << { :author => commit.author, :total => commit.stats.total } }
      

    content_type :json
    Yajl::Encoder.encode(commits)
  end
end
