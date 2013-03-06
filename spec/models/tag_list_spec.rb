describe TagList do
  subject { TagList.new("tag1", "tag2", "tag1") }

  it "uniq tag list" do
    should eq ["tag1", "tag2"]
  end
end
