import os
import mysql.connector
from mysql.connector import Error
from datetime import timedelta, datetime

from flask import Flask, request, jsonify, render_template, send_from_directory
from flask_bcrypt import Bcrypt
# OPTIONAL: uncomment if you run index.html from another origin (e.g., VS Code Live Server)
# from flask_cors import CORS

# ------------------ CONFIG ------------------
DB_CONFIG = {
    'host': 'localhost',
    'database': 'multimedia_project123',
    'user': 'root',
    'password': 'Rorkdsingh@1'  # TODO: do NOT commit real passwords to source control
}

# Path that contains your 'images', 'audio', 'video' subfolders
MEDIA_ROOT_PATH = r"C:\Users\91639\Desktop\dbms_phase2\media_files"

app = Flask(__name__, template_folder='.')
bcrypt = Bcrypt(app)

# OPTIONAL: enable only if UI is served from another origin/port
# CORS(app, resources={r"/api/*": {"origins": "*"}, r"/media/*": {"origins": "*"}})

# ------------- GLOBAL ERROR HANDLERS -------------
@app.errorhandler(404)
def not_found(e):
    if request.path.startswith('/api/'):
        return jsonify({"status": "error", "message": "API route not found"}), 404
    return e, 404

@app.errorhandler(Exception)
def handle_exception(e):
    if request.path.startswith('/api/'):
        msg = getattr(e, "msg", str(e))
        return jsonify({"status": "error", "message": msg}), 500
    return e, 500

# ------------------ HELPERS ------------------
def serialize_metadata(value):
    """Make MySQL TIME (timedelta) and other metadata JSON-serializable."""
    if isinstance(value, timedelta):
        total_seconds = int(value.total_seconds())
        h = total_seconds // 3600
        m = (total_seconds % 3600) // 60
        s = total_seconds % 60
        return f"{h:02d}:{m:02d}:{s:02d}"
    return "" if value is None else str(value)

def serialize_dt(value):
    """Serialize datetime/date to 'YYYY-MM-DD HH:MM:SS'."""
    try:
        if hasattr(value, "strftime"):
            return value.strftime("%Y-%m-%d %H:%M:%S")
    except Exception:
        pass
    return str(value)

# ------------------ DB UTILS ------------------
def get_db_connection():
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        conn.autocommit = True
        return conn
    except Error as e:
        print(f"Database connection failed: {e}")
        return None

def execute_search_query(conn, tags):
    tag_count = len(tags)
    placeholders = ', '.join(['%s'] * tag_count)
    sql = f"""
        SELECT MT.Media_ID, MT.Media_Type
        FROM Media_Tag MT
        JOIN Tag T ON MT.Tag_ID = T.Tag_ID
        WHERE T.Tag_Name IN ({placeholders})
        GROUP BY MT.Media_ID, MT.Media_Type
        HAVING COUNT(DISTINCT T.Tag_Name) = %s;
    """
    params = tuple(tags) + (tag_count,)
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute(sql, params)
        return cursor.fetchall()
    finally:
        cursor.close()

def get_average_rating(conn, media_id, media_type):
    cursor = conn.cursor()
    query = "SELECT AVG(Rating_Value) FROM Media_Rating WHERE Media_ID = %s AND Media_Type = %s"
    try:
        cursor.execute(query, (media_id, media_type))
        result = cursor.fetchone()
        if result and result[0] is not None:
            return float(f"{result[0]:.1f}")
        return 0.0
    except Error:
        return 0.0
    finally:
        cursor.close()

def log_view_history(conn, user_id, media_id, media_type):
    if user_id is None:
        return
    cursor = conn.cursor()
    query = "INSERT INTO View_History (User_ID, Media_ID, Media_Type) VALUES (%s, %s, %s)"
    try:
        cursor.execute(query, (user_id, media_id, media_type))
    except Error as e:
        print(f"[ERROR] Failed to log view history: {e}")
    finally:
        cursor.close()

