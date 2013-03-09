# coding: utf-8
require 'spec_helper'

describe PasokaraDecorator do
  let(:pasokara) { FactoryGirl.build(:pasokara).extend PasokaraDecorator }

  subject { pasokara }

  its(:duration_str) { should eq "2:05" }
end
