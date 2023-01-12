from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:password@localhost:5432/media_app'
db = SQLAlchemy(app)


class Messages(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    text = db.Column(db.String, nullable=False)
    created_at = db.Column(db.DateTime, nullable=False)
    likes_count = db.Column(db.Integer, nullable=False, default=0)

class Likes(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    message_id = db.Column(db.Integer, db.ForeignKey('messages.id'), nullable=False)
    created_at = db.Column(db.DateTime, nullable=False)

# Route to post a new message
@app.route('/messages', methods=['POST'])
def create_message():
    text = request.json.get('text')
    message = Messages(text=text, created_at=datetime.utcnow())
    db.session.add(message)
    db.session.commit()
    return jsonify({'id': message.id, 'text': message.text, 'created_at': message.created_at})

# Route to view a list of all messages
@app.route('/messages', methods=['GET'])
def get_messages():
    messages = Messages.query.order_by(Messages.created_at.desc()).all()
    return jsonify([{'id': message.id, 'Message': message.text, 'created_at': message.created_at, 'likes_count': message.likes_count} for message in messages])

# Route to like a message
@app.route('/messages/<int:id>/like', methods=['POST'])
def like_message(id):
    message = Messages.query.get(id)
    if message:
        like = Likes(message_id=message.id, created_at=datetime.utcnow())        
        db.session.add(like)
        db.session.commit()
        return jsonify({'id': message.id, 'Message': message.text, 'created_at': message.created_at, 'likes_count': message.likes_count})
    else:
        return jsonify({'error': 'Message not found'}), 404

# Route to unlike a message
@app.route('/messages/<int:id>/unlike', methods=['POST'])
def unlike_message(id):
    message = Messages.query.get(id)
    if message:
        like = Likes.query.filter_by(message_id=message.id).first()                
        db.session.delete(like)
        db.session.commit()
        return jsonify({'id': message.id, 'text': message.text, 'created_at': message.created_at, 'likes_count': message.likes_count})
    else:
        return jsonify({'error': 'Message not found'}), 404

# Route to view the total number of likes for a message
@app.route("/messages/<int:message_id>/likes", methods=["GET"])
def get_likes_count(message_id):
    message = Messages.query.get(message_id)
    likes_count = Likes.query.filter_by(message_id=message_id).count()
    return jsonify({"likes": likes_count, 'Message':message.text})

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True)

