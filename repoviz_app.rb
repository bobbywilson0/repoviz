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
    committers = {}
    start_date = params[:start_date] || (Date.today).to_time
    repovis.grit_repo.commits('master', 20).each do |commit|
      puts commit.date
      committers[commit.author.to_s] ||= 0 
      committers[commit.author.to_s] += commit.stats.total
    end

    denormalized_committers = committers.map { |name, total| {:name => name, :total => total}}
    
    content_type :json
    Yajl::Encoder.encode(denormalized_committers)
  end
end
