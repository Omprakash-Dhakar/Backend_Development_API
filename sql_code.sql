# SQL Query for creating Tables and Triggers

# Query for creating 'messages' table
CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    text TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL
);

# Query for creating 'likes' table
CREATE TABLE likes (
    id SERIAL PRIMARY KEY,
    message_id INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL,
    FOREIGN KEY (message_id) REFERENCES messages (id)
);

# Query for making a trigger function
CREATE OR REPLACE FUNCTION update_likes_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE messages SET likes_count = (SELECT COUNT(*) FROM likes WHERE message_id = NEW.message_id) WHERE id = NEW.message_id;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

# Calling trigger function when their is a like
CREATE TRIGGER update_likes_count_on_like
AFTER INSERT ON likes
FOR EACH ROW
EXECUTE FUNCTION update_likes_count();

# calling trigger function for unlike
CREATE TRIGGER update_likes_count_on_unlike
AFTER DELETE ON likes
FOR EACH ROW
EXECUTE FUNCTION update_likes_count();
