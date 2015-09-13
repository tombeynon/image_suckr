module ImageSuckr

  class GoogleSuckr
    attr_accessor :default_params

    def initialize(default_params = {})
      @default_params = {
        :rsz => "8",
        #"as_filetype" => "png",
        #"imgc" => "color",
        #"imgcolor" => "black",
        #"imgsz" => "medium",
        #"imgtype" => "photo",
        #"safe" => "active",
        :v => "1.0"
      }.merge(default_params)
    end

    def get_image_url(params = {})
      return nil unless results = get_results(params)
      results[rand(results.count)]["url"]
    end
    
    def get_image_urls(count=20, params={})
      return nil unless results = get_results(params)
      index = rand(results.count-count)
      results[index..(index+count)].map{|r| r["url"] }
    end

    def get_image_content(params = {})
      Net::HTTP.get_response(URI.parse(get_image_url(params))).body
    end

    def get_image_file(params = {})
      open(URI.parse(get_image_url(params)))
    end
    
    private
    
    def get_results(params={})
      params = @default_params.merge(params)
      params["q"] = rand(1000).to_s if params["q"].nil?

      url = "http://ajax.googleapis.com/ajax/services/search/images?" + params.to_query

      resp = Net::HTTP.get_response(URI.parse(url))
      result = JSON.parse(resp.body)
      return nil if result.nil?

      response_data = result["responseData"]
      return nil if response_data.nil? || response_data["results"].count < 1

      response_data["results"]
    end
  end
end
