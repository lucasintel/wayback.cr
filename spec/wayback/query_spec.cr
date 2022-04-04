require "../spec_helper"

describe Wayback::Query do
  it "applies url" do
    query = Wayback::Query.url("ria.ru")
    query.to_query_string.should eq("url=ria.ru")
  end

  it "applies from" do
    query = Wayback::Query
      .url("ria.ru")
      .from(Time.utc(2022, 4, 1, 10, 10, 10))
    query.to_query_string.should eq("url=ria.ru&from=20220401101010")
  end

  it "applies to" do
    query = Wayback::Query
      .url("ria.ru")
      .from(Time.utc(2022, 4, 1, 10, 10, 10))
      .to(Time.utc(2022, 5, 1))
    query.to_query_string.should eq("url=ria.ru&from=20220401101010&to=20220501000000")
  end

  it "applies limit" do
    query = Wayback::Query
      .url("ria.ru")
      .from(Time.utc(2022, 4, 1, 10, 10, 10))
      .to(Time.utc(2022, 5, 1))
      .limit(10)
    query.to_query_string.should eq("url=ria.ru&from=20220401101010&to=20220501000000&limit=10")
  end

  it "applies a negative limit" do
    query = Wayback::Query
      .url("ria.ru")
      .from(Time.utc(2022, 4, 1, 10, 10, 10))
      .to(Time.utc(2022, 5, 1))
      .limit(-10)
    query.to_query_string.should eq("url=ria.ru&from=20220401101010&to=20220501000000&limit=-10&fastLatest=true")
  end

  it "applies latest" do
    query = Wayback::Query.url("ria.ru").latest(10)
    query.to_query_string.should eq("url=ria.ru&limit=-10&fastLatest=true")
  end

  it "applies earliest" do
    query = Wayback::Query.url("ria.ru").earliest(10)
    query.to_query_string.should eq("url=ria.ru&limit=10")
  end

  it "applies filters" do
    query = Wayback::Query
      .url("ria.ru")
      .status_code(200)
      .mimetype_not("text/html")
      .from(Time.utc(2022, 4, 1, 10, 10, 10))
      .to(Time.utc(2022, 5, 1))
      .limit(10)
    query.to_query_string.should eq("url=ria.ru&filter=statuscode%3A200&filter=%21mimetype%3Atext%2Fhtml&from=20220401101010&to=20220501000000&limit=10")
  end

  it "applies offset" do
    query = Wayback::Query.url("ria.ru").offset(10)
    query.to_query_string.should eq("url=ria.ru&offset=10")
  end
end
