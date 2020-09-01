require "qy_wechat/version"
require 'faraday'
require 'active_support/all'


module QyWechat
  class Api
    # class Error < StandardError; end
    BASE_URL = "https://qyapi.weixin.qq.com"
    # KNOWN_METHODS = [ :user_get, :user_getuserinfo ]
    attr_reader :corpid, :corpsecret, :agentid
    attr_accessor :debug_mode

    def initialize(corpid, corpsecret, agentid=nil, debug_mode=false)
      @corpid = corpid
      @corpsecret = corpsecret
      @agentid = agentid
      @debug_mode = debug_mode
    end


    [ :user_get, :user_getuserinfo ].each do |name|
      define_method name do |args|
        path = name.to_s.split("_", 2).join("/")
        raw_get path, args
      end
    end

    def gettoken
      re = conn.post "/cgi-bin/gettoken", { corpid: @corpid, corpsecret: @corpsecret }.to_json
      raise "error: #{re}" if re.status != 200 and re

      reh = JSON.parse re.body
      raise "error: #{re.body}" if reh['errcode'] != 0

      @access_token_expires_at = Time.now + reh["expires_in"] - 5
      @access_token = reh["access_token"]
    end
    def access_token
      gettoken unless @access_token
      gettoken if access_token_expired?
      @access_token
    end
    def access_token_expired?
      Time.now > @access_token_expires_at
    end

    def gen_qrConnect_link(params)
      if params[:appid].nil?
        params[:appid] = @corpid
      end
      if params[:agentid].nil?
        params[:agentid] = @agentid
      end
      "https://open.work.weixin.qq.com/wwopen/sso/qrConnect?" + params.to_query
    end

    def raw_get(path, params)
      conn.get "cgi-bin/#{path}", params.merge!(access_token: access_token)
    end
    def raw_post(path, params)
      conn.post "cgi-bin/#{path}", params.merge!(access_token: access_token).to_json
    end
    def conn
      Faraday.new(BASE_URL) do |faraday|
        faraday.request  :url_encoded
        faraday.response :logger, ::Logger.new(STDOUT), :bodies => true if @debug_mode
        faraday.adapter  Faraday.default_adapter
        faraday.headers['Content-Type'] = 'application/json'
      end
    end

    private
    #TODO: enhance method missing => filter methods like defined_method?(name)... super unless KNOWN_METHODS.include? name
    # add respond_to? ....
    def method_missing(method, *args, &block)
      path = method.to_s.split("_", 2).join("/")
      args.merge!(access_token: access_token)
      case path
      when /create$/
        raw_post path, args
      else
        raw_get path, args
      end
    end
    # def respond_to?(name, include_private = false)
    #   KNOWN_METHODS.include?(name) or super
    # end

  end
end
