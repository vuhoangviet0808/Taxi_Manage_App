DELIMITER //

-- Tạo procedure mới
CREATE PROCEDURE calculateDriverRevenue(
    IN driver_id INT,              -- Đầu vào Driver_ID
    IN start_date_str VARCHAR(10), -- Đầu vào ngày bắt đầu dưới dạng DD-MM-YYYY
    IN end_date_str VARCHAR(10)    -- Đầu vào ngày kết thúc dưới dạng DD-MM-YYYY
)
BEGIN
    DECLARE start_date DATE;
    DECLARE end_date DATE;
    DECLARE is_same_year BOOLEAN;
    DECLARE totalRevenue DECIMAL(10, 2);

    -- Chuyển đổi chuỗi ngày thành dạng DATE
    SET start_date = STR_TO_DATE(start_date_str, '%d-%m-%Y');
    SET end_date = STR_TO_DATE(end_date_str, '%d-%m-%Y');

    -- Kiểm tra xem hai ngày có cùng năm hay không
    SET is_same_year = (YEAR(start_date) = YEAR(end_date));

    -- Tạo bảng tạm để lưu kết quả
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_revenue (
        period VARCHAR(7), -- 'YYYY-MM' cho cùng năm, 'YYYY' cho khác năm
        revenue DECIMAL(10, 2)
    );

    -- Xóa dữ liệu cũ trong bảng tạm
    DELETE FROM temp_revenue;

    -- Tính toán doanh thu
    IF is_same_year THEN
        -- Tính doanh thu theo từng tháng năm nếu cùng năm
        INSERT INTO temp_revenue (period, revenue)
        SELECT 
            DATE_FORMAT(cr.ride_start_time, '%Y-%m') AS period,
            SUM(cr.price) AS revenue
        FROM Driver d
        JOIN Shift s ON d.Driver_ID = s.Driver_id
        JOIN cab_ride cr ON s.ID = cr.shift_id
        WHERE cr.ride_start_time BETWEEN start_date AND end_date
        AND d.Driver_ID = driver_id
        GROUP BY DATE_FORMAT(cr.ride_start_time, '%Y-%m');
    ELSE
        -- Tính doanh thu theo từng năm nếu khác năm
        INSERT INTO temp_revenue (period, revenue)
        SELECT 
            DATE_FORMAT(cr.ride_start_time, '%Y') AS period,
            SUM(cr.price) AS revenue
        FROM Driver d
        JOIN Shift s ON d.Driver_ID = s.Driver_id
        JOIN cab_ride cr ON s.ID = cr.shift_id
        WHERE cr.ride_start_time BETWEEN start_date AND end_date
        AND d.Driver_ID = driver_id
        GROUP BY DATE_FORMAT(cr.ride_start_time, '%Y');
    END IF;

    -- Trả về kết quả từ bảng tạm
    SELECT * FROM temp_revenue;

    -- Xóa bảng tạm sau khi sử dụng
    DROP TEMPORARY TABLE IF EXISTS temp_revenue;
END //

-- Thiết lập Delimiter về lại mặc định
DELIMITER ;


DELIMITER //

