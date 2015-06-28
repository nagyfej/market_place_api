require 'spec_helper'

describe Placement do
  let(:placement) { FactoryGirl.create :placement }
  subject { placement }

  it { should belong_to :order }
  it { should belong_to :product }
  it { should respond_to :order_id }
  it { should respond_to :product_id }

end
