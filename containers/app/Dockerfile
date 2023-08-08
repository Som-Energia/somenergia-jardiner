# ---------------------------------------------------------------------------- #
#                      example usage for docker and poetry                     #
# ---------------------------------------------------------------------------- #

# References:
# - https://inboard.bws.bio/docker#docker-and-poetry
# - https://github.com/br3ndonland/inboard/blob/0.45.0/Dockerfile
# - https://github.com/python-poetry/poetry/issues/1178
# - https://github.com/python-poetry/poetry/issues/1178#issuecomment-1238475183
#
# For more on users and groups:
# - https://www.debian.org/doc/debian-policy/ch-opersys.html#uid-and-gid-classes
# - https://stackoverflow.com/a/55757473/5819113
# - https://stackoverflow.com/questions/56844746/how-to-set-uid-and-gid-in-docker-compose
# - https://code.visualstudio.com/remote/advancedcontainers/add-nonroot-user#_creating-a-nonroot-user
# - https://nickjanetakis.com/blog/running-docker-containers-as-a-non-root-user-with-a-custom-uid-and-gid

# About renewing Arguments at multiple stages:
# - https://stackoverflow.com/a/53682110

# ---------------------------------------------------------------------------- #
#                            global build arguments                            #
# ---------------------------------------------------------------------------- #

# Global ARG, available to all stages (if renewed)
ARG WORKDIR="/app"

# global username
ARG USERNAME=somenergia
ARG USER_UID=1000
ARG USER_GID=1000

# tag used in all images
ARG PYTHON_VERSION=3.8.9

# general variables
ARG DBT_PROJECT_DIR=dbt_jardiner

# ---------------------------------------------------------------------------- #
#                                  build stage                                 #
# ---------------------------------------------------------------------------- #

FROM python:${PYTHON_VERSION}-slim AS builder

# Renew args
ARG WORKDIR
ARG USERNAME
ARG USER_UID
ARG USER_GID
ARG DBT_PROJECT_DIR

# Poetry version
ARG POETRY_VERSION=1.5.1

# Pipx version
ARG PIPX_VERSION=1.2.0

# prepare the $PATH
ENV PATH=/opt/pipx/bin:${WORKDIR}/.venv/bin:$PATH \
	PIPX_BIN_DIR=/opt/pipx/bin \
	PIPX_HOME=/opt/pipx/home \
	PIPX_VERSION=$PIPX_VERSION \
	POETRY_VERSION=$POETRY_VERSION \
	PYTHONPATH=${WORKDIR} \
	# Don't buffer `stdout`
	PYTHONUNBUFFERED=1 \
	# Don't create `.pyc` files:
	PYTHONDONTWRITEBYTECODE=1 \
	# make poetry create a .venv folder in the project
	POETRY_VIRTUALENVS_IN_PROJECT=true

# ------------------------------ add user ----------------------------- #

RUN groupadd --gid $USER_GID "$USERNAME" \
	&& useradd --uid $USER_UID --gid $USER_GID -m "$USERNAME"

# -------------------------- add python dependencies ------------------------- #

# Install Pipx using pip
RUN python -m pip install --no-cache-dir --upgrade pip pipx==${PIPX_VERSION}
RUN pipx ensurepath && pipx --version

# Install Poetry using pipx
RUN pipx install --force poetry==${POETRY_VERSION}

# ---------------------------- add code specifics ---------------------------- #

# Copy everything to the container, we filter out what we don't need using .dockerignore
WORKDIR ${WORKDIR}

# make sure the user owns /app
RUN chown -R ${USER_UID}:${USER_GID} ${WORKDIR}

# Copy only the files needed for installing dependencies
COPY --chown=${USER_UID}:${USER_GID} pyproject.toml poetry.lock ${WORKDIR}/

USER ${USERNAME}

RUN echo "step 1"
RUN pwd
RUN echo "I should be user somenergia, and I am user=$(whoami)"
RUN ls -lrs -a ${WORKDIR}

# ---------------------------------------------------------------------------- #
#                                 app-pre stage                                #
# ---------------------------------------------------------------------------- #

FROM builder AS app-pre

RUN echo "step 2"
RUN pwd
RUN ls -lrs -a ${WORKDIR}
RUN echo "I should be user somenergia, and I am user=$(whoami)"

# Install dependencies and creates a a virtualenv at /app/.venv
RUN poetry install --no-root --only main

RUN echo "step 3"
RUN pwd
RUN ls -lrs -a ${WORKDIR}
RUN echo "I should be user somenergia, and I am user=$(whoami)"

# ---------------------------------------------------------------------------- #
#                                   app stage                                  #
# ---------------------------------------------------------------------------- #

# We don't want to use alpine because porting from debian is challenging
# https://stackoverflow.com/a/67695490/5819113
FROM python:${PYTHON_VERSION}-slim AS app

# refresh global arguments
ARG WORKDIR
ARG USERNAME
ARG USER_UID
ARG USER_GID
ARG DBT_PROJECT_DIR


# refresh PATH
ENV PATH=/opt/pipx/bin:${WORKDIR}/.venv/bin:$PATH \
	POETRY_VERSION=$POETRY_VERSION \
	PYTHONPATH=${WORKDIR} \
	# Don't buffer `stdout`
	PYTHONUNBUFFERED=1 \
	# Don't create `.pyc` files:
	PYTHONDONTWRITEBYTECODE=1

# ------------------------------ user management ----------------------------- #

