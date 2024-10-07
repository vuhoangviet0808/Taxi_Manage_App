-- insert thoi gian thuc vao bang account khi insert
DELIMITER $$
CREATE TRIGGER account_insert_trigger
BEFORE INSERT ON account
FOR EACH ROW
BEGIN
    SET NEW.created_at = NOW();
END$$
DELIMITER ;


ALTER TABLE booking_driver ADD COLUMN status_updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;




DELIMITER //

CREATE TRIGGER update_status_timestamp
BEFORE UPDATE ON booking_driver
FOR EACH ROW
BEGIN
  IF NEW.status != OLD.status THEN
    SET NEW.status_changed_at = CURRENT_TIMESTAMP;
  END IF;
END;
//

DELIMITER ;