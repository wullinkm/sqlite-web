# Use the official Python image from the Docker Hub
FROM python:3.12-slim

# Set the working directory in the container
WORKDIR /app

# Install required system packages, including SQLite
RUN apt-get update && apt-get install -y \
    sqlite3 \
    libsqlite3-dev \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Install pipenv
RUN pip install --no-cache-dir pipenv

# Copy the Pipfile and Pipfile.lock into the container
COPY Pipfile Pipfile.lock /app/

# Install the dependencies
RUN pipenv install --deploy --system

# Copy the rest of the application code into the container
COPY ./sqlite_web .

# Expose port 8080 for the application
EXPOSE 8080

CMD ["python", "sqlite_web.py", "-H", "0.0.0.0", "-x", "$SQLITE_DATABASE"]
