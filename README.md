# Hit-Italy-Spotify-Project
This repository aims to cover all the code employed to run our Artificial Intelligence &amp;Behavioural Science research project. 

Please refer to the following steps that we went through to arrive to our final results: 

**
1) Database creation **

We created our database based on FIMI (https://www.fimi.it/top-of-the-music/archivio-classifiche-annuali.kl#/chartsyeararchive) charts from 2002 to 2021. Songs were added manually to a Spotify playlist and then downloaded through the following guide and library (https://medium.com/analytics-vidhya/easily-analyse-audio-features-from-spotify-playlists-part-1-3b004cd406b3 and https://github.com/OleAd/GeneralizedSpotifyAnalyser). Please refer to the guide to get started with the necessary files and packages. 

The file "XYZ" represents the code we used to download our hits playlist (https://open.spotify.com/playlist/4XUW6FCXIqh3mBpzkNTGUt?si=90916cd25c0545f3). Similarly, we then proceeded in creating our non-hits database controlling for randomization, genres of the hits database and years (2002-2021). Genres were extracted from the hits database with the "XYZ" script, which was created on purpose (folder XYZ for an initail analysis of the genres). "XYZ" is instead the code used for randomizing the selection process of non-hits and creation of the playlists (https://open.spotify.com/playlist/4bcWQseNOLnxH4XUgpmgkQ?si=d0d4cb509a2040df and https://open.spotify.com/playlist/6DjIRlc7hnwSYT3lf95eVy?si=6c0575fe550a4771). 

**
2) Database analysis**

Both databases were then checked for duplicates with the "XYZ" script, arriving to the final files used for our analysis (folder XYZ)
**
3) Analysis & results**

File "XYZ" represents our R code use to analyse our data and final resuls can be found in the "analysis" folder

