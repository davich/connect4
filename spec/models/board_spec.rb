require "spec_helper"

describe Board do
  let(:b) { Board.new }
  
  it "should save and load" do
    b.data[1] = {}
    b.data[1][1] = 1
    
    b.save
    b2 = Board.find(b.id)
    b2.data[1][1].should == 1
  end
  it "should place piece" do
    b.place_piece("xx", 5)
    b.data[5][0].should == "xx"
  end
  it "should raise if invalid position" do
    lambda do
      b.place_piece("xx", -1, 4)
    end.should raise_exception
  end
  describe "find_winner" do
    it "should find an up down winner" do
      b.data[1] = { 1 => 6, 2 => 6, 3 => 6, 4 => 6 }
      b.find_winner(1).should == 6
    end
    it "should find an across winner" do
      b.data[1] = { 1 => 6 }
      b.data[2] = { 1 => 6 }
      b.data[3] = { 1 => 6 }
      b.data[4] = { 1 => 6 }
      b.find_winner(1).should == 6
    end
    it "should find a slash diagonal winner" do
      b.data[1] = { 1 => 6 }
      b.data[2] = { 2 => 6 }
      b.data[3] = { 3 => 6 }
      b.data[4] = { 4 => 6 }
      b.find_winner(1).should == 6
    end
    it "should find a backslash diagonal inner" do
      b.data[1] = { 4 => 6 }
      b.data[2] = { 3 => 6 }
      b.data[3] = { 2 => 6 }
      b.data[4] = { 1 => 6 }
      b.find_winner(1).should == 6
    end
    it "shouldn't win on three" do
      b.data[1] = { 4 => 6 }
      b.data[2] = { 3 => 6 }
      b.data[3] = { 2 => 6 }
      b.find_winner(1).should == nil
    end
  end
end