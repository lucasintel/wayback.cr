require "../../spec_helper"

describe Wayback::Protocol::SnapshotsParser do
  describe "#call" do
    it "parses the wayback machine output" do
      io = IO::Memory.new <<-CSV
      ru,ria)/ 20220403124505 https://ria.ru/ text/html 200 LZAPGECMHK3WNJPP7YKP4AP4WWEOPIA3 30331
      ru,ria)/ 20220403124535 https://ria.ru/ text/html 200 2NNTV2PK4SKDFWYEWYDWOM5TSMUD6YUF 30284
      CSV

      result = Wayback::Protocol::SnapshotsParser.call(io)

      result.size.should eq(2)

      result[0].id.should eq("ru,ria)/")
      result[0].resource.should eq("https://ria.ru/")
      result[0].time.should eq(Time.utc(2022, 4, 3, 12, 45, 5))
      result[0].status.should eq(HTTP::Status::OK)
      result[0].mimetype.should eq("text/html")
      result[0].digest.should eq("LZAPGECMHK3WNJPP7YKP4AP4WWEOPIA3")
      result[0].content_length.should eq(30331_u64)
      result[0].url.should eq("https://web.archive.org/web/20220403124505/https://ria.ru/")

      result[1].id.should eq("ru,ria)/")
      result[1].resource.should eq("https://ria.ru/")
      result[1].time.should eq(Time.utc(2022, 4, 3, 12, 45, 35))
      result[1].status.should eq(HTTP::Status::OK)
      result[1].mimetype.should eq("text/html")
      result[1].digest.should eq("2NNTV2PK4SKDFWYEWYDWOM5TSMUD6YUF")
      result[1].content_length.should eq(30284_u64)
      result[1].url.should eq("https://web.archive.org/web/20220403124535/https://ria.ru/")
    end

    it "parses snapshots with showGroupCount option" do
      io = IO::Memory.new <<-CSV
      ru,ria)/ 20220403124505 https://ria.ru/ text/html 200 LZAPGECMHK3WNJPP7YKP4AP4WWEOPIA3 30331 100
      CSV

      result = Wayback::Protocol::SnapshotsParser.call(io)

      result.size.should eq(1)

      result[0].id.should eq("ru,ria)/")
      result[0].resource.should eq("https://ria.ru/")
      result[0].time.should eq(Time.utc(2022, 4, 3, 12, 45, 5))
      result[0].status.should eq(HTTP::Status::OK)
      result[0].mimetype.should eq("text/html")
      result[0].digest.should eq("LZAPGECMHK3WNJPP7YKP4AP4WWEOPIA3")
      result[0].content_length.should eq(30331_u64)
      result[0].url.should eq("https://web.archive.org/web/20220403124505/https://ria.ru/")
      result[0].aggregate_count.should eq(100)
    end

    it "parses snapshots with empty http status code" do
      io = IO::Memory.new <<-CSV
      ru,ria)/ 20220403124505 https://ria.ru/ text/html - LZAPGECMHK3WNJPP7YKP4AP4WWEOPIA3 30331 100
      CSV
      result = Wayback::Protocol::SnapshotsParser.call(io)
      result.size.should eq(1)
      result[0].status.should be_nil
    end
  end
end
