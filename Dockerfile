FROM python:3.9-alpine3.13
LABEL maintainer="marvinsilva"

ENV PYTHONUNBUFFERED 1
WORKDIR /app
EXPOSE 8000

RUN adduser \
    --disabled-password \
    --no-create-home \
    django-user && \
    chown django-user ./

COPY --chown=django-user ./requirements.txt /tmp/requirements.txt
COPY --chown=django-user ./requirements.dev.txt /tmp/requirements.dev.txt

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp

COPY --chown=django-user ./app /app
ENV PATH="/py/bin:$PATH"
USER django-user