import mysql.connector


db = mysql.connector.connect(
    user='root', 
    password='123456789', 
    host='localhost', 
    database='taxi_management_app'
)


if db.is_connected():
    print("Successfully connected to the database")
else:
    print(f"Error: {db.error}")


    
