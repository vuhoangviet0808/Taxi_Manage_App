
import mysql.connector


db = mysql.connector.connect(
    user='root', 
    password='123456789', 
    host='localhost', 
    database='taxi'
)


if db.is_connected():
    print("Successfully connected to the database")
else:
    print(f"Error: {db.error}")


    
