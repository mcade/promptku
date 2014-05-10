function get_short_url(long_url, login, api_key, func)
	{
	    $.getJSON(
	        "http://api.bitly.com/v3/shorten?callback=?", 
	        { 
	            "format": "json",
	            "apiKey": api_key,
	            "login": login,
	            "longUrl": long_url
	        },
	        function(response)
	        {
	            func(response.data.url);
	        }
	    );
	}

var login = "promptku";
var api_key = "R_11b528a2a4b64dcebb588cd0a482eb18";