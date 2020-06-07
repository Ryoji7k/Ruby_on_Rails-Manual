## DEPLOY

#### Before Set Up

```
[Gemfile]
gem 'dotenv-rails'
group :production do
  gem 'mysql2'
end

$ bundle install
```

```
[.env]
DB_USERNAME="RDSの接続ユーザ名"
DB_PASSWORD="RDSのパスワード"
DB_HOST="RDSのエンドポイント名"
DB_DATABASE="MySQLのデータベース名"
```

```
[config/database.yml]
production:
  <<: *default
  database: <%= ENV['DB_DATABASE'] %>
  adapter: mysql2
  encoding: utf8mb4
  charset: utf8mb4
  collation: utf8mb4_general_ci
  host: <%= ENV['DB_HOST'] %>
  username: <%= ENV['DB_USERNAME'] %>
  password: <%= ENV['DB_PASSWORD'] %>
```

```
[config/puma.rb]
bind "unix://#{Rails.root}/tmp/sockets/puma.sock"
rails_root = Dir.pwd
# 本番環境のみデーモン起動
if Rails.env.production?
    pidfile File.join(rails_root, 'tmp', 'pids', 'puma.pid')
    state_path File.join(rails_root, 'tmp', 'pids', 'puma.state')
    stdout_redirect(
      File.join(rails_root, 'log', 'puma.log'),
      File.join(rails_root, 'log', 'puma-error.log'),
      true
    )
    # デーモン
    daemonize
end
```

```
[config/environments/production.rb]
※ ドメインの場合
config.action_cable.allowed_request_origins = [ 'http://hoge.com/', /http:\/\/hoge.*/ ]
※ EIPの場合
config.action_cable.allowed_request_origins = [ 'http://xx.xx.xx.xx/' ]
```

#### Nginx Set Up

```
$ sudo yum install -y nginx
$ sudo chkconfig nginx on
$ sudo service nginx start
$ sudo service nginx stop
$ sudo service nginx start

$ sudo sh -c  "echo 'Hello World' > /usr/share/nginx/html/index.html"
```

#### Mysql Set Up

```
$ sudo yum -y install mysql

$ mysql -u root -ppassword -h endpoint
mysql> create database dbname;
```

#### ImageMagick Set Up

```
$ sudo yum -y install libpng-devel libjpeg-devel libtiff-devel gcc
$ wget http://www.imagemagick.org/download/ImageMagick.tar.gz
$ tar -vxf ImageMagick.tar.gz
$ cd ImageMagick-7.0.10-10/
$ ./configure
$ make
$ sudo make install
```

#### Ruby(rbenv) Set Up

```
$ sudo yum remove -y ruby*
$ sudo yum -y install gcc-c++ git openssl-devel readline-devel
$ git clone https://github.com/rbenv/rbenv.git ~/.rbenv
$ git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
$ sudo ~/.rbenv/plugins/ruby-build/install.sh
$ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
$ echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
$ source ~/.bash_profile
$ rbenv install 2.5.7
$ rbenv global 2.5.7
$ rbenv rehash
$ rbenv exec gem install bundler
$ ruby -v
$ bundle -v
```

#### Rails Set Up

```
$ sudo yum -y install patch libyaml-devel zlib zlib-devel libffi-devel make autoconf automake libcurl-devel sqlite-devel mysql-devel
$ curl --silent --location https://rpm.nodesource.com/setup_12.x | sudo bash -
$ sudo yum install -y nodejs
$ gem install rails -v 5.2.3
$ rails -v
```

#### Application Deploy

```
$ git clone url

~~~ master.key .env set up ~~~
$ scp -i ~/.ssh/xxx.pem master.key ec2-user@xxx/config
$ scp -i ~/.ssh/xxx.pem .env ec2-user@xxx/

~~~ App set up ~~~~
$ cd app
$ bundle install --path vendor/bundle --without test development
$ bundle exec rails assets:precompile RAILS_ENV=production
$ sudo npm install yarn -g
$ bundle exec rails assets:precompile RAILS_ENV=production
$ bundle exec rails db:migrate RAILS_ENV=production

~~~ nginx.conf set up ~~~

$ sudo chown -R ec2-user /var/lib/nginx
$ sudo service nginx restart
$ rails s -e production
```
