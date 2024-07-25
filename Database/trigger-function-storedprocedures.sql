-- insert thoi gian thuc vao bang account khi insert
DELIMITER $$
CREATE TRIGGER account_insert_trigger
BEFORE INSERT ON account
FOR EACH ROW
BEGIN
    SET NEW.created_at = NOW();
END$$
DELIMITER ;