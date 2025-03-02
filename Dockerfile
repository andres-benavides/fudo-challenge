FROM ruby:3.2
WORKDIR /app

RUN gem install bundler

COPY api/Gemfile api/Gemfile.lock ./

ENV BUNDLE_PATH=/usr/local/bundle
ENV BUNDLE_BIN=/usr/local/bundle/bin
ENV PATH="${BUNDLE_BIN}:${PATH}"

RUN bundle install

COPY api/ .

CMD ["rackup", "--host", "0.0.0.0", "--port", "9292"]
