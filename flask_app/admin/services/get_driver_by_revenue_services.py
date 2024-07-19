from shared.services.database_service import db

def get_drivers_by_revenue(start_date, end_date):
    cursor = db.cursor(dictionary=True)
    try:
        # Gọi stored procedure getDriversByRevenue
        cursor.callproc('getDriversByRevenue', (start_date, end_date))

        # Lấy kết quả từ stored procedure
        for result in cursor.stored_results():
            driver_revenue_data = result.fetchall()

        return driver_revenue_data

    except Exception as e:
        print("Error occurred: ", e)
        return None

    finally:
        cursor.close()