ARG WORKDIR="/app"

FROM harbor.somenergia.coop/dades/somenergia-jardiner-builder:latest as builder
ARG WORKDIR
RUN poetry export -f requirements.txt --output ${WORKDIR}/mkdocs-requirements.txt --without-hashes

FROM squidfunk/mkdocs-material:latest
ARG WORKDIR
COPY --from=builder ${WORKDIR}/mkdocs-requirements.txt .
RUN pip install --no-cache-dir -r mkdocs-requirements.txt