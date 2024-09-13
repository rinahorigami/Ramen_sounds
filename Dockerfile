# ベースイメージを指定
FROM ruby:3.1.6

# Node.jsとYarnのインストール
RUN apt-get update -qq && apt-get install -y nodejs default-mysql-client

# ChromeとChromedriverをインストール
RUN apt-get install -y wget unzip
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install
RUN wget -N https://chromedriver.storage.googleapis.com/$(curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip -d /usr/local/bin/
RUN chmod +x /usr/local/bin/chromedriver

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