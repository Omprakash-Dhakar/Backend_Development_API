# SQL Query for creating Tables and Triggers

CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    text TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE likes (
    id SERIAL PRIMARY KEY,
    message_id INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL,
    FOREIGN KEY (message_id) REFERENCES messages (id)
);

CREATE OR REPLACE FUNCTION update_likes_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE messages SET likes_count = (SELECT COUNT(*) FROM likes WHERE message_id = NEW.message_id) WHERE id = NEW.message_id;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_likes_count_on_like
AFTER INSERT ON likes
FOR EACH ROW
EXECUTE FUNCTION update_likes_count();

CREATE TRIGGER update_likes_count_on_unlike
AFTER DELETE ON likes
FOR EACH ROW
EXECUTE FUNCTION update_likes_count();
