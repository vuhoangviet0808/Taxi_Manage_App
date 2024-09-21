from shared.services.database_service import db

def get_driver_revenue(driver_id, start_date, end_date):
    cursor = db.cursor(dictionary=True)
    try:
      
       
        cursor.callproc('calculateDriverRevenue', (driver_id, start_date, end_date))

        for result in cursor.stored_results():
            revenue_data = result.fetchall()

        return revenue_data

    except Exception as e:
        print("Error occurred: ", e)
        return None

    finally:
        cursor.close()
