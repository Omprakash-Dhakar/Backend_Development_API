FROM python:3.9-alpine

# Set the working directory
WORKDIR /app

ENV DATABASE_URL = postgresql://postgres:postgrespassword@postgres:5432/postgres

# Copy the requirements.txt file
COPY requirements.txt .

# Install the dependencies
RUN pip install -r requirements.txt

# Copy the rest of the app files
COPY . .

# Expose the port for the app
EXPOSE 5000

# Run the command to start the app
CMD ["python", "app.py"]
