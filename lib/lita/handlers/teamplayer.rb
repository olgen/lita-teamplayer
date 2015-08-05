require 'faraday'

module Lita
  module Handlers
    class Teamplayer < Handler
      def self.default_config(config)
        config.team_url = nil
      end

      route %r(play\s(.+)),
        :add_song,
        command: true,
        help: {
          "play SONG_URL" => "Enqueue the song on the team playlist" }

      route %r(playlist),
        :playlist,
        command: true,
        help: {
          "playlist" => "The current list of songs being/to be played." }

      route %r(upvote\s([0-9]+)),
        :upvote,
        command: true,
        help: {
          "upvote SONG_ID" => "Upvote the song in the list. Needs a numeric song identifier" }

      route %r(downvote\s([0-9]+)),
        :downvote,
        command: true,
        help: {
          "downvote SONG_ID" => "Downvote the song in the list. Needs a numeric song identifier" }

      def add_song(response)
        song_input = response.matches[0][0]
        url = "#{team_url}/songs"
        result = post(url, url: song_input)
        response.reply "Enqueud song: #{format_song(result)}"
      end

      def playlist(response)
        song_input = response.matches[0][0]
        url = "#{team_url}/songs"
        current_list = get(url, url: song_input)
        response.reply "Current playlist: \n" + format_songs(current_list)
      end

      def upvote(response)
        song_id = response.matches[0][0]
        url = "#{team_url}/songs/#{song_id}/upvotes"
        current_list = post(url)
        response.reply "Upvoted #{song_id}!\n Current playlist: \n" + format_songs(current_list)
      end

      def downvote(response)
        song_id = response.matches[0][0]
        url = "#{team_url}/songs/#{song_id}/downvotes"
        current_list = post(url)
        response.reply "Downvoted #{song_id}!\n Current playlist: \n" + format_songs(current_list)
      end

      def team_url
        Lita.config.handlers.teamplayer.team_url
      end

      def format_songs(songs)
        songs.map do |song|
          format_song(song)
        end.join("\n")
      end

      def format_song(song)
        s = OpenStruct.new(song)
        "👍#{s.score} :musical_score:#{s.id} #{s.url}"
      end

      def post(url, data={})
        result = Faraday.post url, data
        json = result.body
        JSON.parse(json)
      end

      def get(url, data={})
        result = Faraday.get url, data
        json = result.body
        JSON.parse(json)
      end
    end

    Lita.register_handler(Teamplayer)
  end
end
