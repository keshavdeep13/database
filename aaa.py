import mysql.connector
from mysql.connector import Error
import os
import sys

# --- DATABASE CONFIGURATION (MUST BE UPDATED) ---
DB_CONFIG = {
    # WARNING: Update 'user' and 'password' with your actual MySQL credentials!
    'host': 'localhost',
    'database': 'multimedia_project2', 
    'user': 'root', # Your current user
    'password': 'Rorkdsingh@1' # Your current password
}

# IMPORTANT: SET YOUR MEDIA ROOT PATH HERE
# This path must lead directly to the folder containing your 'images', 'audio', etc.
MEDIA_ROOT_PATH = r"C:\Users\91639\Desktop\dbms_phase2\media_files" 

# --- UTILITY FUNCTIONS ---

def connect_db():
    """Establishes and returns a connection to the MySQL database."""
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        if conn.is_connected():
            return conn
    except Error as e:
        print(f"\n[ERROR] Failed to connect to MySQL: {e}")
        print("Please check your DB_CONFIG settings (host, user, password, database).")
        sys.exit(1)
    return None

def login_user(conn):
    """Handles user login and returns the authenticated User_ID and Username."""
    username = input("Enter username: ")
    password = input("Enter password: ")
    
    cursor = conn.cursor()
    
    # We select only the User_ID for session tracking
    query = "SELECT User_ID, Password_Hash FROM User WHERE Username = %s"
    
    try:
        cursor.execute(query, (username,))
        result = cursor.fetchone()
        
        if result:
            user_id, stored_hash = result
            
            # NOTE: Simplified authentication for demonstration. 
            if password:
                print(f"\n[SUCCESS] Welcome, {username}!")
                return user_id, username
        
        print("\n[FAILED] Invalid username or password.")
        return None, None
    except Error as e:
        print(f"[ERROR] Login failed: {e}")
        return None, None
    finally:
        cursor.close()

def log_view_history(conn, user_id, media_id, media_type):
    """Inserts a record into View_History for the currently displayed media."""
    if user_id is None:
        return 

    cursor = conn.cursor()
    
    # View_Time defaults to CURRENT_TIMESTAMP in the database
    query = """
    INSERT INTO View_History (User_ID, Media_ID, Media_Type)
    VALUES (%s, %s, %s)
    """
    params = (user_id, media_id, media_type)
    
    try:
        cursor.execute(query, params)
        conn.commit()
    except Error as e:
        # This might fail if the connection drops, but we let the main process continue.
        print(f"  [ERROR] Failed to log view history: {e}")
    finally:
        cursor.close()

def get_average_rating(conn, media_id, media_type):
    """Calculates the average rating for a given media item."""
    cursor = conn.cursor()
    query = """
    SELECT AVG(Rating_Value) 
    FROM Media_Rating 
    WHERE Media_ID = %s AND Media_Type = %s
    """
    
    try:
        cursor.execute(query, (media_id, media_type))
        result = cursor.fetchone()
        
        if result and result[0] is not None:
            return f"{result[0]:.1f}/5.0"
        return "N/A"
    except Error:
        return "ERROR"
    finally:
        cursor.close()

def submit_rating(conn, user_id, media_id, media_type):
    """Allows the user to submit a rating or update an existing one."""
    
    while True:
        try:
            rating_input = input(f"Rate this {media_type} (1-5, or skip): ")
            if rating_input.lower() == 'skip':
                return
            
            rating_value = int(rating_input)
            if 1 <= rating_value <= 5:
                break
            else:
                print("Invalid rating. Please enter a number between 1 and 5.")
        except ValueError:
            print("Invalid input. Please enter a number (1-5) or 'skip'.")
    
    cursor = conn.cursor()
    # INSERT ... ON DUPLICATE KEY UPDATE handles both new ratings and updates efficiently
    query = """
    INSERT INTO Media_Rating (User_ID, Media_ID, Media_Type, Rating_Value)
    VALUES (%s, %s, %s, %s)
    ON DUPLICATE KEY UPDATE Rating_Value = VALUES(Rating_Value)
    """
    params = (user_id, media_id, media_type, rating_value)

    try:
        cursor.execute(query, params)
        conn.commit()
        print(f"\n[SUCCESS] Your rating of {rating_value}/5.0 has been saved!")
    except Error as e:
        print(f"[ERROR] Failed to submit rating: {e}")
    finally:
        cursor.close()
        
def fetch_user_history_details(conn, user_id, username):
    """Fetches and displays the viewing history for the logged-in user."""
    cursor = conn.cursor()
    
    # Query to get history, ordered chronologically (newest first)
    # LIMIT 30 is applied for cleaner CLI output
    query = """
    SELECT
        VH.Media_ID, VH.Media_Type, VH.View_Time
    FROM
        View_History VH
    WHERE
        VH.User_ID = %s
    ORDER BY
        VH.View_Time DESC
    LIMIT 30; 
    """
    
    try:
        cursor.execute(query, (user_id,))
        history_records = cursor.fetchall()
        
        print("\n" + "=" * 50)
        print(f"VIEW HISTORY FOR USER: {username}")
        print("-" * 50)
        
        if not history_records:
            print("No viewing history found.")
            return

        # Dictionaries to store media details to avoid redundant lookups (optimization)
        details_cache = {}

        for media_id, media_type, view_time in history_records:
            cache_key = (media_id, media_type)
            
            if cache_key not in details_cache:
                # Determine table and columns for lookup
                table_name = media_type
                id_column = f"{media_type}_ID"
                
                # Fetch minimal details (Title is enough for history view)
                detail_query = f"SELECT Title FROM {table_name} WHERE {id_column} = %s"
                
                try:
                    cursor.execute(detail_query, (media_id,))
                    title = cursor.fetchone()[0]
                    details_cache[cache_key] = title
                except Error:
                    details_cache[cache_key] = "Unknown Title (Error)"

            print(f"[{view_time.strftime('%Y-%m-%d %H:%M:%S')}] - {media_type:<5} - {details_cache[cache_key]}")
            
    except Error as e:
        print(f"[SQL ERROR] Failed to fetch history: {e}")
    finally:
        cursor.close()

