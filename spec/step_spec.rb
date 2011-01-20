require 'tango'

module Tango
  describe Step do

    context "with just a plain block" do
      it "should run the block" do
        block_calls = 0
        step = Step.new do
          block_calls += 1
        end

        step.run
        block_calls.should == 1
      end
    end

    context "with a meet block and a met block" do
      it "should check the met?, run the meet, then check the met? again" do
        met_block_calls  = 0
        meet_block_calls = 0
        step = Step.new do
          met? do
            met_block_calls += 1
            meet_block_calls > 0
          end
          meet { meet_block_calls += 1 }
        end

        step.run
        met_block_calls.should  == 2
        meet_block_calls.should == 1
      end

      it "should not run the meet if the met? succeeds the first time" do
        met_block_calls  = 0
        meet_block_calls = 0
        step = Step.new do
          met? do
            met_block_calls += 1
            true
          end
          meet { meet_block_calls += 1 }
        end

        step.run
        met_block_calls.should  == 1
        meet_block_calls.should == 0
      end

      it "should raise if the met? block fails twice" do
        met_block_calls  = 0
        meet_block_calls = 0
        step = Step.new do
          met? do
            met_block_calls += 1
            false
          end
          meet { meet_block_calls += 1 }
        end

        expect { step.run }.should raise_error
        met_block_calls.should  == 2
        meet_block_calls.should == 1
      end
    end

    context "step arguments" do
      it "should pass a single argument to the step" do
        step = Step.new do |a|
          a.should == 1
        end

        step.run(1)
      end

      it "should pass multiple arguments to the step" do
        step = Step.new do |a, b|
          a.should == 1
          b.should == 2
        end

        step.run(1, 2)
      end
    end

  end
end
