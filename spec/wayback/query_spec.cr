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

  it "applies offset" do
    query = Wayback::Query.url("ria.ru").offset(10)
    query.to_query_string.should eq("url=ria.ru&offset=10")
  end

  it "applies filters" do
    query = Wayback::Query
      .url("ria.ru")
      .status_code(200)
      .status_code(300)
      .mimetype_not("text/html")
      .from(Time.utc(2022, 4, 1, 10, 10, 10))
      .to(Time.utc(2022, 5, 1))
      .limit(10)
    query.to_query_string.should eq("url=ria.ru&filter=statuscode%3A200&filter=statuscode%3A300&filter=%21mimetype%3Atext%2Fhtml&from=20220401101010&to=20220501000000&limit=10")
  end

  it "resets the query" do
    query = Wayback::Query
      .url("ria.ru")
      .status_code(200)
      .status_code(300)
      .mimetype_not("text/html")
      .from(Time.utc(2022, 4, 1, 10, 10, 10))
      .to(Time.utc(2022, 5, 1))
      .limit(10)
      .clear
      .limit(5)
    query.to_query_string.should eq("url=ria.ru&limit=5")
  end

  it "collapses by id" do
    query = Wayback::Query.url("ria.ru").group_by_id
    query.to_query_string.should eq("url=ria.ru&collapse=urlkey")
  end

  it "collapses by id (with position)" do
    query = Wayback::Query.url("ria.ru").group_by_id(position: 5)
    query.to_query_string.should eq("url=ria.ru&collapse=urlkey%3A5")
  end

  it "collapses by decade" do
    query = Wayback::Query.url("ria.ru").group_by_decade
    query.to_query_string.should eq("url=ria.ru&collapse=timestamp%3A2")
  end

  it "collapses by year" do
    query = Wayback::Query.url("ria.ru").group_by_year
    query.to_query_string.should eq("url=ria.ru&collapse=timestamp%3A4")
  end

  it "collapses by month" do
    query = Wayback::Query.url("ria.ru").group_by_month
    query.to_query_string.should eq("url=ria.ru&collapse=timestamp%3A6")
  end

  it "collapses by day" do
    query = Wayback::Query.url("ria.ru").group_by_day
    query.to_query_string.should eq("url=ria.ru&collapse=timestamp%3A8")
  end

  it "collapses by hour" do
    query = Wayback::Query.url("ria.ru").group_by_hour
    query.to_query_string.should eq("url=ria.ru&collapse=timestamp%3A10")
  end

  it "collapses by minute" do
    query = Wayback::Query.url("ria.ru").group_by_minute
    query.to_query_string.should eq("url=ria.ru&collapse=timestamp%3A12")
  end

  it "collapses by second" do
    query = Wayback::Query.url("ria.ru").group_by_second
    query.to_query_string.should eq("url=ria.ru&collapse=timestamp%3A14")
  end

  it "collapses by url" do
    query = Wayback::Query.url("ria.ru").group_by_url
    query.to_query_string.should eq("url=ria.ru&collapse=original")
  end

  it "collapses by url (with position)" do
    query = Wayback::Query.url("ria.ru").group_by_url(position: 5)
    query.to_query_string.should eq("url=ria.ru&collapse=original%3A5")
  end

  it "collapses by mimetype" do
    query = Wayback::Query.url("ria.ru").group_by_mimetype
    query.to_query_string.should eq("url=ria.ru&collapse=mimetype")
  end

  it "collapses by mimetype (with position)" do
    query = Wayback::Query.url("ria.ru").group_by_mimetype(position: 5)
    query.to_query_string.should eq("url=ria.ru&collapse=mimetype%3A5")
  end

  it "collapses by status_code" do
    query = Wayback::Query.url("ria.ru").group_by_status_code
    query.to_query_string.should eq("url=ria.ru&collapse=statuscode")
  end

  it "collapses by status_code (with position)" do
    query = Wayback::Query.url("ria.ru").group_by_status_code(position: 5)
    query.to_query_string.should eq("url=ria.ru&collapse=statuscode%3A5")
  end

  it "collapses by digest" do
    query = Wayback::Query.url("ria.ru").group_by_digest
    query.to_query_string.should eq("url=ria.ru&collapse=digest")
  end

  it "collapses by digest (with position)" do
    query = Wayback::Query.url("ria.ru").group_by_digest(position: 5)
    query.to_query_string.should eq("url=ria.ru&collapse=digest%3A5")
  end

  it "collapses by url" do
    query = Wayback::Query.url("ria.ru").group_by_url.with_aggregate_count
    query.to_query_string.should eq("url=ria.ru&collapse=original&showGroupCount=true")
  end
end
