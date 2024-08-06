#!/bin/bash
set -e

# データベースが起動するまで待つ
until mysqladmin ping -h db --silent; do
  echo 'waiting for db to be connectable...'
  sleep 2
done

# データベースの作成とマイグレーションの実行
bundle exec rails db:create db:migrate

# 引数で渡されたコマンドを実行
exec "$@"