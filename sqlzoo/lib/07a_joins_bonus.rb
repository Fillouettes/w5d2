# == Schema Information
#
# Table name: albums
#
#  asin        :string       not null, primary key
#  title       :string
#  artist      :string
#  price       :float
#  rdate       :date
#  label       :string
#  rank        :integer
#
# Table name: styles
#
# album        :string       not null
# style        :string       not null
#
# Table name: tracks
# album        :string       not null
# disk         :integer      not null
# posn         :integer      not null
# song         :string

require_relative './sqlzoo.rb'

def alison_artist
  # Select the name of the artist who recorded the song 'Alison'.
  execute(<<-SQL)
    SELECT
      artist
    FROM
      albums
    JOIN
      tracks ON tracks.album = albums.asin
    WHERE
      tracks.song = 'Alison'
  SQL
end

def exodus_artist
  # Select the name of the artist who recorded the song 'Exodus'.
  execute(<<-SQL)
      SELECT
      artist
    FROM
      albums
    JOIN
      tracks ON tracks.album = albums.asin
    WHERE
      tracks.song = 'Exodus'
  SQL
end

def blur_songs
  # Select the `song` for each `track` on the album `Blur`.
  execute(<<-SQL)
    SELECT
      song
    FROM
      tracks
    JOIN
      albums ON tracks.album = albums.asin
    WHERE
      albums.title = 'Blur'
  SQL
end

def heart_tracks
  # For each album show the title and the total number of tracks containing
  # the word 'Heart' (albums with no such tracks need not be shown). Order first by
  # the number of such tracks, then by album title.
  execute(<<-SQL)
    SELECT
      title, COUNT(DISTINCT song) AS num
    FROM
      albums
    JOIN
      tracks ON tracks.album = albums.asin
    WHERE
      tracks.song LIKE '%Heart%'
    GROUP BY
      title
    HAVING
      COUNT(song) > 0
    ORDER BY
      num DESC, title ASC
    SQL
end

def title_tracks
  execute(<<-SQL)
    SELECT
      DISTINCT song
    FROM
      tracks
    JOIN
      albums on albums.title = tracks.song
  SQL
end

def eponymous_albums
  # An 'eponymous album' has a `title` that is the same as its recording
  # artist's name. Select the titles of all the eponymous albums.
  execute(<<-SQL)
    SELECT
      DISTINCT title
    FROM
      albums
    WHERE title = artist
  SQL
end

def song_title_counts
  # Select the song names that appear on more than two albums. Also select the
  # COUNT of times they show up.
  execute(<<-SQL)
    SELECT
      song, COUNT(DISTINCT album)
    FROM
      tracks
    JOIN
      albums on albums.asin = tracks.album
    GROUP BY
      song
    HAVING
      COUNT(DISTINCT album) > 2
  SQL
end

def best_value
  # A "good value" album is one where the price per track is less than 50
  # pence. Find the good value albums - show the title, the price and the number
  # of tracks.
  execute(<<-SQL)
    SELECT
      albums.title, albums.price, COUNT(song)
    FROM
      albums
    JOIN
      tracks ON tracks.album = albums.asin
    GROUP BY
      albums.asin
    HAVING
      albums.price / COUNT(song) < 0.5
  SQL
end

def top_track_counts
  # Wagner's Ring cycle has an imposing 173 tracks, Bing Crosby clocks up 101
  # tracks. List the top 10 albums. Select both the album title and the track
  # count, and order by both track count and title (descending).
  execute(<<-SQL)
    SELECT
      albums.title, COUNT(tracks.song)
    FROM
      albums
    JOIN
      tracks ON albums.asin = tracks.album
    GROUP BY
      albums.asin
    ORDER BY
      COUNT(tracks.song) DESC, albums.title DESC
    LIMIT
      10
  SQL
end

def rock_superstars
  # Select the artist who has recorded the most rock albums, as well as the
  # number of albums. HINT: use LIKE '%Rock%' in your query.
  execute(<<-SQL)
      SELECT
        artist, COUNT(DISTINCT asin)
      FROM
        albums
      JOIN
        styles ON asin = album
      WHERE
        styles.style LIKE '%Rock%'
      GROUP BY
        artist
      ORDER BY
        COUNT(*) DESC
      LIMIT
        1
      
  SQL
end

def expensive_tastes
  # Select the five styles of music with the highest average price per track,
  # along with the price per track. One or more of each aggregate functions,
  # subqueries, and joins will be required.
  #
  # HINT: Start by getting the number of tracks per album. You can do this in a
  # subquery. Next, JOIN the styles table to this result and use aggregates to
  # determine the average price per track.
  execute(<<-SQL)
    SELECT
      styles.style, (SUM(prices.price) / SUM(prices.track_count)) AS avg_price
    FROM
      styles
    JOIN
      (SELECT
        albums.*, COUNT(*) AS track_count
      FROM
        tracks
      LEFT OUTER JOIN
        albums ON albums.asin = tracks.album
      WHERE
        albums.price IS NOT NULL
      GROUP BY
        albums.asin) AS prices ON prices.asin = styles.album
    GROUP BY
      style
    ORDER BY
      avg_price DESC, styles.style ASC
    LIMIT
      5
  SQL
end


#subquery: return price of each track
# SELECT
#   styles.style, AVG(track_price) AS avg_price
# FROM
#   styles
# JOIN
#   (SELECT
#     albums.asin, albums.price / COUNT(tracks.song) AS track_price
#   FROM
#     tracks
#   JOIN
#     albums on albums.asin = tracks.album
#   WHERE
#     albums.price IS NOT NULL
#   GROUP BY
#     albums.asin) ON albums.asin = styles.album
# GROUP BY
#   style
# ORDER BY
#   avg_price DESC
# LIMIT
#   5



# == Schema Information
#
# Table name: albums
#
#  asin        :string       not null, primary key
#  title       :string
#  artist      :string
#  price       :float
#  rdate       :date
#  label       :string
#  rank        :integer
#
# Table name: styles
#
# album        :string       not null
# style        :string       not null
#
# Table name: tracks
# album        :string       not null
# disk         :integer      not null
# posn         :integer      not null
# song         :string