def submit_rating(conn, user_id, media_id, media_type, rating_value):
    cursor = conn.cursor()
    query = """
        INSERT INTO Media_Rating (User_ID, Media_ID, Media_Type, Rating_Value)
        VALUES (%s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE Rating_Value = VALUES(Rating_Value)
    """
    try:
        cursor.execute(query, (user_id, media_id, media_type, rating_value))
        return True
    except Error as e:
        print(f"[ERROR] Failed to submit rating: {e}")
        return False
    finally:
        cursor.close()

# ------------------ ROUTES ------------------
@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/health')
def health():
    return jsonify({"status": "ok"})

# ---- Auth ----
@app.route('/api/register', methods=['POST'])
def api_register():
    if not request.is_json:
        return jsonify({"status": "error", "message": "Expected application/json"}), 400

    data = request.json or {}
    username = data.get('username')
    email = data.get('email')
    password = data.get('password')

    if not all([username, email, password]):
        return jsonify({"status": "error", "message": "Missing fields"}), 400

    conn = get_db_connection()
    if conn is None:
        return jsonify({"status": "error", "message": "Database error"}), 500

    cursor = conn.cursor()
    password_hash = bcrypt.generate_password_hash(password).decode('utf-8')
    query = "INSERT INTO `User` (Username, Email, Password_Hash) VALUES (%s, %s, %s)"
    try:
        cursor.execute(query, (username, email, password_hash))
        return jsonify({"status": "success", "message": "User registered successfully. Please log in."})
    except Error as e:
        if getattr(e, "errno", None) == 1062:
            return jsonify({"status": "error", "message": "Username or Email already taken."}), 409
        return jsonify({"status": "error", "message": f"Database insertion failed: {getattr(e, 'msg', str(e))}"}), 500
    finally:
        conn.close()

@app.route('/api/login', methods=['POST'])
def api_login():
    if not request.is_json:
        return jsonify({"status": "error", "message": "Expected application/json"}), 400

    data = request.json or {}
    username = data.get('username')
    password = data.get('password')

    conn = get_db_connection()
    if conn is None:
        return jsonify({"status": "error", "message": "Database error"}), 500

    cursor = conn.cursor(dictionary=True)
    query = "SELECT User_ID, Password_Hash FROM `User` WHERE Username = %s"
    try:
        cursor.execute(query, (username,))
        user_record = cursor.fetchone()
        if user_record and bcrypt.check_password_hash(user_record['Password_Hash'], password):
            return jsonify({"status": "success", "user_id": user_record['User_ID'], "username": username})
        return jsonify({"status": "error", "message": "Invalid credentials"}), 401
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500
    finally:
        conn.close()

# ---- Search ----
@app.route('/api/search', methods=['POST'])
def api_search():
    if not request.is_json:
        return jsonify({"results": [], "status": "error", "message": "Expected application/json"}), 400

    data = request.json or {}
    tags = [t.strip() for t in data.get('tags', []) if isinstance(t, str) and t.strip()]
    user_id = data.get('user_id')

    if not tags:
        return jsonify({"results": []})

    conn = get_db_connection()
    if conn is None:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500

    media_refs = execute_search_query(conn, tags)
    final_results = []

    TABLES = {
        'Image': {'table': 'Image', 'id_col': 'Image_ID', 'meta_col': 'Resolution'},
        'Audio': {'table': 'Audio', 'id_col': 'Audio_ID', 'meta_col': 'Duration'},
        'Video': {'table': 'Video', 'id_col': 'Video_ID', 'meta_col': 'Duration'},
    }

    cursor = conn.cursor(dictionary=True)
    try:
        for row in media_refs:
            media_id = row['Media_ID']
            media_type = row['Media_Type']

            spec = TABLES.get(media_type)
            if not spec:
                continue

            table = f"`{spec['table']}`"
            id_col = f"`{spec['id_col']}`"
            meta_col = f"`{spec['meta_col']}`"

            select_cols = f"{id_col} AS Media_ID, Title, File_Path, {meta_col} AS Metadata"
            sql = f"SELECT {select_cols} FROM {table} WHERE {id_col} = %s"

            try:
                cursor.execute(sql, (media_id,))
                result = cursor.fetchone()
                if result:
                    # Log history (no-op if user_id is None)
                    log_view_history(conn, user_id, media_id, media_type)

                    file_path = (result['File_Path'] or "").replace("\\", "/")
                    relative_url = f"/media/{file_path}"

                    final_results.append({
                        "media_id": result['Media_ID'],
                        "title": result['Title'],
                        "media_type": media_type,
                        "metadata": serialize_metadata(result['Metadata']),
                        "rating": get_average_rating(conn, media_id, media_type),
                        "url": relative_url
                    })
            except Error as e:
                print(f"Fetch Error: {e}")
                continue
    finally:
        cursor.close()
        conn.close()

    return jsonify({"results": final_results})

