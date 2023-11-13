-- Create a stored procedure which returns the amount for Xth entry
-- of payment table. X is IN, amount is OUT parameter for the procedure. Display the returned amount.

DROP PROCEDURE IF EXISTS GetPayments;

DELIMITER $$

CREATE PROCEDURE GetPayments (
	IN  x INT,
	OUT total DECIMAL(10,2)
)
BEGIN
	SELECT SUM(amount)
	INTO total
	FROM payments;
END$$
DELIMITER ;