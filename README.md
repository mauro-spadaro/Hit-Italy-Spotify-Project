# Hit-Italy-Spotify-Project
This repository aims to cover all the code employed to run our Artificial Intelligence &amp; Behavioural Science research project for the class "Artificial Intelligence & Behavioural Science" at the University of St. Gallen, Switzerland. 

Please refer to the following folders/steps that we went through to arrive to our final results: 

**1. Download Scripts**

We created our database based on FIMI (https://www.fimi.it/top-of-the-music/archivio-classifiche-annuali.kl#/chartsyeararchive) charts from 2002 to 2021. Songs were added manually to a Spotify playlist and then downloaded through the following guide and library (https://medium.com/analytics-vidhya/easily-analyse-audio-features-from-spotify-playlists-part-1-3b004cd406b3 and https://github.com/OleAd/GeneralizedSpotifyAnalyser). Please refer to the guide to get started with the necessary files and packages. 

The file "GSA_hits.py" represents the code we used to download our hits playlist (https://open.spotify.com/playlist/4XUW6FCXIqh3mBpzkNTGUt?si=90916cd25c0545f3). Similarly, we then proceeded in creating our non-hits database controlling for randomization, genres of the hits database and years (2002-2021). Genres were extracted from the hits database with the "Proportion_Genre.py" script, which was created on purpose by the authors (**2. Genre Analysis folder**). "Randomisation non-hits.py" is instead the code used for randomizing the selection process of non-hits and creation of the playlists (https://open.spotify.com/playlist/4bcWQseNOLnxH4XUgpmgkQ?si=d0d4cb509a2040df and https://open.spotify.com/playlist/6DjIRlc7hnwSYT3lf95eVy?si=6c0575fe550a4771) through the _spotipy.random_ method and library. 

**3. Database Analysis**

We then proceeded in merging the non-hits databases downloaded ("2k_non_hits.csv" and "8k_non_hits.csv", **Databases** folder) via Excel and through the "Database Analysis.R" we deleted duplicates for the TrackIDs. 

Before creating descriptive tables and measures ("Descriptive_Measures_HITS.xls" and "Descriptive_Measures_NO_HITS.xls") we further manually checked the hits database, as 6 songs resulted to be the same but with different TrackIDs. Similarly, we performed a manual analysis of the Non-hits merged database, deleting for duplicates with the same TrackName with Excel. 

"Audio features Evolution.xls" shows some intesting consideration for the ranked #1 hit songs audio evolution, plotting data through line trends and charts. 

**4. Model Analysis**

File "220423_Hit Prediction_v03.R" represents our R code used to analyse our data. Results (model measures performances and box plots) can be found in the **Results** folder.

