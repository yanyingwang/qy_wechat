require "qy_wechat/version"
require 'faraday'
require 'active_support/all'


module QyWechat
  class Api
    # class Error < StandardError; end
    BASE_URL = "https://qyapi.weixin.qq.com"
    attr_accessor :corpid, :corpsecret, :agentid

    def initialize(corpid, corpsecret, agentid=nil)
      @corpid = corpid
      @corpsecret = corpsecret
      @agentid = nil
    end

    def gettoken
      re = conn.post "/cgi-bin/gettoken", {corpid: @corpid, corpsecret: @corpsecret}.to_json
      raise "error: #{re}" if re.status != 200 and re

      reh = JSON.parse re.body
      raise "error: #{re.body}" if reh['errcode'] != 0

      @access_token_expires_at = Time.now + reh["expires_in"] - 5
      @access_token = reh["access_token"]
    end

    def access_token
      access_token_expired? ? gettoken : @access_token
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
      BASE_URL + params.to_query
    end

    def conn
      Faraday.new(BASE_URL) do |req|
        faraday.request  :url_encoded
        faraday.response :logger, ::Logger.new(STDOUT), :bodies => true
        faraday.adapter  Faraday.default_adapter
        req.headers['Content-Type'] = 'application/json'
      end
    end
  end


end
