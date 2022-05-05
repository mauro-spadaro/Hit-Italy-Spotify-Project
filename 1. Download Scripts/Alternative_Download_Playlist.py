# -*- coding: utf-8 -*-
"""
Created on Fri Apr 22 17:55:07 2022

@author: spada
"""
import pandas as pd 
import spotipy
import spotipy.util as util

from spotipy.oauth2 import SpotifyClientCredentials
"""
CLIENT_ID = "db0fdd7b08c145e98df0b09c93713a3c"
CLIENT_SECRET = "804d188a652641a9b93d39e42b881a95"
"""

CLIENT_ID = "e6a77915d1ff4ea8ba6a2b2025712ac9"
CLIENT_SECRET = "a5150f9c6cbd4bdc83f26b1f0cba08ce"


""""
token = util.oauth2.SpotifyClientCredentials(client_id=CLIENT_ID, client_secret=CLIENT_SECRET)
cache_token = token.get_access_token()
sp = spotipy.Spotify(cache_token)
"""

auth_manager = SpotifyClientCredentials(client_id=CLIENT_ID,client_secret=CLIENT_SECRET)
sp = spotipy.Spotify(auth_manager=auth_manager)


#insert here creator and ID playlist
playlist_creator = "spotify"
playlist_id = "37i9dQZF1DX5IDTimEWoTd"


def analyze_playlist(creator, playlist_id):
    
    print("Hello0")
    # Create empty dataframe
    playlist_features_list = ["artist", "album", "track_name", "track_id", 
                             "danceability", "energy", "key", "loudness", "mode", "speechiness",
                             "instrumentalness", "liveness", "valence", "tempo", "duration_ms", "time_signature"]
    playlist_df = pd.DataFrame(columns = playlist_features_list)
    
    # Create empty dict
    playlist_features = {}
    
    print("hello1")
    # Loop through every track in the playlist, extract features and append the features to the playlist df
    playlist = sp.user_playlist_tracks(creator, playlist_id)["items"]
    for track in playlist:
        # Get metadata
        playlist_features["artist"] = track["track"]["album"]["artists"][0]["name"]
        playlist_features["album"] = track["track"]["album"]["name"]
        playlist_features["track_name"] = track["track"]["name"]
        playlist_features["track_id"] = track["track"]["id"]
        # Get audio features
        audio_features = sp.audio_features(playlist_features["track_id"])[0]
        for feature in playlist_features_list[4:]:
            playlist_features[feature] = audio_features[feature]
        
        # Concat the dfs
        track_df = pd.DataFrame(playlist_features, index = [0])
        playlist_df = pd.concat([playlist_df, track_df], ignore_index = True)
        
    return playlist_df

playlist_df = analyze_playlist(playlist_creator, playlist_id)

playlist_df.head()


playlist_df.to_csv('trial77.csv')