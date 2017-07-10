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

#### サーバ起動

```
bundle exec rake db:create && bundle exec rake db:migrate
cd spec/dummy
bundle exec rails server
```
open http://localhost:3000/response_time_viewer !!!

#### 集計する

```
cd spec/dummy
be rails console
ResponseTimeViewer::Rails::SummarizedRequest::fetch_log_and_import
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
* テーブルのヘッダーにあるそれぞれのmsをクリックするとそのカラムで並び替えれるようにする
* パラメータが長いので省略しているページでオンマウスでフルのパラメータを表示する
* URLを新規作成する時に既存URLに存在するのかの確認できるようにする
* 正規表現とかでURLのグループを作ってレスポンスタイムでヒストグラム的なのを作る
* WatchingURLを削除したら多対多のレコードも削除する
