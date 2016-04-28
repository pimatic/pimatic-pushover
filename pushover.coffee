# #Pushover Plugin

# This is an plugin to send push notifications via pushover

# ##The plugin code

# Your plugin must export a single function, that takes one argument and returns a instance of
# your plugin class. The parameter is an environment object containing all pimatic related functions
# and classes. See the [startup.coffee](http://sweetpi.de/pimatic/docs/startup.html) for details.
module.exports = (env) ->

  Promise = env.require 'bluebird'
  assert = env.require 'cassert'
  util = env.require 'util'
  M = env.matcher
  # Require the [pushover-notifications](https://github.com/qbit/node-pushover) library
  Pushover = require 'pushover-notifications'
  Promise.promisifyAll(Pushover.prototype)

  pushoverService = null

  # ###Pushover class
  class PushoverPlugin extends env.plugins.Plugin

    # ####init()
    init: (app, @framework, config) =>
      
      user = config.user
      token = config.token
      env.logger.debug "pushover: user= #{user}"
      env.logger.debug "pushover: token = #{token}"

      pushoverService = new Pushover( {
        user: user,
        token: token,
        onerror: (message) => env.logger.error("pushover error: #{message}")
      })
      
      @framework.ruleManager.addActionProvider(new PushoverActionProvider @framework, config)
  
  # Create a instance of my plugin
  plugin = new PushoverPlugin()

  class PushoverActionProvider extends env.actions.ActionProvider
  
    constructor: (@framework, @config) ->
      return

    parseAction: (input, context) =>

      defaultTitle = @config.title
      defaultMessage = @config.message
      defaultPriority = @config.priority
      defaultSound = @config.sound
      defaultDevice = @config.device
      defaultRetry = @config.retry
      defaultExpire = @config.expire
      defaultCallbackurl = @config.callbackurl
      
      # Helper to convert 'some text' to [ '"some text"' ]
      strToTokens = (str) => ["\"#{str}\""]

      titleTokens = strToTokens defaultTitle
      messageTokens = strToTokens defaultMessage
      priority = defaultPriority
      sound = defaultSound
      device = defaultDevice
      retry = defaultRetry
      expire = defaultExpire
      callbackurl = defaultCallbackurl

      setTitle = (m, tokens) => titleTokens = tokens
      setMessage = (m, tokens) => messageTokens = tokens
      setPriority = (m, p) => priority = p
      setDevice = (m, d) => device = d
      setSound = (m, d) => sound = d
      setRetry = (m, d) => retry = d
      setExpire = (m, d) => expire = d
      setCallbackurl = (m, d) => callbackurl = d

      m = M(input, context)
        .match('send ', optional: yes)
        .match(['push','pushover','notification'])

      next = m.match(' title:').matchStringWithVars(setTitle)
      if next.hadMatch() then m = next

      next = m.match(' message:').matchStringWithVars(setMessage)
      if next.hadMatch() then m = next

      next = m.match(' priority:').matchNumber(setPriority)
      if next.hadMatch() then m = next

      next = m.match(' device:').matchString(setDevice)
      if next.hadMatch() then m = next
      
      next = m.match(' sound:').matchString(setSound)
      if next.hadMatch() then m = next
      
      next = m.match(' retry:').matchNumber(setRetry)
      if next.hadMatch() then m = next
      
      next = m.match(' expire:').matchNumber(setExpire)
      if next.hadMatch() then m = next
      
      next = m.match(' callbackurl:').matchString(setCallbackurl)
      if next.hadMatch() then m = next

      if m.hadMatch()
        match = m.getFullMatch()

        assert Array.isArray(titleTokens)
        assert Array.isArray(messageTokens)
        assert(not isNaN(priority))

        return {
          token: match
          nextInput: input.substring(match.length)
          actionHandler: new PushoverActionHandler(
            @framework, titleTokens, messageTokens, priority, sound, device, retry, expire, callbackurl
          )
        }
            

  class PushoverActionHandler extends env.actions.ActionHandler 

    constructor: (@framework, @titleTokens, @messageTokens, @priority, @sound, @device, @retry, @expire, @callbackurl) ->

    executeAction: (simulate, context) ->
      Promise.all( [
        @framework.variableManager.evaluateStringExpression(@titleTokens)
        @framework.variableManager.evaluateStringExpression(@messageTokens)
      ]).then( ([title, message]) =>
        if simulate
          # just return a promise fulfilled with a description about what we would do.
          return __("would push message \"%s\" with title \"%s\"", message, title)
        else
          
          if @priority is "2"
            env.logger.debug "pushover debug: priority=2"
            msg = {
                message: message
                title: title
                sound: @sound
                priority: @priority
                retry: @retry
                expire: @expire
                callbackurl: @callbackurl
            }
          else
            env.logger.debug "pushover debug: priority=xxx"
            msg = {
                message: message
                title: title
                sound: @sound
                priority: @priority
            }
            

          msg.device = @device if @device? and @device.length > 0

          return pushoverService.sendAsync(msg).then( => 
            __("pushover message sent successfully") 
          )
      )

  module.exports.PushoverActionHandler = PushoverActionHandler

  # and return it to the framework.
  return plugin   
