FROM ruby:3.3.11-slim-trixie

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get update && apt-get install -y \
  build-essential \
  libpq-dev \
  libxml2-dev \
  libxslt1-dev \
  git \
  curl \
  ca-certificates \
  tzdata \
  libjpeg62-turbo \
  libpng16-16 \
  libxrender1 \
  libfontconfig1 \
  libxext6 \
  libyaml-dev \
  zlib1g-dev \
  libffi-dev

WORKDIR /app
ENV HOME=/app

ARG UID=1001
RUN useradd -u ${UID} -m appuser
RUN chown appuser:appuser /app

COPY --chown=appuser:appuser Gemfile Gemfile.lock .ruby-version ./

ENV BUNDLER_VERSION=2.1.4
RUN gem install bundler

USER appuser

RUN bundle config set force_ruby_platform true
RUN bundle config set deployment true
RUN bundle config set --local frozen false

ARG BUNDLE_WITHOUT='test development'
RUN bundle config set without ${BUNDLE_WITHOUT}
RUN bundle install --no-cache --jobs 4 --retry 3

COPY --chown=appuser:appuser . .

ARG RAILS_ENV='production'
ENV RAILS_ENV=$RAILS_ENV

ENV APP_PORT=3000
EXPOSE $APP_PORT

CMD ["sh", "-c", "bundle exec rails s -p ${APP_PORT} --binding=0.0.0.0"]
