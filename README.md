pimatic-pushover
=======================

A plugin for sending [pushover](https://pushover.net/) notifications in pimatic. 
Forked from [thexperiments](https://github.com/thexperiments/pimatic-pushover)


Configuration
-------------
You can load the backend by editing your `config.json` to include:

    {
      "plugin": "pushover",
      "user": "xxxxxxxxxxxxxxxxxxxxxxxxxx",
      "token": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    }

in the `plugins` section. For all configuration options see 
[pushover-config-schema](pushover-config-schema.coffee)

Currently you can send pushover notifications via action handler within rules.

Example:
--------

    if it is 08:00 push title:"Good morning!" message:"Good morning Dave!" priority:1

in general: if X then push title:

    "title of the push notification" message:"message for the notification" [priority:-1 - 1]

Find priorities here at [pushover](https://pushover.net/api#priority) be aware that priority 2 currently crashes pimatic!

Obtaining the API-Token
-----------------------

To setup the pushover plugin you need an account at pushover.net.
once created, you will get an user key. Have a look here:

![pushoverkey](https://cloud.githubusercontent.com/assets/8620305/4965728/91510a1a-6792-11e4-86a5-cda7f91e07b4.jpg)

Then you need to register an application. As type use plugin, description is "pimatic". You can set an icon that will be displayed when the pushover app displays messages send from pimatic.

![pushoverkey3](https://cloud.githubusercontent.com/assets/8620305/4965735/150233f2-6793-11e4-80c0-2cf2e580bc05.jpg)

Once registered, you will get an API Token / Key. This is the token to be set in the config.json, below your user key. 

![pushoverkey2](https://cloud.githubusercontent.com/assets/8620305/4965747/cedab8a8-6793-11e4-9254-f648fbbee959.jpg)
