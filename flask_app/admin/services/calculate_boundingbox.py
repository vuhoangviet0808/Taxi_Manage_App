import math

def calculate_bounding_box(lat, lon):
    
    radius_earth_km = 6371.0  
    lat_radians = math.radians(lat)
    
    delta_lat = 3 / radius_earth_km
    min_lat = lat - math.degrees(delta_lat)
    max_lat = lat + math.degrees(delta_lat)
    

    delta_lon = 3 / (radius_earth_km * math.cos(lat_radians))
    min_lon = lon - math.degrees(delta_lon)
    max_lon = lon + math.degrees(delta_lon)
    
    return min_lat, max_lat, min_lon, max_lon

"""
latitude =  21.037
longitude = 105.856

bounding_box = calculate_bounding_box(latitude, longitude)
print(f"Bounding Box: {bounding_box}")
"""