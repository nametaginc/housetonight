Nametag
=======

[Nametag](https://getnametag.com) is the latest generation of privacy-preserving secure authentication using government-issued IDs for online, over the phone, and in-person interactions.

To demonstrate the ease with which you can integrate Nametag's technology into your workflow, HouseTonight is a demonstration of using Nametag on a single web-page that is less than 400 lines of HTML and Javascript.

The Backstory
-------------
HouseTonight is a way for people to rent a luxury house for tonight. Because these are very well appointed properties, it is important that the home owners, via HouseTonight, know that the renters are over 21. In addition, because it is time-sensitive transaction (it is for tonight, after all), there isn't time to do a traditional ID review with a human involved, and the back-and-forth of a manual process. The people renting these houses don't want to share all of the information on their government-issued ID with HouseTonight---there is no need for that and over-sharing increase the risk of identity theft; likewise, HouseTonight doesn't want to be responsible for storing and securing renters' personally identifiable information (PII).

Nametag solves all of these problems by authenticating the renter's government ID, confirming that they want to share with HouseTonight their name, photo, and whether or not they are over 21, and (on confirmation) giving HouseTonight access to only those three pieces of information. HouseTonight can retrieve that information any time without storing it, and the renter can revoke HouseTonight's access to that information at any time.

Setting up a Nametag Integration with HouseTonight
--------------------------------------------------
Nametag uses the industry-standard [OAuth2](https://oauth.net/2/) process to securely exchange data. This configuration is done at the [Nametag Developer Console](https://console.nametag.co) where the steps are:

1. Create a Team

   A team is the list of people who can view and change the settings for your app; you are automatically added to it, so simply creating it is sufficient for now

2. Add an App
   1. A name for your application (in this case, HouseTonight)
   2. A (optional) logo that Nametag will display in the mobile application and a few other places (in this case, `logo.png`)
   3. A callback URL that will be visited after an authentication requests (in this case, it is the same page).

	  You'll note that Nametag **requires** a TLS-secured HTTP endpoint (aka `https://`). The easiest way we have found to do this is to create a free account with [ngrok](https://ngrok.com/), install the `ngrok` software, and start it by typing `ngrok http 3000`. Copy the `https` URL provided by ngrok and paste that into the callback URL configuration; leave `ngrok` running so the URL doesn't change.

	  The callback URL is entered on the Configuration tab; click the button that looks like `+ Add a callback URL` and enter the ngrok URL there.

   4. The data elements (called scopes) you are requesting (in this case `login`, `nt:name`, `nt:first_name`, `nt:profile_picture`, and `nt:age_over_21`; these are all defined in `index.html`)

	On creating the OAuth2 "application", you will get back a **Client ID** that you will use in your app to identify it to Nametag.  Depending on how you deploy your app, you may or may not need the **Client Secret**.

Building HouseTonight
---------------------
Once you have your callback URL (for this example, the DNS part of that goes in the `HOUSETONIGHT_DNS_NAME`, don't include the `https://` part) and Client ID, edit the top of the Makefile and fill in the two variables with that information.

Typing `make build` will produce a directory called `build` with the contents of the website.

You can serve this in any number of ways:

### Using the included Go program
If you have a [Go compiler](https://go.dev/) you can run the `nopkce.go` program by typing `make run-nopkce`. You will have to include the **CLIENT_SECRET** in the Makefile for this to work.

Visit the ngrok-provided URL in your web browser to use House Tonight.

### Using Python's SimpleHTTPServer
If you have [Python](https://www.python.org/) installed, you can change directories into `build` and type:
```shell
python -m SimpleHTTPServer 3000
```

Visit the ngrok-provided URL in your web browser to use House Tonight.

### Using a simple Node webserver
If you have [Node](https://nodejs.dev/) installed, you can install the [http-server package](https://www.npmjs.com/package/http-server) and start it by typing:
```shell
http-server build/ -p 3000
```

Visit the ngrok-provided URL in your web browser to use House Tonight.

Next Steps
----------
You can add scopes to your configuration and to the House Tonight `index.html` file to request other data elements (for a full list of scopes see [https://docs.nametag.co/api/#scopes](https://docs.nametag.co/api/#scopes)), you can revoke access from the mobile app to confirm that the user is always in control of their data, you can use the iOS App Clip to experience that process, you can add logos to your configuration and see how they appear, and then start making your own application that uses Nametag.

Explore the Nametag documentation at https://docs.nametag.co, reach out to us at help@nametag.co, and have fun building authentication that is very secure, doesn't over-share your users' data, and relieves you of the requirement to store and secure PII.