# ---- Rating ----
@app.route('/api/rate', methods=['POST'])
def api_rate():
    if not request.is_json:
        return jsonify({"status": "error", "message": "Expected application/json"}), 400

    data = request.json or {}
    user_id = data.get('user_id')
    media_id = data.get('media_id')
    media_type = data.get('media_type')
    rating = data.get('rating')

    if not all([user_id, media_id, media_type, rating]):
        return jsonify({"status": "error", "message": "Missing rating data"}), 400

    conn = get_db_connection()
    if conn is None:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500

    ok = submit_rating(conn, user_id, media_id, media_type, rating)
    conn.close()
    if ok:
        return jsonify({"status": "success", "message": "Rating updated."})
    return jsonify({"status": "error", "message": "Could not update rating."}), 500

# ---- View History ----
@app.route('/api/history', methods=['POST'])
def api_history():
    if not request.is_json:
        return jsonify({"status": "error", "message": "Expected application/json"}), 400

    data = request.json or {}
    user_id = data.get('user_id')
    limit = int(data.get('limit', 50))

    if not user_id:
        return jsonify({"status": "error", "message": "user_id is required"}), 400

    conn = get_db_connection()
    if conn is None:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500

    cursor = conn.cursor(dictionary=True)
    try:
        # NOTE: your schema uses View_Time, so we alias it as Viewed_At
        sql = """
            SELECT vh.View_Time AS Viewed_At, 'Image' AS Media_Type, i.Image_ID AS Media_ID, i.Title, i.File_Path
            FROM View_History vh
            JOIN Image i ON i.Image_ID = vh.Media_ID
            WHERE vh.User_ID = %s AND vh.Media_Type = 'Image'

            UNION ALL

            SELECT vh.View_Time AS Viewed_At, 'Audio' AS Media_Type, a.Audio_ID AS Media_ID, a.Title, a.File_Path
            FROM View_History vh
            JOIN Audio a ON a.Audio_ID = vh.Media_ID
            WHERE vh.User_ID = %s AND vh.Media_Type = 'Audio'

            UNION ALL

            SELECT vh.View_Time AS Viewed_At, 'Video' AS Media_Type, v.Video_ID AS Media_ID, v.Title, v.File_Path
            FROM View_History vh
            JOIN Video v ON v.Video_ID = vh.Media_ID
            WHERE vh.User_ID = %s AND vh.Media_Type = 'Video'

            ORDER BY Viewed_At DESC
            LIMIT %s
        """
        cursor.execute(sql, (user_id, user_id, user_id, limit))
        rows = cursor.fetchall()

        history = []
        for r in rows:
            file_path = (r['File_Path'] or "").replace("\\", "/")
            url = f"/media/{file_path}"
            viewed_at = serialize_dt(r.get('Viewed_At'))
            history.append({
                "viewed_at": viewed_at,
                "media_type": r.get("Media_Type"),
                "media_id": r.get("Media_ID"),
                "title": r.get("Title"),
                "url": url
            })

        return jsonify({"status": "success", "results": history})
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# ---- Serve media files ----
@app.route('/media/<path:filename>')
def serve_media_files(filename):
    cleaned = filename.replace('..', '').replace('\\', '/')
    return send_from_directory(MEDIA_ROOT_PATH, cleaned)

# ------------------ MAIN ------------------
if __name__ == '__main__':
    print("Flask server starting...")
    app.run(host='0.0.0.0', port=5000, debug=True)