RUN groupadd --gid $USER_GID "$USERNAME" \
	&& useradd --uid $USER_UID --gid $USER_GID -m "$USERNAME"

# ------------------------------- app specific ------------------------------- #

WORKDIR ${WORKDIR}

RUN echo "step 5"
RUN pwd
RUN ls -lrs -a ${WORKDIR}
RUN echo "I should be user root, and I am user=$(whoami)"

COPY --from=app-pre ${WORKDIR} ${WORKDIR}

# Move profiles to .dbt
RUN mkdir -p "/home/$USERNAME/.dbt"

COPY ./${DBT_PROJECT_DIR}/config/profiles.yml /home/$USERNAME/.dbt/profiles.yml

# install deps
RUN mkdir -p ${WORKDIR}/${DBT_PROJECT_DIR}/
COPY ./${DBT_PROJECT_DIR}/dbt_project.yml ${WORKDIR}/${DBT_PROJECT_DIR}/
RUN dbt deps --project-dir ${WORKDIR}/${DBT_PROJECT_DIR}/ --profiles-dir /home/$USERNAME/.dbt

USER ${USERNAME}

RUN echo "step 6"
RUN pwd
RUN ls -lrs -a ${WORKDIR}
RUN echo "I should be user somenergia, and I am user=$(whoami)"

ENTRYPOINT [ "python" ]
CMD [ "--version" ]


# ---------------------------------------------------------------------------- #
#                                   dev stage                                  #
# ---------------------------------------------------------------------------- #

FROM app-pre AS dev

# refresh global arguments
ARG WORKDIR
ARG USERNAME
ARG USER_UID
ARG USER_GID
ARG DBT_PROJECT_DIR

RUN echo "step 7-dev"
RUN pwd
RUN ls -lrs -a ${WORKDIR}
RUN echo "I should be user somenergia, and I am user=$(whoami)"

USER root

RUN echo "step 8-dev"
RUN pwd
RUN ls -lrs -a ${WORKDIR}
RUN echo "I should be user root, and I am user=$(whoami)"

# Add USERNAME to sudoers. Omit if you don't need to install software after connecting.
RUN apt-get update \
	&& apt-get install -y sudo git iputils-ping \
	&& echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
	&& chmod 0440 /etc/sudoers.d/${USERNAME}

USER ${USERNAME}

RUN echo "step 9-dev"
RUN pwd
RUN ls -lrs -a ${WORKDIR}
RUN echo "I should be user somenergia, and I am user=$(whoami)"

# install all remaning dependencies
RUN poetry install --no-root

# Move profiles to .dbt
RUN mkdir -p "/home/${USERNAME}/.dbt"
COPY ./${DBT_PROJECT_DIR}/config/profiles.yml /home/${USERNAME}/.dbt/profiles.yml

# install dbt dependencies
RUN mkdir -p ${WORKDIR}/${DBT_PROJECT_DIR}/
COPY ./${DBT_PROJECT_DIR}/dbt_project.yml ${WORKDIR}/${DBT_PROJECT_DIR}/
RUN dbt deps --project-dir ${WORKDIR}/${DBT_PROJECT_DIR}/ --profiles-dir /home/${USERNAME}/.dbt

RUN echo "step 10-dev"
RUN pwd
RUN ls -lrs -a ${WORKDIR}
RUN echo "I should be user somenergia, and I am user=$(whoami)"

USER ${USERNAME}

# ---------------------------------------------------------------------------- #
#                                dbt-docs stage                                #
# ---------------------------------------------------------------------------- #

FROM builder AS dbt-docs-pre

# install dependencies
RUN poetry install --no-root --only dbt-docs

# We don't want to use alpine because porting from debian is challenging
# https://stackoverflow.com/a/67695490/5819113
FROM python:${PYTHON_VERSION}-slim AS dbt-docs

# refresh global arguments
ARG WORKDIR
ARG USERNAME
ARG USER_UID
ARG USER_GID
ARG DBT_PROJECT_DIR

# refresh PATH
ENV PATH=/opt/pipx/bin:${WORKDIR}/.venv/bin:$PATH \
	POETRY_VERSION=$POETRY_VERSION \
	PYTHONPATH=${WORKDIR} \
	# Don't buffer `stdout`
	PYTHONUNBUFFERED=1 \
	# Don't create `.pyc` files:
	PYTHONDONTWRITEBYTECODE=1

# ------------------------------ user management ----------------------------- #

RUN groupadd --gid $USER_GID "$USERNAME" \
	&& useradd --uid $USER_UID --gid $USER_GID -m "$USERNAME"

# ------------------------------- app specific ------------------------------- #


COPY --from=dbt-docs-pre --chown=${USER_UID}:${USER_GID} ${WORKDIR} ${WORKDIR}

# Run all commands as non-root user
WORKDIR ${WORKDIR}
USER ${USERNAME}

# Move profiles to .dbt
RUN mkdir -p "/home/$USERNAME/.dbt"

COPY ./${DBT_PROJECT_DIR}/config/profiles.yml /home/$USERNAME/.dbt/profiles.yml

# install deps
RUN mkdir -p ${WORKDIR}/${DBT_PROJECT_DIR}/
COPY ./${DBT_PROJECT_DIR}/dbt_project.yml ${WORKDIR}/${DBT_PROJECT_DIR}/
RUN dbt deps --project-dir ${WORKDIR}/${DBT_PROJECT_DIR}/ --profiles-dir /home/$USERNAME/.dbt

EXPOSE 80
