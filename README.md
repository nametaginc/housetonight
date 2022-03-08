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
Nametag uses the industry-standard [OAuth2](https://oauth.net/2/) process to securely exchange data.  The first step in setting this up is to inform Nametag about the details of your OAuth2 "application" (don't worry, you aren't writing an OAuth2 program); the things you need are:
1. A name for your application (in this case, HouseTonight)
2. A logo that Nametag will display in the mobile application and a few other places (in this case, `logo.png`)
3. A callback URL that will be visited after an authentication requests (in this case, it is the same page)
4. The data elements (called scopes) you are requesting (in this case `login`, `nt:name`, `nt:first_name`, `nt:profile_picture`, and `nt:age_over_21`; these are all defined in `index.html`)

On creating the OAuth2 "application", you will get back a **ClientID** that you will use in your app to identify it to Nametag.

This configuration is done at the [Nametag Developer Console](https://console.nametag.co).

Building HouseTonight
---------------------
Once you have your callback URL and ClientID, edit the top of the Makefile and fill in the two variables with that information.

Typing `make build` will produce a directory called `build` with the contents of the website.

If you are using Netlify, you can use your Netlify credentials to deploy this website by typing `make deploy`

Next Steps
----------
Explore the Nametag documentation at https://docs.nametag.co, reach out to us at help@nametag.co, and have fun building authentication that is very secure, doesn't over-share your users' data, and relieves you of the requirement to store and secure PII.
