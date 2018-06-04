FROM ubuntu:14.04

# ==============================================================================
# Setting up base ubuntu environment
# ==============================================================================

# Ignore APT warnings about not having a TTY
ENV DEBIAN_FRONTEND noninteractive

# Ensure UTF-8 locale
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8
RUN dpkg-reconfigure locales

# Install build dependencies
RUN apt-get update -qq && \
    apt-get install -y -qq \
      build-essential \
      ca-certificates \
      curl \
      libcurl4-openssl-dev \
      libffi-dev \
      libgdbm-dev \
      libpq-dev \
      libreadline6-dev \
      libssl-dev \
      libtool \
      libxml2-dev \
      libxslt-dev \
      libyaml-dev \
      postgresql-client \
      software-properties-common \
      wget \
      git \
      libsqlite3-dev \
      sqlite3 \
      zlib1g-dev \
      libpq-dev \
      imagemagick \
      libmagickwand-dev \
      ghostscript \
      npm \
      xvfb \
      libgtk2.0-0 \
      libnotify-bin \
      libgconf-2-4 \
      libnss3 \
      libxss1

## Brightbox Ruby 1.9.3, 2.0 and 2.1
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C3173AA6
RUN echo deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu trusty main > /etc/apt/sources.list.d/brightbox.list

## Install latest node
RUN curl -sL https://deb.nodesource.com/setup_9.x | bash -
RUN apt-get install -y nodejs

# Yarn repository
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

# Postgres Repository
RUN curl -sS https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
RUN add-apt-repository 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main'

RUN apt-get update && apt-get install -y ruby2.5 ruby2.5-dev nodejs yarn postgresql-client-10

# Install bundler and foreman
RUN gem2.5 install rake bundler --no-rdoc --no-ri
RUN gem2.5 install rake foreman --no-rdoc --no-ri

# Add options to gemrc
RUN echo "gem: --no-ri --no-rdoc" > /etc/gemrc

# Creating app user
RUN mkdir /home/app
RUN groupadd -r app -g 433 && \
useradd -u 431 -r -g app -d /home/app -s /sbin/nologin -c "Docker image user" app && \
chown -R app:app /home/app

RUN  echo "    IdentityFile ~/.ssh/id_rsa" >> /etc/ssh/ssh_config

WORKDIR /home/app
ADD Gemfile /home/app/
ADD Gemfile.lock /home/app/
RUN chown -R app:app /home/app
ADD deploy_key_rsa /home/app/.ssh/id_rsa
ADD known_hosts /home/app/.ssh/known_hosts

RUN chmod 600 /home/app/.ssh/*
RUN chown -R app:app /home/app
RUN chown -R app:app /home/app/.ssh

USER app
ENV HOME /home/app

RUN bundle config frozen 1
RUN bundle install --deployment

USER root
ADD . /home/app
RUN chown -R app:app /home/app

USER app
RUN yarn install
RUN NO_DB=1 RAILS_ENV=production RAILS_RELATIVE_URL_ROOT=/connect SECRET_KEY_BASE=secret bundle exec rake assets:precompile

USER root
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN chmod a+x docker-start.sh

USER app
CMD ["/home/app/docker-start.sh"]

EXPOSE 3000
