require "../spec_helper"

describe Wayback::Api do
  describe "#perform" do
    it "performs the query" do
      body_io = IO::Memory.new <<-CSV
      ru,ria)/ 20220403124505 https://ria.ru/ text/html 200 LZAPGECMHK3WNJPP7YKP4AP4WWEOPIA3 30331
      ru,ria)/ 20220403124535 https://ria.ru/ text/html 200 2NNTV2PK4SKDFWYEWYDWOM5TSMUD6YUF 30284
      CSV

      WebMock.stub(:get, "https://web.archive.org/cdx/search/cdx")
        .with(query: {"url" => "https://ria.ru"})
        .to_return(body_io: body_io)

      api = Wayback::Api.new
      query = Wayback::Query.url("https://ria.ru")
      result = api.perform(query)
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

    context "query params" do
      it "applies limit" do
        WebMock.stub(:get, "https://web.archive.org/cdx/search/cdx")
          .with(query: {"url" => "https://ria.ru", "limit" => "10"})
          .to_return(body_io: IO::Memory.new)

        api = Wayback::Api.new
        query = Wayback::Query.url("https://ria.ru").limit(10)
        api.perform(query)
      end

      it "applies from" do
        WebMock.stub(:get, "https://web.archive.org/cdx/search/cdx")
          .with(query: {"url" => "https://ria.ru", "from" => "20200101000000"})
          .to_return(body_io: IO::Memory.new)

        api = Wayback::Api.new
        query = Wayback::Query.url("https://ria.ru").from(Time.utc(2020, 1, 1))
        api.perform(query)
      end

      it "applies to" do
        WebMock.stub(:get, "https://web.archive.org/cdx/search/cdx")
          .with(query: {"url" => "https://ria.ru", "to" => "20200101000000"})
          .to_return(body_io: IO::Memory.new)

        api = Wayback::Api.new
        query = Wayback::Query.url("https://ria.ru").to(Time.utc(2020, 1, 1))
        api.perform(query)
      end

      it "applies filter" do
        WebMock.stub(:get, "https://web.archive.org/cdx/search/cdx")
          .with(query: {"url" => "https://ria.ru", "filter" => "statuscode:200"})
          .to_return(body_io: IO::Memory.new)

        api = Wayback::Api.new
        query = Wayback::Query.url("https://ria.ru").status_code(200)
        api.perform(query)
      end
    end

    it "decompresses the body_io when the response is compressed with gzip (Crystal #11354 workaround)" do
      io = IO::Memory.new
      Compress::Gzip::Writer.open(io) do |gzip|
        gzip << "ru,ria)/ 20220403124505 https://ria.ru/ text/html 200 LZAPGECMHK3WNJPP7YKP4AP4WWEOPIA3 30331"
      end
      io.rewind

      WebMock.stub(:get, "https://web.archive.org/cdx/search/cdx")
        .with(query: {"url" => "https://ria.ru"})
        .to_return(headers: {"Content-Encoding" => "gzip"}, body_io: io)

      api = Wayback::Api.new
      query = Wayback::Query.url("https://ria.ru")
      api.perform(query)
    end

    it "decompresses the body_io when the response is compressed with deflate (Crystal #11354 workaround)" do
      io = IO::Memory.new
      Compress::Deflate::Writer.open(io) do |deflate|
        deflate << "ru,ria)/ 20220403124505 https://ria.ru/ text/html 200 LZAPGECMHK3WNJPP7YKP4AP4WWEOPIA3 30331"
      end
      io.rewind

      WebMock.stub(:get, "https://web.archive.org/cdx/search/cdx")
        .with(query: {"url" => "https://ria.ru"})
        .to_return(headers: {"Content-Encoding" => "deflate"}, body_io: io)

      api = Wayback::Api.new
      query = Wayback::Query.url("https://ria.ru")
      api.perform(query)
    end
  end
end