def execute_search_query(conn, tags):
    """Executes the core tag-based search and returns media references (ID and Type)."""
    tag_count = len(tags)
    placeholders = ', '.join(['%s'] * tag_count)
    
    # Core SQL to find (Media_ID, Media_Type) pairs matching ALL tags
    base_query = f"""
    SELECT
        MT.Media_ID,
        MT.Media_Type
    FROM
        Media_Tag MT
    JOIN
        Tag T ON MT.Tag_ID = T.Tag_ID
    WHERE
        T.Tag_Name IN ({placeholders})
    GROUP BY
        MT.Media_ID, MT.Media_Type
    HAVING
        COUNT(DISTINCT T.Tag_Name) = %s;
    """
    
    params = tuple(tags) + (tag_count,)
    
    cursor = conn.cursor()
    try:
        cursor.execute(base_query, params)
        return cursor.fetchall()
    except Error as e:
        print(f"[SQL ERROR] Search query failed: {e}")
        return []
    finally:
        cursor.close()

def fetch_and_print_paths(conn, user_id, media_references):
    """Fetches details, logs history, calculates rating, and prints the absolute path."""
    cursor = conn.cursor()
    found_count = 0
    
    for media_id, media_type in media_references:
        # 1. Conditional Query Construction
        if media_type == 'Image':
            id_column = 'Image_ID'
            select_cols = 'Title, File_Path, Resolution'
        elif media_type == 'Audio':
            id_column = 'Audio_ID'
            select_cols = 'Title, File_Path, Duration'
        elif media_type == 'Video':
            id_column = 'Video_ID'
            select_cols = 'Title, File_Path, Duration'
        else:
            continue

        query = f"SELECT {select_cols} FROM {media_type} WHERE {id_column} = %s"
        
        try:
            cursor.execute(query, (media_id,))
            result = cursor.fetchone()
            
            if result:
                # Unpack results
                title, file_path_relative, metadata_value = result
                
                # 2. Log History BEFORE displaying (tracking the access event)
                log_view_history(conn, user_id, media_id, media_type)
                
                # 3. Calculate Rating
                rating_str = get_average_rating(conn, media_id, media_type)
                
                # 4. Construct the full absolute path
                full_path = os.path.join(MEDIA_ROOT_PATH, file_path_relative.replace('/', os.sep))
                
                print("=" * 50)
                print(f"TITLE: {title}")
                print(f"TYPE: {media_type} (ID: {media_id})")
                
                # Print specific metadata (Duration or Resolution)
                if media_type == 'Image':
                    print(f"RESOLUTION: {metadata_value}")
                else:
                    print(f"DURATION: {metadata_value}")
                    
                print(f"RATING: {rating_str}")
                print("-" * 50)
                print(f"ABSOLUTE PATH (to access file): {full_path}")
                
                # 5. Allow rating submission immediately after display
                submit_rating(conn, user_id, media_id, media_type)

                found_count += 1
                
        except Error as e:
            print(f"[ERROR] Could not fetch details for {media_type} ID {media_id}: {e}")

    if found_count == 0:
        print("=" * 50)
        print("No paths found for the given criteria. Ensure files are tagged correctly.")
        print("=" * 50)
    
    cursor.close()

def main():
    """Main function to run the CLI search tool."""
    
    conn = connect_db()
    if conn is None:
        return
        
    print("\n" + "=" * 50)
    print("      MULTIMEDIA SEARCH & RATING CLI TOOL")
    print("=" * 50)
    
    # 1. Login
    user_id, username = login_user(conn)
    if user_id is None:
        conn.close()
        return

    # 2. Main Search Loop
    while True:
        print("\n" + "=" * 50)
        user_input = input(f"Enter tags to search (e.g., car, vehicle), 'history', or 'exit': ")
        print("=" * 50)
        
        user_input_lower = user_input.lower().strip()
        
        if user_input_lower == 'exit':
            break
        
        if user_input_lower == 'history' or user_input_lower == 'h':
            fetch_user_history_details(conn, user_id, username)
            continue
            
        tags = [tag.strip().lower() for tag in user_input.split(',') if tag.strip()]
        
        if not tags:
            print("No valid tags entered. Try again.")
            continue

        print(f"\nSearching for media matching: {', '.join(tags)}...")

        # 3. Execute Search and Get References
        media_references = execute_search_query(conn, tags)

        # 4. Fetch Paths, Log History, and Print/Rate
        fetch_and_print_paths(conn, user_id, media_references)

    # 5. Close Connection
    conn.close()
    print("\nConnection closed. Goodbye!")

if __name__ == "__main__":
    main()