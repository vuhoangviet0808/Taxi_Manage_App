from flask import jsonify
from ..services.get_driver_by_revenue_services import get_drivers_by_revenue

def get_drivers_by_revenue_controller(start_date_str, end_date_str):
    try:
        # Fetch the revenue data for drivers
        result = get_drivers_by_revenue(start_date_str, end_date_str)

        if not result:
            return {"error": "No revenue data found."}, 404

        # Process and sort the driver revenue data
        driver_revenue_data = []
        for row in result:
            driver_id = row.get('Driver_ID', 0)
            firstname = row.get('Firstname', '')
            lastname = row.get('Lastname', '')
            total_revenue = float(row.get('total_revenue', 0.0))
            driver_revenue_data.append({
                "driver_id": driver_id,
                "firstname": firstname,
                "lastname": lastname,
                "total_revenue": total_revenue
            })

        # Sort the driver_revenue_data by total_revenue in descending order
        driver_revenue_data.sort(key=lambda x: x['total_revenue'], reverse=True)

        # Return the sorted driver revenue data
        return {
            "start_date": start_date_str,
            "end_date": end_date_str,
            "driver_revenue_data": driver_revenue_data
        }, 200

    except ValueError:
        return {"error": "Incorrect date format, should be dd-mm-yyyy."}, 400
    except Exception as e:
        return {"error": str(e)}, 500