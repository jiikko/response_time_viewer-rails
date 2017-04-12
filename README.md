# ResponseTimeViewer::Rails
* 集計したログ(json)を取り込んで指定したパスをグラフに描画する

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'response_time_viewer-rails'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install response_time_viewer-rails
```

## Development
### start server
```
cd spec/dummy
bundle exec rake db:create && bundle exec rake db:migrate
bundle exec rails server
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## TODO
* index の見直し
* モデルバリデーション
  * pathユニーク
  * pathの存在チェック
* 毎時間ログをチェックする場合、取り込み済みのログファイルをskipする
