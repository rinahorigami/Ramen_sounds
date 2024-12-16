# ベースイメージを指定
FROM ruby:3.1.6

# 必要なパッケージをインストール
RUN apt-get update -qq && apt-get install -y \
    curl \
    build-essential \
    default-mysql-client \
    wget \
    unzip

# Node.jsとnpmの公式リポジトリを追加してインストール
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# ChromeとChromedriverをインストール
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && dpkg -i google-chrome-stable_current_amd64.deb || apt-get -fy install \
    && wget -N https://chromedriver.storage.googleapis.com/$(curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip \
    && unzip chromedriver_linux64.zip -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/chromedriver \
    && rm -f google-chrome-stable_current_amd64.deb chromedriver_linux64.zip

# 作業ディレクトリを設定
WORKDIR /app

# GemfileとGemfile.lockをコピー
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Bundlerをインストールし、gemをインストール
RUN bundle install

# アプリケーションコードをコピー
COPY . /app

# npmのグローバルパッケージをインストール
RUN npm install -g yarn

# エントリーポイントを設定
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# サーバーを起動
CMD ["rails", "server", "-b", "0.0.0.0"]