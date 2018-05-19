FROM ruby:2.5.1-alpine

# Fetch/install gems
RUN mkdir -p /opt/gems
COPY Gemfile Gemfile.lock /opt/gems/
WORKDIR /opt/gems
RUN bundle install --deployment

ENV APP_DIR=/usr/src/app

COPY . $APP_DIR
RUN mkdir -p $APP_DIR/vendor && ln -s /opt/gems/vendor/bundle $APP_DIR/vendor/bundle
RUN mkdir -p $APP_DIR/bin/buildkite && touch $APP_DIR/bin/buildkite/buildkite-agent && chmod +x $APP_DIR/bin/buildkite/buildkite-agent
ENV PATH="$APP_DIR/bin/buildkite:${PATH}"

VOLUME $APP_DIR/bin/buildkite

WORKDIR $APP_DIR
CMD ["./bin/run"]
