FROM ruby:2.6.4-alpine3.9

RUN apk add build-base postgresql-contrib postgresql-dev bash tzdata wkhtmltopdf

WORKDIR /app
ENV HOME /app

ARG UID='1001'

RUN addgroup -S appgroup && \
  adduser -u ${UID} -S appuser -G appgroup

COPY --chown=appuser:appgroup Gemfile Gemfile.lock .ruby-version ./

RUN gem install bundler

ARG BUNDLE_ARGS='--without test development'
RUN bundle install --no-cache ${BUNDLE_ARGS}

COPY --chown=appuser:appgroup . .

ARG RAILS_ENV='production'
ENV RAILS_ENV=$RAILS_ENV

ENV APP_PORT 3000
EXPOSE $APP_PORT

CMD bundle exec bundle exec rails s -p ${APP_PORT} --binding=0.0.0.0
