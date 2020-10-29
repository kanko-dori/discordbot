FROM ruby:2.7.2

COPY Gemfile .
RUN bundle install
