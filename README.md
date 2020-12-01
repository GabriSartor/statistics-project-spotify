# MIP Statistics Project: Spotify Dataset analysis for Rolling Stones
 This is a university project for the Statistics course at MIP - Politecnico di Milano.

 Authors:
 - Matteo Canale
 - Gabriele Sartor
 - Matteo Gatto
 - Federico Pomé

 The main proposition of the whole project was to define a stakeholder and to perform a statistical analysis to collect some insigths regarding the stakeholder field for a specific purpose.
 In order to perform the analysis R in RStudio IDE has been used, combined with Excel and Powerpoint to present results.

 ## Dataset Description
 The dataset is composed by 180.000 tracks from Spotify platform from 1921 to 2020 (updated at June 2020).
 For each track 19 variables are present: both numerical, categorial and dummy.
 Here follows a brief description (see more at https://developer.spotify.com/documentation/web-api/)
 | Variable  | Range | Description |
 | ------------- | ------------- | ------------- |
 | Artists | List<String>  | List of artists performing the track |
 | Name | String | Name of the track |
 | ID | String | Unique ID to identify the track in spotify DB |
 | Release Date | Date | The release date of the track |
 | Year | Integer | The year in which the track has been released |
 | Mode | Dummy (0,1) | Mode indicates the modality (major or minor) of a track, the type of scale from which its melodic content is derived. Major is represented by 1 and minor is 0. |
 | Key | Categorical (-1, 11) | The estimated overall key of the track. Integers map to pitches using standard Pitch Class notation . E.g. 0 = C, 1 = C♯/D♭, 2 = D, and so on. If no key was detected, the value is -1.|
 | Acousticness | Float (0,1) | A confidence measure from 0.0 to 1.0 of whether the track is acoustic. 1.0 represents high confidence the track is acoustic. |
 | Danceability | Float (0,1) | Danceability describes how suitable a track is for dancing based on a combination of musical elements including tempo, rhythm stability, beat strength, and overall regularity. A value of 0.0 is least danceable and 1.0 is most danceable. |
 | Energy | Float (0,1) | Energy is a measure from 0.0 to 1.0 and represents a perceptual measure of intensity and activity. |
 | Instrumentalness | Float (0,1) | The closer the instrumentalness value is to 1.0, the greater likelihood the track contains no vocal content. Values above 0.5 are intended to represent instrumental tracks, but confidence is higher as the value approaches 1.0. |
 | Liveness | Float (0,1) | Detects the presence of an audience in the recording. Higher liveness values represent an increased probability that the track was performed live. |
 | Loudness | Float (-60,0) | The overall loudness of a track in decibels (dB). |
 | Speechiness | Float (0,1) | Speechiness detects the presence of spoken words in a track. The more exclusively speech-like the recording (e.g. talk show, audio book, poetry), the closer to 1.0 the attribute value. |
 | Valence | Float(0,1) | A measure from 0.0 to 1.0 describing the musical positiveness conveyed by a track. Tracks with high valence sound more positive (e.g. happy, cheerful, euphoric), while tracks with low valence sound more negative (e.g. sad, depressed, angry). |
 | Tempo | Float (~20, ~300) | The overall estimated tempo of a track in beats per minute (BPM).|
 | Duration_ms | Integer | The track length in milliseconds |
 | Explicit | Boolean | Whether or not the track has explicit lyrics |
 | Popularity | Integer (0,100) | The popularity of a track is a value between 0 and 100, with 100 being the most popular. The popularity is calculated by algorithm and is based, in the most part, on the total number of plays the track has had and how recent those plays are. |


 ## Stakeholder: Rolling Stones
 The stakeholder identified is the Rolling Stones magazine working on a fictitious special edition for "100 Years of Music".
 Our aim is to identify the major shifts in music during the last 100 years and have a global and complex picture of music from 1920 to today.
 Some questions:
 - What are the features that changed the most in music?
 - What are some evergreen features in music?
 - Which are the most popular artists today and in history?

 ## Analysis (See R scripts in Sources folder)
 Mainly three type of analysis have been performed:
  - Univariate analysis to investigate distribution for each variable during the years
  - Multivariate analysis to investigate correlations between variables and wether music can be described with few principal components
  - Trend analysis, to understand how the music has changed and collect some curious and interesting insigths on the most popular songs and artists in history

  ### 0) Dataset Cleaning
  The dataset has been cleaned removing tracks based on duration since the dataset had some hundreds tracks consisting in "White Noise for 90 minutes" and similar.
  See '0_dataset_cleaning.r' for more information on methods and criterions.

  ### 1) Univariate analysis
  Five "Music Eras" have been defined and tracks have been grouped in those eras by the release date.

  | Range of Years | Label |
  | -------------- | ----- |
  | 1920 - 1949 | 20s to 40s |
  | 1950 - 1979 | 50s to 70s | 
  | 1980 - 1999 | 80s to 90s | 
  | 2000 - 2009 | early 2000s|
  | 2010 - 2020 | nowadays |

  For each era and for each numerical variable we plotted boxplots and computed skewness and kurtosis indexes in order to estimate the shift and the type of distribution through the years.
  See the results both 1_univariate_analysis.r, plots and data

  ### 2) Multivariate analysis
  Correlation matrix has been computed on the dataset with various results. Some variables seem correlated while others are not.
  Because of poor correlations the Principal Component Analysis explains only ~60% of variability with the first 3 components.
  // To do

  ### 3) Trend analysis
  To perform the trend analysis we have increased the granularity of univariate analysis and plotted the mean value of each variable through the years, revealing some nice trends both in the early days of music (1920-1950) and in the last 40 years of music (See the plot in plots/trend).

  Then we tried to find the most popular artists and songs using two different approaches: order artists by the mean popularity of their songs and the summed popularity of their whole discography. This brought two completly opposite results: the first approach identified artists with few very famous tracks (e.g. viral songs, also thanks to social media phenomena) while the second identified artists from further back in time with very long careers and still loved today such as The Beatles, The Led Zeppelin. (Data have been extracted in data folder, or run 3_trend_analysis.r script)
 
