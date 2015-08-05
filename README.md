# lita-teamplayer

**lita-teamplayer** is a handler for [Lita](https://github.com/jimmycuadra/lita) that provides an interface to the teamplayer music app

## Installation

Add lita-teamplayer to your Lita instance's Gemfile:

``` ruby
gem "lita-teamplayer"
```


## Configuration

This plugin requires a working teamplayer account & team_id

``` ruby
  config.handlers.teamplayer.team_id = 'TEAMPLAYER_TEAM_ID'
  }
```

## Usage

```
Lita: tp SONG_URL
--
Queued the song to the list


Lita: up song_id
Lita: down song_id

---
```

## License

[MIT](http://opensource.org/licenses/MIT)
