from flask import jsonify
from ..services.driver_revenue_services import get_driver_revenue

def calculate_driver_revenue(driver_id, start_date_str, end_date_str):
    try:
        # Fetch the revenue data
        result = get_driver_revenue(driver_id, start_date_str, end_date_str)

        if not result:
            return {"error": "No revenue data found."}, 404

        # Process and sort the revenue data
        revenue_data = []
        for row in result:
            period = str(row.get('period', ''))
            revenue = float(row.get('revenue', 0.0))  
            revenue_data.append({"period": period, "revenue": revenue})

        # Sort the revenue_data by period in descending order
        revenue_data.sort(key=lambda x: x['period'], reverse=True)

        # Return the sorted revenue data
        return {"driver_id": driver_id, "start_date": start_date_str, "end_date": end_date_str, "revenue_data": revenue_data}, 200

    except ValueError:
        return {"error": "Incorrect date format, should be dd-mm-yyyy."}, 400
    except Exception as e:
        return {"error": str(e)}, 500