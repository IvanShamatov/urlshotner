class Link

  class NotFound < StandardError; end


  # model without database representation
  attr_reader :short_url, :original_url

  NAMESPACE = "shortner"


  def self.create(original_url)
    puts "do we have it here? #{original_url}"
    link = new
    link.original_url = original_url
    puts "whats in #{link.original_url}"
    link.save
    link
  end


  def self.find(short_url)
    link = new
    link.short_url = short_url
    link
  end


  def self.keys
    # will return all keys from redis
    # need some namespace
    Redis.current.keys("#{NAMESPACE}*")
  end

  def self.uniq_key
    begin 
      string = [('a'..'z'), ('A'..'Z'), (0..9)].map { |i| i.to_a }.flatten.shuffle[0,5].join
    end while keys.include?(string)
    string 
  end



  def initialize(hash = nil)
    unless hash.nil?
      @original_url = hash[:original_url] if hash.has_key?(:original_url)
      @short_url = hash[:short_url] if hash.has_key?(:short_url)
    end
  end


  def save
    puts "we are saving #{self.original_url} to #{self.short_url} "
    Redis.current.set("#{NAMESPACE}:#{self.short_url}", self.original_url)
  end



  def original_url=(original_url)
    # TODO: need to validate url like url
    @original_url = original_url
    @short_url = self.class.uniq_key
  end



  def short_url=(short_url)
    @short_url = short_url
    url = Redis.current.get("#{NAMESPACE}:#{self.short_url}")
    if url.nil?
      raise NotFound
    else
      @original_url = url
    end
  end


end