require 'spec_helper'
require 'split/wimdu_dashboard/helpers'


describe Split::WimduDashboardHelpers do
  include Split::WimduDashboardHelpers

  describe '.confidence_level' do
    subject { confidence_level(number) }

    context "with very small number" do
      let(:number) { Complex(2e-18, -0.03) }
      it { is_expected.to eq('Insufficient confidence') }
    end

    context "with 1.64" do
      let(:number) { 1.64 }
      it { is_expected.to eq('Insufficient confidence') }
    end

    context "with 1.65" do
      let(:number) { 1.65 }
      it { is_expected.to eq('90% confidence') }
    end

    context "with 1.95" do
      let(:number) { 1.95 }
      it { is_expected.to eq('90% confidence') }
    end

    context "with 1.96" do
      let(:number) { 1.96 }
      it { is_expected.to eq('95% confidence') }
    end

    context "with 2.57" do
      let(:number) { 2.57 }
      it { is_expected.to eq('95% confidence') }
    end

    context "with 2.58" do
      let(:number) { 2.58 }
      it { is_expected.to eq('99% confidence') }
    end
  end
end
