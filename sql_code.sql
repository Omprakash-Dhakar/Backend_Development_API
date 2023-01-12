--SQL Query for creating Tables and Triggers

--Query for creating 'messages' table
CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    text TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL
);

--Query for creating 'likes' table
CREATE TABLE likes (
    id SERIAL PRIMARY KEY,
    message_id INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL,
    FOREIGN KEY (message_id) REFERENCES messages (id)
);

--Query for making a trigger function
-- Create a trigger function to increment the likes_count when a like is inserted
CREATE OR REPLACE FUNCTION increment_likes_count() RETURNS TRIGGER AS $$
BEGIN
    UPDATE messages SET likes_count = likes_count + 1 WHERE id = NEW.message_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger to call the increment_likes_count function after a like is inserted
CREATE TRIGGER increment_likes_count_trigger
AFTER INSERT ON likes
FOR EACH ROW
EXECUTE FUNCTION increment_likes_count();

-- Create a trigger function to decrement the likes_count when a like is deleted
CREATE OR REPLACE FUNCTION decrement_likes_count() RETURNS TRIGGER AS $$
BEGIN
    UPDATE messages SET likes_count = likes_count - 1 WHERE id = OLD.message_id;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger to call the decrement_likes_count function after a like is deleted
CREATE TRIGGER decrement_likes_count_trigger
AFTER DELETE ON likes
FOR EACH ROW
EXECUTE FUNCTION decrement_likes_count();

