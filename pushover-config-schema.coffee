module.exports = {
  title: "pushover config options"
  type: "object"
  required: ["user", "token"]
  properties: 
    user:
      description: "Pushover user hash"
      type: "string"
      required: yes
    token:
      description: "Pushover token"
      type: "string"
      default: ""
      required: yes
    title: #might be overwritten by predicate
      description: "Title for the notification"
      type: "string"
      default: ""
    message: #might be overwritten by predicate
      description: "Message for the notification"
      type: "string"
      default: ""
    url: #might be overwritten by predicate, not implemented yet
      description: "URL which to send with the notification"
      type: "string"
      format: "url"
      default: "https://github.com/thexperiments/pimatic-pushover"
    urlTitle: #might be overwritten by predicate, not implemented yet
      description: "Title of the URL which to send with the notification"
      type: "string"
      default: ""
    priority: #might be overwritten by predicate
      description: """Priority of the notification: send as -1 to always send as a quiet 
        notification, 1 to display as high-priority and bypass the user's quiet hours, or 2 to 
        also require confirmation from the user (Receipts not implemented yet)"""
      type: "integer"
      default: 0
    sound: #might be overwritten by predicate
      description: "Sound for the notification, see https://pushover.net/api#sounds"
      type: "string"
      default: "pushover"
    url: #might be overwritten by predicate
      description: "Supplementary URL to show with your message, see https://pushover.net/api#urls"
      type: "string"
      required: false
    device: #might be overwritten by predicate
      description: "device to send the notification to"
      type: "string"
      default: ""
    retry: #might be overwritten by predicate
      description: """Only applicable when priority = 2. Sets how often the user is notified (in seconds)"""
      type: "integer"
      default: 600
    expire: #might be overwritten by predicate
      description: """Only applicable when priority = 2. Sets how long the user is notified (in seconds)"""
      type: "integer"
      default: 3600
    callbackurl: #might be overwritten by predicate
      description: """Only applicable when priority = 2. URL is called when user acknowledges the notification"""
      type: "string"
      default: ""
}
