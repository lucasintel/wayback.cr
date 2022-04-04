require "../spec_helper"

describe Wayback::Utils do
  describe ".parse_timestamp" do
    it "parses the timestamp string into a time object" do
      expected_time = Time.utc(2022, 4, 1, 10, 10, 10)
      Wayback::Utils.parse_timestamp("20220401101010").should eq(expected_time)
    end
  end

  describe ".to_timestamp" do
    it "formats as expected by the wayback machine" do
      time = Time.utc(2022, 4, 1, 10, 10, 10)
      Wayback::Utils.to_timestamp(time).should eq("20220401101010")
    end
  end
end
