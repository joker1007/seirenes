FROM ubuntu:13.10

MAINTAINER joker1007 "kakyoin.hierophant@gmail.com"

RUN apt-get -y update
RUN apt-get -y install build-essential libreadline-dev libssl-dev zlib1g-dev git-core curl libyaml-dev libxml2-dev libxslt1-dev autoconf libncurses5-dev
RUN apt-get -y install libmysqlclient-dev mysql-client

# Install ruby-build
RUN git clone https://github.com/sstephenson/ruby-build.git
RUN ruby-build/install.sh

RUN ruby-build 2.1.1 /usr/local

RUN gem update --system
RUN gem install bundler --no-document

RUN useradd -m seirenes

WORKDIR /tmp
ADD ./Gemfile Gemfile
ADD ./Gemfile.lock Gemfile.lock
RUN bundle install -j4

ADD . /app

RUN chown seirenes -R /app
WORKDIR /app

ADD ./docker/database.yml /app/config/database.yml
RUN cp config/settings.sample.yml config/settings.yml
