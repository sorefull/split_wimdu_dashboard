require 'spec_helper'
require 'rack/test'
require 'split/wimdu_dashboard'

describe Split::WimduDashboard do
  include Rack::Test::Methods

  def app
    @app ||= Split::WimduDashboard
  end

  def link(color)
    Split::Alternative.new(color, experiment.name)
  end

  def goto_dashboard(evilmode: true)
    if evilmode
      get '/?evilmode=true'
    else
      get '/'
    end
  end

  let(:experiment) {
    Split::Experiment.find_or_create("link_color", "blue", "red")
  }

  let(:experiment_with_goals) {
    Split::Experiment.find_or_create({"link_color" => ["goal_1", "goal_2"]}, "blue", "red")
  }

  let(:metric) {
    Split::Metric.find_or_create(name: 'testmetric', experiments: [experiment, experiment_with_goals])
  }

  let(:red_link) { link("red") }
  let(:blue_link) { link("blue") }

  it "respond to /" do
    get '/'
    last_response.should be_ok
  end

  context "start experiment manually" do
    before do
      Split.configuration.start_manually = true
    end

    context "experiment without goals" do
      it "display a Start button" do
        experiment
        goto_dashboard
        last_response.body.should include('Start')

        post "/start/#{experiment.name}"
        goto_dashboard
        last_response.body.should include('Reset Data')
        last_response.body.should_not include('Metrics:')
      end
    end

    context "experiment with metrics" do
      it "display the names of associated metrics" do
        metric
        get '/'
        last_response.body.should include('Metrics:testmetric')
      end
    end

    context "with goals" do
      it "display a Start button" do
        experiment_with_goals
        goto_dashboard
        last_response.body.should include('Start')

        post "/start/#{experiment.name}"
        goto_dashboard
        last_response.body.should include('Reset Data')
      end
    end
  end

  describe "index page" do
    context "with winner" do
      before { experiment.winner = 'red' }

      it "displays `Reopen Experiment` button" do
        goto_dashboard

        expect(last_response.body).to include('Reopen Experiment')
      end
    end

    context "without winner" do
      it "should not display `Reopen Experiment` button" do
        get '/'

        expect(last_response.body).to_not include('Reopen Experiment')
      end
    end
  end

  describe "reopen experiment" do
    before { experiment.winner = 'red' }

    it 'redirects' do
      post "/reopen/#{experiment.name}"

      expect(last_response).to be_redirect
    end

    it "removes winner" do
      post "/reopen/#{experiment.name}"

      expect(experiment).to_not have_winner
    end

    it "keeps existing stats" do
      red_link.participant_count = 5
      blue_link.participant_count = 7
      experiment.winner = 'blue'

      post "/reopen/#{experiment.name}"

      expect(red_link.participant_count).to eq(5)
      expect(blue_link.participant_count).to eq(7)
    end
  end

  it "reset an experiment" do
    red_link.participant_count = 5
    blue_link.participant_count = 7
    experiment.winner = 'blue'

    post "/reset/#{experiment.name}"

    last_response.should be_redirect

    new_red_count = red_link.participant_count
    new_blue_count = blue_link.participant_count

    new_blue_count.should eql(0)
    new_red_count.should eql(0)
    experiment.winner.should be_nil
  end

  it "delete an experiment" do
    delete "/#{experiment.name}"
    last_response.should be_redirect
    Split::Experiment.find(experiment.name).should be_nil
  end

  it "mark an alternative as the winner" do
    experiment.winner.should be_nil
    post "/#{experiment.name}", :alternative => 'red'

    last_response.should be_redirect
    experiment.winner.name.should eql('red')
  end

  it "display the start date" do
    experiment_start_time = Time.parse('2011-07-07')
    Time.stub(:now => experiment_start_time)
    experiment

    get '/'

    last_response.body.should include('<small>2011-07-07</small>')
  end

  it "handle experiments without a start date" do
    experiment_start_time = Time.parse('2011-07-07')
    Time.stub(:now => experiment_start_time)
    Split.redis.hdel(:experiment_start_times, experiment.name)

    get '/'

    last_response.body.should include('<small>Unknown</small>')
  end
end
