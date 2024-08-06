# ベースイメージを指定
FROM ruby:3.1.6

# Node.jsとYarnのインストール
RUN apt-get update -qq && apt-get install -y nodejs default-mysql-client

# 作業ディレクトリを設定
WORKDIR /app

# GemfileとGemfile.lockをコピー
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Bundlerをインストールし、gemをインストール
RUN bundle install

# アプリケーションコードをコピー
COPY . /app

# エントリーポイントを設定
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# サーバーを起動
CMD ["rails", "server", "-b", "0.0.0.0"]