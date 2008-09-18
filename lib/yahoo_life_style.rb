# http://tw.developer.yahoo.com/lifestyle_api.html

require 'net/https'
require 'rubygems'
require 'xmlsimple'

class YahooLifeStyle

  @@request_url = 'http://tw.lifestyle.yahooapis.com/v0.1'
  @@appid = "YOUR_APP_ID"

  def initialize(appid=@@appid)
    @appid = appid
  end

  def boot_up
    url = "#{@@request_url}/Auth.bootUp?appid=#{@@appid}"
    return get_xml(url)["status"]
  end

  # array of hash for "Name", "Rank", "LastRank", "Link", "id"
  def list_buzz
    url = "#{@@request_url}/Biz.listBuzzBizs?appid=#{@@appid}"
    data = get_xml(url)
    return [] unless data["status"] == 'ok'
    return data["BizList"][0]["Biz"]
  end

  # hash for "Name", "Location", "Hour", "Url", "Card", "Tel", "id", "Close", "Email", "ParkingService", "ParkingLot", "Booking", "Fax", "Highlight", "Address"
  def get_details(biz_id)
    url = "#{@@request_url}/Biz.getDetails?appid=#{@@appid}&ID=#{biz_id}"
    data = get_xml(url)
    return nil unless data["status"] == 'ok'
    return data["Biz"][0]
  end

  # array of hash for "Name", "Numofrating", "Tel", "id", "Rating", "Highlight", "Address"
  def search( name, address = '', page = 1)
    url = "#{@@request_url}/Biz.search?appid=#{@@appid}&BizName=#{url_encode(name)}&address=#{url_encode(address)}&page=#{page}"
    data = get_xml(url)
    return [] unless data["status"] == 'ok'
    return data["BizList"][0]["Biz"]
  end

  # array of hash for "id", "Title"
  def list_categories(class_id='')
    url = "#{@@request_url}/Class.listClasses?appid=#{@@appid}&id=#{class_id}"
    data = get_xml(url)
    return [] unless data["status"] == 'ok' 
    return data["ClassList"][0]["Class"]
  end

  # array of hash for "Name", "Location", "Tel", "id", "Address"
  def list_by_geo( lon="121.5438", lat="25.0417", class_id="0")
    url = "#{@@request_url}/Class.listBizsInRange?appid=#{@@appid}&class=#{class_id}&lon=#{lon}&lat#{lat}"
    data = get_xml(url)
    return [] unless data["status"] == 'ok'
    return data["BizList"][0]["Biz"]
  end

  # array of hash for "Comment", "TemplateID", "Rating"
  def list_reviews(biz_id, index = 1, limit = 10)
    url = "#{@@request_url}/Biz.listReviews?appid=#{@@appid}&ID=#{biz_id}&begin=#{index}&limit=#{limit}"
    data = get_xml(url)
    return [] unless data["status"] == 'ok'
    return data["ReviewList"][0]["Review"]
  end
  
  # not implentment now
  # I have no idea about "User Is Not Authorized"
  def list_bookmarks(user_id)
    url = "#{@@request_url}/User.listBookmarks?appid=#{@@appid}&ID=#{user_id}"
  end

  def list_biz_by_bookmark(user_id, bookmark_id)
    url = "#{@@request_url}/Bookmark.listBizs?appid=#{@@appid}&ID=#{bookmark_id}&User=#{user_id}"   
  end

  def list_user_reviews(user_id, biz_id="")
    url = "#{@@request_url}/User.listReview?appid=#{@@appid}&ID=#{user_id}&biz=#{biz_id}" 
  end

  def add_review(biz_id, comment)
    url = "#{@@request_url}/Biz.addReview?appid=#{@@appid}&ID=#{biz_id}&Comment=#{url_encode(comment)}" 
  end

  protected

  def get_xml(url)
    return XmlSimple.xml_in( Net::HTTP.get( URI.parse(url) ) )
  end

  def url_encode(str)
    CGI.escape(str)
  end
end
