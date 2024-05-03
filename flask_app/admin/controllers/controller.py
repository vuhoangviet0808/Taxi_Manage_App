from flask import jsonify


def get_orders():
    orders = [
        {"thời gian": "01:02:33", "ngày": "28/4/2024"},
        {"thời gian": "02:02:33", "ngày": "29/4/2024"},
        {"thời gian": "03:02:33", "ngày": "30/4/2024"},
        {"thời gian": "04:02:33", "ngày": "1/5/2024"},
        {"thời gian": "05:02:33", "ngày": "2/5/2024"},
    ]
    return jsonify(orders)


def get_drivers():
    drivers = [
        {"họ tên": "Monica Geller", "ngày sinh": "01/01/1990"},
        {"họ tên": "Chandler Bing", "ngày sinh": "02/02/1991"},
        {"họ tên": "Rachel Green", "ngày sinh": "03/03/1992"},
        {"họ tên": "Ross Geller", "ngày sinh": "04/04/1993"},
        {"họ tên": "Joey Buffay", "ngày sinh": "05/05/1994"}
    ]
    return jsonify(drivers)