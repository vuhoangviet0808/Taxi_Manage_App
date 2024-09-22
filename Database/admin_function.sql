

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


-- Tính toán doanh thu của tài xế:----------------------------------------------------------------------------------------------------
use taxi;
DELIMITER //

-- Tạo procedure mới
CREATE PROCEDURE calculateDriverRevenue(
    IN driver_id INT,             
    IN start_date_str VARCHAR(10), 
    IN end_date_str VARCHAR(10)    
)
BEGIN
    DECLARE start_date DATE;
    DECLARE end_date DATE;
    DECLARE is_same_year BOOLEAN;

    
    SET start_date = STR_TO_DATE(start_date_str, '%d-%m-%Y');
    SET end_date = STR_TO_DATE(end_date_str, '%d-%m-%Y');

    
    SET is_same_year = (YEAR(start_date) = YEAR(end_date));

    
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_revenue (
        period VARCHAR(7), 
        revenue DECIMAL(10, 2)
    );

    
    DELETE FROM temp_revenue;

    -- Tính toán doanh thu
    IF is_same_year THEN
        
        INSERT INTO temp_revenue (period, revenue)
        SELECT 
            DATE_FORMAT(cr.ride_start_time, '%Y-%m') AS period,
            SUM(7000000 + (0.15 * cr.price)) AS revenue
        FROM Driver d
        JOIN Shift s ON d.Driver_ID = s.Driver_id
        JOIN cab_ride cr ON s.ID = cr.shift_id
        WHERE cr.ride_start_time BETWEEN start_date AND end_date
        AND d.Driver_ID = driver_id
        GROUP BY DATE_FORMAT(cr.ride_start_time, '%Y-%m');
    ELSE
        
        INSERT INTO temp_revenue (period, revenue)
        SELECT 
            DATE_FORMAT(cr.ride_start_time, '%Y') AS period,
            SUM(7000000 + (0.15 * cr.price)) AS revenue
        FROM Driver d
        JOIN Shift s ON d.Driver_ID = s.Driver_id
        JOIN cab_ride cr ON s.ID = cr.shift_id
        WHERE cr.ride_start_time BETWEEN start_date AND end_date
        AND d.Driver_ID = driver_id
        GROUP BY DATE_FORMAT(cr.ride_start_time, '%Y');
    END IF;

    
    SELECT * FROM temp_revenue;

    
    DROP TEMPORARY TABLE IF EXISTS temp_revenue;
END //


DELIMITER ;
SET SQL_SAFE_UPDATES = 0;
CALL calculateDriverRevenue(1, '01-01-2024', '31-12-2024');