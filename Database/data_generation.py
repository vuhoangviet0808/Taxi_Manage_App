import random
from datetime import datetime, timedelta
from faker import Faker

# Khởi tạo Faker
fake = Faker('vi_VN')  # Đặt địa phương là Việt Nam

# Một số địa chỉ và tọa độ GPS mẫu ở Hà Nội
hanoi_locations = [
    {"address": "Hồ Hoàn Kiếm, Hoàn Kiếm, Hà Nội", "gps": "POINT(105.8525 21.0285)"},
    {"address": "Lăng Chủ tịch Hồ Chí Minh, Ba Đình, Hà Nội", "gps": "POINT(105.8341 21.0367)"},
    {"address": "Văn Miếu, Đống Đa, Hà Nội", "gps": "POINT(105.8356 21.0283)"},
    {"address": "Cầu Long Biên, Hoàn Kiếm, Hà Nội", "gps": "POINT(105.8563 21.0436)"},
    {"address": "Nhà thờ Lớn Hà Nội, Hoàn Kiếm, Hà Nội", "gps": "POINT(105.8515 21.0285)"},
    {"address": "Công viên Thống Nhất, Hai Bà Trưng, Hà Nội", "gps": "POINT(105.8437 21.0145)"},
    {"address": "Bảo tàng Lịch sử Quốc gia, Hoàn Kiếm, Hà Nội", "gps": "POINT(105.8564 21.0245)"},
    {"address": "Hoàng thành Thăng Long, Ba Đình, Hà Nội", "gps": "POINT(105.8429 21.0401)"},
    {"address": "Chùa Trấn Quốc, Tây Hồ, Hà Nội", "gps": "POINT(105.8360 21.0450)"},
    {"address": "Hồ Tây, Tây Hồ, Hà Nội", "gps": "POINT(105.8232 21.0506)"}
]


# Hàm chọn ngẫu nhiên địa điểm ở Hà Nội
def random_hanoi_location():
    return random.choice(hanoi_locations)


# Tạo câu lệnh INSERT cho bảng Account
roles = ['admin', 'driver', 'user']
statuses = ['active', 'inactive']

sdt_list = []

for _ in range(100):
    sdt = fake.bothify(text='##########')
    sdt_list.append(sdt)
    password = fake.password()
    role = random.choice(roles)
    status = random.choice(statuses)

    print(f"INSERT INTO Account (SDT, password, roles, status) VALUES ('{sdt}', '{password}', '{role}', '{status}');")

# Tạo câu lệnh INSERT cho bảng User
genders = ['Nam', 'Nữ']

for _ in range(50):
    sdt = random.choice(sdt_list)
    firstname = fake.first_name()
    lastname = fake.last_name()
    wallet = round(random.uniform(0, 1000), 2)
    dob = fake.date_of_birth(tzinfo=None, minimum_age=18, maximum_age=65)
    gender = random.choice(genders)
    location = random_hanoi_location()
    cccd = fake.bothify(text='##########')
    user_token = fake.uuid4() if random.choice([True, False]) else None

    print(
        f"INSERT INTO User (SDT, Firstname, Lastname, Wallet, DOB, Gender, Address, CCCD, user_token) VALUES ('{sdt}', '{firstname}', '{lastname}', {wallet}, '{dob}', '{gender}', '{location['address']}', '{cccd}', {'NULL' if user_token is None else f"'{user_token}'"});")

