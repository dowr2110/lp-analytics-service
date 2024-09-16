FROM ruby:3.0.0

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libffi-dev \
  curl

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem install bson_ext

RUN gem install bundler && bundle config set force_ruby_platform true && bundle install

COPY . .

EXPOSE 3001

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3001"]