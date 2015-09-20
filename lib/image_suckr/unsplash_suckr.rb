module ImageSuckr

  class UnsplashSuckr
    attr_accessor :default_params

    def initialize(default_params = {})
    end

    def get_image_url(params = {})
      get_results(1).try(:[], 0)
    end
    
    def get_image_urls(count=20, params={})
      get_results(count)
    end
    
    private
    
    def get_results(count=20)
      url = "https://unsplash.it/list"

      resp = Net::HTTP.get_response(URI.parse(url))
      result = JSON.parse(resp.body)
      return nil if result.nil?

      result.sample(count).map do |image|
        "https://unsplash.it/1000?image=#{image['id']}"
      end
    end
  end
end
