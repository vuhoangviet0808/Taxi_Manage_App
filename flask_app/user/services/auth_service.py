from shared.services.database_service import db

def get_user_data():
    query = 'select * form user'
    result = db.cursor().excute(query)
    return result.fetchall()
