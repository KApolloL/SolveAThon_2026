FROM rocker/shiny:4.4.2
RUN R -q -e 'install.packages(c("data.table","DT"), repos="https://cloud.r-project.org")' \
 && R -q -e 'stopifnot(all(c("data.table","DT","shiny") %in% rownames(installed.packages())))'
COPY app.R entrypoint.sh /srv/app/
COPY data /srv/app/data
COPY www /srv/app/www
RUN chmod +x /srv/app/entrypoint.sh
WORKDIR /srv/app
ENV MODE=app
EXPOSE 3838
ENTRYPOINT ["/srv/app/entrypoint.sh"]
