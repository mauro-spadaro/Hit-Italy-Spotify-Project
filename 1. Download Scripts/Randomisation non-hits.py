# Install & import relevant libraries
from fileinput import filename
from spotipy import Spotify
import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
from spotipy.oauth2 import SpotifyOAuth
from spotipy_random import get_random
from random import randrange
import json
import sys

# Define key variables
clientID = "Insert your ClientID" #This is personal and secret -> insert own client ID
clientSecret = "Insert your clientSecret" #This is personal and secret -> insert own client secret
playlistID = "Insert your playlistID" #Insert relevant playlist ID
scope = "playlist-modify-public"

# Setting up the Loop
counter = 1
max_songs = range(15000)
offset = 1

# Define initial Spotify function
def Spotify_function(genre_type):
    # Randomly select first song (needed to create JSON)
    spotify_client = spotipy.Spotify(auth_manager=SpotifyClientCredentials(
                                 client_id = clientID,
                                 client_secret = clientSecret))
    random_pop_song_json = str = get_random(spotify=spotify_client, type="track", year="2002-2021", genre=genre_type, limit=int(50), offset_min=offset, offset_max=(offset+1))
    # Extract song URL from random song JSON (needed as input for next step)
    json_str = json.dumps(random_pop_song_json)
    resp = json.loads(json_str)
    track_uri = resp['uri']
    # Add selected random song to playlist on Spotify
    sp = spotipy.Spotify(auth_manager=SpotifyOAuth(client_id = clientID, client_secret = clientSecret, 
    redirect_uri="http://localhost:8888/callback", scope=scope))
    sp.playlist_add_items(playlist_id = playlistID, items=[track_uri], position=None)

# Loop through song genres
for counter in max_songs:
    offset = randrange(1, 950)
    if counter < 2209:
        try:
            Spotify_function("pop")
            counter = counter + 1
            print(counter)
        except:
            counter = counter - 1
            pass
    elif counter < 4192:
        try:
            Spotify_function("dance pop")
            counter = counter + 1
            print(counter)
        except:
            counter = counter - 1
            pass
    elif counter < 5905:
        try:
            Spotify_function("italian adult pop")
            counter = counter + 1
            print(counter)
        except:
            counter = counter - 1
            pass
    elif counter < 7222:
        try:
            Spotify_function("italian pop")
            counter = counter + 1
            print(counter)
        except:
            counter = counter - 1
            pass
    elif counter < 7938:
        try:
            Spotify_function("pop rap")
            counter = counter + 1
            print(counter)
        except:
            counter = counter - 1
            pass
    elif counter < 8579:
        try:
            Spotify_function("italian hip hop")
            counter = counter + 1
            print(counter)
        except:
            counter = counter - 1
            pass
    elif counter < 9170:
        try:
            Spotify_function("pop dance")
            counter = counter + 1
            print(counter)
        except:
            counter = counter - 1
            pass
    elif counter < 9726:
        try:
            Spotify_function("edm")
            counter = counter + 1
            print(counter)
        except:
            counter = counter - 1
            pass
    elif counter < 10247:
        try:
            Spotify_function("classic italian pop")
            counter = counter + 1
            print(counter)
        except:
            counter = counter - 1
            pass
    elif counter < 10613:
        try:
            Spotify_function("tropical house")
            counter = counter + 1
            print(counter)
        except:
            counter = counter - 1
            pass
    elif counter < 10964:
        try:
            Spotify_function("pop rock")
            counter = counter + 1
            print(counter)
        except:
            counter = counter - 1
            pass
    elif counter < 11305:
        try:
            Spotify_function("post-teen pop")
            counter = counter + 1
            print(counter)
        except:
            counter = counter - 1
            pass
    elif counter < 11641:
        try:
            Spotify_function("latin")
            counter = counter + 1
            print(counter)
        except:
            counter = counter - 1
            pass
    elif counter < 11952:
        try:
            Spotify_function("europop")
            counter = counter + 1
            print(counter)
        except:
            counter = counter - 1
            pass
    elif counter < 12247:
        try:
            Spotify_function("italian indie pop")
            counter = counter + 1
            print(counter)
        except:
            counter = counter - 1
            pass
    elif counter < 12512:
        try:
            Spotify_function("urban contemporary")
            counter = counter + 1
            print(counter)
        except:
            counter = counter - 1
            pass
    elif counter < 12757:
        try:
            Spotify_function("italian pop rock")
            counter = counter + 1
            print(counter)
        except:
            counter = counter - 1
            pass
    elif counter < 12982:
        try:
            Spotify_function("uk pop")
            counter = counter + 1
            print(counter)
        except:
            counter = counter - 1
            pass
    elif counter < 13192:
        try:
            Spotify_function("rock")
            counter = counter + 1
            print(counter)
        except:
            counter = counter - 1
            pass
    elif counter < 13402:
        try:
            Spotify_function("electro house")
            counter = counter + 1
            print(counter)
        except:
            counter = counter - 1
            pass
    elif counter < 13597:
        try:
            Spotify_function("electropop")
            counter = counter + 1
            print(counter)
        except:
            counter = counter - 1
            pass
    elif counter < 13792:
        try:
            Spotify_function("latin pop")
            counter = counter + 1
            print(counter)
        except:
            counter = counter - 1
            pass
    elif counter < 13982:
        try:
            Spotify_function("canadian pop")
            counter = counter + 1
            print(counter)
        except:
            counter = counter - 1
            pass
    elif counter < 14167:
        try:
            Spotify_function("modern rock")
            counter = counter + 1
            print(counter)
        except:
            counter = counter - 1
            pass
    elif counter < 14342:
        try:
            Spotify_function("trap italiana")
            counter = counter + 1
            print(counter)
        except:
            counter = counter - 1
            pass
    elif counter < 14512:
        try:
            Spotify_function("rap napoletano")
            counter = counter + 1
            print(counter)
        except:
            counter = counter - 1
            pass
    elif counter < 14682:
        try:
            Spotify_function("rap")
            counter = counter + 1
            print(counter)
        except:
            counter = counter - 1
            pass
    elif counter < 14842:
        try:
            Spotify_function("permanent wave")
            counter = counter + 1
            print(counter)
        except:
            counter = counter - 1
            pass
    else:
        try:
            Spotify_function("trap latino")
            counter = counter + 1
            print(counter)
        except:
            counter = counter - 1
            pass