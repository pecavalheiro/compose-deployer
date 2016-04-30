FROM ruby:2.3

RUN gem install rails

RUN rm -rf service2 && \
    git clone https://github.com/pecavalheiro/rails-bootstrap service2

RUN cd service2 && \
    RAILS_ENV=production bundle install

EXPOSE 3000

ENV SECRET_KEY_BASE 98f9eyu979o8iop7i9874656897qw87zx6cz5dx1vsdf6g5rt6y8riyu7ou9opuiouioui98k4j65m4nbv3c52vb13dxf5g49wsed8fq7rw9e8r7fsa6df54z6d5gfdf
ENV DOMAIN_NAME http://localhost/service2/

CMD cd service2 && \
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
