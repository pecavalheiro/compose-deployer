FROM ruby:2.3

RUN gem install rails

RUN rm -rf service1 && \
    git clone https://github.com/pecavalheiro/rails-bootstrap service1

RUN cd service1 && \
    RAILS_ENV=production bundle install

EXPOSE 3000

ENV SECRET_KEY_BASE hk6j4h5gkhj9gjk0hgkj6h57g46j3hfhgfd2w4reqwezx4dfc5z6bvc5687bv897c9809m680k89l098pog09hghfc5x2df3s56f4ds512gds23df4aaeuy98werfdg3
ENV DOMAIN_NAME http://localhost/service1/

CMD cd service1 && \
    git reset --hard && \
    git clean -df && \
    git checkout master && \
    git pull && \
    git checkout ${branch} && \
    git pull && \
    RAILS_ENV=${RAILS_ENV} bundle install && \
    RAILS_ENV=${RAILS_ENV} rake db:create && \
    RAILS_ENV=${RAILS_ENV} rake db:migrate && \
    RAILS_ENV=${RAILS_ENV} rake assets:precompile && \
    rm -f tmp/pids/server.pid && \
    RAILS_ENV=${RAILS_ENV} rails s