# Tạo câu lệnh INSERT cho bảng Driver
for _ in range(50):
    sdt = random.choice(sdt_list)
    firstname = fake.first_name()
    lastname = fake.last_name()
    wallet = round(random.uniform(0, 1000), 2)
    dob = fake.date_of_birth(tzinfo=None, minimum_age=18, maximum_age=65)
    gender = random.choice(genders)
    location = random_hanoi_location()
    cccd = fake.bothify(text='##########')
    driving_licence_number = fake.bothify(text='DL##########')
    working_experiment = round(random.uniform(0, 30), 2)
    driver_token = fake.uuid4() if random.choice([True, False]) else None

    print(
        f"INSERT INTO Driver (SDT, Firstname, Lastname, Wallet, DOB, Gender, Address, CCCD, Driving_licence_number, Working_experiment, driver_token) VALUES ('{sdt}', '{firstname}', '{lastname}', {wallet}, '{dob}', '{gender}', '{location['address']}', '{cccd}', '{driving_licence_number}', {working_experiment}, {'NULL' if driver_token is None else f"'{driver_token}'"});")

# Tạo câu lệnh INSERT cho bảng Cab
car_types = ['4_seat', '6_seat']

for _ in range(30):
    licence_plate = fake.bothify(text='##A-####')
    car_type = random.choice(car_types)
    manufacture_year = random.randint(2000, 2023)
    active = random.choice([True, False])

    print(
        f"INSERT INTO Cab (licence_plate, car_type, manufacture_year, active) VALUES ('{licence_plate}', '{car_type}', {manufacture_year}, {active});")

# Tạo câu lệnh INSERT cho bảng Shift
for _ in range(100):
    driver_id = random.randint(1, 50)
    cab_id = random.randint(1, 30)
    location = random_hanoi_location()
    evaluate = round(random.uniform(0, 5), 1)

    print(
        f"INSERT INTO Shift (Driver_id, cab_id, current_gps_location, current_address, evaluate) VALUES ({driver_id}, {cab_id}, ST_GeomFromText('{location['gps']}'), '{location['address']}', {evaluate});")

# Tạo câu lệnh INSERT cho bảng cab_ride
statuses_ride = ['in_progress', 'cancelled', 'completed']
cancelled_by_options = ['user', 'driver', 'system', None]

for _ in range(200):
    shift_id = random.randint(1, 100)
    user_id = random.randint(1, 50)
    ride_start_time = fake.date_time_between(start_date='-30d', end_date='now')
    ride_end_time = ride_start_time + timedelta(minutes=random.randint(10, 60))
    location_start = random_hanoi_location()
    location_end = random_hanoi_location()
    status = random.choice(statuses_ride)
    cancelled_by = random.choice(cancelled_by_options)
    price = round(random.uniform(50, 500), 2)
    response = fake.text()
    evaluate = round(random.uniform(0, 5), 1)

    print(
        f"INSERT INTO cab_ride (shift_id, user_id, ride_start_time, ride_end_time, address_starting_point, GPS_starting_point, address_destination, GPS_destination, status, cancelled_by, price, response, evaluate) VALUES ({shift_id}, {user_id}, '{ride_start_time}', '{ride_end_time}', '{location_start['address']}', ST_GeomFromText('{location_start['gps']}'), '{location_end['address']}', ST_GeomFromText('{location_end['gps']}'), '{status}', {'NULL' if cancelled_by is None else f"'{cancelled_by}'"}, {price}, '{response}', {evaluate});")

# Tạo câu lệnh INSERT cho bảng booking_requests
statuses_booking = ['pending', 'assigned', 'cancelled']

for _ in range(100):
    user_id = random.randint(1, 50)
    requested_car_type = random.choice(car_types)
    location_pickup = random_hanoi_location()
    location_dropoff = random_hanoi_location()
    price = round(random.uniform(50, 500), 2)
    status = random.choice(statuses_booking)
    driver_id = random.randint(1, 50) if status != 'pending' else None

    print(
        f"INSERT INTO booking_requests (user_id, requested_car_type, pickup_location, dropoff_location, gps_pick_up_location, gps_destination_location, price, status, driver_id) VALUES ({user_id}, '{requested_car_type}', '{location_pickup['address']}', '{location_dropoff['address']}', ST_GeomFromText('{location_pickup['gps']}'), ST_GeomFromText('{location_dropoff['gps']}'), {price}, '{status}', {'NULL' if driver_id is None else driver_id});")
