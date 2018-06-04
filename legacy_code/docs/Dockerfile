FROM alpine:edge

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.19.1.1/s6-overlay-amd64.tar.gz /tmp
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

RUN apk add --update openssh \
  ruby \
  ruby-io-console \
  ruby-dev \
  ruby-json \
  ruby-bigdecimal \
  ruby-irb \
  yaml \
  nodejs \
  linux-headers \
  git \
  libc-dev \
  build-base \
  libffi-dev \
  postgresql-dev \
  libxml2-dev \
  yarn \
  && rm -rf /var/cache/apk/*

RUN gem install bundler --no-document

RUN mkdir /home/app
RUN addgroup -g 433 app && \
adduser -u 431 -G app -D -h /home/app -s /sbin/nologin -g "Docker image user" app && \
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

# Services
ADD start.sh /etc/services.d/web/run

USER app
ENV HOME /home/app

RUN bundle config frozen 1
RUN DISABLE_SSL=true bundle install --deployment

USER root
ADD start.sh /etc/services.d/web/run

ADD . /home/app
RUN chown -R app:app /home/app
RUN apk add --update tzdata

ENTRYPOINT ["/init"]
