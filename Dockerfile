FROM julia

ENV JULIA_PROJECT /src/minilogging
WORKDIR $JULIA_PROJECT
# Allow Docker to cache all dependencies
COPY Project.toml Project.toml
# If ssh is needed
# RUN eval "$(ssh-agent)" && ssh-add && julia -e 'using Pkg; Pkg.instantiate(); Pkg.status()'
RUN julia -e 'using Pkg; Pkg.instantiate(); Pkg.status()'

COPY src src
COPY test test
CMD ["julia", "-e", "using Pkg; Pkg.test()"]
