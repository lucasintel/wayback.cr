require "../spec_helper"

describe Wayback::Engine do
  describe "#snapshots" do
    it "returns the snapshots for url" do
      body_io = IO::Memory.new("ru,ria)/ 20220403124505 https://ria.ru/ text/html 200 LZAPGECMHK3WNJPP7YKP4AP4WWEOPIA3 30331")
      WebMock.stub(:get, "https://web.archive.org/cdx/search/cdx")
        .with(query: {"url" => "https://ria.ru", "from" => "20220101000000", "to" => "20220401000000", "limit" => "5"})
        .to_return(body_io: body_io)

      engine = Wayback::Engine.new
      result = engine.snapshots("https://ria.ru", from: Time.utc(2022, 1, 1), to: Time.utc(2022, 4, 1), earliest: 5)
      result.size.should eq(1)
    end

    it "return an empty array when no snapshots are found" do
      body_io = IO::Memory.new
      WebMock.stub(:get, "https://web.archive.org/cdx/search/cdx")
        .with(query: {"url" => "https://ria.ru", "from" => "20220101000000", "to" => "20220401000000", "limit" => "5"})
        .to_return(body_io: body_io)

      engine = Wayback::Engine.new
      result = engine.snapshots("https://ria.ru", from: Time.utc(2022, 1, 1), to: Time.utc(2022, 4, 1), earliest: 5)
      result.size.should eq(0)
    end
  end

  describe "#latest_snapshot" do
    it "returns the snapshots for url" do
      body_io = IO::Memory.new("ru,ria)/ 20220403124505 https://ria.ru/ text/html 200 LZAPGECMHK3WNJPP7YKP4AP4WWEOPIA3 30331")
      WebMock.stub(:get, "https://web.archive.org/cdx/search/cdx")
        .with(query: {"url" => "https://ria.ru", "limit" => "-1", "fastLatest" => "true"})
        .to_return(body_io: body_io)

      engine = Wayback::Engine.new
      result = engine.latest_snapshot("https://ria.ru")
      result.should_not be_nil
      if result
        result.id.should eq("ru,ria)/")
      end
    end

    it "returns nil when no snapshots are found" do
      body_io = IO::Memory.new
      WebMock.stub(:get, "https://web.archive.org/cdx/search/cdx")
        .with(query: {"url" => "https://ria.ru", "limit" => "-1", "fastLatest" => "true"})
        .to_return(body_io: body_io)

      engine = Wayback::Engine.new
      result = engine.latest_snapshot("https://ria.ru")
      result.should be_nil
    end
  end

  describe "#first_snapshot" do
    it "returns the snapshots for url" do
      body_io = IO::Memory.new("ru,ria)/ 20220403124505 https://ria.ru/ text/html 200 LZAPGECMHK3WNJPP7YKP4AP4WWEOPIA3 30331")
      WebMock.stub(:get, "https://web.archive.org/cdx/search/cdx")
        .with(query: {"url" => "https://ria.ru", "limit" => "1"})
        .to_return(body_io: body_io)

      engine = Wayback::Engine.new
      result = engine.first_snapshot("https://ria.ru")
      result.should_not be_nil
      if result
        result.id.should eq("ru,ria)/")
      end
    end

    it "returns nil when no snapshots are found" do
      body_io = IO::Memory.new
      WebMock.stub(:get, "https://web.archive.org/cdx/search/cdx")
        .with(query: {"url" => "https://ria.ru", "limit" => "1"})
        .to_return(body_io: body_io)

      engine = Wayback::Engine.new
      result = engine.first_snapshot("https://ria.ru")
      result.should be_nil
    end
  end

  describe "#perform" do
    it "executes a arbitrary query" do
      body_io = IO::Memory.new("ru,ria)/ 20220403124505 https://ria.ru/ text/html 200 LZAPGECMHK3WNJPP7YKP4AP4WWEOPIA3 30331")
      WebMock.stub(:get, "https://web.archive.org/cdx/search/cdx")
        .with(query: {"url" => "https://ria.ru", "limit" => "10"})
        .to_return(body_io: body_io)

      engine = Wayback::Engine.new
      query = Wayback::Query.url("https://ria.ru").limit(10)
      result = engine.perform(query)
      result.size.should eq(1)
    end
  end
end
