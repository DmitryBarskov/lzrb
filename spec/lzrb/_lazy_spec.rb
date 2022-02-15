# frozen_string_literal: true

class Greedy
  class Error < StandardError; end

  def invoke
    raise Error
  end
end

RSpec.describe Lzrb::_Lazy do
  subject(:lazy_object) { described_class.new(greedy_object) }

  let(:greedy_object) { Greedy.new }

  it "doesn't call the original object" do
    result = lazy_object.invoke
    expect { result }.not_to raise_error
  end

  it "calls the original object when it is accessed" do
    expect { lazy_object.invoke.work }.to raise_error(Greedy::Error)
  end
end