-- Tạo procedure mới
CREATE PROCEDURE calculateCompanyRevenue(
    IN start_date_str VARCHAR(10), -- Đầu vào ngày bắt đầu dưới dạng DD-MM-YYYY
    IN end_date_str VARCHAR(10)    -- Đầu vào ngày kết thúc dưới dạng DD-MM-YYYY
)
BEGIN
    DECLARE start_date DATE;
    DECLARE end_date DATE;
    DECLARE is_same_year BOOLEAN;
    DECLARE totalRevenue DECIMAL(10, 2);

    -- Chuyển đổi chuỗi ngày thành dạng DATE
    SET start_date = STR_TO_DATE(start_date_str, '%d-%m-%Y');
    SET end_date = STR_TO_DATE(end_date_str, '%d-%m-%Y');

    -- Kiểm tra xem hai ngày có cùng năm hay không
    SET is_same_year = (YEAR(start_date) = YEAR(end_date));

    -- Tạo bảng tạm để lưu kết quả
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_company_revenue (
        period VARCHAR(7), -- 'YYYY-MM' cho cùng năm, 'YYYY' cho khác năm
        revenue DECIMAL(10, 2)
    );

    -- Xóa dữ liệu cũ trong bảng tạm
    DELETE FROM temp_company_revenue;

    -- Tính toán doanh thu
    IF is_same_year THEN
        -- Tính doanh thu theo từng tháng năm nếu cùng năm
        INSERT INTO temp_company_revenue (period, revenue)
        SELECT 
            DATE_FORMAT(cr.ride_start_time, '%Y-%m') AS period,
            SUM(cr.price) AS revenue
        FROM cab_ride cr
        WHERE cr.ride_start_time BETWEEN start_date AND end_date
        GROUP BY DATE_FORMAT(cr.ride_start_time, '%Y-%m');
    ELSE
        -- Tính doanh thu theo từng năm nếu khác năm
        INSERT INTO temp_company_revenue (period, revenue)
        SELECT 
            DATE_FORMAT(cr.ride_start_time, '%Y') AS period,
            SUM(cr.price) AS revenue
        FROM cab_ride cr
        WHERE cr.ride_start_time BETWEEN start_date AND end_date
        GROUP BY DATE_FORMAT(cr.ride_start_time, '%Y');
    END IF;

    -- Trả về kết quả từ bảng tạm
    SELECT * FROM temp_company_revenue;

    -- Xóa bảng tạm sau khi sử dụng
    DROP TEMPORARY TABLE IF EXISTS temp_company_revenue;
END //

-- Thiết lập Delimiter về lại mặc định
DELIMITER ;
SET SQL_SAFE_UPDATES = 0;
CALL calculateCompanyRevenue('01-01-2024', '31-12-2024');


DELIMITER //

CREATE PROCEDURE getDriversByRevenue(
    IN start_date_str VARCHAR(10), -- Input start date as DD-MM-YYYY
    IN end_date_str VARCHAR(10)    -- Input end date as DD-MM-YYYY
)
BEGIN
    DECLARE start_date DATE;
    DECLARE end_date DATE;

    -- Convert string dates to DATE type
    SET start_date = STR_TO_DATE(start_date_str, '%d-%m-%Y');
    SET end_date = STR_TO_DATE(end_date_str, '%d-%m-%Y');

    -- Create temporary table to hold revenue data
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_driver_revenue (
        Driver_ID INT,
        Firstname CHAR(255) CHARACTER SET UTF8MB4,
        Lastname CHAR(255) CHARACTER SET UTF8MB4,
        total_revenue DECIMAL(10, 2)
    );

    -- Clear old data in temporary table
    DELETE FROM temp_driver_revenue;

    -- Insert revenue data into temporary table
    INSERT INTO temp_driver_revenue (Driver_ID, Firstname, Lastname, total_revenue)
    SELECT 
        d.Driver_ID,
        d.Firstname,
        d.Lastname,
        SUM(cr.price) AS total_revenue
    FROM Driver d
    JOIN Shift s ON d.Driver_ID = s.Driver_id
    JOIN cab_ride cr ON s.ID = cr.shift_id
    WHERE cr.ride_start_time BETWEEN start_date AND end_date
    GROUP BY d.Driver_ID
    ORDER BY total_revenue DESC;

    -- Select results from temporary table
    SELECT 
        Driver_ID,
        Firstname,
        Lastname,
        total_revenue
    FROM temp_driver_revenue
    ORDER BY total_revenue DESC;

    -- Drop temporary table after use
    DROP TEMPORARY TABLE IF EXISTS temp_driver_revenue;
END //

DELIMITER ;