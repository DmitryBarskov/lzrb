# frozen_string_literal: true

RSpec.describe Lzrb::Lazy do
  class TestingError < StandardError; end

  subject(:lazy_result) { described_class.new(&block) }

  let(:block) { Proc.new { raise TestingError } }

  it "can be safely created" do
    expect { lazy_result }.not_to raise_error
  end

  it "accesses the block only when needed" do
    expect { lazy_result.work }.to raise_error(TestingError)
  end

  context "when accessing some Object methods" do
    let(:block) { Proc.new { "some string" } }

    it "delegates them too" do
      expect(lazy_result.to_s).to eq("some string")
    end
  end
end
