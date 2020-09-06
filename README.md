QyWechat
====


## example:

    $./bin/console


~~~ruby
c = QyWechat::Api.new('corpid-123',
                      "corpsecret-123",
                      "agentid-123", # agentid can be absent
                      debug_mode: true)  # set debug_mode to true to show request's debug log, the omission of it will set it to false.
c.corpid
c.corpsecret
c.agentid

c.access_token # access_token will auto update itself if expired when you access it

c.gen_qrConnect_link(appid: "appid-123", # can be absent
                     agentid: "agentid-123", # can be absent
                     redirect_uri: "http://you-webside-domain.com/path/abc",
                     state: "url-state-params-of-the-redirect-uri")

c.user_getuserinfo(code: "12343")
c.raw_get("user/getuserinfo, code: "12343") # same as previous line, but instead using a low level method to do the reqeust.

c.debug_mode = false # turn off debug mode
~~~


## notice
As said from the official doc, the access_token should not be updated frequently, we may as well set up a global var for the api client and then do every request with this client:
~~~ruby
$qy_wechat_client = QyWechat::Api.new('corpid-123', "corpsecret-123", "agentid-123")
~~~

For a Rails app, you can put it to the initialize dir's file.
