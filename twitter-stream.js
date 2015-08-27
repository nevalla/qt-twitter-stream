.pragma library

Qt.include("backbone.js")

$.ajaxSettings["headers"] = {
        "Enginio-Backend-Id": "533d48785a3d8b7d1701291f"
    }


var REQUEST_URL = "https://mar-eu-1-13viqrf8.qtcloudapp.com"
var baseUrl = "https://api.engin.io/v1";
var Contact = Backbone.Model.extend({

    url: function() {
        return baseUrl+"/objects/contacts";
    },

});

var Contacts = Backbone.Collection.extend({
    model: Contact,
    url: baseUrl+"/objects/contacts",

    parse: function(response) {
          return response.results;
    }
});

function initItems(tweet)
{
    var coll = new Contacts();
    coll.on("add", function(model){console.log("new model "+model.get("firstName"));});
    coll.fetch({success: function(data) { console.log("success"); console.log(coll.length) }, error: function(data, response, options) {console.log("error") }});

    console.log("Init Tweets");
    var doc = new XMLHttpRequest();
    doc.open("GET", REQUEST_URL + "/tweets/qtdd14", true);
    doc.setRequestHeader('Content-Type', 'application/json');
    doc.onreadystatechange = function()
    {
        // When ready
        if (doc.readyState === 4) {

            // If OK
            if (doc.status === 200) {
                var data = parseTweet(doc.responseText);

                if (checkError(data)) {
                    initModels(data, tweet)
                    //app.loading = false
                }
            }
            else {
                console.log(doc.status, doc.statusText)
            }
        }
    }
    doc.send();

}

function initModels(data, tweet)
{
    tweet.clear()
    for (var i=data.length; i--;) {
        var obj = data[i];        
        insertTweet(tweet, obj);
    }
}

function insertTweet(tweet, obj, i)
{
    tweet.insert(0, {tweetText: obj.text, screenName: obj.screen_name, img: obj.profile_img_url, name: obj.name, created: obj.created })
}

function parseTweet(tweetString)
{
    return JSON.parse(tweetString)
}


function openWebSocketConnection(socket)
{
    console.log("Get WebSocketUri");
    var doc = new XMLHttpRequest();
    doc.open("GET", REQUEST_URL + "/websocket_uri", true);
    doc.setRequestHeader('Content-Type', 'application/json');
    doc.onreadystatechange = function()
    {
        // When ready
        if (doc.readyState === 4) {

            // If OK
            if (doc.status === 200) {
                var data = JSON.parse(doc.responseText);

                socket.url = data.uri
            }
            else {
                console.log(doc.status, doc.statusText)
            }
        }
    }
    doc.send();

}

function checkError(data)
{
    var obj = data.error
    if (obj === undefined) {
        return true;
    }
    else {
        error(obj.code, obj.message, false)
        return false;
    }
}

function parseTwitterDate(tdate) {
    var system_date, user_date;
    if(tdate) {
        system_date = new Date(Date.parse(tdate));
        user_date = new Date();
    }
    else {
        return "just now";
    }

    var diff = Math.floor((user_date - system_date) / 1000);
    if (diff <= 1) {return "just now";}
    if (diff < 20) {return diff + "s";}

    if (diff <= 3540) {return Math.round(diff / 60) + "m";}
    if (diff <= 5400) {return "1h";}
    if (diff <= 86400) {return Math.round(diff / 3600) + "h";}
    if (diff <= 129600) {return "1 day ago";}
    if (diff < 604800) {return Math.round(diff / 86400) + "d";}
    if (diff <= 777600) {return "1w";}
    return "on " + system_date;
}

