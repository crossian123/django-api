FROM python:3.7-slim-buster

# Install into Debian
RUN apt-get update \
    # && apt-get install -y sudo wget gnupg2 vim \
    # set Japanese
    && apt-get install fonts-ipafont-gothic fonts-ipafont-mincho

# Don't create '/__pycache__'
ENV PYTHONDONTWRITEBYTECODE=1

# copy project
WORKDIR /code
COPY ./code ./

# Install Python Libraries
RUN pip install --no-cache-dir -r requirements.txt


EXPOSE 8000
# can overwrite
CMD ["gunicorn", "-b", ":8000", "config.wsgi:application"]
