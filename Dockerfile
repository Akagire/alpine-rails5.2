FROM alpine:latest

ENV WORKING_DIR /myapp

COPY Gemfile* /myapp/
WORKDIR /myapp

RUN apk add --update --no-cache \
  ruby \
  nodejs \
  yarn \
  mariadb-dev

RUN apk add --update --no-cache --virtual build-dependencies \
  build-base \
  libxml2-dev \
  libxslt-dev \
  ruby-dev \
  yaml-dev \
  zlib-dev \
  linux-headers \
  ca-certificates && \
  #gem files
  gem install bundler --no-doc && \
  bundle install -j4 && \
  apk del build-dependencies && \
  # clean up
  gem cleanup && \
  rm -rf /usr/lib/ruby/gems/*/cache/* \
  /var/cache/apk/* \
  /tmp/* \
  /var/tmp/* && \
  rm /usr/bin/mysql*

COPY . .
