from shared.services.database_service import db

def get_company_revenue(start_date, end_date):
    cursor = db.cursor(dictionary=True)
    try:
        # Call the stored procedure to calculate company revenue
        cursor.callproc('calculateCompanyRevenue', (start_date, end_date))

        # Fetch all results from the stored procedure
        for result in cursor.stored_results():
            revenue_data = result.fetchall()

        return revenue_data

    except Exception as e:
        print("Error occurred: ", e)
        return None

    finally:
        cursor.close()