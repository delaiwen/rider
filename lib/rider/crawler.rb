module Rider
  class Crawler
    # Creates a new Crawler, with the specified +mask+ (a Regexp) and queue (a +Rider::Queue+ instance).
    def initialize(mask, queue)
      @mask = mask
      @queue = queue
      @seen_urls = []
      @www = WWW::Mechanize.new { |a| a.log = Logger.new("tmp/www.log") }
    end
    
    # Returns true if +url+ passes the +mask+.
    def match_mask?(url)
      @mask.match(url) != nil
    end
    
    # Crawls documents and passes their URL, response headers, and data to the supplied block.
    def each_document
      while doc_data = next_document()
        follow_urls = yield(doc_data) || []
        follow_urls.each { |url| @queue.push(url) unless seen_url?(url) }
      end
    end
    
    # Returns the document from the next valid URL in the queue.
    def next_document
      url = next_url()
      return nil if url.nil?
      doc_data = get(url)
      saw_url(url)
      return doc_data
    end
    
    # Gets the document at the specified +url+. Returns an Array [uri, metadata, contents]
    def get(url)
      uri = URI.parse(url)
      case uri.scheme
      when 'http'
        get_http(uri)
      when 'file'
        get_file(uri)
      else
        raise(ArgumentError, "don't know how to get #{url}")
      end
    end
    
    def get_file(uri)
      filename = uri.gsub(/^file:\/\//, '')
      [uri, {}, File.read(filename)]
    end
    
    def get_http(uri)
      [uri, {}, @www.get_file(uri)]
    end
    
    # Retrieves the next URL in the queue that matches the +mask+.
    def next_url
      while url = @queue.pop
        return url if match_mask?(url) and !seen_url?(url)
      end
    end
    
    def seen_url?(url)
      @seen_urls.include?(url)
    end
    
    def saw_url(url)
      @seen_urls << url
    end
  end
end