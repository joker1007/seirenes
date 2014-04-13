FROM ubuntu:13.10

MAINTAINER joker1007 "kakyoin.hierophant@gmail.com"

RUN apt-get -y update
RUN apt-get -y install build-essential libreadline-dev libssl-dev zlib1g-dev git-core curl libyaml-dev libxml2-dev libxslt1-dev autoconf libncurses5-dev
RUN apt-get -y install libmysqlclient-dev mysql-client

# Install ruby-build
RUN git clone https://github.com/sstephenson/ruby-build.git
RUN ruby-build/install.sh

# Install ruby
RUN ruby-build 2.1.1 /usr/local

# Install bundler
RUN gem update --system
RUN gem install bundler --no-document

# Create app user
RUN useradd -m seirenes

# Create app dir
RUN mkdir /rails_app
ADD ./Gemfile /rails_app/Gemfile
ADD ./Gemfile.lock /rails_app/Gemfile.lock
RUN chown seirenes -R /rails_app
USER seirenes
WORKDIR /rails_app
RUN bundle install -j4 --path /rails_app/bundle --without development test --deployment --quiet

# Add application
ADD . /rails_app/seirenes
ADD ./docker/database.yml /rails_app/seirenes/config/database.yml
USER root
RUN chown seirenes -R /rails_app/seirenes
USER seirenes
WORKDIR /rails_app/seirenes

ENV RAILS_ENV production
RUN bundle install --path /rails_app/bundle --without development test --deployment --quiet
RUN cp config/settings.sample.yml config/settings.yml

EXPOSE 80
